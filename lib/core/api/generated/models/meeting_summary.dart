// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting_summary_conference_status.dart';

part 'meeting_summary.freezed.dart';
part 'meeting_summary.g.dart';

/// Liste satırının özeti (COLLABORATION-K70). Konferans alanları detaydaki `conference`'ın, o yoksa `last_conference`'ın aynı değerleridir (zaman alanları detayla aynı). `conference_status`: `none` hiç konferans açılmadı (iki zaman da null); `starting`/`live`/`ending` detaydaki `conference.status`; `ended` açık konferans yok, son konferans bitti. Süreyi istemci hesaplar; sistem kapanışında (boş oda) süre 5 dk boş oda payını içerir.
@Freezed()
abstract class MeetingSummary with _$MeetingSummary {
  const factory MeetingSummary({
    @JsonKey(name: 'agenda_total') required int agendaTotal,
    @JsonKey(name: 'agenda_checked') required int agendaChecked,

    /// Not sayısı (silinen not kalıcı silinir ve sayılmaz).
    @JsonKey(name: 'note_count') required int noteCount,

    /// Detaydaki `conference.connected.count` ile aynı (COLLABORATION-K78); `none`/`ended` iken 0.
    @JsonKey(name: 'connected_count') required int connectedCount,
    @JsonKey(name: 'participant_count') required int participantCount,
    @JsonKey(name: 'conference_status')
    required MeetingSummaryConferenceStatus conferenceStatus,
    @JsonKey(name: 'conference_started_at')
    required DateTime? conferenceStartedAt,

    /// `starting`/`live` iken null; `ending`/`ended` iken kapanma isteğinin ya da sistem kapanışının anı.
    @JsonKey(name: 'conference_ended_at') required DateTime? conferenceEndedAt,
  }) = _MeetingSummary;

  factory MeetingSummary.fromJson(Map<String, Object?> json) =>
      _$MeetingSummaryFromJson(json);
}
