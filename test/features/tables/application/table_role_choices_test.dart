import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/table_destinations.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tasks/tasks.dart';

class Catalog extends TaskCatalogController {
  Catalog(this.catalog);
  final TaskCatalog catalog;
  @override
  Future<TaskCatalog> build() async => catalog;
}

TaskCatalog catalog(SeatRole role, {bool admin = false}) => TaskCatalog(
  today: DateTime(2026, 11, 16),
  me: 'me',
  tasks: const [],
  people: const [
    Person(id: 'me', name: 'Oturumdaki kişi', role: PersonRole.member),
    Person(id: 'coord', name: 'Koordinatör', role: PersonRole.coordinator),
    Person(id: 'member', name: 'Üye', role: PersonRole.member),
    Person(id: 'admin', name: 'Admin', role: PersonRole.admin),
  ],
  departments: [
    const TaskDepartment(id: 'd1', name: 'Ekip', code: 'EKP'),
    const TaskDepartment(id: 'd2', name: 'Başka ekip', code: 'BSK'),
    if (admin)
      const TaskDepartment(id: 'member-dept', name: 'Üye ekibi', code: 'UYE'),
    const TaskDepartment(id: 'unknown', name: 'Bilinmeyen rol', code: 'BLN'),
    const TaskDepartment(id: 'old-program', name: 'Başka program', code: 'DIG'),
  ],
  coordinatorships: const [
    CoordinatorshipRef(
      code: 'd1',
      name: 'Ekip',
      leads: ['coord'],
      members: ['me', 'member'],
    ),
  ],
  access: TaskAccess(
    accountId: 'me',
    companyAdmin: admin,
    seats: [
      if (admin)
        const TeamSeat(
          programId: 'p1',
          departmentId: 'member-dept',
          departmentName: 'Üye ekibi',
          role: SeatRole.member,
        ),
      TeamSeat(
        programId: 'p1',
        departmentId: 'd1',
        departmentName: 'Ekip',
        role: role,
      ),
      const TeamSeat(
        programId: 'p1',
        departmentId: 'unknown',
        departmentName: 'Bilinmeyen rol',
        role: SeatRole.unknown,
      ),
      const TeamSeat(
        programId: 'p2',
        departmentId: 'old-program',
        departmentName: 'Başka program',
        role: SeatRole.coordinator,
      ),
    ],
  ),
);

void main() {
  for (final role in [SeatRole.coordinator, SeatRole.member]) {
    test(
      '$role: kapsam üyeliği ve klasör/onay yönetimi birbirinden ayrılır',
      () async {
        final container = ProviderContainer(
          overrides: [
            sessionGenerationProvider.overrideWith((ref) => 1),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p1'),
            ),
            taskCatalogControllerProvider.overrideWith(
              () => Catalog(catalog(role)),
            ),
          ],
        );
        addTearDown(container.dispose);
        final choices = await container.read(
          tableSharingChoicesProvider.future,
        );
        expect(choices.departments.keys, [const TableDepartmentId('d1')]);
        expect(choices.canPublish('d1'), role == SeatRole.coordinator);
        expect(choices.canPublish('d2'), isFalse);
        expect(choices.canPublish('old-program'), isFalse);
        expect(
          choices.peopleIn('d1').keys,
          containsAll([
            const TablePersonId('coord'),
            const TablePersonId('member'),
            const TablePersonId('admin'),
          ]),
        );
        expect(choices.people, isNot(contains(const TablePersonId('me'))));
        final destinations = await container.read(
          tableDestinationDepartmentsProvider('p1').future,
        );
        expect(destinations.keys, [const TableDepartmentId('d1')]);
      },
    );
  }
  test(
    'birleşik yönetici hesabının Üye görünümünde klasör/onay yönetimi açılmaz',
    () async {
      for (final role in EffectiveRole.values) {
        final container = ProviderContainer(
          overrides: [
            sessionGenerationProvider.overrideWith((ref) => 1),
            scopeStateProvider.overrideWith(
              (ref) => ScopeSelection(
                programId: 'p1',
                role: role,
                departmentId: role == EffectiveRole.member
                    ? 'member-dept'
                    : 'd1',
              ),
            ),
            taskCatalogControllerProvider.overrideWith(
              () => Catalog(catalog(SeatRole.coordinator, admin: true)),
            ),
          ],
        );
        final choices = await container.read(
          tableSharingChoicesProvider.future,
        );
        expect(choices.canPublish('d1'), role != EffectiveRole.member);
        expect(choices.canPublish('d2'), role == EffectiveRole.admin);
        container.dispose();
      }
    },
  );
}
