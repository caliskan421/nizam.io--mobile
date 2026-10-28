import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/quick_forms_controller.dart';
import '../domain/task_catalog.dart';
import '../domain/task_query.dart';

/// Görev ekranlarının etiketleri ve sayılı cümleleri. UI metin kaynağı yer tutucu kabul
/// etmediği için parçalar ARB'den gelir, burada birleşir; tarih biçimi `tr`.
extension TaskTexts on AppLocalizations {
  String statusLabel(TaskStatus s) => switch (s) {
    TaskStatus.todo => uiTasksStatusTodo,
    TaskStatus.inProgress => uiTasksStatusDoing,
    TaskStatus.review => uiTasksStatusReview,
    TaskStatus.returned => uiTasksStatusReturned,
    TaskStatus.done => uiTasksStatusDone,
  };

  String priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.high => uiTasksPrioHigh,
    TaskPriority.medium => uiTasksPrioMedium,
    TaskPriority.low => uiTasksPrioLow,
  };

  String viewLabel(TaskView v) => switch (v) {
    TaskView.all => uiTasksViewAll,
    TaskView.late => uiTasksViewLate,
    TaskView.inProgress => uiTasksViewDoing,
    TaskView.review => uiTasksViewReview,
    TaskView.dateRequest => uiTasksViewRequest,
    TaskView.notStarted => uiTasksViewTodo,
    TaskView.done => uiTasksViewDone,
  };

  String viewListTitle(TaskView v) => switch (v) {
    TaskView.all => uiTasksListAll,
    TaskView.late => uiTasksListLate,
    TaskView.inProgress => uiTasksListDoing,
    TaskView.review => uiTasksListReview,
    TaskView.dateRequest => uiTasksListRequest,
    TaskView.notStarted => uiTasksListTodo,
    TaskView.done => uiTasksListDone,
  };

  String sortLabel(TaskSort s) => switch (s) {
    TaskSort.created => uiTasksSortCreated,
    TaskSort.due => uiTasksSortDue,
    TaskSort.start => uiTasksSortStart,
    TaskSort.coordinatorship => uiTasksSortCoord,
  };

  String sortShort(TaskSort s) => switch (s) {
    TaskSort.created => uiTasksSortCreatedShort,
    TaskSort.due => uiTasksSortDueShort,
    TaskSort.start => uiTasksSortStartShort,
    TaskSort.coordinatorship => uiTasksSortCoordShort,
  };

  String sortDirection(TaskSort s, {required bool descending}) =>
      switch ((s, descending)) {
        (TaskSort.created, false) => uiTasksDirCreatedAsc,
        (TaskSort.created, true) => uiTasksDirCreatedDesc,
        (TaskSort.due, false) => uiTasksDirDueAsc,
        (TaskSort.due, true) => uiTasksDirDueDesc,
        (TaskSort.start, false) => uiTasksDirStartAsc,
        (TaskSort.start, true) => uiTasksDirStartDesc,
        (TaskSort.coordinatorship, _) => '',
      };

  String tagLabel(EvidenceTag t) => switch (t) {
    EvidenceTag.site => uiTasksTagSite,
    EvidenceTag.result => uiTasksTagResult,
    EvidenceTag.status => uiTasksTagStatus,
  };

  String roleLabel(InviteRole r) => switch (r) {
    InviteRole.member => uiTasksRoleMember,
    InviteRole.coordinator => uiTasksRoleCoordinator,
    InviteRole.admin => uiTasksRoleAdmin,
  };

  String roleDescription(InviteRole r) => switch (r) {
    InviteRole.member => uiTasksRdMember,
    InviteRole.coordinator => uiTasksRdCoordinator,
    InviteRole.admin => uiTasksRdAdmin,
  };

  String newTaskError(NewTaskError e) => switch (e) {
    NewTaskError.title => uiTasksErrTitle,
    NewTaskError.coordinatorship => uiTasksErrCoord,
    NewTaskError.assignees => uiTasksErrAssignee,
    NewTaskError.dates => uiTasksErrDatesFull,
  };

  String meetingError(MeetingError e) => switch (e) {
    MeetingError.title => uiTasksErrTitle,
    MeetingError.past => uiTasksErrPast,
    MeetingError.coordinatorships => uiTasksErrMtCoords,
    MeetingError.people => uiTasksErrMtPeople,
  };

  String inviteError(InviteError e) => switch (e) {
    InviteError.name => uiTasksErrName,
    InviteError.email => uiTasksErrEmail,
    InviteError.coordinatorships => uiTasksErrIvCoord,
  };

  /// "76 görev" ya da "8 / 76 görev".
  String countLine(int shown, int total) => shown == total
      ? '$total $uiTasksTasksLc'
      : '$shown / $total $uiTasksTasksLc';

  String groupedCountLine(int tasks, int groups) =>
      '$tasks $uiTasksTasksLc · $groups $uiTasksCoordsLc';

  String lateBadge(int days) => '$days $uiTasksLateTail';

  String subtaskLine(int done, int total) =>
      '$done/$total $uiTasksSubtasksTail';

  /// "+51 gün" / "-3 gün".
  String plusDays(int d) => '${d >= 0 ? '+' : ''}$d $uiTasksDaysLc';

  String peopleCount(int n) => '$n $uiTasksPeopleLc';

  /// "2 hafta" / "1 ay" / "10 gün" (prototip süre gösterimi).
  String duration(int days) {
    if (days >= 28 && days <= 35 && days % 7 == 0) return uiTasksOneMonth;
    if (days % 7 == 0 && days > 0) return '${days ~/ 7} $uiTasksWeeksLc';
    return '$days $uiTasksDaysLc';
  }
}

/// Tarih biçimleri (prototip): "15.07.2026", "22.06", "21 Eki", "Çar".
abstract final class TaskDates {
  static String full(DateTime d) => DateFormat('dd.MM.yyyy', 'tr').format(d);
  static String dayMonth(DateTime d) => DateFormat('dd.MM', 'tr').format(d);
  static String short(DateTime d) => DateFormat('d MMM', 'tr').format(d);
  static String weekday(DateTime d) => DateFormat('EEE', 'tr').format(d);
  static String time(DateTime d) => DateFormat.Hm('tr').format(d);

  /// Aynı yıl: "22.06 → 10.09.2026"; farklı yıl iki tam tarih.
  static String range(DateTime s, DateTime e) =>
      '${s.year == e.year ? dayMonth(s) : full(s)} → ${full(e)}';
}

/// Durum → ton (README durum renkleri; prototip `rp-dot--*`).
NzTone statusTone(TaskStatus s) => switch (s) {
  TaskStatus.todo => NzTone.neutral,
  TaskStatus.inProgress => NzTone.progress,
  TaskStatus.review => NzTone.waiting,
  TaskStatus.returned => NzTone.danger,
  TaskStatus.done => NzTone.done,
};

int priorityLevel(TaskPriority p) => switch (p) {
  TaskPriority.low => 1,
  TaskPriority.medium => 2,
  TaskPriority.high => 3,
};

/// Ad soyaddan iki harf ("Kerem Özdal" → "KÖ").
String initialsOf(String name) => name
    .split(' ')
    .where((x) => x.isNotEmpty)
    .take(2)
    .map((x) => x.characters.first)
    .join();

/// Kanıt türü çip metni.
String fileKindLabel(TaskFileKind k) => switch (k) {
  TaskFileKind.image => 'IMG',
  TaskFileKind.pdf => 'PDF',
  TaskFileKind.doc => 'DOC',
};
