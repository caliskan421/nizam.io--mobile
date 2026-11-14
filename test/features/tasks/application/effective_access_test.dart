// Etkin görünüm: seçili üçlü + sunucu erişimi → rol, koordinatörlük ve yetenek bayrakları.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TeamSeat _seat(String dept, SeatRole role, {String program = 'p1'}) => TeamSeat(
  programId: program,
  departmentId: dept,
  departmentName: 'Ad $dept',
  role: role,
);

TaskAccess _access({bool admin = false, List<TeamSeat> seats = const []}) =>
    TaskAccess(accountId: 'me', companyAdmin: admin, seats: seats);

const _p1 = ScopeSelection(programId: 'p1');

void main() {
  final seats = [
    _seat('ALT', SeatRole.member),
    _seat('MEK', SeatRole.coordinator),
    _seat('X', SeatRole.unknown),
    _seat('ULA', SeatRole.coordinator, program: 'p2'),
  ];

  test('TaskAccess: program başına roller ve koordinatörlükler', () {
    final a = _access(admin: true, seats: seats);
    expect(a.rolesIn('p1'), [
      EffectiveRole.admin,
      EffectiveRole.coordinator,
      EffectiveRole.member,
    ]);
    expect(_access(seats: seats).rolesIn('p2'), [EffectiveRole.coordinator]);
    expect(
      a
          .departmentsFor('p1', EffectiveRole.coordinator)
          .map((s) => s.departmentId),
      ['MEK'],
    );
    expect(a.departmentsFor('p1', EffectiveRole.admin), isEmpty);
    expect(a.grantsIn('p1').seats.map((s) => s.departmentId), [
      'ALT',
      'MEK',
    ], reason: 'tanımsız rol hak vermez');
  });

  test('varsayılan: yönetici → Yönetici, tüm koordinatörlükler', () {
    final v = EffectiveAccess.of(_access(admin: true, seats: seats), _p1);
    expect((v.role, v.departmentId), (EffectiveRole.admin, null));
    expect(
      (v.isAdminView, v.seesAllDepartments, v.canAdminister, v.canManageTeam),
      (true, true, true, true),
    );
    expect(v.canReviewDateRequests, isTrue);
    expect(v.canAssign, isTrue, reason: 'birleşik rol: koordinatörlüğü var');
    expect(v.departmentName, isNull);
  });

  test('yönetici Üye görünümü: yönetici ve koordinatör eylemleri gizli', () {
    final v = EffectiveAccess.of(
      _access(admin: true, seats: seats),
      const ScopeSelection(programId: 'p1', role: EffectiveRole.member),
    );
    expect((v.role, v.departmentId), (EffectiveRole.member, 'ALT'));
    expect(
      (v.canAdminister, v.canManageTeam, v.canApprove, v.canCreateTask),
      (false, false, false, false),
    );
    final view = v.viewAccess!;
    expect(view.companyAdmin, isFalse);
    expect(view.coordinatesIn('p1', 'MEK'), isFalse, reason: 'üye sayılır');
    expect(view.coordinatesIn('p2', 'ULA'), isTrue, reason: 'başka program');
    expect(v.departmentName, 'Ad ALT');
  });

  test('koordinatör: varsayılan ilk koordinatörlük; geçersiz seçim düşer', () {
    final a = _access(seats: seats);
    final v = EffectiveAccess.of(a, _p1);
    expect((v.role, v.departmentId), (EffectiveRole.coordinator, 'MEK'));
    expect(
      (v.isCoordinatorView, v.canManageTeam, v.canApprove, v.canAssign),
      (true, true, true, true),
    );
    expect((v.canAdminister, v.canReviewDateRequests), (false, false));
    final forged = EffectiveAccess.of(
      a,
      const ScopeSelection(
        programId: 'p1',
        role: EffectiveRole.admin,
        departmentId: 'ULA',
      ),
    );
    expect(
      (forged.role, forged.departmentId),
      (EffectiveRole.coordinator, 'MEK'),
    );
    expect(forged.canAdminister, isFalse);
  });

  test('erişim bilinmiyor: rol seçimden, yetenek yok (fail-closed)', () {
    final v = EffectiveAccess.of(
      null,
      const ScopeSelection(programId: 'p1', role: EffectiveRole.admin),
    );
    expect(v.known, isFalse);
    expect(v.role, EffectiveRole.admin);
    expect(
      (v.isAdminView, v.canAdminister, v.canCreateTask),
      (false, false, false),
    );
    expect(v.viewAccess, isNull);
  });

  test('eşitlik: aynı erişim ve görünüm eşit', () {
    final a = _access(seats: seats);
    expect(EffectiveAccess.of(a, _p1), EffectiveAccess.of(a, _p1));
    expect(
      EffectiveAccess.of(a, _p1) ==
          EffectiveAccess.of(_access(seats: seats), _p1),
      isFalse,
    );
  });
}
