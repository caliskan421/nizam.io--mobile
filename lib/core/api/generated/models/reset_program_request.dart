// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_program_request.freezed.dart';
part 'reset_program_request.g.dart';

@Freezed(toStringOverride: false)
abstract class ResetProgramRequest with _$ResetProgramRequest {
  const factory ResetProgramRequest({required String password}) =
      _ResetProgramRequest;

  factory ResetProgramRequest.fromJson(Map<String, Object?> json) =>
      _$ResetProgramRequestFromJson(json);
}
