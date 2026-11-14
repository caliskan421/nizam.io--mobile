import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../scope/scope.dart' show DepartmentRole;
import '../../tasks/tasks.dart';
import '../domain/department.dart';
import 'coordinatorships_providers.dart';

/// Yönetici bütün program ekiplerini okuyabilir; atanabilir havuz ise yalnız hedef
/// koordinatörüne açıktır (ORGANIZATION-K16). İki yüz aynı üyelik yazmasına bağlanır.
final coordMemberCandidatesProvider = FutureProvider.autoDispose
    .family<PageSlice<AssignableAccount>, String>((ref, code) async {
      final session = ref.watch(sessionGenerationProvider);
      final scope = ref.watch(scopeStateProvider);
      final program = scope.programId;
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      if (program == null ||
          !(catalog.access?.canCreateIn(program, code) ?? false)) {
        throw ApiError('organization.not_authorized');
      }
      if (!ref.mounted ||
          ref.read(sessionGenerationProvider) != session ||
          ref.read(scopeStateProvider) != scope) {
        throw ApiError('client.scope_changed');
      }
      final repo = ref.read(departmentRepositoryProvider);
      PageSlice<AssignableAccount> result;
      if (!catalog.viewIn(scope).isAdminView) {
        result = await repo.listAssignable(code);
      } else {
        final groups = catalog.coordinatorships;
        final teams = await Future.wait([
          for (final g in groups) repo.listMembers(g.code),
        ]);
        final target = <String>{};
        final seats = <({String id, String name, String role})>[];
        for (var i = 0; i < groups.length; i++) {
          for (final p in teams[i].items) {
            final account = p.accountId;
            if (p.status != MemberStatus.active || account == null) continue;
            if (groups[i].code == code) {
              target.add(account);
            } else {
              seats.add((
                id: account,
                name: p.name,
                role:
                    '${groups[i].code}:${p.role == DepartmentRole.coordinator ? 'koordinator' : 'uye'}',
              ));
            }
          }
        }
        // Hesap sırası aynı kişinin farklı ekiplerini bitişik getirir; havuzu
        // büyüklüğüyle karesel dolaşmadan tek geçişte birleştirir.
        seats.sort((a, b) => a.id.compareTo(b.id));
        final candidates = <AssignableAccount>[];
        for (var i = 0; i < seats.length;) {
          final person = seats[i];
          final roles = <String>[];
          do {
            roles.add(seats[i++].role);
          } while (i < seats.length && seats[i].id == person.id);
          if (!target.contains(person.id)) {
            candidates.add(
              AssignableAccount(
                accountId: person.id,
                fullName: person.name,
                roles: roles,
              ),
            );
          }
        }
        result = PageSlice(
          items: candidates,
          truncated:
              catalog.departmentsTruncated || teams.any((t) => t.truncated),
        );
      }
      if (!ref.mounted ||
          ref.read(sessionGenerationProvider) != session ||
          ref.read(scopeStateProvider) != scope) {
        throw ApiError('client.scope_changed');
      }
      return result;
    });

final coordMemberControllerProvider = NotifierProvider.autoDispose
    .family<CoordMemberController, CoordMemberState, String>(
      CoordMemberController.new,
    );

class CoordMemberState {
  const CoordMemberState({this.selected, this.busy = false, this.error});
  final String? selected;
  final bool busy;
  final ApiError? error;
}

/// Var olan kişiye yalnız hedef program/departmanda üye satırı ekler. Kaynak
/// üyeliklere dokunmaz; yetkiyi ve havuzu gönderimde yeniden denetler.
class CoordMemberController extends Notifier<CoordMemberState> {
  CoordMemberController(this.code);
  final String code;
  int _epoch = 0;

  @override
  CoordMemberState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch++;
    return const CoordMemberState();
  }

  void select(String account) {
    if (!state.busy) state = CoordMemberState(selected: account);
  }

  Future<bool> submit() async {
    final id = state.selected;
    if (id == null || state.busy) return false;
    final candidates = ref.read(coordMemberCandidatesProvider(code)).value;
    final program = ref.read(scopeStateProvider).programId;
    final access = ref.read(taskCatalogControllerProvider).value?.access;
    if (program == null ||
        !(access?.canCreateIn(program, code) ?? false) ||
        !(candidates?.items.any((p) => p.accountId == id) ?? false)) {
      state = CoordMemberState(
        selected: id,
        error: ApiError('organization.not_authorized'),
      );
      return false;
    }
    final epoch = _epoch;
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    bool live() =>
        ref.mounted &&
        _epoch == epoch &&
        ref.read(scopeStateProvider) == scope &&
        ref.read(sessionGenerationProvider) == session;
    state = CoordMemberState(selected: id, busy: true);
    try {
      await ref
          .read(departmentRepositoryProvider)
          .assignMembership(
            code,
            accountId: id,
            role: DepartmentRole.member,
            programId: program,
          );
      if (!live()) return false;
      ref.invalidate(taskTeamProvider(code));
      ref.invalidate(coordMemberCandidatesProvider(code));
      await ref.read(taskCatalogControllerProvider.notifier).reload();
      if (!live()) return false;
      state = const CoordMemberState();
      return true;
    } on Object catch (e, st) {
      final error = toReportedApiError(
        e,
        st,
        source: ReportSource.coordinatorships,
      );
      if (live()) {
        state = CoordMemberState(selected: id, error: error);
        if (error.code == 'organization.membership_exists') {
          ref.invalidate(coordMemberCandidatesProvider(code));
        }
      }
      return false;
    }
  }
}
