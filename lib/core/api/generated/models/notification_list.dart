// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';

part 'notification_list.freezed.dart';
part 'notification_list.g.dart';

@Freezed()
abstract class NotificationList with _$NotificationList {
  const factory NotificationList({
    required List<Notification> items,
    @JsonKey(name: 'unread_count') required int unreadCount,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _NotificationList;

  factory NotificationList.fromJson(Map<String, Object?> json) =>
      _$NotificationListFromJson(json);
}
