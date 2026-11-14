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

  /// "18 kullanıcı · 11 koordinatörlük".
  String teamSummary(HomeDashboard d, TeamTotals team) =>
      '${team.users} $uiHomeUsers · ${d.coordinatorships.length} $uiHomeCoordinatorshipsLc';

  /// "11 koordinatörlük · 18 kullanıcı (2 admin, 15 koordinatör, 3 üye)".
  /// Ekip sayıları bilinmiyorsa (yönetici olmayan hesap) yalnız koordinatörlük sayısı.
  String footerSummary(HomeDashboard d) => switch (d.team) {
    null => '${d.coordinatorships.length} $uiHomeCoordinatorshipsLc',
    final t =>
      '${d.coordinatorships.length} $uiHomeCoordinatorshipsLc · '
          '${t.users} $uiHomeUsers (${t.admins} $uiHomeRoleAdminLc, '
          '${t.coordinators} $uiHomeRoleCoordinatorLc, '
          '${t.members} $uiHomeRoleMemberLc)',
  };

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

  /// "Takvim mobilde sonraki adımda eklenecek".
  String soon(String what) => '$what $uiHomeSoonTail';
}
