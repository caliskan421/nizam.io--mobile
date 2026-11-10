// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../date_only.dart';

part 'date_change_request_create.freezed.dart';
part 'date_change_request_create.g.dart';

@Freezed()
abstract class DateChangeRequestCreate with _$DateChangeRequestCreate {
  const factory DateChangeRequestCreate({
    @JsonKey(name: 'work_item_id') required String workItemId,
    @DateOnlyConverter()
    @JsonKey(name: 'new_start_on')
    required DateTime newStartOn,
    @DateOnlyConverter()
    @JsonKey(name: 'new_end_on')
    required DateTime newEndOn,
    String? reason,

    /// İsteğe bağlı: istemcinin gördüğü tarih sürümü (`dates_revision`; WORK-K89). Verilirse görev kilidi altında okunan güncel sürümle karşılaştırılır; farklıysa 409 `work.edit_conflict` (`fields[0].field = expected_dates_revision`), talep açılmaz. Pozitif değilse 422 `work.input_invalid` (alan kodu `work.revision_invalid`).
    @JsonKey(name: 'expected_dates_revision') int? expectedDatesRevision,
  }) = _DateChangeRequestCreate;

  factory DateChangeRequestCreate.fromJson(Map<String, Object?> json) =>
      _$DateChangeRequestCreateFromJson(json);
}
