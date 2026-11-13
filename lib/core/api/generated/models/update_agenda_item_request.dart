// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_agenda_item_request.freezed.dart';
part 'update_agenda_item_request.g.dart';

@Freezed()
abstract class UpdateAgendaItemRequest with _$UpdateAgendaItemRequest {
  const factory UpdateAgendaItemRequest({
    /// Verilirse eklemedeki kuralla aynı: düz metne indirilip kırpıldıktan sonra 1–300 karakter (Unicode kod noktası).
    String? title,
    @JsonKey(name: 'is_checked') bool? isChecked,
  }) = _UpdateAgendaItemRequest;

  factory UpdateAgendaItemRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateAgendaItemRequestFromJson(json);
}
