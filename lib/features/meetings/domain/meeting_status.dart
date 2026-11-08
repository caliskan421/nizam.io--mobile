import 'package:meta/meta.dart';

import 'meeting.dart';
import 'meeting_board.dart';

// Toplantının durumu (prototip `RPM.status`) ve kart sayaçları. Durumun bir kısmı sunucudan
// türer (canlı konferans, saati geçmiş ama başlamamış toplantı); bir kısmı için sunucuda henüz
// alan yoktur ([MeetingExtras]).

/// Backend'in (v0.9.0-api) TAŞIMADIĞI toplantı olguları: konferans geçmişi (süre, hiç yapılmadı),
/// canlı konferansa bağlı kişi sayısı, silen kişi, toplantı sohbeti. Sunucu alanları gelince bu
/// tip kalkar, alanlar domain varlıklarına taşınır. Üretimde boştur ([MeetingExtras.none]);
/// geliştirmede örnek kaynak doldurur (tasarım durumları görülsün diye).
@immutable
final class MeetingExtras {
  const MeetingExtras({
    this.finishedMinutes,
    this.notHeld = false,
    this.connected,
    this.deletedBy,
    this.chatId,
  });

  static const none = MeetingExtras();

  /// Geçmiş toplantının konferansı bitti: süre (dk).
  final int? finishedMinutes;

  /// Geçmiş toplantıda konferans hiç açılmadı.
  final bool notHeld;

  /// Canlı konferansa bağlı kişi sayısı.
  final int? connected;

  /// Toplantıyı silen kişinin adı.
  final String? deletedBy;

  /// Toplantı sohbetinin kimliği.
  final String? chatId;
}

/// [MeetingExtras] kaynağı (geçici port; bkz. [MeetingExtras]).
abstract interface class MeetingExtrasRepository {
  MeetingExtras of(Meeting meeting, DateTime today);
}

/// Üretim: sunucuda alan yok → hiçbir olgu yok.
final class NoMeetingExtras implements MeetingExtrasRepository {
  const NoMeetingExtras();

  @override
  MeetingExtras of(Meeting meeting, DateTime today) => MeetingExtras.none;
}

/// Kart ve sekme durumu.
enum MeetingPhase {
  /// Konferans sürüyor (ya da açılıyor).
  live,

  /// Bugün, saati geçti, konferans başlatılmadı.
  waiting,

  /// Geçmiş toplantıda konferans hiç açılmadı.
  notHeld,

  /// Geçmiş toplantının konferansı bitti ([MeetingStatus.minutes]).
  finished,
}

@immutable
final class MeetingStatus {
  const MeetingStatus(this.phase, {this.minutes});

  final MeetingPhase phase;
  final int? minutes;

  @override
  bool operator ==(Object other) =>
      other is MeetingStatus &&
      other.phase == phase &&
      other.minutes == minutes;

  @override
  int get hashCode => Object.hash(phase, minutes);
}

/// Toplantının durumu; durum yoksa (ileri tarihli, ya da veri bilinmiyor) null.
/// [conferenceKnown]: konferans bilgisi okundu mu (liste satırında ayrıntı gelmeden "bekliyor"
/// denmez; liste ucu konferans taşımaz, COLLABORATION-K51).
MeetingStatus? meetingStatus(
  Meeting m, {
  required DateTime now,
  MeetingConference? conference,
  bool conferenceKnown = false,
  MeetingExtras extras = MeetingExtras.none,
}) {
  if (conference != null && conference.status != ConferenceStatus.ending) {
    return const MeetingStatus(MeetingPhase.live);
  }
  if (extras.finishedMinutes case final min?) {
    return MeetingStatus(MeetingPhase.finished, minutes: min);
  }
  if (extras.notHeld) return const MeetingStatus(MeetingPhase.notHeld);
  final today = DateTime(now.year, now.month, now.day);
  if (conferenceKnown &&
      dayDiff(meetingDay(m), today) == 0 &&
      !m.meetingDate.isAfter(now)) {
    return const MeetingStatus(MeetingPhase.waiting);
  }
  return null;
}

/// Kart sayaçları (ayrıntıdan): gündem, not, katılımcı, konferans.
@immutable
final class MeetingSummary {
  const MeetingSummary({
    required this.agendaDone,
    required this.agendaTotal,
    required this.notes,
    required this.people,
    this.moreNotes = false,
    this.conference,
  });

  /// [notes] verilmezse ayrıntının ilk not sayfası sayılır ([moreNotes]: devamı var).
  factory MeetingSummary.of(MeetingDetail d, {int? notes}) => MeetingSummary(
    agendaDone: d.agenda.where((a) => a.isChecked).length,
    agendaTotal: d.agenda.length,
    notes: notes ?? d.notes.items.length,
    moreNotes: notes == null && d.notes.hasMore,
    people: d.participants.length,
    conference: d.conference,
  );

  final int agendaDone;
  final int agendaTotal;
  final int notes;

  /// Not sayısı bir alt sınırdır ("20+").
  final bool moreNotes;
  final int people;
  final MeetingConference? conference;
}
