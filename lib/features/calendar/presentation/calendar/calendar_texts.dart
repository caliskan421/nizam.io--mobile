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

  /// Önizleme tarihi (prototip virgülsüz): "21 Ekim Çarşamba".
  String dayText(DateTime d) => '${d.day} ${monthName(d)} ${weekdayName(d)}';

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
    CalendarKind.sheet => uiCalendarGroupSheets,
    CalendarKind.season => uiCalendarSeasonLc,
  };

  String requestType(RequestType t) => switch (t) {
    RequestType.purchase => uiCalendarReqPurchase,
    RequestType.quote => uiCalendarReqQuote,
    RequestType.expense => uiCalendarReqExpense,
    RequestType.budget => uiCalendarReqBudget,
  };

  String requestState(RequestState s) => switch (s) {
    RequestState.pending => uiCalendarStatePending,
    RequestState.approved => uiCalendarStateApproved,
    RequestState.ordered => uiCalendarStateOrdered,
    RequestState.delivered => uiCalendarStateDelivered,
  };

  /// "₺14.600".
  String money(int amount) =>
      '₺${NumberFormat.decimalPattern('tr').format(amount)}';

  /// "14:00".
  String clock(MeetingEntry m) =>
      '${m.hour.toString().padLeft(2, '0')}:${m.minute.toString().padLeft(2, '0')}';

  /// Davetli koordinatörlükler: "İDA, OPE" ya da "Tüm koordinatörlükler".
  String invited(MeetingEntry m) => m.allCoordinatorships
      ? uiCalendarAllCoordinatorships
      : m.coordinatorships.join(', ');

  /// Toplantı satırı alt yazısı: "ALT · 6 katılımcı · 3 gündem".
  String meetingSub(MeetingEntry m) =>
      '${invited(m)} · ${m.participants} $uiCalendarParticipantsLc · '
      '${m.agenda.length} $uiCalendarAgendaLc';
}
