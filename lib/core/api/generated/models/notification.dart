// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_subject.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@Freezed()
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,

    /// Kaynak olay türü (docs/api/events.md).
    required String type,
    @JsonKey(name: 'subject_ref') required NotificationSubject subjectRef,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, Object?> json) =>
      _$NotificationFromJson(json);
}
