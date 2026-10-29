// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    _TransferRequest(
      sourceProgramId: json['source_program_id'] as String?,
      targetProgramId: json['target_program_id'] as String?,
      departmentId: json['department_id'] as String?,
      workItemIds: (json['work_item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      previewFingerprint: json['preview_fingerprint'] as String?,
      reversesTransferId: json['reverses_transfer_id'] as String?,
      addMissingAccess: json['add_missing_access'] as bool?,
    );

Map<String, dynamic> _$TransferRequestToJson(_TransferRequest instance) =>
    <String, dynamic>{
      'source_program_id': ?instance.sourceProgramId,
      'target_program_id': ?instance.targetProgramId,
      'department_id': ?instance.departmentId,
      'work_item_ids': ?instance.workItemIds,
      'preview_fingerprint': ?instance.previewFingerprint,
      'reverses_transfer_id': ?instance.reversesTransferId,
      'add_missing_access': ?instance.addMissingAccess,
    };
