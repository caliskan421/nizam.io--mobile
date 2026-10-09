// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_program_request.freezed.dart';
part 'update_program_request.g.dart';

@Freezed()
abstract class UpdateProgramRequest with _$UpdateProgramRequest {
  const factory UpdateProgramRequest({
    String? name,
    int? year,
    String? description,
  }) = _UpdateProgramRequest;

  factory UpdateProgramRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateProgramRequestFromJson(json);
}
