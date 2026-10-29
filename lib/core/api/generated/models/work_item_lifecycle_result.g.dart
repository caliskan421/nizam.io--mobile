// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_lifecycle_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemLifecycleResult _$WorkItemLifecycleResultFromJson(
  Map<String, dynamic> json,
) => _WorkItemLifecycleResult(
  workItemId: json['work_item_id'] as String,
  status: WorkItemLifecycleResultStatus.fromJson(json['status'] as String),
);

Map<String, dynamic> _$WorkItemLifecycleResultToJson(
  _WorkItemLifecycleResult instance,
) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'status': _$WorkItemLifecycleResultStatusEnumMap[instance.status]!,
};

const _$WorkItemLifecycleResultStatusEnumMap = {
  WorkItemLifecycleResultStatus.restored: 'restored',
  WorkItemLifecycleResultStatus.$unknown: r'$unknown',
};
