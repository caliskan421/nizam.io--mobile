import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/administration/domain/admin_user_tasks.dart';
import 'package:nizamio/features/tasks/tasks.dart';

TaskItem _task(
  String id, {
  TaskStatus status = TaskStatus.todo,
  TaskPriority priority = TaskPriority.medium,
  int overdueDays = 0,
  int dueDay = 10,
}) => TaskItem(
  code: id,
  title: id,
  coordinatorship: 'department',
  status: status,
  priority: priority,
  start: DateTime(2026, 11, 1),
  due: DateTime(2026, 11, dueDay),
  assignees: const ['person'],
  overdueDays: overdueDays,
);

void main() {
  test('varsayılan tüm durumlar; seçimler birleşir ve öncelikle kesişir', () {
    final tasks = [
      _task('late', overdueDays: 2, priority: TaskPriority.high),
      _task('review', status: TaskStatus.review),
      _task('done', status: TaskStatus.done),
    ];
    expect(const UserTaskPanelState().select(tasks).map((t) => t.code), [
      'late',
      'review',
      'done',
    ]);
    const status = UserTaskPanelState(
      statuses: {UserTaskStatus.late, UserTaskStatus.review},
    );
    expect(status.select(tasks).map((t) => t.code), ['late', 'review']);
    expect(
      status
          .copyWith(priorities: {TaskPriority.high})
          .select(tasks)
          .single
          .code,
      'late',
    );
    expect(const UserTaskPanelState(statuses: {}).select(tasks), hasLength(3));
  });

  test('tarih grupları sunucu gecikmesini ve tamamlanmayı korur; 7 gün sınırı dahildir', () {
    final today = DateTime(2026, 11, 10);
    expect(
      userTaskGroup(_task('late', overdueDays: 1), today),
      UserTaskGroup.late,
    );
    expect(userTaskGroup(_task('week', dueDay: 17), today), UserTaskGroup.week);
    expect(
      userTaskGroup(_task('later', dueDay: 18), today),
      UserTaskGroup.later,
    );
    expect(
      userTaskGroup(
        _task('done', status: TaskStatus.done, overdueDays: 9),
        today,
      ),
      UserTaskGroup.done,
    );
    expect(
      userTaskGroup(_task('server-not-late', dueDay: 1), today),
      UserTaskGroup.week,
      reason: 'Tarih geçmiş olsa da sunucuda gecikmeyen görevi gecikme grubuna taşımayız',
    );
  });

  test('gün farkı saatlerden ve takvim günü sınırından etkilenmez', () {
    final task = _task('date').copyWith(due: DateTime(2026, 3, 30, 1));
    expect(userTaskDueDays(task, DateTime(2026, 3, 28, 23, 59)), 2);
  });
}
