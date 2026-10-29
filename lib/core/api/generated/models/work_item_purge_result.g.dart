// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_purge_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemPurgeResult _$WorkItemPurgeResultFromJson(Map<String, dynamic> json) =>
    _WorkItemPurgeResult(
      workItemId: json['work_item_id'] as String,
      status: WorkItemPurgeResultStatus.fromJson(json['status'] as String),
      filesDeleted: (json['files_deleted'] as num).toInt(),
    );

Map<String, dynamic> _$WorkItemPurgeResultToJson(
  _WorkItemPurgeResult instance,
) => <String, dynamic>{
  'work_item_id': instance.workItemId,
  'status': _$WorkItemPurgeResultStatusEnumMap[instance.status]!,
  'files_deleted': instance.filesDeleted,
};

const _$WorkItemPurgeResultStatusEnumMap = {
  WorkItemPurgeResultStatus.purged: 'purged',
  WorkItemPurgeResultStatus.$unknown: r'$unknown',
};
