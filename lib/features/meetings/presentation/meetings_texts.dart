import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import '../domain/meeting_status.dart';

/// Toplantı ekranlarının tarih ve sayılı cümleleri. UI metin kaynağı yer tutucu kabul etmediği
/// için parçalar ARB'den gelir, Türkçe söz dizimiyle burada birleşir.
extension MeetingsTexts on AppLocalizations {
  static final _time = DateFormat('HH:mm', 'tr');
  static final _long = DateFormat('d MMMM EEEE', 'tr');
  static final _dayMonth = DateFormat('d MMMM', 'tr');
  static final _month = DateFormat('MMMM y', 'tr');
  static final _monthShort = DateFormat('MMM', 'tr');

  /// "14:00" (yerel).
  String meetingTime(DateTime at) => _time.format(at.toLocal());

  /// "18 Ekim".
  String meetingDayMonth(DateTime at) => _dayMonth.format(at.toLocal());

  /// Tarih kutusu ayı: "EKİ".
  String meetingMonthTag(DateTime at) => _monthShort
      .format(at.toLocal())
      .replaceAll('.', '')
      .replaceAll('i', 'İ')
      .toUpperCase();

  /// Ayrıntı kimlik satırı: "Bugün · 14 Ekim Çarşamba · 15:00".
  String meetingWhenLine(DateTime at, DateTime today) {
    final local = at.toLocal();
    final r = dayDiff(DateTime(local.year, local.month, local.day), today);
    final rel = switch (r) {
      0 => '$uiMeetingsGroupToday · ',
      1 => '$uiMeetingsGroupTomorrow · ',
      -1 => '$uiMeetingsYesterday · ',
      _ => '',
    };
    return '$rel${_long.format(local)} · ${meetingTime(at)}';
  }

  String meetingsTabLabel(MeetingsTab t) => switch (t) {
    MeetingsTab.upcoming => uiMeetingsTabUpcoming,
    MeetingsTab.past => uiMeetingsTabPast,
    MeetingsTab.deleted => uiMeetingsTabDeleted,
  };

  /// Liste grubu başlığı: yaklaşanlarda göreli gün, diğerlerinde "Ekim 2026".
  String meetingGroupLabel(MeetingGroup g) => switch (g.when) {
    MeetingWhen.today => uiMeetingsGroupToday,
    MeetingWhen.tomorrow => uiMeetingsGroupTomorrow,
    MeetingWhen.thisWeek => uiMeetingsGroupThisWeek,
    MeetingWhen.nextWeek => uiMeetingsGroupNextWeek,
    MeetingWhen.later => uiMeetingsGroupLater,
    null => _month.format(g.month!),
  };

  String meetingsEmpty(MeetingsTab t, {required bool filtered}) => filtered
      ? uiMeetingsEmptyFilter
      : switch (t) {
          MeetingsTab.upcoming => uiMeetingsEmptyUpcoming,
          MeetingsTab.past => uiMeetingsEmptyPast,
          MeetingsTab.deleted => uiMeetingsEmptyDeleted,
        };

  /// "Sahip: Altyapı ve tesisat · 2 koordinatörlük davetli".
  /// Liste kartında yalnız sahip ([invited] false): "Sahip: Altyapı ve tesisat".
  String meetingOwnerLine(Meeting m, String ownerName, {bool invited = true}) =>
      invited
      ? '$uiMeetingsOwnerPrefix $ownerName · ${m.departments.length} '
            '$uiMeetingsInvitedTail'
      : '$uiMeetingsOwnerPrefix $ownerName';

  /// "Silindi · 18 Ekim".
  String meetingDeletedLine(DateTime at) =>
      '$uiMeetingsDeletedPrefix · ${meetingDayMonth(at)}';

  String meetingSectionLabel(MeetingSection s) => switch (s) {
    MeetingSection.agenda => uiMeetingsTabAgenda,
    MeetingSection.notes => uiMeetingsTabNotes,
    MeetingSection.people => uiMeetingsTabPeople,
    MeetingSection.info => uiMeetingsTabInfo,
  };

  String meetingRole(MeetingRole r) => switch (r) {
    MeetingRole.admin => uiMeetingsRoleAdmin,
    MeetingRole.coordinator => uiMeetingsRoleCoordinator,
    MeetingRole.member || MeetingRole.unknown => uiMeetingsRoleMember,
  };

  String noteFilterLabel(NoteFilter f, int count) =>
      '${switch (f) {
        NoteFilter.all => uiMeetingsNfAll,
        NoteFilter.converted => uiMeetingsNfConverted,
        NoteFilter.mine => uiMeetingsNfMine,
      }} $count';

  /// Okuyucu: "3 maddeden 2 tamamlandı".
  String agendaProgress(int done, int total) =>
      '$total $uiMeetingsAgendaOfTail $done $uiMeetingsAgendaDoneTail';

  /// "Saha keşfi maddesini sil".
  String agendaDeleteLabel(String title) =>
      '$title $uiMeetingsAgendaDeleteTail';

  /// Katılımcı ekleme sonucu: "2 kişi eklendi · 1 kişi eklenemedi".
  String participantsAdded(int added, int failed) => [
    if (added > 0) '$added $uiMeetingsTAddedTail',
    if (failed > 0) '$failed $uiMeetingsTFailedTail',
  ].join(' · ');

  /// Tarih kutusu etiketi: "CANLI", "BEKLİYOR", "YAPILMADI", "BİTTİ".
  String meetingTileLabel(MeetingPhase p) => switch (p) {
    MeetingPhase.live => uiMeetingsStLive,
    MeetingPhase.waiting => uiMeetingsStWaiting,
    MeetingPhase.notHeld => uiMeetingsStNotHeld,
    MeetingPhase.finished => uiMeetingsStDone,
  };

  /// Okuyucu ve konferans başlığı: "Canlı", "Bekliyor", "Yapılmadı", "Bitti · 40 dk".
  String meetingStatusLabel(MeetingStatus s) => switch (s.phase) {
    MeetingPhase.live => uiMeetingsConfLive,
    MeetingPhase.waiting => uiMeetingsStatusWaiting,
    MeetingPhase.notHeld => uiMeetingsStatusNotHeld,
    MeetingPhase.finished =>
      '$uiMeetingsStatusDone · ${s.minutes ?? 0} $uiMeetingsMinTail',
  };

  /// "14:02'den beri" (Türkçe ayrılma eki saatin okunuşuna göre: iki → 'den, dört → 'ten,
  /// altı → 'dan; dakika sıfırsa saat okunur).
  String meetingSince(DateTime at) {
    final local = at.toLocal();
    final n = local.minute != 0 ? local.minute : local.hour;
    final suffix = switch (n % 10) {
      1 || 2 || 7 || 8 => 'den',
      3 || 4 || 5 => 'ten',
      6 || 9 => 'dan',
      _ => switch (n ~/ 10) {
        2 || 5 => 'den',
        4 => 'tan',
        _ => 'dan',
      },
    };
    return "${meetingTime(at)}'$suffix $uiMeetingsSinceTail";
  }

  /// Kart sayaçları: "2 not" / "not yok" (devamı varsa "20+ not"), "3 kişi".
  String meetingNotesStat(MeetingSummary s) => s.notes == 0
      ? uiMeetingsNoNotes
      : '${s.notes}${s.moreNotes ? '+' : ''} $uiMeetingsNoteTail';

  String meetingPeopleStat(int n) => '$n $uiMeetingsPersonTail';

  /// "Koordinatörlük · 3 birim".
  String meetingInviteKind(Meeting m) =>
      '$uiMeetingsInviteCoord · ${m.departments.length} $uiMeetingsUnitTail';
}

/// Toplantı departmanının ekrandaki kısa etiketi: katalogdaki departman kodu, yoksa toplantının
/// taşıdığı ad kopyası (departman silinmiş olabilir).
String meetingDeptLabel(TaskCatalog? catalog, MeetingDepartment d) =>
    catalog?.coordinatorship(d.id)?.label ?? d.name;

/// Departmanın adı: katalogdaki güncel ad, yoksa toplantının ad kopyası.
String meetingDeptName(TaskCatalog? catalog, MeetingDepartment d) =>
    catalog?.coordinatorship(d.id)?.name ?? d.name;

/// Sahip departman önde, diğerleri sunucu sırasıyla.
List<MeetingDepartment> ownerFirst(Meeting m) => [
  ...m.departments.where((d) => d.id == m.ownerDepartmentId),
  ...m.departments.where((d) => d.id != m.ownerDepartmentId),
];
