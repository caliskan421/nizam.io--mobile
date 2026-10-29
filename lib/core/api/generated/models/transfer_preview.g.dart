// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferPreview _$TransferPreviewFromJson(
  Map<String, dynamic> json,
) => _TransferPreview(
  resolvedWorkItemIds: (json['resolved_work_item_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  fileCount: (json['file_count'] as num).toInt(),
  fileTotalBytes: (json['file_total_bytes'] as num).toInt(),
  preservedDependencyCount: (json['preserved_dependency_count'] as num).toInt(),
  missingAccess: json['missing_access'] as bool,
  blockers: (json['blockers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  canExecute: json['can_execute'] as bool,
  previewFingerprint: json['preview_fingerprint'] as String,
  unresolvedWorkItemIds: (json['unresolved_work_item_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  missingFileIds: (json['missing_file_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  cutDependencyIds: (json['cut_dependency_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  cycleWorkItemIds: (json['cycle_work_item_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TransferPreviewToJson(_TransferPreview instance) =>
    <String, dynamic>{
      'resolved_work_item_ids': ?instance.resolvedWorkItemIds,
      'file_count': instance.fileCount,
      'file_total_bytes': instance.fileTotalBytes,
      'preserved_dependency_count': instance.preservedDependencyCount,
      'missing_access': instance.missingAccess,
      'blockers': instance.blockers,
      'warnings': instance.warnings,
      'can_execute': instance.canExecute,
      'preview_fingerprint': instance.previewFingerprint,
      'unresolved_work_item_ids': ?instance.unresolvedWorkItemIds,
      'missing_file_ids': ?instance.missingFileIds,
      'cut_dependency_ids': ?instance.cutDependencyIds,
      'cycle_work_item_ids': ?instance.cycleWorkItemIds,
    };
