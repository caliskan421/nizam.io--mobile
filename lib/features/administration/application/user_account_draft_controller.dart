import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/expected_failure.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../coordinatorships/coordinatorships.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';
import '../domain/user_account_draft.dart';
import 'admin_controller.dart';

final userAccountDraftProvider = NotifierProvider.autoDispose
    .family<UserAccountDraftController, UserAccountDraft?, String>(
      UserAccountDraftController.new,
    );

class UserAccountDraftController extends Notifier<UserAccountDraft?> {
  UserAccountDraftController(this.accountId);
  final String accountId;
  int _generation = 0;
  AccountDraftValues? _lastSource;
  @override
  UserAccountDraft? build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _generation++;
    _lastSource = null;
    return null;
  }

  static bool _same(AccountDraftValues a, AccountDraftValues b) =>
      a.fullName == b.fullName &&
      a.email == b.email &&
      a.companyAdmin == b.companyAdmin &&
      UserAccountDraft.sameTeams(a.teams, b.teams);
  void initialize(
    KnownUser user, {
    required String? email,
    required bool? companyAdmin,
  }) {
    if (user.accountId != accountId) return;
    final program = ref.read(scopeStateProvider).programId;
    final source = AccountDraftValues(
      fullName: user.fullName,
      email: email,
      companyAdmin: companyAdmin,
      teams: [
        for (final m in user.teams)
          if (m.programId == program)
            AccountTeamDraft(departmentId: m.departmentId, role: m.role),
      ],
    );
    final existing = state;
    if (existing == null) {
      _lastSource = source;
      state = UserAccountDraft(
        base: source,
        value: source,
        roleForNew:
            source.teams
                .where((t) => t.role != DepartmentRole.unknown)
                .firstOrNull
                ?.role ??
            DepartmentRole.member,
      );
      return;
    }
    if (existing.busy) return;
    if (existing.dirty) {
      if (existing.base.companyAdmin == null && companyAdmin != null) {
        state = existing.copyWith(
          base: existing.base.copyWith(companyAdmin: () => companyAdmin),
          value: existing.value.copyWith(companyAdmin: () => companyAdmin),
        );
      }
      return;
    }
    if (_lastSource != null && _same(_lastSource!, source)) return;
    _lastSource = source;
    // Unknown fields are not evidence that a value accepted on save was removed.
    final fresh = source.copyWith(
      email: () => email ?? existing.base.email,
      companyAdmin: () => companyAdmin ?? existing.base.companyAdmin,
    );
    if (_same(existing.base, fresh) && _same(existing.value, fresh)) return;
    state = UserAccountDraft(
      base: fresh,
      value: fresh,
      roleForNew:
          fresh.teams
              .where((t) => t.role != DepartmentRole.unknown)
              .firstOrNull
              ?.role ??
          existing.roleForNew,
    );
  }

  void _edit(UserAccountDraft Function(UserAccountDraft) change) {
    final before = state;
    if (before == null || before.busy) return;
    state = change(before).copyWith(error: () => null);
  }

  void setFullName(String value) =>
      _edit((s) => s.copyWith(value: s.value.copyWith(fullName: value.trim())));
  void setEmail(String value) => _edit(
    (s) => s.copyWith(value: s.value.copyWith(email: () => value.trim())),
  );
  void setPassword(String value) => _edit((s) => s.copyWith(password: value));
  void toggleAdmin() => _edit(
    (s) => s.value.companyAdmin == null
        ? s
        : s.copyWith(
            value: s.value.copyWith(companyAdmin: () => !s.value.companyAdmin!),
          ),
  );
  void selectRole(DepartmentRole role, {required Set<String> departmentIds}) {
    if (role == DepartmentRole.unknown) return;
    _edit(
      (s) => s.copyWith(
        roleForNew: role,
        value: s.value.copyWith(
          teams: [
            for (final t in s.value.teams)
              AccountTeamDraft(
                departmentId: t.departmentId,
                role: departmentIds.contains(t.departmentId) ? role : t.role,
              ),
          ],
        ),
      ),
    );
  }

  void setDepartmentRole(
    String id,
    DepartmentRole role, {
    required bool selected,
  }) {
    if (role == DepartmentRole.unknown) return;
    _edit(
      (s) => s.copyWith(
        roleForNew: role,
        value: s.value.copyWith(
          teams: [
            for (final team in s.value.teams)
              if (team.departmentId != id) team,
            if (selected) AccountTeamDraft(departmentId: id, role: role),
          ],
        ),
      ),
    );
  }

  void clearDepartmentRole(DepartmentRole role, Set<String> departmentIds) =>
      _edit(
        (s) => s.copyWith(
          value: s.value.copyWith(
            teams: [
              for (final team in s.value.teams)
                if (team.role != role ||
                    !departmentIds.contains(team.departmentId))
                  team,
            ],
          ),
        ),
      );

  void discard() => _edit(
    (s) => s.copyWith(
      value: s.base,
      password: '',
      roleForNew: s.base.teams.firstOrNull?.role ?? DepartmentRole.member,
    ),
  );

  Future<AccountSaveResult> save({
    required Future<bool> Function() confirmEffects,
  }) async {
    final initial = state;
    if (initial == null ||
        !initial.dirty ||
        initial.busy ||
        !initial.valid ||
        ref.read(adminCommandProvider)) {
      return AccountSaveResult.unchanged;
    }
    final generation = _generation;
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    final self =
        ref.read(taskCatalogControllerProvider).value?.access?.accountId ==
        accountId;
    // Either operation ends this administrator's session/authority. They need separate saves.
    if (self &&
        initial.password.isNotEmpty &&
        initial.adminChanged &&
        initial.value.companyAdmin == false) {
      state = initial.copyWith(
        error: () => ApiError('organization.not_authorized'),
      );
      return AccountSaveResult.failed;
    }
    bool current() =>
        ref.mounted &&
        generation == _generation &&
        session == ref.read(sessionGenerationProvider) &&
        scope == ref.read(scopeStateProvider);
    void check() {
      if (!current()) throw ApiError('client.scope_changed');
    }

    void applyTeam(String id, DepartmentRole? role) {
      check();
      final s = state!;
      state = s.copyWith(
        base: s.base.copyWith(
          teams: [
            for (final t in s.base.teams)
              if (t.departmentId != id) t,
            if (role != null) AccountTeamDraft(departmentId: id, role: role),
          ],
        ),
      );
    }

    Future<void> withEffects(Future<void> Function(bool) write) async {
      check();
      try {
        await write(false);
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.administration);
        if (e.code != 'organization.confirmation_required') rethrow;
        check();
        if (!await confirmEffects()) throw const _SaveCancelled();
        check();
        await write(true);
      }
    }

    state = initial.copyWith(busy: true, error: () => null);
    try {
      final departments = ref.read(departmentRepositoryProvider);
      await ref.read(adminCommandProvider.notifier).run((
        organization,
        _,
      ) async {
        // Each accepted operation advances the baseline immediately. Retrying a partial
        // save only executes the remaining differences; accepted writes never replay.
        for (final target in initial.value.teams) {
          check();
          final old = state!.base.teams
              .where((t) => t.departmentId == target.departmentId)
              .firstOrNull;
          if (old?.role == target.role) continue;
          if (old == null) {
            await departments.assignMembership(
              target.departmentId,
              accountId: accountId,
              role: target.role,
            );
          } else {
            await withEffects((confirm) async {
              await departments.changeMembershipRole(
                target.departmentId,
                accountId,
                role: target.role,
                confirm: confirm,
              );
            });
          }
          applyTeam(target.departmentId, target.role);
        }
        final removals = [
          for (final old in state!.base.teams)
            if (!initial.value.teams.any(
              (t) => t.departmentId == old.departmentId,
            ))
              old,
        ];
        for (final old in removals) {
          await withEffects((confirm) async {
            await departments.removeMember(
              old.departmentId,
              accountId,
              confirm: confirm,
            );
          });
          applyTeam(old.departmentId, null);
        }
        Future<void> account() async {
          check();
          final s = state!;
          if (!s.basicChanged) return;
          await organization.updateAccount(
            accountId,
            fullName: s.base.fullName == s.value.fullName
                ? null
                : s.value.fullName,
            email: s.base.email == s.value.email ? null : s.value.email,
            password: s.password.isEmpty ? null : s.password,
          );
          check();
          state = state!.copyWith(
            base: state!.base.copyWith(
              fullName: s.value.fullName,
              email: () => s.value.email,
            ),
            password: '',
          );
        }

        Future<void> admin() async {
          check();
          final s = state!;
          if (!s.adminChanged || s.value.companyAdmin == null) return;
          await organization.updateUser(
            accountId,
            companyAdmin: s.value.companyAdmin,
          );
          check();
          state = state!.copyWith(
            base: state!.base.copyWith(
              companyAdmin: () => s.value.companyAdmin,
            ),
          );
        }

        // Self-password replacement is last; revoking one's admin flag is last otherwise.
        if (self && state!.password.isNotEmpty) {
          await admin();
          await account();
        } else {
          await account();
          await admin();
        }
      });
      if (current()) state = state!.copyWith(busy: false);
      return AccountSaveResult.saved;
    } on _SaveCancelled {
      if (current()) state = state!.copyWith(busy: false);
      return AccountSaveResult.cancelled;
    } on Object catch (e, st) {
      // Rapor/çeviri durum korumasından ÖNCE: kapsam değişimi ya da dispose sonrası gelen
      // beklenmeyen hata da raporlanır; yalnız durum yazımı koruma altındadır.
      final api = toReportedApiError(
        e,
        st,
        source: ReportSource.administration,
      );
      if (current()) {
        state = state!.copyWith(busy: false, error: () => api);
      }
      return AccountSaveResult.failed;
    }
  }
}

class _SaveCancelled implements Exception, ExpectedFailure {
  const _SaveCancelled();
}
