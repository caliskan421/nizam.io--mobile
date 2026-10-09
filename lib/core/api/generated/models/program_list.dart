// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'program.dart';

part 'program_list.freezed.dart';
part 'program_list.g.dart';

@Freezed()
abstract class ProgramList with _$ProgramList {
  const factory ProgramList({required List<Program> programs}) = _ProgramList;

  factory ProgramList.fromJson(Map<String, Object?> json) =>
      _$ProgramListFromJson(json);
}
