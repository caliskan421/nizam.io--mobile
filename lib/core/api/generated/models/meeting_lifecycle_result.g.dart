// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_lifecycle_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingLifecycleResult _$MeetingLifecycleResultFromJson(
  Map<String, dynamic> json,
) => _MeetingLifecycleResult(
  meetingId: json['meeting_id'] as String,
  status: MeetingLifecycleResultStatus.fromJson(json['status'] as String),
);

Map<String, dynamic> _$MeetingLifecycleResultToJson(
  _MeetingLifecycleResult instance,
) => <String, dynamic>{
  'meeting_id': instance.meetingId,
  'status': _$MeetingLifecycleResultStatusEnumMap[instance.status]!,
};

const _$MeetingLifecycleResultStatusEnumMap = {
  MeetingLifecycleResultStatus.restored: 'restored',
  MeetingLifecycleResultStatus.purged: 'purged',
  MeetingLifecycleResultStatus.$unknown: r'$unknown',
};
