import '../../../../core/i18n/generated/app_localizations.dart';
import '../../domain/coordinator_board.dart';
import '../../domain/task_catalog.dart';

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

  String requestStateLabel(DateRequestState s) => switch (s) {
    DateRequestState.pending => uiTasksRequestStatePending,
    DateRequestState.approved => uiTasksRequestsTabApproved,
    DateRequestState.rejected => uiTasksRequestsTabRejected,
    DateRequestState.unknown => uiTasksGroupOther,
  };

  /// "1 aktif · 3 talep".
  String requestsLine(int active, int total) =>
      '$active $uiTasksRequestsActiveLc · $total $uiTasksRequestsTotalLc';
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
