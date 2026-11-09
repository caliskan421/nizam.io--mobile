import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/department.dart';
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
  });

  final bool saving;
  final ApiError? error;
  final Department? pending;
}

/// Şirket yöneticisi mi: koordinatörlük ekleme ve bilgi düzenleme düğmeleri yalnız ona görünür
/// (`createDepartment`, `updateDepartment`, `linkDepartment`, `renameDepartmentLink` yalnız
/// şirket yöneticisine açık). Gizleme güvenlik değildir; sunucu her istekte denetler.
@riverpod
bool canManageCoordinatorships(Ref ref) =>
    ref.watch(taskCatalogControllerProvider).value?.access?.companyAdmin ??
    false;

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
        scopeStateProvider.select((s) => s.programId),
        (_, _) => _reset(),
      );
    return const CoordinatorshipFormState();
  }

  /// Formun ait olduğu oturum nesli.
  int _session = 0;

  /// Sahiplik nesli: oturum ya da program değişiminde artar; uçuştaki işlem başladığı nesil
  /// geçerli değilse sonucunu yazmaz.
  int _epoch = 0;

  void _reset() {
    _session = ref.read(sessionControllerProvider).generation;
    _epoch++;
    state = const CoordinatorshipFormState();
  }

  /// Uçuştaki işlem hâlâ başladığı oturum ve programa mı ait.
  bool _live(int epoch) => ref.mounted && epoch == _epoch;

  /// Form açılırken önceki gönderimin hatasını siler (bekleyen departman kalır).
  void clearError() {
    if (state.error == null) return;
    state = CoordinatorshipFormState(pending: state.pending);
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
    final kind = draft.kind;
    final program = ref.read(scopeStateProvider).programId;
    if (program == null || program.isEmpty) {
      _fail(ApiError(ClientErrorCode.scopeMissing));
      return false;
    }
    final epoch = _epoch;
    final repo = ref.read(departmentRepositoryProvider);
    var pending = state.pending;
    state = CoordinatorshipFormState(saving: true, pending: pending);
    try {
      if (pending == null) {
        if (kind == null || kind == DepartmentKind.unknown) {
          throw ApiError('organization.input_invalid');
        }
        pending = await repo.createDepartment(
          name: draft.name,
          kind: kind,
          description: draft.description.isEmpty ? null : draft.description,
        );
        if (!_live(epoch)) return false;
        state = CoordinatorshipFormState(saving: true, pending: pending);
      }
      final link = await repo.linkDepartment(
        program,
        pending.id,
        displayName: draft.name,
      );
      if (!_live(epoch)) return false;
      if (link.displayName != draft.name) {
        await repo.renameDepartmentLink(program, pending.id, draft.name);
      }
    } on Object catch (e) {
      if (_live(epoch)) _fail(toApiError(e));
      return false;
    }
    if (!_live(epoch)) return false;
    state = const CoordinatorshipFormState();
    await _reload();
    return true;
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
    final program = ref.read(scopeStateProvider).programId;
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
    final epoch = _epoch;
    final repo = ref.read(departmentRepositoryProvider);
    state = CoordinatorshipFormState(saving: true, pending: state.pending);
    try {
      if (kindChanged || descriptionChanged) {
        await repo.updateDepartment(
          departmentId,
          kind: kindChanged ? kind : null,
          description: descriptionChanged ? draft.description : null,
        );
        if (!_live(epoch)) return false;
      }
      if (nameChanged) {
        await repo.renameDepartmentLink(program, departmentId, draft.name);
      }
    } on Object catch (e) {
      if (_live(epoch)) _fail(toApiError(e));
      return false;
    }
    if (!_live(epoch)) return false;
    state = CoordinatorshipFormState(pending: state.pending);
    await _reload();
    return true;
  }

  void _fail(ApiError e) =>
      state = CoordinatorshipFormState(error: e, pending: state.pending);

  /// Liste ve ayrıntı: katalog (programdaki adlar, `listProgramDepartments`) ve departman
  /// kayıtları (tür, açıklama). Okuma hatası ekranların kendi durumunda gösterilir.
  Future<void> _reload() async {
    ref.invalidate(coordinatorshipProfilesControllerProvider);
    await ref.read(taskCatalogControllerProvider.notifier).reload();
  }
}
