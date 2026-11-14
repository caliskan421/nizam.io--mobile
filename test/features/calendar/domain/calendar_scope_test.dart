// Takvim kapsam süzgeci: yönetici görünümü her şeyi, Koordinatör/Üye görünümü yalnız etkin
// koordinatörlüğün toplantı ve görevlerini görür; koordinatörlük bilinmiyorsa hiçbir kayıt.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';
import 'package:nizamio/features/calendar/domain/calendar_scope.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/tasks/tasks.dart';

final _day = DateTime(2026, 11, 5);

Meeting _meeting(String id, List<String> depts) => Meeting(
  id: id,
  programId: 'p',
  ownerDepartmentId: depts.first,
  title: id,
  meetingDate: _day.add(const Duration(hours: 10)),
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.coordinator,
  createdAt: _day,
  updatedAt: _day,
  departments: [for (final d in depts) MeetingDepartment(id: d, name: d)],
);

TaskItem _task(String code, String dept) => TaskItem(
  code: code,
  title: code,
  coordinatorship: dept,
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: _day,
  due: _day,
  assignees: const [],
);

CalendarIndex _index(String? scope) => CalendarIndex.build(
  [
    _meeting('alt-only', ['alt']),
    _meeting('ele-owned-alt-invited', ['ele', 'alt']),
    _meeting('ele-only', ['ele']),
  ],
  TaskCatalog(
    today: _day,
    me: 'me',
    tasks: [_task('t-alt', 'alt'), _task('t-ele', 'ele')],
    people: const [],
    coordinatorships: const [],
  ),
  coordinatorship: scope,
);

Set<String> _meetings(CalendarIndex ix) =>
    ix.on(_day).whereType<MeetingEntry>().map((e) => e.id).toSet();

Set<String> _tasks(CalendarIndex ix) =>
    ix.on(_day).whereType<TaskEntry>().map((e) => e.code).toSet();

void main() {
  test('yönetici görünümü süzgeçsiz', () {
    final scope = calendarScope(known: true, seesAll: true, department: 'alt');
    expect(scope, isNull);
    final ix = _index(scope);
    expect(_meetings(ix), hasLength(3));
    expect(_tasks(ix), {'t-alt', 't-ele'});
  });

  test('koordinatör/üye görünümü yalnız etkin koordinatörlük (davetli olunan dahil)', () {
    final scope = calendarScope(known: true, seesAll: false, department: 'alt');
    expect(scope, 'alt');
    final ix = _index(scope);
    expect(_meetings(ix), {'alt-only', 'ele-owned-alt-invited'});
    expect(_tasks(ix), {'t-alt'});
  });

  test('görünümde koordinatörlük yoksa hiçbir kayıt', () {
    final ix = _index(
      calendarScope(known: true, seesAll: false, department: null),
    );
    expect(_meetings(ix), isEmpty);
    expect(_tasks(ix), isEmpty);
  });

  test('erişim bilinmiyorsa ek süzgeç yok (görünürlük sunucuda)', () {
    expect(
      calendarScope(known: false, seesAll: false, department: 'alt'),
      isNull,
    );
  });
}
