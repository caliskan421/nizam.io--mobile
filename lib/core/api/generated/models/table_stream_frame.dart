// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_stream_frame.freezed.dart';
part 'table_stream_frame.g.dart';

/// Tablo akışının `ready` ve `changed` çerçevesi (ADR-0039 "Akış"). İçeriksizdir; `sequence` taze ACL okumasındaki güncel işlem sırasıdır ve tüketilmiş replay imleci değildir. Bir bağlantıda yalnız artar.
@Freezed()
abstract class TableStreamFrame with _$TableStreamFrame {
  const factory TableStreamFrame({
    @JsonKey(name: 'table_id') required String tableId,
    required int sequence,
  }) = _TableStreamFrame;

  factory TableStreamFrame.fromJson(Map<String, Object?> json) =>
      _$TableStreamFrameFromJson(json);
}
