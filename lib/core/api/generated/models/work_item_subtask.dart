// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'work_item_subtask.freezed.dart';
part 'work_item_subtask.g.dart';

@Freezed()
abstract class WorkItemSubtask with _$WorkItemSubtask {
  const factory WorkItemSubtask({
    @JsonKey(name: 'subtask_id') required String subtaskId,
    @JsonKey(name: 'work_item_id') required String workItemId,
    required String title,
    required bool done,
    @JsonKey(name: 'created_by_account_id') required String createdByAccountId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Atananın görünen adı; atanan yoksa ya da ad çözülemezse (geçici okuma hatası dahil) `null`.
    @JsonKey(name: 'assignee_full_name') required String? assigneeFullName,

    /// Kapatanın görünen adı; açık alt görevde ya da ad çözülemezse (geçici okuma hatası dahil) `null`.
    @JsonKey(name: 'done_by_full_name') required String? doneByFullName,

    /// Oluşturanın görünen adı; ad çözülemezse (geçici okuma hatası dahil) `null`.
    @JsonKey(name: 'created_by_full_name') required String? createdByFullName,
    @JsonKey(name: 'assignee_account_id') String? assigneeAccountId,
    @DateOnlyConverter() @JsonKey(name: 'start_on') DateTime? startOn,
    @DateOnlyConverter() @JsonKey(name: 'end_on') DateTime? endOn,
    @JsonKey(name: 'done_at') DateTime? doneAt,
    @JsonKey(name: 'done_by_account_id') String? doneByAccountId,
  }) = _WorkItemSubtask;

  factory WorkItemSubtask.fromJson(Map<String, Object?> json) =>
      _$WorkItemSubtaskFromJson(json);
}
