import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../domain/task_writes.dart';
import 'quick_forms_controller.dart' show newTaskCoordinatorshipsProvider;
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'invite_form_controller.g.dart';

// "Kullanıcı ekle" formu (prototip `S_home.state.iv`): ad, e-posta, rol ve tek koordinatörlük.
// Sunucuda davet e-postası yoktur: gönderim `createUser` ile hesabı açar ve seçilen
// koordinatörlüğün bu programdaki ekibine ekler; ilk parola sunucuda üretilir ve kimseye
// iletilmez (backend GAP-024). E-posta başka hesaptaysa sunucu yöneticiye aktarım teklifi
// (hesap kimliği + ad) döner; ikinci gönderim o var olan hesabı ekibe ekler. Taslak sayfa
// kapanınca korunur, başarıda ve oturum nesli değişince sıfırlanır.

enum InviteRole { member, coordinator, admin }

enum InviteError { name, email, coordinatorship }

/// Sunucunun aktarım teklifindeki var olan hesap; [email] teklifin geldiği gönderimin
/// (kırpılmış) e-postasıdır. Teklif yalnız bu e-postayla gönderimde kullanılır.
typedef ExistingAccount = ({String accountId, String fullName, String email});

@immutable
final class InviteForm {
  const InviteForm({
    this.name = '',
    this.email = '',
    this.role = InviteRole.member,
    this.coordinatorship,
    this.paneOpen = false,
    this.error,
    this.failure,
    this.busy = false,
    this.existing,
  });

  final String name;
  final String email;

  /// Yalnız şirket yöneticisi seçer; koordinatörün eklediği kişi üyedir (sunucu da zorlar).
  final InviteRole role;

  /// Hedef koordinatörlük (`department_id`); hesap bu programdaki ekibine eklenir.
  final String? coordinatorship;
  final bool paneOpen;
  final InviteError? error;

  /// Sunucu ya da yetki hatası.
  final ApiError? failure;
  final bool busy;

  /// Aktarım teklifi: e-posta bu hesaba ait; sonraki gönderim onu ekibe ekler. E-posta
  /// değişince düşer; geciken teklif değişmiş taslağa yazılmaz.
  final ExistingAccount? existing;

  /// Teklif bu taslağın e-postasına aitse teklif, değilse null.
  ExistingAccount? get offer =>
      existing?.email == email.trim() ? existing : null;

  static final _email = RegExp(r'.+@.+\..+');

  bool get emailValid => _email.hasMatch(email.trim());

  InviteForm copyWith({
    String? name,
    String? email,
    InviteRole? role,
    String? Function()? coordinatorship,
    bool? paneOpen,
    InviteError? Function()? error,
    ApiError? Function()? failure,
    bool? busy,
    ExistingAccount? Function()? existing,
  }) => InviteForm(
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    coordinatorship: coordinatorship == null
        ? this.coordinatorship
        : coordinatorship(),
    paneOpen: paneOpen ?? this.paneOpen,
    error: error == null ? this.error : error(),
    failure: failure == null ? this.failure : failure(),
    busy: busy ?? this.busy,
    existing: existing == null ? this.existing : existing(),
  );
}

@Riverpod(keepAlive: true)
class InviteFormController extends _$InviteFormController {
  @override
  InviteForm build() {
    final session = ref.read(sessionControllerProvider);
    _session = session.generation;
    ref.listen(sessionStateProvider, (_, _) {
      if (session.generation == _session) return;
      _session = session.generation;
      state = const InviteForm();
    });
    return const InviteForm();
  }

  /// Taslağın ait olduğu oturum nesli (önceki hesabın taslağı ve teklifi taşınmaz).
  int _session = 0;

  /// Açılış: satır kapalı, hata yok. [coordinatorship] verilirse (koordinatörlük ayrıntısı
  /// "Üye ekle") o koordinatörlük seçili, rol Üye.
  void prepare({String? coordinatorship}) {
    var f = state.copyWith(
      paneOpen: false,
      error: () => null,
      failure: () => null,
    );
    if (coordinatorship != null) {
      f = f.copyWith(
        coordinatorship: () => coordinatorship,
        role: InviteRole.member,
      );
    }
    state = f;
  }

  void _set(InviteForm f) =>
      state = f.copyWith(error: () => null, failure: () => null);

  void setName(String v) => _set(state.copyWith(name: v));

  void setEmail(String v) =>
      _set(state.copyWith(email: v, existing: () => null));

  void setRole(InviteRole r) => _set(state.copyWith(role: r));

  void togglePane() => _set(state.copyWith(paneOpen: !state.paneOpen));

  /// Tek seçim: seçer ve satırı kapatır.
  void pickCoordinatorship(String code) =>
      _set(state.copyWith(coordinatorship: () => code, paneOpen: false));

  /// Doğrular ve kişiyi ekler (`createUser`); başarıda gönderilen formu döner ve taslağı
  /// sıfırlar, ekip ve katalog yeniden okunur. Hata [InviteForm.error] / [InviteForm.failure]
  /// (ya da aktarım teklifi [InviteForm.existing]) ile null döner; otomatik tekrar yok.
  ///
  /// Yetki: şirket yöneticisi ya da programda koordinatör; koordinatörlük seçenekleri yalnız
  /// yöneticinin bütün, koordinatörün kendi koordinatörlükleridir. Rol ve yöneticilik yalnız
  /// yöneticiden gönderilir. Yetkisizse istek gönderilmez (`organization.not_authorized`).
  Future<InviteForm?> submit() async {
    final f = state;
    if (f.busy) return null;
    final access = ref.read(taskCatalogControllerProvider).value?.access;
    final program = ref.read(scopeStateProvider).programId;
    if (access == null || program == null || !access.canCreateAnyIn(program)) {
      state = f.copyWith(
        error: () => null,
        failure: () => ApiError('organization.not_authorized'),
      );
      return null;
    }
    // Teklif yalnız kaynak e-postasıyla birebir eşleşen gönderimde aktarım olur.
    final existing = f.offer;
    final dept = f.coordinatorship;
    final options = ref.read(newTaskCoordinatorshipsProvider);
    final err = existing == null && f.name.trim().isEmpty
        ? InviteError.name
        : !f.emailValid
        ? InviteError.email
        : dept == null || !options.any((c) => c.code == dept)
        ? InviteError.coordinatorship
        : null;
    if (err != null) {
      state = f.copyWith(error: () => err, failure: () => null);
      return null;
    }
    final admin = access.companyAdmin;
    final email = f.email.trim();
    final enrollment = MemberEnrollment(
      programId: program,
      departmentId: dept!,
      email: email,
      fullName: f.name.trim(),
      coordinator: admin && f.role == InviteRole.coordinator,
      companyAdmin: admin && f.role == InviteRole.admin,
      transferAccountId: existing?.accountId,
    );
    final session = ref.read(sessionControllerProvider);
    final generation = session.generation;
    bool live() => ref.mounted && session.generation == generation;
    state = f.copyWith(busy: true, error: () => null, failure: () => null);
    try {
      await ref.read(taskWriteRepositoryProvider).enrollMember(enrollment);
    } on Object catch (e) {
      if (!live()) return null;
      final error = toApiError(e);
      // Teklif gönderilen e-postaya bağlıdır; taslağın e-postası bu arada değiştiyse
      // (A gönderilip B'ye düzenlendi) A'nın hesabı B taslağına yazılmaz.
      final current = state.email.trim() == email;
      final offer = _offer(error, email);
      state = state.copyWith(
        busy: false,
        // Sonuç bilinmiyor: hesap açılmış olabilir; tekrar gönderim çakışmayı sunucu söyler.
        failure: () => offer != null
            ? null
            : isOutcomeUnknown(error)
            ? ApiError(ClientErrorCode.outcomeUnknown, status: error.status)
            : error,
        existing: () => current ? offer : state.existing,
      );
      return null;
    }
    if (!live()) return null;
    state = const InviteForm();
    ref.invalidate(taskTeamProvider(dept));
    await ref.read(taskCatalogControllerProvider.notifier).reload();
    return f;
  }

  /// `identity.account_exists` zarfındaki aktarım teklifi: `organization.transfer_available`
  /// kodlu `account_id` ve `user_full_name` alanlarının değeri sözleşme gereği hesap kimliği
  /// ve addır (yalnız şirket yöneticisine gelir). Teklif yoksa null.
  static ExistingAccount? _offer(ApiError e, String email) {
    if (e.code != 'identity.account_exists') return null;
    String? field(String name) => e.fields
        .where(
          (x) => x.field == name && x.code == 'organization.transfer_available',
        )
        .firstOrNull
        ?.message;
    final id = field('account_id');
    if (id == null || id.isEmpty) return null;
    return (
      accountId: id,
      fullName: field('user_full_name') ?? '',
      email: email,
    );
  }
}
