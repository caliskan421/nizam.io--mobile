// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_tab_counts.freezed.dart';
part 'meeting_tab_counts.g.dart';

/// Toplantı listesinin sekme sayaçları (COLLABORATION-K79). `upcoming` ve `past` görünürlük, `department_id` ve `from`/`to` süzgeçli kümeyi sayar; `when` ve imleç sayaçlara uygulanmaz. Sınır kurulum saat diliminde bugünün gece yarısıdır: bugün saati geçmiş toplantı `upcoming`'dedir.
@Freezed()
abstract class MeetingTabCounts with _$MeetingTabCounts {
  const factory MeetingTabCounts({
    required int upcoming,
    required int past,

    /// Programın silinmiş toplantı sayısı (`GET /v1/meetings/deleted` kümesi; süzgeç almaz). Yalnız şirket yöneticisinde dolu, diğer rollerde null.
    required int? deleted,
  }) = _MeetingTabCounts;

  factory MeetingTabCounts.fromJson(Map<String, Object?> json) =>
      _$MeetingTabCountsFromJson(json);
}
