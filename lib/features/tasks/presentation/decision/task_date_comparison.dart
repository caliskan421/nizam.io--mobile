import 'package:flutter/material.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/overlays/nz_decision_sheet.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import 'coordinator_texts.dart';

/// Talep anındaki tarihler ile önerilen tarihler birlikte gösterilir. Başlangıç bilgisi
/// yoksa bugünkü görevden tahmin edilmez; eksik bilgi açıkça belirtilir.
class TaskDateComparison extends StatelessWidget {
  const TaskDateComparison({
    super.key,
    required this.previousStart,
    required this.previousDue,
    required this.start,
    required this.due,
  });

  TaskDateComparison.request({super.key, required DateChangeRequest request})
    : previousStart = request.oldStart,
      previousDue = request.oldDue,
      start = request.start,
      due = request.due;

  final DateTime? previousStart;
  final DateTime previousDue;
  final DateTime start;
  final DateTime due;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return NzDecisionFacts(
      facts: [
        NzDecisionFact(
          l.uiTasksPreviousStart,
          previousStart == null
              ? l.uiTasksDateUnavailable
              : TaskDates.full(previousStart!),
        ),
        NzDecisionFact(l.uiTasksNewStart, TaskDates.full(start)),
        NzDecisionFact(l.uiTasksPreviousDue, TaskDates.full(previousDue)),
        NzDecisionFact(l.uiTasksNewDue, TaskDates.full(due)),
      ],
    );
  }
}

/// Onay tamamlanma tarihini belirler; plan bitişi yalnız erken bitişte açıkça istenirse
/// bugüne çekilir. Geç onayda tamamlanma tarihi yeni bitiş gibi gösterilmez.
List<NzDecisionFact> approvalDateFacts(
  AppLocalizations l, {
  required DateTime due,
  required DateTime today,
  required bool pull,
}) {
  DateTime day(DateTime d) => DateTime.utc(d.year, d.month, d.day);
  final early = day(today).isBefore(day(due));
  return [
    NzDecisionFact(l.uiTasksPreviousDue, TaskDates.full(due)),
    NzDecisionFact(
      l.uiTasksAfterDue,
      TaskDates.full(early && pull ? today : due),
    ),
    NzDecisionFact(l.uiTasksCompletionDate, TaskDates.full(today)),
    NzDecisionFact(
      l.uiTasksCmpResult,
      l.completionResult(due: due, done: today, pulled: early && pull),
      danger: day(today).isAfter(day(due)),
    ),
  ];
}
