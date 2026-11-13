// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meeting.dart';
import 'meeting_tab_counts.dart';

part 'meeting_list.freezed.dart';
part 'meeting_list.g.dart';

@Freezed()
abstract class MeetingList with _$MeetingList {
  const factory MeetingList({
    required List<Meeting> items,
    @JsonKey(name: 'next_cursor') required String nextCursor,

    /// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz. Bu isteğin süzülmüş kümesinin boyu: görünürlük, `department_id`, `from`/`to` ve `when`. İmleçten bağımsızdır; her sayfada aynı değerdir (sayfalar arasındaki yazımlar hariç). `when` yoksa `tab_counts.upcoming + tab_counts.past`'tır.
    int? total,

    /// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz.
    @JsonKey(name: 'tab_counts') MeetingTabCounts? tabCounts,
  }) = _MeetingList;

  factory MeetingList.fromJson(Map<String, Object?> json) =>
      _$MeetingListFromJson(json);
}
