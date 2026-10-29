// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      id: json['id'] as String,
      type: json['type'] as String,
      subjectRef: NotificationSubject.fromJson(
        json['subject_ref'] as Map<String, dynamic>,
      ),
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'subject_ref': instance.subjectRef.toJson(),
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };
