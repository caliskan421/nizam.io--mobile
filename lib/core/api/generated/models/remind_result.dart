// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'remind_result.freezed.dart';
part 'remind_result.g.dart';

@Freezed()
abstract class RemindResult with _$RemindResult {
  const factory RemindResult({
    /// Bildirim kuyruğa alınan atanan sayısı (eylemi yapan hariç).
    @JsonKey(name: 'recipient_count') required int recipientCount,
  }) = _RemindResult;

  factory RemindResult.fromJson(Map<String, Object?> json) =>
      _$RemindResultFromJson(json);
}
