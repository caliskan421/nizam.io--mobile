// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_item.freezed.dart';
part 'agenda_item.g.dart';

@Freezed()
abstract class AgendaItem with _$AgendaItem {
  const factory AgendaItem({
    @JsonKey(name: 'agenda_item_id') required String agendaItemId,
    @JsonKey(name: 'meeting_id') required String meetingId,
    required String title,
    @JsonKey(name: 'sort_order') required int sortOrder,
    @JsonKey(name: 'is_checked') required bool isChecked,
    @JsonKey(name: 'checked_at') required DateTime? checkedAt,
    @JsonKey(name: 'checked_by_account_id') required String? checkedByAccountId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AgendaItem;

  factory AgendaItem.fromJson(Map<String, Object?> json) =>
      _$AgendaItemFromJson(json);
}
