// TaskCatalogController departman süzgeci (sunucu süzgeci `department_id`, istemci akışları §2):
// kaynağın temizlediği süzgeç (404 `work.program_scope_invalid`) bellekte de düşer; program
// değişince süzgeç sıfırlanır; "Yeni görev" kapısı süzgece ve rol kümesine göre.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

void main() {
  (ProviderContainer, _Repo) harness(TaskAccess access, {_Repo? repo}) {
    final scope = ScopeController()..selectProgram('p1');
    final r = repo ?? _Repo(access);
    final c = ProviderContainer(
      overrides: [
        scopeControllerProvider.overrideWithValue(scope),
        taskCatalogRepositoryProvider.overrideWithValue(r),
      ],
    );
    addTearDown(c.dispose);
    c.listen(taskCatalogControllerProvider, (_, _) {});
    return (c, r);
  }

  final admin = TaskAccess(
    accountId: 'me',
    companyAdmin: true,
    seats: const [],
  );

  test('kaynak süzgeci temizlediyse (404) bellekteki seçim de düşer: sonraki okuma '
      'süzgeçsiz, bilgi bayrağı taşınır', () async {
    final (c, repo) = harness(admin, repo: _Repo(admin, invalid: {'silinmis'}));
    await c.read(taskCatalogControllerProvider.future);
    c.read(taskCatalogControllerProvider.notifier).selectDepartment('silinmis');
    final cleared = await c.read(taskCatalogControllerProvider.future);
    expect(cleared.departmentId, isNull);
    expect(cleared.departmentFilterCleared, isTrue);
    await c.read(taskCatalogControllerProvider.notifier).reload();
    expect(repo.asked, [null, 'silinmis', null]);
    expect(
      c.read(taskCatalogControllerProvider).value!.departmentFilterCleared,
      isFalse,
      reason: 'bilgi yalnız temizlendiği okumada',
    );
  });

  test('program değişince süzgeç sıfırlanır', () async {
    final (c, repo) = harness(admin);
    await c.read(taskCatalogControllerProvider.future);
    c.read(taskCatalogControllerProvider.notifier).selectDepartment('d2');
    await c.read(taskCatalogControllerProvider.future);
    c.read(scopeControllerProvider).selectProgram('p2');
    final next = await c.read(taskCatalogControllerProvider.future);
    expect(repo.asked, [null, 'd2', null]);
    expect(next.departmentId, isNull);
  });

  test('canCreateTask: süzgeç yokken programda koordinatörlük ya da yöneticilik; süzgeçte '
      'o departmanda', () async {
    final mixed = TaskAccess(
      accountId: 'me',
      companyAdmin: false,
      seats: const [
        TeamSeat(
          programId: 'p1',
          departmentId: 'd1',
          departmentName: 'A',
          role: SeatRole.member,
        ),
        TeamSeat(
          programId: 'p1',
          departmentId: 'd2',
          departmentName: 'B',
          role: SeatRole.coordinator,
        ),
      ],
    );
    final (c, _) = harness(mixed);
    c.listen(canCreateTaskProvider, (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    expect(c.read(canCreateTaskProvider), isTrue, reason: 'd2 koordinatörü');
    c.read(taskCatalogControllerProvider.notifier).selectDepartment('d1');
    await c.read(taskCatalogControllerProvider.future);
    expect(c.read(canCreateTaskProvider), isFalse, reason: 'd1 üyesi');

    final member = TaskAccess(
      accountId: 'me',
      companyAdmin: false,
      seats: const [
        TeamSeat(
          programId: 'p1',
          departmentId: 'd1',
          departmentName: 'A',
          role: SeatRole.member,
        ),
      ],
    );
    final (m, _) = harness(member);
    m.listen(canCreateTaskProvider, (_, _) {});
    await m.read(taskCatalogControllerProvider.future);
    expect(m.read(canCreateTaskProvider), isFalse, reason: 'yalnız üye');
  });
}

/// Süzgeci kaydeden sahte kaynak; [invalid] departmanlar sunucunun 404'ü gibi temizlenir.
class _Repo implements TaskCatalogRepository {
  _Repo(this.access, {this.invalid = const {}});

  final TaskAccess access;
  final Set<String> invalid;
  final List<String?> asked = [];

  @override
  Future<TaskCatalog> load({String? departmentId}) async {
    asked.add(departmentId);
    final cleared = departmentId != null && invalid.contains(departmentId);
    return TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      tasks: const [],
      people: const [],
      coordinatorships: const [],
      access: access,
      departmentId: cleared ? null : departmentId,
      departmentFilterCleared: cleared,
      departments: const [
        TaskDepartment(id: 'd1', name: 'A'),
        TaskDepartment(id: 'd2', name: 'B'),
      ],
    );
  }
}
