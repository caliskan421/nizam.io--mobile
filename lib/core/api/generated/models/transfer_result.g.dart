// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferResult _$TransferResultFromJson(Map<String, dynamic> json) =>
    _TransferResult(
      transferId: json['transfer_id'] as String,
      movedWorkItemIds: (json['moved_work_item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      movedFileCount: (json['moved_file_count'] as num).toInt(),
      cutDependencyCount: (json['cut_dependency_count'] as num).toInt(),
      restoredDependencyCount: (json['restored_dependency_count'] as num)
          .toInt(),
      grantedLinks: (json['granted_links'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      revokedLinks: (json['revoked_links'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      retainedLinks: (json['retained_links'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      grantedMemberships: (json['granted_memberships'] as List<dynamic>)
          .map((e) => GrantedMembership.fromJson(e as Map<String, dynamic>))
          .toList(),
      replayed: json['replayed'] as bool,
      skippedWorkItemIds: (json['skipped_work_item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransferResultToJson(_TransferResult instance) =>
    <String, dynamic>{
      'transfer_id': instance.transferId,
      'moved_work_item_ids': ?instance.movedWorkItemIds,
      'moved_file_count': instance.movedFileCount,
      'cut_dependency_count': instance.cutDependencyCount,
      'restored_dependency_count': instance.restoredDependencyCount,
      'granted_links': instance.grantedLinks,
      'revoked_links': instance.revokedLinks,
      'retained_links': instance.retainedLinks,
      'granted_memberships': instance.grantedMemberships
          .map((e) => e.toJson())
          .toList(),
      'replayed': instance.replayed,
      'skipped_work_item_ids': ?instance.skippedWorkItemIds,
    };
