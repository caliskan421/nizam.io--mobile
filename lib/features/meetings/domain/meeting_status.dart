import 'package:meta/meta.dart';

import 'meeting.dart';
import 'meeting_board.dart';

// Toplantının durumu (prototip `RPM.status`): sunucu özetinden (liste satırı `summary` ya da
// ayrıntıdan türetilen [MeetingSummary]) ve toplantı anından türer.

/// Kart ve sekme durumu.
enum MeetingPhase {
  /// Konferans sürüyor (ya da açılıyor).
  live,

  /// Bugün, saati geçti, konferans başlatılmadı.
  waiting,

  /// Geçmiş toplantıda konferans hiç açılmadı.
  notHeld,

  /// Konferans bitti ([MeetingStatus.minutes]).
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

/// Toplantının durumu; özet yoksa ya da durum yoksa (ileri tarihli, kapanmakta olan, bilinmeyen
/// konferans durumu) null. [summary] verilmezse liste satırının özeti ([Meeting.summary]).
/// Süre `ended_at − started_at` (dakikaya yuvarlanır; sistem kapanışında boş oda payı dahildir).
MeetingStatus? meetingStatus(
  Meeting m, {
  required DateTime now,
  MeetingSummary? summary,
}) {
  final s = summary ?? m.summary;
  if (s == null) return null;
  final st = s.conferenceStatus;
  if (st == SummaryConferenceStatus.starting ||
      st == SummaryConferenceStatus.live) {
    return const MeetingStatus(MeetingPhase.live);
  }
  final start = s.conferenceStartedAt;
  final end = s.conferenceEndedAt;
  if ((st == SummaryConferenceStatus.ended ||
          st == SummaryConferenceStatus.ending) &&
      start != null &&
      end != null) {
    final secs = end.difference(start).inSeconds;
    return MeetingStatus(
      MeetingPhase.finished,
      minutes: secs <= 0 ? 0 : (secs / 60).round(),
    );
  }
  if (st != SummaryConferenceStatus.none) return null;
  final today = DateTime(now.year, now.month, now.day);
  final diff = dayDiff(meetingDay(m), today);
  if (diff < 0) return const MeetingStatus(MeetingPhase.notHeld);
  if (diff == 0 && !m.meetingDate.isAfter(now)) {
    return const MeetingStatus(MeetingPhase.waiting);
  }
  return null;
}
