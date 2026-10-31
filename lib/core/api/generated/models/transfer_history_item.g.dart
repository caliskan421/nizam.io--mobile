// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferHistoryItem _$TransferHistoryItemFromJson(Map<String, dynamic> json) =>
    _TransferHistoryItem(
      transferId: json['transfer_id'] as String,
      sourceProgramId: json['source_program_id'] as String,
      targetProgramId: json['target_program_id'] as String,
      departmentId: json['department_id'] as String,
      workItemIds: (json['work_item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      movedItemCount: (json['moved_item_count'] as num).toInt(),
      movedFileCount: (json['moved_file_count'] as num).toInt(),
      cutDependencyCount: (json['cut_dependency_count'] as num).toInt(),
      restoredDependencyCount: (json['restored_dependency_count'] as num)
          .toInt(),
      grantedMemberships: (json['granted_memberships'] as List<dynamic>)
          .map((e) => GrantedMembership.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      skippedWorkItemIds: (json['skipped_work_item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      reversesTransferId: json['reverses_transfer_id'] as String?,
    );

Map<String, dynamic> _$TransferHistoryItemToJson(
  _TransferHistoryItem instance,
) => <String, dynamic>{
  'transfer_id': instance.transferId,
  'source_program_id': instance.sourceProgramId,
  'target_program_id': instance.targetProgramId,
  'department_id': instance.departmentId,
  'work_item_ids': ?instance.workItemIds,
  'moved_item_count': instance.movedItemCount,
  'moved_file_count': instance.movedFileCount,
  'cut_dependency_count': instance.cutDependencyCount,
  'restored_dependency_count': instance.restoredDependencyCount,
  'granted_memberships': instance.grantedMemberships
      .map((e) => e.toJson())
      .toList(),
  'created_at': instance.createdAt.toIso8601String(),
  'skipped_work_item_ids': ?instance.skippedWorkItemIds,
  'reverses_transfer_id': ?instance.reversesTransferId,
};
