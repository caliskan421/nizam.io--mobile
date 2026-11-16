import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';

/// Koordinatörlük ayrıntısı (segmentli bölümler) sayılı cümleleri; parçalar ARB'den.
extension CoordDetailTexts on AppLocalizations {
  String coordTabLabel(CoordinatorshipTab t) => switch (t) {
    CoordinatorshipTab.general => uiCoordTabGeneral,
    CoordinatorshipTab.tasks => uiCoordTabTasks,
    CoordinatorshipTab.members => uiCoordTabMembers,
    CoordinatorshipTab.archive => uiCoordTabArchive,
    CoordinatorshipTab.calendar => uiCoordTabCalendar,
  };

  String coordFilterLabel(CoordTaskFilter f) => switch (f) {
    CoordTaskFilter.open => uiCoordStOpen,
    CoordTaskFilter.late => uiCoordStLate,
    CoordTaskFilter.review => uiCoordStReview,
    CoordTaskFilter.dateRequest => uiCoordStRequest,
    CoordTaskFilter.notStarted => uiCoordStTodo,
    CoordTaskFilter.done => uiCoordStDone,
    CoordTaskFilter.all => uiCoordStAll,
  };

  /// "8 açık · 3 gecikmede".
  String coordOpenLate(CoordPulse p) =>
      '${p.open} $uiCoordOpenTail · ${p.late} $uiCoordLateTail';

  /// "2 koordinatör · 4 üye".
  String coordLeadsMembers(int leads, int members) =>
      '$leads $uiCoordLeadsTail · $members $uiCoordMembersTail';

  /// "Açık · 8 görev" (bölüm başlığı; süzgeç adı ayrıca kalın).
  String coordTaskCount(int n) => '$n $uiCoordTasksTail';

  /// Kişi satırı alt metni.
  String coordPersonSub(CoordPerson p) => p.late > 0
      ? '${p.late} $uiCoordPersonLateTail'
      : p.open > 0
      ? '${p.open} $uiCoordOpenTasksTail'
      : uiCoordNoOpen;

  /// "koordinatörler · 2".
  String coordGroupLabel(String label, int n) => '$label · $n';

  /// "12 kişi".
  String coordPeopleCount(int n) => '$n $uiCoordPeopleTail';

  /// 1 234 567 bayt → "1,2 MB"; 1 MB altı "420 KB" (en az 1 KB).
  String coordBytes(int bytes) {
    final mb = bytes / (1024 * 1024);
    if (mb >= 1) {
      return '${NumberFormat('0.0', 'tr').format(mb)} MB';
    }
    final kb = (bytes / 1024).ceil();
    return '${kb < 1 ? 1 : kb} KB';
  }

  /// "dosya · 1,2 MB" (sayı ayrıca büyük yazılır).
  String coordFilesSize(int bytes) =>
      '$uiCoordFilesTail · ${coordBytes(bytes)}';

  String coordKindLabel(CoordFileKind k) => switch (k) {
    CoordFileKind.image => uiCoordKindImage,
    CoordFileKind.document => uiCoordKindDoc,
    CoordFileKind.pdf => uiCoordKindPdf,
  };

  /// Dosya kutucuğu kısa adı (mono).
  String coordKindTag(CoordFileKind k) => switch (k) {
    CoordFileKind.image => 'IMG',
    CoordFileKind.document => 'DOC',
    CoordFileKind.pdf => 'PDF',
  };

  /// "4 yaklaşan · 2 geçmiş".
  String coordMeetCount(int up, int past) =>
      '$up $uiCoordUpcomingTail · $past $uiCoordPastTail';

  /// Toplantıya kalan: "bugün", "yarın", "5 gün sonra".
  String coordMeetWhen(DateTime at, DateTime today) {
    final d = DateTime(
      at.year,
      at.month,
      at.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    if (d <= 0) return uiCoordToday;
    if (d == 1) return uiCoordTomorrow;
    return '$d $uiCoordDaysLaterTail';
  }

  /// "10:00 · Sahip · 3 birim".
  String coordMeetMeta(CoordMeeting m) => [
    DateFormat('HH:mm', 'tr').format(m.at),
    m.owner ? uiCoordOwner : uiCoordInvited,
    '${m.departments} $uiCoordDepartmentsTail',
  ].join(' · ');

  /// Ayın kısa adı büyük harfle ("KAS", "EKİ").
  String coordMonth(DateTime d) => DateFormat(
    'MMM',
    'tr',
  ).format(d).replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  /// "Sıradaki 28 kas · 10:00" / "planlı toplantı yok".
  String coordNextMeeting(CoordMeeting? m) => m == null
      ? uiCoordNoMeetingsPlanned
      : '$uiCoordNext ${DateFormat('d MMM · HH:mm', 'tr').format(m.at)}';

  /// "7 kas" (Akış'taki bugün çizgisi).
  String coordDayMonth(DateTime d) =>
      DateFormat('d MMM', 'tr').format(d).toLowerCase();

  /// "3 gün geçti".
  String coordDaysAgo(int n) => '$n $uiCoordDaysAgoTail';

  /// [at] gününe kalan: "bugün" ya da "5 gün".
  String coordDaysLeft(DateTime at, DateTime today) {
    final d = DateTime(
      at.year,
      at.month,
      at.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    return d <= 0 ? uiCoordToday : '$d $uiCoordDaysTail';
  }

  /// Akış toplantı satırı: "10:00 · sahip · toplantı".
  String coordFlowMeetingMeta(CoordMeeting m) => [
    DateFormat('HH:mm', 'tr').format(m.at),
    (m.owner ? uiCoordOwner : uiCoordInvited).toLowerCase(),
    uiCoordMeetingTag,
  ].join(' · ');

  /// İş yükü satırının alt metni: geciken varsa sayısı, yoksa "zamanında" ya da bitenler.
  String coordLoadSub(CoordLoad r) => r.late > 0
      ? '${r.late} $uiCoordLateTasksTail'
      : r.open > 0
      ? uiCoordOnTime
      : '${r.done} $uiCoordFinishedTail';

  /// "Tüm ekip · 9 kişi".
  String coordAllTeam(int n) => '$uiCoordAllTeam · ${coordPeopleCount(n)}';
}
