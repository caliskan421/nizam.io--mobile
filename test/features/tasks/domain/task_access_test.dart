// TaskAccess: rol türetmenin tek yeri — kapsam başına ekip rolü (program × departman), birleşik
// rol (yönetici + koordinatör), tarih talebi yüzü seçimi (yönetici kuyruk, koordinatör kendi,
// üye/rolsüz yok) ve oturum kişisinin görünüm rolü.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

TeamSeat _seat(String program, String dept, SeatRole role) => TeamSeat(
  programId: program,
  departmentId: dept,
  departmentName: 'Ad $dept',
  role: role,
);

TaskAccess _access({bool admin = false, List<TeamSeat> seats = const []}) =>
    TaskAccess(accountId: 'me', companyAdmin: admin, seats: seats);

void main() {
  test('rol program × departman başınadır (aynı departman iki programda)', () {
    final a = _access(
      seats: [
        _seat('p1', 'd1', SeatRole.member),
        _seat('p2', 'd1', SeatRole.coordinator),
      ],
    );
    expect(a.roleIn('p1', 'd1'), SeatRole.member);
    expect(a.roleIn('p2', 'd1'), SeatRole.coordinator);
    expect(a.roleIn('p1', 'd2'), isNull);
    expect(a.seesAllIn('p1', 'd1'), isFalse);
    expect(a.seesAllIn('p2', 'd1'), isTrue);
    expect(a.seatsIn('p1').map((s) => s.departmentId), ['d1']);
  });

  test('tarih talebi yüzü: rol → uç', () {
    final coord = _access(seats: [_seat('p1', 'd1', SeatRole.coordinator)]);
    final member = _access(seats: [_seat('p1', 'd1', SeatRole.member)]);
    final unknown = _access(seats: [_seat('p1', 'd1', SeatRole.unknown)]);
    final admin = _access(admin: true);
    final both = _access(
      admin: true,
      seats: [_seat('p1', 'd1', SeatRole.coordinator)],
    );

    expect(admin.dateRequestFeed('p1', 'd1'), DateRequestFeed.reviewQueue);
    expect(both.dateRequestFeed('p1', 'd1'), DateRequestFeed.reviewQueue);
    expect(coord.dateRequestFeed('p1', 'd1'), DateRequestFeed.mine);
    expect(
      coord.dateRequestFeed('p2', 'd1'),
      DateRequestFeed.none,
      reason: 'koordinatörlük başka programda',
    );
    expect(coord.dateRequestFeed('p1', null), DateRequestFeed.none);
    expect(coord.dateRequestFeed('p1', ''), DateRequestFeed.none);
    expect(member.dateRequestFeed('p1', 'd1'), DateRequestFeed.none);
    expect(unknown.dateRequestFeed('p1', 'd1'), DateRequestFeed.none);
  });

  test('birleşik rol: yönetici bayrağı + kapsamdaki koordinatörlük', () {
    final both = _access(
      admin: true,
      seats: [_seat('p1', 'd1', SeatRole.coordinator)],
    );
    expect(both.coordinatesIn('p1', 'd1'), isTrue);
    expect(both.seesAllIn('p1', 'd9'), isTrue, reason: 'yönetici her kapsamda');
    expect(_access(admin: true).coordinatesIn('p1', 'd1'), isFalse);
  });

  test('görünüm rolü: yönetici > programda koordinatörlük > üye', () {
    expect(_access(admin: true).personRoleIn('p1'), PersonRole.admin);
    final a = _access(
      seats: [
        _seat('p1', 'd1', SeatRole.member),
        _seat('p1', 'd2', SeatRole.coordinator),
        _seat('p2', 'd3', SeatRole.member),
      ],
    );
    expect(a.personRoleIn('p1'), PersonRole.coordinator);
    expect(a.personRoleIn('p2'), PersonRole.member);
  });
}
