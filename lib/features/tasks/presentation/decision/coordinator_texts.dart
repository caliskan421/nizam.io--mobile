import '../../../../core/i18n/generated/app_localizations.dart';
import '../../domain/coordinator_board.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';

/// Koordinatör görünümünün sayılı cümleleri (UI metin kaynağı yer tutucu kabul etmez; parçalar
/// burada birleşir).
extension CoordinatorTexts on AppLocalizations {
  /// Satırın bitiş metni: gecikmede "3 gün geç", bugün "bugün", ileride "5 gün kaldı".
  String dueLine(TaskItem t, DateTime today) {
    if (isTaskLate(t)) {
      final n = t.lateness?.daysOverdue ?? t.overdueDays;
      return '$n $uiTasksResultLateTail';
    }
    final left = _day(t.due).difference(_day(today)).inDays;
    return left <= 0 ? uiTasksEvToday : '$left $uiTasksDaysLeftTail';
  }

  /// Onay sonucunun özeti: planlanandan geç → "n gün geç"; erken ve bitiş çekilmediyse
  /// "n gün erken"; aksi "Zamanında".
  String completionResult({
    required DateTime due,
    required DateTime done,
    required bool pulled,
  }) {
    final diff = _day(done).difference(_day(due)).inDays;
    if (diff > 0) return '$diff $uiTasksResultLateTail';
    if (diff < 0 && !pulled) return '${-diff} $uiTasksResultEarlyTail';
    return uiTasksResultOnTime;
  }

  String statusGroupLabel(TaskStatusGroup g) => switch (g) {
    TaskStatusGroup.review => uiTasksGroupReview,
    TaskStatusGroup.unassigned => uiTasksGroupUnassigned,
    TaskStatusGroup.inProgress => uiTasksGroupDoing,
    TaskStatusGroup.returned => uiTasksGroupReturned,
    TaskStatusGroup.todo => uiTasksGroupTodo,
    TaskStatusGroup.done => uiTasksGroupDone,
    TaskStatusGroup.other => uiTasksGroupOther,
  };

  /// Grup başlığının alt yazısı (yoksa null).
  String? statusGroupHint(TaskStatusGroup g) => switch (g) {
    TaskStatusGroup.review => uiTasksGroupReviewSub,
    TaskStatusGroup.unassigned => uiTasksGroupUnassignedSub,
    TaskStatusGroup.returned => uiTasksGroupReturnedSub,
    _ => null,
  };

  String requestStateLabel(DateRequestState s) => switch (s) {
    DateRequestState.pending => uiTasksRequestStatePending,
    DateRequestState.approved => uiTasksRequestsTabApproved,
    DateRequestState.rejected => uiTasksRequestsTabRejected,
    DateRequestState.unknown => uiTasksGroupOther,
  };

  /// Kapsam satırı: "Altyapı ve tesisat · 17 görev · 8 açık · yalnız ALT görevlerini
  /// görüyorsun".
  String scopeLine({
    required String department,
    required String label,
    required int total,
    required int open,
  }) =>
      '$department · $total $uiTasksTasksLc · $open $uiTasksScopeOpenLc · '
      '$uiTasksScopeOnlyHead $label $uiTasksScopeOnlyTail';

  /// "1 aktif · 3 talep".
  String requestsLine(int active, int total) =>
      '$active $uiTasksRequestsActiveLc · $total $uiTasksRequestsTotalLc';
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
