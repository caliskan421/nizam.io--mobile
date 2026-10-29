// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_item_request.freezed.dart';
part 'agenda_item_request.g.dart';

@Freezed()
abstract class AgendaItemRequest with _$AgendaItemRequest {
  const factory AgendaItemRequest({required String title}) = _AgendaItemRequest;

  factory AgendaItemRequest.fromJson(Map<String, Object?> json) =>
      _$AgendaItemRequestFromJson(json);
}
