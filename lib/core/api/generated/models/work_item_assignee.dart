// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item_assignee.freezed.dart';
part 'work_item_assignee.g.dart';

@Freezed()
abstract class WorkItemAssignee with _$WorkItemAssignee {
  const factory WorkItemAssignee({
    @JsonKey(name: 'account_id') required String accountId,

    /// Görünen ad. Hesabın satırı yoksa `null` (boş dize değil); ad okuması o an başarısızsa da geçici olarak `null` (yanıt yine başarılıdır). İstemci nötr etiket gösterir. Silinmiş (geri yüklenebilir) hesabın adı döner.
    @JsonKey(name: 'full_name') required String? fullName,
  }) = _WorkItemAssignee;

  factory WorkItemAssignee.fromJson(Map<String, Object?> json) =>
      _$WorkItemAssigneeFromJson(json);
}
