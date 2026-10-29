// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_change_request.dart';

part 'date_change_request_list.freezed.dart';
part 'date_change_request_list.g.dart';

@Freezed()
abstract class DateChangeRequestList with _$DateChangeRequestList {
  const factory DateChangeRequestList({
    required List<DateChangeRequest> requests,
    required int total,
  }) = _DateChangeRequestList;

  factory DateChangeRequestList.fromJson(Map<String, Object?> json) =>
      _$DateChangeRequestListFromJson(json);
}
