import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../application/coordinatorship_query_controller.dart';
import '../../domain/home_dashboard.dart';

/// Ana sayfanın sayılı cümleleri. UI metin kaynağı yer tutucu kabul etmediği için (i18n/ui
/// README) parçalar ARB'den gelir, Türkçe söz dizimiyle burada birleşir; sayı/tarih biçimi
/// `tr` yerel ayarıyla.
extension HomeTexts on AppLocalizations {
  static final _percent = NumberFormat.decimalPercentPattern(
    locale: 'tr',
    decimalDigits: 0,
  );

  /// 0–1 oran → "%49".
  String percent(double ratio) => _percent.format(ratio);

  /// "21 ekim 2026, çarşamba".
  String dateKicker(DateTime day) =>
      DateFormat('d MMMM y, EEEE', 'tr').format(day).toLowerCase();

  /// "79 görevin 39'u bitti".
  String kpiDoneCaption(TaskTotals t) =>
      '${t.total} $uiHomeKpiDoneOf ${t.done}${possessive(t.done)} '
      '$uiHomeKpiDoneTail';

  String kpiDoingCaption(TaskTotals t) =>
      '${t.inProgressOnTime} $uiHomeKpiDoingTail';

  /// "Açık görevlerin %38'i".
  String kpiLateCaption(TaskTotals t) {
    final ratio = t.open == 0 ? 0.0 : t.late / t.open;
    return '$uiHomeKpiLateLead ${percent(ratio)}'
        '${possessive((ratio * 100).round())}';
  }

  /// Sayıdan sonra üçüncü tekil iyelik eki, okunuşa göre ("39'u", "%38'i", "2'si").
  static String possessive(int n) {
    const units = ['', "'i", "'si", "'ü", "'ü", "'i", "'sı", "'si", "'i", "'u"];
    const tens = ['', "'u", "'si", "'u", "'ı", "'si", "'ı", "'i", "'i", "'ı"];
    if (n == 0) return "'ı";
    if (n % 10 != 0) return units[n % 10];
    if (n % 100 != 0) return tens[(n ~/ 10) % 10];
    if (n % 1000 != 0) return "'ü";
    return "'i";
  }

  /// "18 kullanıcı · 11 koordinatörlük".
  String teamSummary(HomeDashboard d) =>
      '${d.team.users} $uiHomeUsers · ${d.coordinatorships.length} $uiHomeCoordinatorshipsLc';

  /// "11 koordinatörlük · 18 kullanıcı (2 admin, 15 koordinatör, 3 üye)".
  String footerSummary(HomeDashboard d) =>
      '${d.coordinatorships.length} $uiHomeCoordinatorshipsLc · '
      '${d.team.users} $uiHomeUsers (${d.team.admins} $uiHomeRoleAdminLc, '
      '${d.team.coordinators} $uiHomeRoleCoordinatorLc, '
      '${d.team.members} $uiHomeRoleMemberLc)';

  /// "Son işlem bugün 14:27 · Abdullah Ateş" (bugün değilse tarih).
  String lastActivity(LastActivity a, DateTime now) {
    final sameDay =
        a.at.year == now.year && a.at.month == now.month && a.at.day == now.day;
    final when = sameDay
        ? '$uiHomeHistoryToday ${DateFormat.Hm('tr').format(a.at)}'
        : DateFormat('d MMM HH:mm', 'tr').format(a.at);
    return '$uiHomeHistoryLast $when · ${a.actorName}';
  }

  /// "%9 · 11 görev".
  String coordProgress(CoordinatorshipSummary c) =>
      '${percent(c.donePercent / 100)} · ${c.total} $uiHomeTasksLc';

  /// "4 geciken" / "gecikme yok".
  String coordLate(CoordinatorshipSummary c) =>
      c.late > 0 ? '${c.late} $uiHomeLateLc' : uiHomeNoLate;

  String sortLabel(CoordinatorshipSort s) => switch (s) {
    CoordinatorshipSort.late => uiHomeSortLate,
    CoordinatorshipSort.progress => uiHomeSortProgress,
    CoordinatorshipSort.name => uiHomeSortName,
  };

  String filterLabel(CoordinatorshipFilter f) => switch (f) {
    CoordinatorshipFilter.all => uiHomeFilterAll,
    CoordinatorshipFilter.late => uiHomeFilterLate,
    CoordinatorshipFilter.onTrack => uiHomeFilterOnTrack,
    CoordinatorshipFilter.unassigned => uiHomeFilterUnassigned,
  };

  /// "ALT-7 · Tarih talebi · +51 gün" / "ULA-1 · Tarih talebi · 15 Kas" / "İDA-2 · Onay
  /// bekliyor".
  String pendingCaption(PendingItem p) {
    final date = p.requestedDate;
    final shift = p.requestedShiftDays;
    final when = shift != null
        ? ' · +$shift $uiHomeShiftDaysTail'
        : date == null
        ? ''
        : ' · ${DateFormat('d MMM', 'tr').format(date)}';
    return switch (p.kind) {
      PendingKind.dateChange => '${p.taskCode} · $uiHomeDateRequest$when',
      PendingKind.approval => '${p.taskCode} · $uiHomeAwaitingApproval',
    };
  }

  /// Zil etiketi: "Bildirimler · 3 tarih talebi ve 3 onay seni bekliyor" (yalnız biri varsa o
  /// parça); bekleyen yoksa "Bildirimler".
  String notificationsLabel(List<PendingItem> pending) {
    int n(PendingKind k) => pending.where((p) => p.kind == k).length;
    final parts = [
      if (n(PendingKind.dateChange) case final d when d > 0)
        '$d $uiHomeNotifyDateRequests',
      if (n(PendingKind.approval) case final a when a > 0)
        '$a $uiHomeNotifyApprovals',
    ];
    return parts.isEmpty
        ? uiHomeNotifications
        : '$uiHomeNotifications · ${parts.join(' $uiHomeNotifyAnd ')} '
              '$uiHomeNotifyTail';
  }

  /// Çekmecedeki sezon kartının alt satırı: "2026 sezonu" (yıl yoksa kapsam değiştirme).
  String seasonCaption(int? year, String fallback) =>
      year == null ? fallback : '$year $uiHomeSeasonTail';

  /// "Takvim mobilde sonraki adımda eklenecek".
  String soon(String what) => '$what $uiHomeSoonTail';
}
