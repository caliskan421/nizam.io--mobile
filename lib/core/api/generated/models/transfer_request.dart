// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_request.freezed.dart';
part 'transfer_request.g.dart';

/// İleri aktarımda kaynak/hedef program, departman ve kalemler; ters aktarımda `reverses_transfer_id`. Eksik/çelişkili alan 422 program.transfer_input_invalid.
@Freezed()
abstract class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    @JsonKey(name: 'source_program_id') String? sourceProgramId,
    @JsonKey(name: 'target_program_id') String? targetProgramId,
    @JsonKey(name: 'department_id') String? departmentId,
    @JsonKey(name: 'work_item_ids') List<String>? workItemIds,
    @JsonKey(name: 'preview_fingerprint') String? previewFingerprint,

    /// Doluysa istek o aktarımın tersidir.
    @JsonKey(name: 'reverses_transfer_id') String? reversesTransferId,
    @JsonKey(name: 'add_missing_access') bool? addMissingAccess,
  }) = _TransferRequest;

  factory TransferRequest.fromJson(Map<String, Object?> json) =>
      _$TransferRequestFromJson(json);
}
