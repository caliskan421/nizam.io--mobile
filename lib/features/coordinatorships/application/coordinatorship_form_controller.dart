import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/department.dart';
import 'coordinatorship_detail_controller.dart';
import 'coordinatorship_profiles_controller.dart';
import 'coordinatorships_providers.dart';

part 'coordinatorship_form_controller.g.dart';

/// Koordinatörlük formunun girdisi: ad (programda görünen ad), tür, açıklama (boş → yok).
/// [kind] `null` → seçilmedi (düzenlemede departman kaydı okunamadıysa).
@immutable
final class CoordinatorshipDraft {
  const CoordinatorshipDraft({
    required this.name,
    required this.kind,
    this.description = '',
  });

  final String name;
  final DepartmentKind? kind;
  final String description;

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipDraft &&
      other.name == name &&
      other.kind == kind &&
      other.description == description;

  @override
  int get hashCode => Object.hash(name, kind, description);
}

/// Formun gönderim durumu. [pending]: sunucuda oluşturulmuş ama seçili programa
/// bağlanamamış departman; tekrar denemede yeniden oluşturulmaz, bu kimlikle bağlanır.
@immutable
final class CoordinatorshipFormState {
  const CoordinatorshipFormState({
    this.saving = false,
    this.error,
    this.pending,
    this.existingId,
    this.deleted = false,
    this.frozen = false,
  });

  final bool saving;
  final ApiError? error;
  final Department? pending;
  final String? existingId;
  final bool deleted;
  final bool frozen;
}

/// Şirket yöneticisi mi: koordinatörlük ekleme ve bilgi düzenleme düğmeleri yalnız ona görünür
/// (`createDepartment`, `updateDepartment`, `linkDepartment`, `renameDepartmentLink` yalnız
/// şirket yöneticisine açık). Gizleme güvenlik değildir; sunucu her istekte denetler.
@riverpod
bool canManageCoordinatorships(Ref ref) =>
    ref.watch(taskCatalogControllerProvider).value?.access?.companyAdmin ??
    false;

/// Uçuştaki işlemin sahibi (yerel nesil, oturum nesli, program).
typedef _Owner = ({int epoch, int session, String program, String? department});

/// Koordinatörlük ekle / bilgileri düzenle komutları. Uygulama ömrünce yaşar: oluşturulup
/// bağlanamamış departman ([CoordinatorshipFormState.pending]) form kapanıp açılsa da
/// korunur. Otomatik yeniden deneme yoktur; tekrar kullanıcı eylemiyle.
///
/// Bekleyen işlem oturum nesline (hesap ve sunucu: çıkış, başka hesapla giriş, yeniden
/// bağlanma nesli artırır) ve seçili programa aittir: ikisinden biri değişince form boşalır
/// ve uçuştaki işlemin sonucu yok sayılır (önceki hesabın departmanı yeni oturumda bağlanmaz).
@Riverpod(keepAlive: true)
class CoordinatorshipFormController extends _$CoordinatorshipFormController {
  @override
  CoordinatorshipFormState build() {
    final session = ref.read(sessionControllerProvider);
    _session = session.generation;
    ref
      ..listen(sessionStateProvider, (_, _) {
        if (session.generation != _session) _reset();
      })
      ..listen(
        scopeStateProvider.select((s) => (s.programId, s.departmentId)),
        (_, _) => _reset(),
      );
    return const CoordinatorshipFormState();
  }

  /// Formun ait olduğu oturum nesli.
  int _session = 0;

  /// Sahiplik nesli: oturum ya da program değişiminde artar; uçuştaki işlem başladığı nesil
  /// geçerli değilse sonucunu yazmaz.
  int _epoch = 0;
  RequestKeys _keys = const RequestKeys();
  CoordinatorshipDraft? _draft;
  String? _existingId;
  bool _needsRestore = false;
  bool _confirmed = false;
  CoordinatorshipDraft? get pendingDraft => _draft;

  void _reset() {
    _session = ref.read(sessionControllerProvider).generation;
    _epoch++;
    _keys = const RequestKeys();
    _draft = null;
    _existingId = null;
    _needsRestore = false;
    _confirmed = false;
    state = const CoordinatorshipFormState();
  }

  /// Uçuştaki işlemin sahipliği: yerel nesil, gerçek oturum nesli ve hedef program.
  _Owner _own(String program) => (
    epoch: _epoch,
    session: ref.read(sessionControllerProvider).generation,
    program: program,
    department: ref.read(scopeControllerProvider).current.departmentId,
  );

  /// Uçuştaki işlem hâlâ başladığı oturum ve programa mı ait. Oturum nesli ve program
  /// doğrudan okunur: çıkışta nesil, durum bildirimi yayımlanmadan (depo temizliği sürerken)
  /// artar; o aralıkta dönen yanıt da sonraki adıma geçmez.
  bool _live(_Owner o) =>
      ref.mounted &&
      o.epoch == _epoch &&
      ref.read(sessionControllerProvider).generation == o.session &&
      ref.read(scopeControllerProvider).current.programId == o.program &&
      ref.read(scopeControllerProvider).current.departmentId == o.department;

  /// Form açılırken önceki gönderimin hatasını siler (bekleyen departman kalır).
  void clearError() {
    if (state.error == null) return;
    state = CoordinatorshipFormState(
      pending: state.pending,
      existingId: _existingId,
      deleted: _needsRestore,
      frozen: _draft != null,
    );
  }

  Future<bool> confirmExisting() async {
    if (_existingId == null || _draft == null) return false;
    _confirmed = true;
    return create(_draft!);
  }

  /// Departmanı oluşturur (`createDepartment`) ve seçili programa bağlar (`linkDepartment`,
  /// programdaki ad = [draft] adı). Bağlama düşerse departman [CoordinatorshipFormState.pending]
  /// olarak kalır; sonraki çağrı yeniden oluşturmaz, yalnız bağlamayı dener (tür ve açıklama
  /// oluşturulmuş kayıttadır). Başarıda katalog ve departman kayıtları yeniden okunur.
  ///
  /// Bağ sunucuda kurulup yanıt kaybolduysa tekrar denemede sunucu var olan bağı eski adla
  /// döndürür (adı değiştirmez); dönen ad formdaki addan farklıysa programdaki ad
  /// `renameDepartmentLink` ile düzeltilir.
  Future<bool> create(CoordinatorshipDraft draft) async {
    if (state.saving) return false;
    final program = ref.read(scopeControllerProvider).current.programId;
    if (program == null || program.isEmpty) {
      _fail(ApiError(ClientErrorCode.scopeMissing));
      return false;
    }
    final owner = _own(program);
    final repo = ref.read(departmentRepositoryProvider);
    _draft ??= draft;
    final frozen = _draft!;
    var pending = state.pending;
    if (_existingId != null && !_confirmed) return false;
    state = CoordinatorshipFormState(
      saving: true,
      pending: pending,
      existingId: _existingId,
      deleted: _needsRestore,
    );
    try {
      if (_existingId != null && _needsRestore) {
        if (!_live(owner)) return false;
        try {
          await repo.restoreDepartment(program, _existingId!);
        } on ApiError catch (error) {
          if (error.code != 'organization.not_deleted') rethrow;
        }
        if (!_live(owner)) return false;
        _needsRestore = false;
      }
      if (pending == null && _existingId == null) {
        if (frozen.kind == null || frozen.kind == DepartmentKind.unknown) {
          throw ApiError('organization.input_invalid');
        }
        final (keys, key) = _keys.keyFor(
          'create',
          '${frozen.name}\u0000${frozen.kind}\u0000${frozen.description}',
        );
        _keys = keys;
        if (!_live(owner)) return false;
        pending = await repo.createDepartment(
          name: frozen.name,
          kind: frozen.kind!,
          description: frozen.description.isEmpty ? null : frozen.description,
          requestKey: key,
        );
        if (!_live(owner)) return false;
        state = CoordinatorshipFormState(saving: true, pending: pending);
      }
      final id = pending?.id ?? _existingId!;
      final (keys, key) = _keys.keyFor(
        'link',
        '$program\u0000$id\u0000${frozen.name}',
      );
      _keys = keys;
      if (!_live(owner)) return false;
      await repo.linkDepartment(
        program,
        id,
        displayName: frozen.name,
        requestKey: key,
      );
      if (!_live(owner)) return false;
    } on Object catch (e) {
      if (_live(owner)) {
        final error = toApiError(e);
        if (error.code == 'organization.department_exists') {
          final ids = error.fields.where((f) => f.field == 'department_id');
          final deleted = error.fields.where((f) => f.field == 'deleted');
          if (ids.length == 1 &&
              deleted.length == 1 &&
              ids.single.message.isNotEmpty &&
              (deleted.single.message == 'true' ||
                  deleted.single.message == 'false')) {
            _existingId = ids.single.message;
            _needsRestore = deleted.single.message == 'true';
            _confirmed = false;
            state = CoordinatorshipFormState(
              existingId: _existingId,
              deleted: _needsRestore,
            );
            return false;
          }
        }
        if (isKeyReused(error)) _keys = const RequestKeys();
        if (!isOutcomeUnknown(error) &&
            pending == null &&
            _existingId == null) {
          _draft = null;
          _keys = const RequestKeys();
        }
        _fail(error);
      }
      return false;
    }
    if (!_live(owner)) return false;
    state = const CoordinatorshipFormState();
    _draft = null;
    _existingId = null;
    _confirmed = false;
    _keys = const RequestKeys();
    try {
      await _reload();
    } on Object {
      /* Okuma durumu kendi sağlayıcısında görünür. */
    }
    return _live(owner);
  }

  /// Bilgileri düzenler: tür ve açıklama departman kaydındadır (`updateDepartment`, yalnız
  /// değişen alanlar); ad bu programdaki addır (`renameDepartmentLink`; katalog adı ve başka
  /// programlardaki adlar değişmez). Değişiklik yoksa istek atılmaz. İki istek de aynı değerle
  /// tekrarlanabilir: biri düşüp yeniden denenirse ötekinin tekrarı zararsızdır.
  Future<bool> edit(
    String departmentId, {
    required CoordinatorshipDraft initial,
    required CoordinatorshipDraft draft,
  }) async {
    if (state.saving) return false;
    final program = ref.read(scopeControllerProvider).current.programId;
    if (program == null || program.isEmpty) {
      _fail(ApiError(ClientErrorCode.scopeMissing));
      return false;
    }
    final kind = draft.kind;
    final kindChanged =
        kind != null && kind != DepartmentKind.unknown && kind != initial.kind;
    final descriptionChanged = draft.description != initial.description;
    final nameChanged = draft.name != initial.name;
    if (!kindChanged && !descriptionChanged && !nameChanged) return true;
    final owner = _own(program);
    final repo = ref.read(departmentRepositoryProvider);
    state = CoordinatorshipFormState(saving: true, pending: state.pending);
    try {
      if (kindChanged || descriptionChanged) {
        await repo.updateDepartment(
          departmentId,
          kind: kindChanged ? kind : null,
          description: descriptionChanged ? draft.description : null,
        );
        if (!_live(owner)) return false;
      }
      if (nameChanged) {
        if (!_live(owner)) return false;
        await repo.renameDepartmentLink(program, departmentId, draft.name);
      }
    } on Object catch (e) {
      if (_live(owner)) _fail(toApiError(e));
      return false;
    }
    if (!_live(owner)) return false;
    state = CoordinatorshipFormState(pending: state.pending);
    try {
      await _reload();
    } on Object {
      /* Okuma durumu kendi sağlayıcısında görünür. */
    }
    return _live(owner);
  }

  void _fail(ApiError e) => state = CoordinatorshipFormState(
    error: e,
    pending: state.pending,
    existingId: _existingId,
    deleted: _needsRestore,
    frozen: _draft != null,
  );

  /// Liste ve ayrıntı: katalog (programdaki adlar, `listProgramDepartments`) ve departman
  /// kayıtları (tür, açıklama). Okuma hatası ekranların kendi durumunda gösterilir.
  Future<void> _reload() async {
    ref.invalidate(coordinatorshipProfilesControllerProvider);
    ref.invalidate(programDepartmentProvider);
    await ref.read(taskCatalogControllerProvider.notifier).reload();
  }
}
