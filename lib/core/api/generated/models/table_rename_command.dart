// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_rename_command_kind.dart';

part 'table_rename_command.freezed.dart';
part 'table_rename_command.g.dart';

@Freezed()
abstract class TableRenameCommand with _$TableRenameCommand {
  const factory TableRenameCommand({
    required TableRenameCommandKind kind,
    required String name,
  }) = _TableRenameCommand;

  factory TableRenameCommand.fromJson(Map<String, Object?> json) =>
      _$TableRenameCommandFromJson(json);
}
