// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_work_item_request_priority.dart';

part 'create_work_item_request.freezed.dart';
part 'create_work_item_request.g.dart';

@Freezed()
abstract class CreateWorkItemRequest with _$CreateWorkItemRequest {
  const factory CreateWorkItemRequest({
    required String title,

    /// Şirket yöneticisi dışındaki çağıranda en çok 40 gün geçmişte olabilir (aksi 422 `work.input_invalid`).
    @JsonKey(name: 'start_on') required DateTime startOn,
    @JsonKey(name: 'end_on') required DateTime endOn,
    String? description,

    /// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
    CreateWorkItemRequestPriority? priority,

    /// Boşsa atamasız açılır.
    @JsonKey(name: 'assignee_account_id') String? assigneeAccountId,
  }) = _CreateWorkItemRequest;

  factory CreateWorkItemRequest.fromJson(Map<String, Object?> json) =>
      _$CreateWorkItemRequestFromJson(json);
}
