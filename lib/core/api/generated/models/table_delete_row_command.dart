// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_delete_row_command_kind.dart';

part 'table_delete_row_command.freezed.dart';
part 'table_delete_row_command.g.dart';

/// Satırı ve hücrelerini siler.
@Freezed()
abstract class TableDeleteRowCommand with _$TableDeleteRowCommand {
  const factory TableDeleteRowCommand({
    required TableDeleteRowCommandKind kind,

    /// Satır kimliği.
    required String id,
  }) = _TableDeleteRowCommand;

  factory TableDeleteRowCommand.fromJson(Map<String, Object?> json) =>
      _$TableDeleteRowCommandFromJson(json);
}
