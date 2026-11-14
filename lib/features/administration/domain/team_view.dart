import 'package:meta/meta.dart';

import '../../../core/domain/effective_role.dart';
import '../../../core/domain/turkish_collation.dart';
import 'admin_user_directory.dart';

/// "Ekibim" / Kullanıcılar sayfasının veri kaynağı. Tek sayfa, etkin görünüme göre dallanır
/// (ayrı kopya sayfa yok):
/// - [directory]: yönetici görünümü, şirket dizini (`GET /v1/admin/users`).
/// - [departmentMembers]: koordinatör görünümü, etkin koordinatörlüğün ekibi
///   (`GET /v1/departments/{id}/members`; üye ekle/çıkar açık).
/// - [departmentGroup]: üye görünümü. `members` ucu üyeye kapalı; ekip, koordinatörlüğün
///   kendiliğinden kurulan sohbet grubunun kaynaklı üyelerinden salt okunur türetilir
///   (MESSAGING-K04/K05). Grup yoksa liste boştur ("backend bekliyor").
/// - [none]: erişim henüz bilinmiyor ya da görünümün koordinatörlüğü yok.
enum TeamSource { directory, departmentMembers, departmentGroup, none }

/// Etkin görünüm ([known], [role], [departmentId]) → ekip kaynağı. Karar tek yerde.
TeamSource teamSourceFor({
  required bool known,
  required EffectiveRole role,
  required String? departmentId,
}) {
  if (!known) return TeamSource.none;
  final hasDepartment = departmentId != null && departmentId.isNotEmpty;
  return switch (role) {
    EffectiveRole.admin => TeamSource.directory,
    EffectiveRole.coordinator =>
      hasDepartment ? TeamSource.departmentMembers : TeamSource.none,
    EffectiveRole.member =>
      hasDepartment ? TeamSource.departmentGroup : TeamSource.none,
  };
}

/// Kullanıcı ayrıntısının sekmeleri (sıra ekrandaki sıradır).
enum UserProfileTab { tasks, files, history, account }

extension TeamSourceFacts on TeamSource {
  /// Ekibe kişi ekleme (havuzdan ya da yeni `uye` hesabı) açık mı.
  bool get canAddMembers => this == TeamSource.departmentMembers;

  /// Liste türetilmiş ve salt okunur mu (üye görünümü).
  bool get derived => this == TeamSource.departmentGroup;

  /// Kişi başına açık/geciken görev sayısı katalogdan doğru sayılabilir mi: koordinatör
  /// koordinatörlüğün bütün görevlerini görür; üye yalnız kendisine atananları (sayım
  /// yanıltır, gösterilmez); yönetici dizini sayım taşımaz.
  bool get countsLoad => this == TeamSource.departmentMembers;

  /// Kullanıcı ayrıntısının sekme kümesi:
  /// - yönetici: Görevler, Dosyalar, Geçmiş, Hesap;
  /// - koordinatör: Görevler, Dosyalar (Hesap yok: rol/kilit/silme yönetici işi; Geçmiş yok:
  ///   işlem geçmişi yalnız şirket yöneticisine açık, AUDIT-K10);
  /// - üye: Görevler (kendi görünür görevleri);
  /// - bilinmiyor: yok.
  List<UserProfileTab> get profileTabs => switch (this) {
    TeamSource.directory => UserProfileTab.values,
    TeamSource.departmentMembers => const [
      UserProfileTab.tasks,
      UserProfileTab.files,
    ],
    TeamSource.departmentGroup => const [UserProfileTab.tasks],
    TeamSource.none => const [],
  };
}

/// Ekip satırı (koordinatörlükteki bir kişi). E-posta koordinatöre/üyeye dönmez; alan yoktur.
@immutable
final class TeamPerson {
  const TeamPerson({
    required this.accountId,
    required this.name,
    required this.lead,
  });

  final String accountId;
  final String name;

  /// Koordinatörlüğün koordinatörü mü (`role == koordinator`; türetilmiş listede grup
  /// yöneticisi).
  final bool lead;

  @override
  bool operator ==(Object other) =>
      other is TeamPerson &&
      other.accountId == accountId &&
      other.name == name &&
      other.lead == lead;

  @override
  int get hashCode => Object.hash(accountId, name, lead);
}

/// Etkin koordinatörlüğün ekibi. [available] `false`: kaynak yok (üye görünümünde sohbet
/// grubu bulunamadı) — ekran "backend bekliyor" boş durumunu gösterir.
@immutable
final class TeamRoster {
  TeamRoster({
    required this.source,
    required this.departmentId,
    required List<TeamPerson> people,
    this.truncated = false,
    this.available = true,
  }) : people = List.unmodifiable(
         <TeamPerson>[...people]..sort((a, b) {
           if (a.lead != b.lead) return a.lead ? -1 : 1;
           return compareTurkish(a.name, b.name);
         }),
       );

  final TeamSource source;
  final String departmentId;

  /// Önce koordinatörler, sonra üyeler; her grupta Türkçe ad sırası.
  final List<TeamPerson> people;
  final bool truncated;
  final bool available;

  TeamPerson? person(String accountId) =>
      people.where((p) => p.accountId == accountId).firstOrNull;

  int get leads => people.where((p) => p.lead).length;
  int get members => people.length - leads;

  /// Rol bölücüsünün (Tümü, Koordinatör, Üye) sayısı.
  int countFor(AdminUserRoleFilter role) => switch (role) {
    AdminUserRoleFilter.coordinator => leads,
    AdminUserRoleFilter.member => members,
    AdminUserRoleFilter.all || AdminUserRoleFilter.admin => people.length,
  };

  /// [role] ve [search] (ad, Türkçe büyük/küçük harf duyarsız) süzgeci.
  List<TeamPerson> filter({
    AdminUserRoleFilter role = AdminUserRoleFilter.all,
    String search = '',
  }) {
    final q = trLower(search.trim());
    return [
      for (final p in people)
        if ((role != AdminUserRoleFilter.coordinator || p.lead) &&
            (role != AdminUserRoleFilter.member || !p.lead) &&
            (q.isEmpty || trLower(p.name).contains(q)))
          p,
    ];
  }
}

/// Ekibim rol bölücüsü: yöneticisiz üç öğe (Tümü, Koordinatör, Üye).
const teamRoleFilters = [
  AdminUserRoleFilter.all,
  AdminUserRoleFilter.coordinator,
  AdminUserRoleFilter.member,
];

/// "Ekipten çıkar" yalnız koordinatör görünümünde, yalnız üyeye (koordinatör ataması
/// yönetici işi) ve kişinin kendisine değil (`DELETE …/memberships/{accountId}`, ORGANIZATION
/// README §4: K yalnız `uye`). Sunucu yine denetler.
bool canRemoveFromTeam(
  TeamSource source,
  TeamPerson? target, {
  required String? me,
}) =>
    source == TeamSource.departmentMembers &&
    target != null &&
    !target.lead &&
    target.accountId != me;
