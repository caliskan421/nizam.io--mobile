// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'role.dart';

part 'teams.freezed.dart';
part 'teams.g.dart';

@Freezed()
abstract class Teams with _$Teams {
  const factory Teams({
    @JsonKey(name: 'department_id') required String departmentId,
    @JsonKey(name: 'department_name') required String departmentName,
    required Role role,
  }) = _Teams;

  factory Teams.fromJson(Map<String, Object?> json) => _$TeamsFromJson(json);
}
