import '../../tasks/tasks.dart';

enum UserTaskStatus { open, late, review, done }

enum UserTaskGroup { late, week, later, done }

enum UserTaskView { list, calendar }

class UserTaskPanelState {
  const UserTaskPanelState({
    this.statuses = const {UserTaskStatus.open},
    this.priorities = const {},
    this.view = UserTaskView.list,
  });
  final Set<UserTaskStatus> statuses;
  final Set<TaskPriority> priorities;
  final UserTaskView view;
  bool get defaultStatuses =>
      statuses.length == 1 && statuses.contains(UserTaskStatus.open);
  bool get filtered => !defaultStatuses || priorities.isNotEmpty;
  bool matchesStatus(TaskItem task) =>
      statuses.isEmpty || statuses.any((s) => userTaskHasStatus(task, s));
  bool matchesPriority(TaskItem task) =>
      priorities.isEmpty || priorities.contains(task.priority);
  List<TaskItem> select(Iterable<TaskItem> tasks) =>
      tasks.where((t) => matchesStatus(t) && matchesPriority(t)).toList()
        ..sort((a, b) => a.due.compareTo(b.due));
  UserTaskPanelState copyWith({
    Set<UserTaskStatus>? statuses,
    Set<TaskPriority>? priorities,
    UserTaskView? view,
  }) => UserTaskPanelState(
    statuses: statuses ?? this.statuses,
    priorities: priorities ?? this.priorities,
    view: view ?? this.view,
  );
}

bool userTaskHasStatus(TaskItem task, UserTaskStatus status) =>
    switch (status) {
      UserTaskStatus.open => !task.isDone,
      UserTaskStatus.late => !task.isDone && task.isOverdue,
      UserTaskStatus.review => task.status == TaskStatus.review,
      UserTaskStatus.done => task.isDone,
    };

int userTaskDueDays(TaskItem task, DateTime today) => DateTime.utc(
  task.due.year,
  task.due.month,
  task.due.day,
).difference(DateTime.utc(today.year, today.month, today.day)).inDays;

UserTaskGroup userTaskGroup(TaskItem task, DateTime today) => task.isDone
    ? UserTaskGroup.done
    : task.isOverdue
    ? UserTaskGroup.late
    : userTaskDueDays(task, today) <= 7
    ? UserTaskGroup.week
    : UserTaskGroup.later;
