// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_preview_request.freezed.dart';
part 'transfer_preview_request.g.dart';

@Freezed()
abstract class TransferPreviewRequest with _$TransferPreviewRequest {
  const factory TransferPreviewRequest({
    @JsonKey(name: 'source_program_id') String? sourceProgramId,
    @JsonKey(name: 'target_program_id') String? targetProgramId,
    @JsonKey(name: 'department_id') String? departmentId,
    @JsonKey(name: 'work_item_ids') List<String>? workItemIds,
  }) = _TransferPreviewRequest;

  factory TransferPreviewRequest.fromJson(Map<String, Object?> json) =>
      _$TransferPreviewRequestFromJson(json);
}
