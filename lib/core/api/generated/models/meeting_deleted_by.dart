// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_deleted_by.freezed.dart';
part 'meeting_deleted_by.g.dart';

@Freezed()
abstract class MeetingDeletedBy with _$MeetingDeletedBy {
  const factory MeetingDeletedBy({
    @JsonKey(name: 'account_id') required String accountId,

    /// Hesabın bugünkü görünen adı; hesap bulunamazsa boş.
    @JsonKey(name: 'full_name') required String fullName,
  }) = _MeetingDeletedBy;

  factory MeetingDeletedBy.fromJson(Map<String, Object?> json) =>
      _$MeetingDeletedByFromJson(json);
}
