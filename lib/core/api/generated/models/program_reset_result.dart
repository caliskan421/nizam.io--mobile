// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_reset_result.freezed.dart';
part 'program_reset_result.g.dart';

@Freezed()
abstract class ProgramResetResult with _$ProgramResetResult {
  const factory ProgramResetResult({
    @JsonKey(name: 'program_id') required String programId,
    required int tasks,
    required int files,
    required int messages,
    required int meetings,
  }) = _ProgramResetResult;

  factory ProgramResetResult.fromJson(Map<String, Object?> json) =>
      _$ProgramResetResultFromJson(json);
}
