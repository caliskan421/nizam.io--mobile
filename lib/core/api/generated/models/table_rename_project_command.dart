// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_project_command.dart';
import 'table_rename_project_command_kind.dart';

part 'table_rename_project_command.freezed.dart';
part 'table_rename_project_command.g.dart';

@Freezed()
abstract class TableRenameProjectCommand with _$TableRenameProjectCommand {
  const factory TableRenameProjectCommand({
    required TableRenameProjectCommandKind kind,
    required String id,
    required String name,
  }) = _TableRenameProjectCommand;

  factory TableRenameProjectCommand.fromJson(Map<String, Object?> json) =>
      _$TableRenameProjectCommandFromJson(json);
}
