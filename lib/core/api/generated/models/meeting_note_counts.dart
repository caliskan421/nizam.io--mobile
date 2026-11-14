// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_note_counts.freezed.dart';
part 'meeting_note_counts.g.dart';

/// Not sekme sayaçları (COLLABORATION-K80): süzgeçten ve imleçten bağımsızdır; toplantıyı gören her rol aynı kümeyi sayar.
@Freezed()
abstract class MeetingNoteCounts with _$MeetingNoteCounts {
  const factory MeetingNoteCounts({
    required int all,

    /// Göreve dönüşmüş notlar.
    required int converted,

    /// Çağıranın yazdığı notlar (yazarın rol kopyasından bağımsız).
    required int mine,
  }) = _MeetingNoteCounts;

  factory MeetingNoteCounts.fromJson(Map<String, Object?> json) =>
      _$MeetingNoteCountsFromJson(json);
}
