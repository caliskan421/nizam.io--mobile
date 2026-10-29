// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_preview_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferPreviewRequest _$TransferPreviewRequestFromJson(
  Map<String, dynamic> json,
) => _TransferPreviewRequest(
  sourceProgramId: json['source_program_id'] as String?,
  targetProgramId: json['target_program_id'] as String?,
  departmentId: json['department_id'] as String?,
  workItemIds: (json['work_item_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TransferPreviewRequestToJson(
  _TransferPreviewRequest instance,
) => <String, dynamic>{
  'source_program_id': ?instance.sourceProgramId,
  'target_program_id': ?instance.targetProgramId,
  'department_id': ?instance.departmentId,
  'work_item_ids': ?instance.workItemIds,
};
