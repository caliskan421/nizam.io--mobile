import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../domain/horizontal_timeline.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';

/// Yatay çizelgenin birleşik cümleleri (parçalar ARB'den; tarih biçimi `tr`).
extension GanttTexts on AppLocalizations {
  String ganttZoomLabel(GanttZoom z) => switch (z) {
    GanttZoom.week => uiTimelineScaleWeek,
    GanttZoom.month => uiTimelineScaleMonth,
    GanttZoom.season => uiTimelineGanttScaleSeason,
  };

  /// "Tümü" / "Açık" / "Geciken · 15".
  String ganttFilterLabel(GanttFilter f, int lateAll) => switch (f) {
    GanttFilter.all => uiTimelineStatusAll,
    GanttFilter.open => uiTimelineStatusOpen,
    GanttFilter.late => '$uiTimelineStatusLate · $lateAll',
  };

  /// "6 Haz" (prototip `fd`).
  String ganttDay(int day, int year) =>
      DateFormat('d MMM', 'tr').format(seasonDate(day, year));

  /// "16 Haz – 15 Tem" (planlanan başlangıç – bitiş).
  String ganttRange(GanttTask t, int year) =>
      '${ganttDay(t.start, year)} – ${ganttDay(t.end - 1, year)}';

  /// Ay başlığı: "Ocak" (sezon ölçeğinde "Oca").
  String ganttMonth(int month, int year, {required bool short}) =>
      DateFormat(short ? 'MMM' : 'MMMM', 'tr').format(DateTime(year, month));

  /// "76 görev · tüm koordinatörlükler" / "13 görev · ALT, MEK".
  String ganttCountLine(GanttView v) =>
      '${v.visible} $uiTimelineTasksLc · '
      '${v.state.coords.isEmpty ? uiTimelineGanttAllCoordsLc : v.state.coords.join(', ')}';

  /// Grup başlığı: "3 gecikme".
  String ganttGroupLate(int n) => '$n $uiTimelineGanttLateTail';

  /// Okuyucu etiketi (prototip `aria`): "ALT-5 · Su deposu… · 16 Haz – 15 Tem · Devam ediyor ·
  /// gecikmede".
  String ganttBarLabel(GanttTask t, int year) =>
      '${t.code} · ${t.item.title} · ${ganttRange(t, year)} · '
      '${statusLabel(t.status)}${t.late ? ' · $uiTimelineLateLc' : ''}';

  /// Görev satırı etiketi: "ALT-5 Su deposu…".
  String ganttRowLabel(GanttTask t) => '${t.code} ${t.item.title}';

  /// Kart: "98 gün gecikti".
  String ganttLateDays(GanttTask t) => '${t.lateDays} $uiTimelineGanttDaysLate';

  /// Kart: atananlar ya da "Atanmamış".
  String ganttAssignees(GanttSelection s) =>
      s.assignees.isEmpty ? uiTimelineGanttUnassigned : s.assignees.join(', ');
}
