import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../domain/calendar.dart';

/// Takvim ekranının sayılı/biçimli metinleri (parçalar ARB'den; tarih/sayı biçimi `tr`).
extension CalendarTexts on AppLocalizations {
  /// "Ekim 2026".
  String monthTitle(DateTime m) => '${monthName(m)} ${m.year}';

  /// "Ekim".
  String monthName(DateTime d) => DateFormat('MMMM', 'tr').format(d);

  /// "Çarşamba".
  String weekdayName(DateTime d) => DateFormat('EEEE', 'tr').format(d);

  /// Gün başlığı: "21 Ekim, Çarşamba".
  String dayTitle(DateTime d) => '${d.day} ${monthName(d)}, ${weekdayName(d)}';

  /// Pazartesiden başlayan kısa gün adları.
  List<String> get weekdaysShort => uiCalendarWeekdaysShort.split(' ');

  /// Hafta kipi başlığı: "Ekim 2026 · 4. hafta".
  String weekTitle(DateTime selected, int weekIndex) =>
      '${monthTitle(selected)} · ${weekIndex + 1}. $uiCalendarWeekLc';

  /// Ay/hafta düğmesinin okuyucu etiketi: "Haftaya daralt · Ekim 2026".
  String modeLabel(CalendarMode mode, DateTime month) =>
      '${mode == CalendarMode.month ? uiCalendarCollapse : uiCalendarExpand} · '
      '${monthTitle(month)}';

  /// Hücre etiketi: "21 Ekim, Çarşamba, bugün, 4 kayıt".
  String cellLabel(DateTime d, {required bool today, required int count}) =>
      '${dayTitle(d)}${today ? ', $uiCalendarRelToday' : ''}'
      '${count > 0 ? ', $count $uiCalendarRecordsLc' : ''}';

  /// Bugüne göre: bugün / yarın / dün / "3 gün sonra" / "2 gün önce".
  String relative(int days) => switch (days) {
    0 => uiCalendarRelToday,
    1 => uiCalendarRelTomorrow,
    -1 => uiCalendarRelYesterday,
    > 0 => '$days $uiCalendarRelAfter',
    _ => '${-days} $uiCalendarRelBefore',
  };

  String groupLabel(CalendarKind k) => switch (k) {
    CalendarKind.meeting => uiCalendarGroupMeetings,
    CalendarKind.task => uiCalendarGroupTasks,
    CalendarKind.request => uiCalendarGroupRequests,
  };

  /// Görev süzgeci düğmesi: "Bitecek" / "Başlayacak" (süren görev yalnız "bu hafta"da).
  String edgeFilter(TaskEdge e) => switch (e) {
    TaskEdge.end => uiCalendarFilterEnds,
    TaskEdge.start => uiCalendarFilterStarts,
    TaskEdge.ongoing => uiCalendarSecOngoing,
  };

  /// Görev alt bölümü başlığı: "bu gün bitecek" / "bu gün başlayacak".
  String edgeSection(TaskEdge e) => switch (e) {
    TaskEdge.end => uiCalendarSubEnds,
    TaskEdge.start => uiCalendarSubStarts,
    TaskEdge.ongoing => uiCalendarSecOngoing,
  };

  /// Gün listesi satırının mono öncüsü (görev kimliği yerine): "biter" / "başlar" / "sürer".
  String edgeLead(TaskEntry e) => switch (e.edge) {
    TaskEdge.end => uiCalendarLeadEnd,
    TaskEdge.start => uiCalendarLeadStart,
    TaskEdge.ongoing => uiCalendarLeadOngoing,
  };

  /// Kısa gün: "Sa 20".
  String shortDay(DateTime d) => '${weekdaysShort[d.weekday - 1]} ${d.day}';

  /// Hafta aralığı: "19–25 Eki" (ay geçişinde "28 Eyl – 4 Eki").
  String weekRange(DateTime first, DateTime last) => first.month == last.month
      ? '${first.day}–${last.day} ${DateFormat('MMM', 'tr').format(last)}'
      : dayRange(first, last);

  /// Tarih aralığı: "21 Eki – 4 Kas".
  String dayRange(DateTime a, DateTime b) {
    final f = DateFormat('d MMM', 'tr');
    return '${f.format(a)} – ${f.format(b)}';
  }

  /// "14:00".
  String clock(MeetingEntry m) =>
      '${m.hour.toString().padLeft(2, '0')}:${m.minute.toString().padLeft(2, '0')}';

  /// Toplantı satırı alt yazısı: bağlı departmanlar ("Altyapı, Mekanik").
  String meetingSub(MeetingEntry m) => m.departments.join(', ');

  /// Tarih talebi satırı alt yazısı: "İstenen aralık · 5 Kas – 14 Kas".
  String requestSub(RequestEntry r) {
    final f = DateFormat('d MMM', 'tr');
    return '$uiCalendarRequestedRange · ${f.format(r.start)} – '
        '${f.format(r.date)}';
  }
}
