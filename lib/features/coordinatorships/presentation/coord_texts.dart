import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/department.dart';

/// Koordinatörlük ekranlarının sayılı cümleleri. UI metin kaynağı yer tutucu kabul etmediği
/// için parçalar ARB'den gelir, Türkçe söz dizimiyle burada birleşir.
extension CoordTexts on AppLocalizations {
  /// "11 koordinatörlük · 76 görev · 7 koordinatörlükte gecikme".
  String coordListSubtitle(List<CoordinatorshipStats> list) {
    final tasks = list.fold<int>(0, (a, c) => a + c.total);
    final late = list.where((c) => c.late > 0).length;
    return '${list.length} $uiCoordCountTail · $tasks $uiCoordTasksTail · '
        '$late $uiCoordLateCoordsTail';
  }

  /// "9/13 bitti".
  String coordDone(CoordinatorshipStats c) =>
      '${c.done}/${c.total} $uiCoordDoneTail';

  /// "3 gecikmede".
  String coordLate(CoordinatorshipStats c) => '${c.late} $uiCoordLateTail';

  /// Liste kartı satırı (kaynak `S_coord` `D[5]`): koordinatörler virgülle ("Abdullah Ateş,
  /// Ali Avcı, Kadir Özbek"); üyeler yalnız koordinatör yokken ("Koordinatör yok · Bahar Kılıç
  /// (üye)").
  String coordPeople(CoordinatorshipStats c) {
    if (c.hasLead) return c.leads.map((p) => p.name).join(', ');
    if (c.members.isEmpty) return uiCoordNoLead;
    return '$uiCoordNoLead · ${c.members.map((p) => p.name).join(', ')} '
        '$uiCoordMemberSuffix';
  }

  String coordSortLabel(CoordinatorshipSort s) => switch (s) {
    CoordinatorshipSort.name => uiCoordSortName,
    CoordinatorshipSort.late => uiCoordSortLate,
    CoordinatorshipSort.progress => uiCoordSortProgress,
  };

  /// Departman türünün adı ("Koordinatörlük", "Çalışma grubu"); tanımsız tür null.
  String? coordKind(DepartmentKind k) => switch (k) {
    DepartmentKind.coordinatorship => uiCoordDeptKindCoordinatorship,
    DepartmentKind.workingGroup => uiCoordDeptKindWorkingGroup,
    DepartmentKind.unknown => null,
  };

  /// "ALT-5 · Kadir Özbek".
  String coordAttentionWho(AttentionItem a) =>
      [a.label, ?a.assignee].join(' · ');

  /// "98 gün gecikti".
  String coordDaysLate(AttentionItem a) =>
      '${a.overdueDays} $uiCoordDaysLateTail';

  /// "15 dosya".
  String coordFiles(int n) => '$n $uiCoordFilesTail';

  /// "2 planlı" / "yok".
  String coordMeetings(int n) => n > 0 ? '$n $uiCoordPlannedTail' : uiCoordNone;

  /// "ekip · 9".
  String coordTeamKicker(int people) => '$uiCoordTeam · $people';

  /// "6 üye daha".
  String coordMoreMembers(int n) => '$n $uiCoordMoreMembersTail';

  /// "Altyapı ve tesisat işlemleri".
  String coordMenuTitle(String name) => '$name $uiCoordMenuTitleTail';

  /// "ALT · 9/13 bitti · 3 gecikmede" (kısayol menüsü alt satırı).
  String coordFlyoutCaption(CoordinatorshipStats c) =>
      [?c.shortCode, coordDone(c), if (c.late > 0) coordLate(c)].join(' · ');

  /// "19.10".
  String coordShortDate(DateTime d) => DateFormat('dd.MM', 'tr').format(d);
}
