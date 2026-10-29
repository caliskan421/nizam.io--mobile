// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationList _$NotificationListFromJson(Map<String, dynamic> json) =>
    _NotificationList(
      items: (json['items'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unread_count'] as num).toInt(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$NotificationListToJson(_NotificationList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'unread_count': instance.unreadCount,
      'next_cursor': ?instance.nextCursor,
    };
