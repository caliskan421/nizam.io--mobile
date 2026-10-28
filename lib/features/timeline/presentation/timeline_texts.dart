import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../tasks/tasks.dart';
import '../domain/timeline.dart';

/// Zaman çizelgesinin sayılı cümleleri. UI metin kaynağı yer tutucu kabul etmediği için parçalar
/// ARB'den gelir, burada birleşir; tarih biçimi `tr`.
extension TimelineTexts on AppLocalizations {
  String statusLabel(TaskStatus s) => switch (s) {
    TaskStatus.todo => uiTimelineStTodo,
    TaskStatus.inProgress => uiTimelineStDoing,
    TaskStatus.review => uiTimelineStReview,
    TaskStatus.returned => uiTimelineStBack,
    TaskStatus.done => uiTimelineStDone,
  };

  String statusFilterLabel(TimelineStatusFilter f) => switch (f) {
    TimelineStatusFilter.all => uiTimelineStatusAll,
    TimelineStatusFilter.open => uiTimelineStatusOpen,
    TimelineStatusFilter.late => uiTimelineStatusLate,
    TimelineStatusFilter.done => uiTimelineStatusDone,
  };

  String scaleLabel(TimelineScale s) => switch (s) {
    TimelineScale.day => uiTimelineScaleDay,
    TimelineScale.week => uiTimelineScaleWeek,
    TimelineScale.month => uiTimelineScaleMonth,
  };

  String priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.high => uiTimelinePrioHigh,
    TaskPriority.medium => uiTimelinePrioMid,
    TaskPriority.low => uiTimelinePrioLow,
  };

  /// Seçici özeti: "tümü" / tek ad / "3 seçili" / "seçilmedi".
  String coordSummary(TimelineView v) {
    final sel = v.selectedCoordinatorships;
    if (v.allSelected) return uiTimelineCoordAll;
    if (sel.length == 1) return v.nameOf(sel.single);
    if (sel.isEmpty) return uiTimelineCoordNone;
    return '${sel.length} $uiTimelineCoordSelected';
  }

  /// "3 / 11 açık".
  String coordFoot(TimelineView v) =>
      '${v.selectedCoordinatorships.length} / ${v.coordinatorships.length} '
      '$uiTimelineCoordOpenTail';

  /// "98 gün gecikmede" / "5 gün geç bitti" / boş.
  String lateText(TimelineTask t) => t.late
      ? '${t.lateDays} $uiTimelineDaysLate'
      : t.doneLate
      ? '${t.doneLateDays} $uiTimelineDaysLateDone'
      : '';

  /// "06 Haz".
  String shortDay(int day, int year) =>
      DateFormat('dd MMM', 'tr').format(seasonDate(day, year));

  /// "21.10.2026".
  String fullDay(int day, int year) =>
      DateFormat('dd.MM.y', 'tr').format(seasonDate(day, year));

  /// "+3 gün" / "−3 gün".
  String signedDays(int n) => '${n > 0 ? '+' : '−'}${n.abs()} $uiTimelineDay';

  /// Çubuk alt satırı: "06 Haz → 15 Tem · 98 gün gecikmede".
  String barSubtitle(TimelineTask t, int year) {
    final late = lateText(t);
    return '${shortDay(t.range.start, year)} → ${shortDay(t.range.end, year)}'
        '${late.isEmpty ? '' : ' · $late'}';
  }

  /// Okuyucu etiketi: "ALT-5 Su deposu…, Devam ediyor, 16.06.2026 – 15.07.2026, 98 gün gecikmede".
  String barLabel(TimelineTask t, int year) {
    final late = lateText(t);
    return '${t.code} ${t.item.title}, ${statusLabel(t.status)}, '
        '${fullDay(t.range.start, year)} – ${fullDay(t.range.end, year)}'
        '${late.isEmpty ? '' : ', $late'}';
  }

  /// Genel bakış sütunu: "Altyapı ve tesisat: 13 görev, 8 bitti, 3 gecikmede · aç".
  String overviewLabel(TimelineGroup g) =>
      '${g.name}: ${g.total} $uiTimelineTasksLc, ${g.done} $uiTimelineDoneLc, '
      '${g.late} $uiTimelineLateLc · $uiTimelineOpen';

  /// "başlangıç +3 gün · bitiş −1 gün · süre 12 hf → 13 hf" (değişiklik yoksa boş).
  String deltaText(TimelineSelection s) {
    final parts = [
      if (s.startDelta != 0) '$uiTimelineStart ${signedDays(s.startDelta)}',
      if (s.endDelta != 0) '$uiTimelineEnd ${signedDays(s.endDelta)}',
    ];
    if (parts.isEmpty) return '';
    return '${parts.join(' · ')} · $uiTimelineDuration '
        '${TimelineSelection.weeks(s.current)} $uiTimelineWeekShort → '
        '${TimelineSelection.weeks(s.draft)} $uiTimelineWeekShort';
  }

  /// Kayıt bildirimi: "ALT-7 3 gün ileri kaydırıldı" / "ALT-7 süresi 2 gün uzatıldı".
  String undoTitle(TimelineUndo u) {
    if (u.isShift) {
      return '${u.code} ${u.startDelta.abs()} '
          '${u.startDelta > 0 ? uiTimelineShiftedForward : uiTimelineShiftedBack}';
    }
    final dl = u.to.length - u.from.length;
    return '${u.code} $uiTimelineDurationOf ${dl.abs()} '
        '${dl > 0 ? uiTimelineExtended : uiTimelineShortened}';
  }

  /// "başlangıç +3 gün · bitiş +3 gün".
  String undoDelta(TimelineUndo u) => [
    if (u.startDelta != 0) '$uiTimelineStart ${signedDays(u.startDelta)}',
    if (u.endDelta != 0) '$uiTimelineEnd ${signedDays(u.endDelta)}',
  ].join(' · ');

  /// "06 Haz – 15 Tem".
  String rangeText(DayRange r, int year) =>
      '${shortDay(r.start, year)} – ${shortDay(r.end, year)}';

  /// "Tarih talebi gönderildi · yeni bitiş 31.10.2026 onay bekliyor".
  String requestSentText(DateTime end) =>
      '$uiTimelineRequestSent ${DateFormat('dd.MM.y', 'tr').format(end)} '
      '$uiTimelineRequestSentTail';

  /// "2 kanıt dosyası" / "kanıt yok".
  String evidenceText(int files) =>
      files > 0 ? '$files $uiTimelineEvidenceTail' : uiTimelineNoEvidence;

  /// "Bugün 21 Ekim".
  String todayLabel(DateTime today) =>
      '$uiTimelineToday ${DateFormat('d MMMM', 'tr').format(today)}';

  /// "15 görevi göster".
  String showTasks(int n) => '$n $uiTimelineShowTasksTail';
}
