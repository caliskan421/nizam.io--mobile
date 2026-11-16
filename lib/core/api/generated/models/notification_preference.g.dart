// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreference _$NotificationPreferenceFromJson(
  Map<String, dynamic> json,
) => _NotificationPreference(
  group: NotificationPreferenceGroup.fromJson(json['group'] as String),
  pushMuted: json['push_muted'] as bool,
);

Map<String, dynamic> _$NotificationPreferenceToJson(
  _NotificationPreference instance,
) => <String, dynamic>{
  'group': _$NotificationPreferenceGroupEnumMap[instance.group]!,
  'push_muted': instance.pushMuted,
};

const _$NotificationPreferenceGroupEnumMap = {
  NotificationPreferenceGroup.gorev: 'gorev',
  NotificationPreferenceGroup.mesaj: 'mesaj',
  NotificationPreferenceGroup.toplanti: 'toplanti',
  NotificationPreferenceGroup.sistem: 'sistem',
  NotificationPreferenceGroup.$unknown: r'$unknown',
};
