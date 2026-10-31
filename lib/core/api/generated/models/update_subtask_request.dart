// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_subtask_request.freezed.dart';
part 'update_subtask_request.g.dart';

/// Verilmeyen alan değişmez. `assignee_account_id`, `start_on`, `end_on` boş dizgeyle kaldırılır (tarihler birlikte).
@Freezed()
abstract class UpdateSubtaskRequest with _$UpdateSubtaskRequest {
  const factory UpdateSubtaskRequest({
    String? title,
    @JsonKey(name: 'assignee_account_id') String? assigneeAccountId,
    @JsonKey(name: 'start_on') String? startOn,
    @JsonKey(name: 'end_on') String? endOn,

    /// true kapatır, false yeniden açar (tamamlanmış görevde 409 `work.item_completed`).
    bool? done,
  }) = _UpdateSubtaskRequest;

  factory UpdateSubtaskRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateSubtaskRequestFromJson(json);
}
