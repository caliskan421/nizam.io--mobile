// Üye adımları: durumdan bant hâli, başlatma/onaya sunma koşulları (matris + kilit), kanıt ön
// denetimi ve iade/gönderim notu seçimi.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/domain/member_flow.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_permissions.dart';

TaskItem _t(
  TaskStatus status, {
  List<String> assignees = const ['me'],
  bool evidence = false,
}) => TaskItem(
  code: 'w1',
  title: 'w1',
  coordinatorship: 'd1',
  departmentId: 'd1',
  programId: 'p1',
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 10),
  due: DateTime(2026, 10, 10),
  assignees: assignees,
  evidenceRequired: evidence,
);

TaskPermissions _perms(TaskItem t, SeatRole role) => TaskPermissions.of(
  TaskAccess(
    accountId: 'me',
    companyAdmin: false,
    seats: [
      TeamSeat(
        programId: 'p1',
        departmentId: 'd1',
        departmentName: 'Altyapı',
        role: role,
      ),
    ],
  ),
  t,
);

TaskNote _n(String by, int day, String text) =>
    TaskNote(by: by, at: DateTime(2026, 10, day), text: text);

void main() {
  test('bant hâli durumdan', () {
    expect(MemberStep.of(_t(TaskStatus.todo)), MemberStep.start);
    expect(MemberStep.of(_t(TaskStatus.returned)), MemberStep.fix);
    expect(MemberStep.of(_t(TaskStatus.inProgress)), MemberStep.submit);
    expect(MemberStep.of(_t(TaskStatus.review)), MemberStep.waiting);
    expect(MemberStep.of(_t(TaskStatus.done)), MemberStep.none);
  });

  group('atanmış üye', () {
    bool start(TaskStatus s, {int blocking = 0}) {
      final t = _t(s);
      return canStartTask(_perms(t, SeatRole.member), t, blocking: blocking);
    }

    bool submit(TaskStatus s) {
      final t = _t(s);
      return canSubmitTask(_perms(t, SeatRole.member), t);
    }

    test('başlamadı ve iade → devam; kilitliyse başlatılamaz', () {
      expect(start(TaskStatus.todo), isTrue);
      expect(start(TaskStatus.returned), isTrue);
      expect(start(TaskStatus.todo, blocking: 1), isFalse);
      expect(start(TaskStatus.inProgress), isFalse);
      expect(start(TaskStatus.review), isFalse);
    });

    test('yalnız devamdan onaya sunar (başlamadıdan doğrudan değil, K5)', () {
      expect(submit(TaskStatus.inProgress), isTrue);
      expect(submit(TaskStatus.todo), isFalse);
      expect(submit(TaskStatus.returned), isFalse);
      expect(submit(TaskStatus.review), isFalse);
    });
  });

  test('atanmamış üye ne başlatır ne onaya sunar', () {
    final t = _t(TaskStatus.inProgress, assignees: ['x']);
    final p = _perms(t, SeatRole.member);
    expect(canSubmitTask(p, t), isFalse);
    final todo = _t(TaskStatus.todo, assignees: ['x']);
    expect(canStartTask(_perms(todo, SeatRole.member), todo), isFalse);
  });

  test('kanıt ön denetimi: yalnız kanıt istenip dosya 0 iken eksik', () {
    final req = _t(TaskStatus.inProgress, evidence: true);
    expect(evidenceMissing(req, files: 0), isTrue);
    expect(evidenceMissing(req, files: 1), isFalse);
    expect(evidenceMissing(req, files: null), isFalse);
    expect(evidenceMissing(_t(TaskStatus.inProgress), files: 0), isFalse);
  });

  test(
    'iade notu: benim olmayan en yeni not; gönderim notu: önekli kendi notum',
    () {
      final notes = [
        _n('k', 2, 'eski'),
        _n('me', 5, 'Onaya sunma notu: bitti'),
        _n('k', 4, 'İade sebebi: eksik'),
        _n('me', 6, 'serbest'),
      ];
      expect(lastNote(notes, me: 'me')?.text, 'İade sebebi: eksik');
      expect(
        lastNote(
          notes,
          me: 'me',
          foreign: false,
          head: 'Onaya sunma notu',
        )?.text,
        'Onaya sunma notu: bitti',
      );
      expect(lastNote([_n('me', 1, 'x')], me: 'me'), isNull);
    },
  );
}
