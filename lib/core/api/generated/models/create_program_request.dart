// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_program_request.freezed.dart';
part 'create_program_request.g.dart';

@Freezed()
abstract class CreateProgramRequest with _$CreateProgramRequest {
  const factory CreateProgramRequest({
    required String name,
    int? year,
    String? description,
  }) = _CreateProgramRequest;

  factory CreateProgramRequest.fromJson(Map<String, Object?> json) =>
      _$CreateProgramRequestFromJson(json);
}
