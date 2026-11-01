// TaskPermissions: işlem bazlı görünürlük olgulardan (yönetici, kapsam koordinatörü/üyesi,
// atanmış, yazar) türetilir — tek rol etiketinden değil (istemci akışları §4–§5). Aktör →
// uç seçimi, geçiş matrisi → görünür hedefler, not/alt görev yetkileri, birleşik roller ve
// başka departmandaki satırın yetki vermemesi.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_permissions.dart';
import 'package:nizamio/features/tasks/domain/work_item.dart';

TaskItem _task({List<String> assignees = const [], TaskStatus? status}) =>
    TaskItem(
      code: 'w1',
      title: 'Hidrofor',
      coordinatorship: 'd1',
      departmentId: 'd1',
      programId: 'p1',
      status: status ?? TaskStatus.inProgress,
      priority: TaskPriority.medium,
      start: DateTime(2026, 7, 2),
      due: DateTime(2026, 9, 20),
      assignees: assignees,
    );

TaskAccess _access({
  bool admin = false,
  SeatRole? role,
  String department = 'd1',
  String program = 'p1',
}) => TaskAccess(
  accountId: 'me',
  companyAdmin: admin,
  seats: [
    if (role != null)
      TeamSeat(
        programId: program,
        departmentId: department,
        departmentName: 'Altyapı',
        role: role,
      ),
  ],
);

TaskPermissions _p(TaskAccess a, {bool assigned = false}) =>
    TaskPermissions.of(a, _task(assignees: assigned ? ['me', 'u2'] : ['u2']));

TaskNote _note(String by, {String? id = 'n1'}) =>
    TaskNote(id: id, by: by, at: DateTime(2026, 10), text: 'Not');

void main() {
  group('aktör → uç ve görünür hedefler (matris)', () {
    test(
      'kapsam koordinatörü (atanmamış): transitions, koordinatör satırı',
      () {
        final p = _p(_access(role: SeatRole.coordinator));
        expect(p.actor, TransitionActor.coordinator);
        expect(p.statusEndpoint, StatusEndpoint.transition);
        expect(p.statusTargets(TaskStatus.inProgress), [
          TaskStatus.todo,
          TaskStatus.done,
        ]);
        expect(p.statusTargets(TaskStatus.review), [
          TaskStatus.done,
          TaskStatus.returned,
        ]);
        expect(p.statusTargets(TaskStatus.done), [TaskStatus.inProgress]);
      },
    );

    test('koordinatör kendi görevinde: birleşim (onaya sunabilir), uç yine transitions', () {
      final p = _p(_access(role: SeatRole.coordinator), assigned: true);
      expect(p.actor, TransitionActor.coordinatorOwnTask);
      expect(p.statusEndpoint, StatusEndpoint.transition);
      expect(p.statusTargets(TaskStatus.inProgress), [
        TaskStatus.todo,
        TaskStatus.review,
        TaskStatus.done,
      ]);
    });

    test('yalnız atanmış üye: own-status, üye satırı', () {
      final p = _p(_access(role: SeatRole.member), assigned: true);
      expect(p.actor, TransitionActor.member);
      expect(p.statusEndpoint, StatusEndpoint.ownStatus);
      expect(p.statusTargets(TaskStatus.todo), [TaskStatus.inProgress]);
      expect(p.statusTargets(TaskStatus.inProgress), [TaskStatus.review]);
      expect(p.statusTargets(TaskStatus.review), isEmpty);
      expect(p.statusTargets(TaskStatus.done), isEmpty);
    });

    test('atanmamış üye: aktör yok, hedef yok', () {
      final p = _p(_access(role: SeatRole.member));
      expect(p.actor, isNull);
      expect(p.statusEndpoint, isNull);
      expect(p.statusTargets(TaskStatus.inProgress), isEmpty);
    });

    test('şirket yöneticisi tek başına aktör değildir (atanmış olsa da)', () {
      final p = _p(_access(admin: true), assigned: true);
      expect(p.actor, isNull);
      expect(p.statusEndpoint, isNull);
      expect(p.statusTargets(TaskStatus.inProgress), isEmpty);
    });

    test(
      'yönetici + aynı kapsamda koordinatör: koordinatör olarak geçirir',
      () {
        final p = _p(_access(admin: true, role: SeatRole.coordinator));
        expect(p.statusEndpoint, StatusEndpoint.transition);
        expect(p.statusTargets(TaskStatus.todo), [
          TaskStatus.inProgress,
          TaskStatus.done,
        ]);
      },
    );

    test('başka departmandaki ya da başka programdaki satır yetki vermez', () {
      for (final a in [
        _access(role: SeatRole.coordinator, department: 'd2'),
        _access(role: SeatRole.coordinator, program: 'p2'),
      ]) {
        final p = _p(a, assigned: true);
        expect(p.actor, isNull);
        expect(p.canAddNote, isFalse);
        expect(p.canManageSubtasks, isFalse);
      }
    });

    test('geri alma gerekçesi yalnız tamamlandı çıkışında', () {
      expect(
        requiresRevertReason(TaskStatus.done, TaskStatus.inProgress),
        isTrue,
      );
      expect(requiresRevertReason(TaskStatus.review, TaskStatus.done), isFalse);
    });
  });

  group('notlar', () {
    test('ekle: koordinatör ve atanmış üye; atanmamış üye hayır', () {
      expect(_p(_access(role: SeatRole.coordinator)).canAddNote, isTrue);
      expect(
        _p(_access(role: SeatRole.member), assigned: true).canAddNote,
        isTrue,
      );
      expect(_p(_access(role: SeatRole.member)).canAddNote, isFalse);
    });

    test(
      'yöneticilik baskın: koordinatör ya da atanmış üye olsa da yazamaz; okur',
      () {
        for (final p in [
          _p(_access(admin: true)),
          _p(_access(admin: true, role: SeatRole.coordinator)),
          _p(_access(admin: true, role: SeatRole.member), assigned: true),
        ]) {
          expect(p.canAddNote, isFalse);
          expect(p.canReadNotes, isTrue);
        }
      },
    );

    test('düzenle/sil yalnız yazar ve kapsamda ekip satırı varken', () {
      final member = _p(_access(role: SeatRole.member), assigned: true);
      expect(member.canEditNote(_note('me')), isTrue);
      expect(member.canEditNote(_note('u2')), isFalse);
      expect(member.canEditNote(_note('me', id: null)), isFalse);
      final coord = _p(_access(role: SeatRole.coordinator));
      expect(
        coord.canEditNote(_note('u2')),
        isFalse,
        reason: 'koordinatör başkasının notunu düzenlemez',
      );
      expect(
        _p(_access(admin: true)).canEditNote(_note('me')),
        isFalse,
        reason: 'ekip satırı yok',
      );
    });
  });

  group('alt görevler', () {
    const free = Subtask(id: 's1', title: 'A');
    const mine = Subtask(id: 's2', title: 'B', assignee: 'me');
    const other = Subtask(id: 's3', title: 'C', assignee: 'u2');

    test('yönet (aç/sil/başlık/kişi/tarih): yönetici ya da koordinatör', () {
      expect(_p(_access(admin: true)).canManageSubtasks, isTrue);
      expect(_p(_access(role: SeatRole.coordinator)).canManageSubtasks, isTrue);
      expect(
        _p(_access(role: SeatRole.member), assigned: true).canManageSubtasks,
        isFalse,
      );
    });

    test(
      'işaretle: koordinatör her alt görev; atanmış üye atamasız/kendisine',
      () {
        final coord = _p(_access(role: SeatRole.coordinator));
        expect([free, mine, other].every(coord.canToggleSubtask), isTrue);
        final member = _p(_access(role: SeatRole.member), assigned: true);
        expect(member.canToggleSubtask(free), isTrue);
        expect(member.canToggleSubtask(mine), isTrue);
        expect(member.canToggleSubtask(other), isFalse);
        expect(
          _p(_access(role: SeatRole.member)).canToggleSubtask(free),
          isFalse,
          reason: 'ana göreve atanmamış',
        );
      },
    );

    test('yönetici tek başına işaretleyemez', () {
      expect(
        _p(_access(admin: true), assigned: true).canToggleSubtask(free),
        isFalse,
      );
    });

    test('atanabilecekler ana görevin atananları', () {
      final t = _task(assignees: ['me', 'u2']);
      expect(
        TaskPermissions.of(
          _access(role: SeatRole.coordinator),
          t,
        ).subtaskAssignees(t),
        ['me', 'u2'],
      );
    });
  });

  test('örnek katalog (erişim yok): yerel, her eylem açık', () {
    final p = TaskPermissions.of(null, _task());
    expect(p.local, isTrue);
    expect(p.statusTargets(TaskStatus.inProgress), hasLength(4));
    expect(p.canAddNote && p.canManageSubtasks, isTrue);
  });
}
