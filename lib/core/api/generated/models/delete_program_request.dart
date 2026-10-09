// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_program_request.freezed.dart';
part 'delete_program_request.g.dart';

@Freezed()
abstract class DeleteProgramRequest with _$DeleteProgramRequest {
  const factory DeleteProgramRequest({required String password}) =
      _DeleteProgramRequest;

  factory DeleteProgramRequest.fromJson(Map<String, Object?> json) =>
      _$DeleteProgramRequestFromJson(json);
}
