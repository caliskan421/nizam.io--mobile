// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_change_request_create.freezed.dart';
part 'date_change_request_create.g.dart';

@Freezed()
abstract class DateChangeRequestCreate with _$DateChangeRequestCreate {
  const factory DateChangeRequestCreate({
    @JsonKey(name: 'work_item_id') required String workItemId,
    @JsonKey(name: 'new_start_on') required DateTime newStartOn,
    @JsonKey(name: 'new_end_on') required DateTime newEndOn,
    String? reason,
  }) = _DateChangeRequestCreate;

  factory DateChangeRequestCreate.fromJson(Map<String, Object?> json) =>
      _$DateChangeRequestCreateFromJson(json);
}
