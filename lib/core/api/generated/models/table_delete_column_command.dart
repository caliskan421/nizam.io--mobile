// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_delete_column_command_kind.dart';

part 'table_delete_column_command.freezed.dart';
part 'table_delete_column_command.g.dart';

@Freezed()
abstract class TableDeleteColumnCommand with _$TableDeleteColumnCommand {
  const factory TableDeleteColumnCommand({
    required TableDeleteColumnCommandKind kind,

    /// Sütun kimliği.
    required String id,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = _TableDeleteColumnCommand;

  factory TableDeleteColumnCommand.fromJson(Map<String, Object?> json) =>
      _$TableDeleteColumnCommandFromJson(json);
}
