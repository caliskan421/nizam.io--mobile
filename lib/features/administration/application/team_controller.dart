import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../coordinatorships/coordinatorships.dart';
import '../../messages/messages.dart';
import '../../scope/scope.dart' show DepartmentRole;
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';
import '../domain/team_view.dart';

/// Etkin görünümün ekip kaynağı ([teamSourceFor]); sayfa ve kullanıcı ayrıntısı bununla dallanır.
final teamSourceProvider = Provider.autoDispose<TeamSource>((ref) {
  final view = ref.watch(effectiveAccessProvider);
  return teamSourceFor(
    known: view.known,
    role: view.role,
    departmentId: view.departmentId,
  );
});

/// Etkin koordinatörlüğün ekibi (yönetici dizininde ve kaynak yokken `null`).
/// - Koordinatör: görev kataloğunun ekibi. Katalog bu ekibi koordinatörün okuyabildiği
///   departmanlar için `GET /v1/departments/{id}/members` ile (etkin üyeler) okur; üye
///   ekle/çıkar sonrası katalog yeniden okunur, liste kendiliğinden tazelenir (ikinci okuma yok).
/// - Üye: koordinatörlük sohbet grubunun kaynaklı üyeleri ([departmentGroupTeamProvider];
///   salt okunur). Grup yoksa [TeamRoster.available] `false`.
final teamRosterProvider = FutureProvider.autoDispose<TeamRoster?>((ref) async {
  final view = ref.watch(effectiveAccessProvider);
  final source = ref.watch(teamSourceProvider);
  final department = view.departmentId;
  if (department == null) return null;
  switch (source) {
    case TeamSource.directory || TeamSource.none:
      return null;
    case TeamSource.departmentMembers:
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      final team = catalog.coordinatorship(department);
      String name(String id) => catalog.nameOf(id) ?? '—';
      return TeamRoster(
        source: source,
        departmentId: department,
        people: [
          for (final id in team?.leads ?? const <String>[])
            TeamPerson(accountId: id, name: name(id), lead: true),
          for (final id in team?.members ?? const <String>[])
            if (!(team?.leads.contains(id) ?? false))
              TeamPerson(accountId: id, name: name(id), lead: false),
        ],
      );
    case TeamSource.departmentGroup:
      final group = await ref.watch(
        departmentGroupTeamProvider(department).future,
      );
      return TeamRoster(
        source: source,
        departmentId: department,
        available: group != null,
        truncated: group?.truncated ?? false,
        people: [
          for (final m in group?.items ?? const <ChatMember>[])
            TeamPerson(
              accountId: m.accountId,
              name: m.name,
              // Kaynaklı koordinatörlük grubunda yöneticiler o koordinatörlüğün
              // koordinatörleridir (MESSAGING-K07).
              lead: m.role == ChatMemberRole.admin,
            ),
        ],
      );
  }
});

/// Ekip satırının kullanıcı ayrıntısı için hesap görünümü (e-posta yok: koordinatöre ve üyeye
/// dönmez). Kişi etkin koordinatörlüğün ekibinde değilse `null` ("bulunamadı").
final teamUserProfileProvider = FutureProvider.autoDispose
    .family<KnownUser?, String>((ref, accountId) async {
      final roster = await ref.watch(teamRosterProvider.future);
      final person = roster?.person(accountId);
      if (roster == null || person == null) return null;
      final view = ref.read(effectiveAccessProvider);
      return KnownUser(
        accountId: person.accountId,
        fullName: person.name,
        memberships: const [],
        teams: [
          UserMembership(
            programId: view.programId ?? '',
            departmentId: roster.departmentId,
            role: person.lead
                ? DepartmentRole.coordinator
                : DepartmentRole.member,
            displayName: view.departmentName ?? '',
          ),
        ],
      );
    });

/// Kişinin [department] koordinatörlüğündeki açık ve geciken görev sayısı (katalogdan).
({int open, int late}) teamLoadOf(
  TaskCatalog catalog,
  String department,
  String accountId,
) {
  var open = 0;
  var late = 0;
  for (final t in catalog.tasksOf(department)) {
    if (t.isDone || !t.assignees.contains(accountId)) continue;
    open++;
    if (t.isOverdue) late++;
  }
  return (open: open, late: late);
}

/// Ekip komutları (koordinatör): "Ekipten çıkar". Durum = meşgul.
final teamCommandProvider =
    NotifierProvider.autoDispose<TeamCommandController, bool>(
      TeamCommandController.new,
    );

class TeamCommandController extends Notifier<bool> {
  @override
  bool build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return false;
  }

  /// [accountId]'yi etkin koordinatörlüğün ekibinden çıkarır
  /// (`DELETE /v1/departments/{id}/memberships/{accountId}`). Hesap silinmez; diğer
  /// koordinatörlüklerdeki yeri değişmez. Görev etkisi varsa sunucu [confirm] olmadan 409
  /// `organization.confirmation_required` döner (çağıran onay alıp yeniden dener).
  Future<void> remove(String accountId, {bool confirm = false}) async {
    if (state) return;
    final roster = ref.read(teamRosterProvider).value;
    final me = ref.read(effectiveAccessProvider).access?.accountId;
    final source = ref.read(teamSourceProvider);
    if (roster == null ||
        !canRemoveFromTeam(source, roster.person(accountId), me: me)) {
      throw ApiError('organization.not_authorized');
    }
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    bool live() =>
        ref.mounted &&
        session == ref.read(sessionGenerationProvider) &&
        scope == ref.read(scopeStateProvider);
    state = true;
    try {
      await ref
          .read(departmentRepositoryProvider)
          .removeMember(roster.departmentId, accountId, confirm: confirm);
      if (!live()) throw ApiError(ClientErrorCode.scopeChanged);
      ref.invalidate(taskTeamProvider(roster.departmentId));
      await ref.read(taskCatalogControllerProvider.notifier).reload();
    } finally {
      if (live()) state = false;
    }
  }
}
