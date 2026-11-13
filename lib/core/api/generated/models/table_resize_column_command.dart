// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_resize_column_command_kind.dart';

part 'table_resize_column_command.freezed.dart';
part 'table_resize_column_command.g.dart';

@Freezed()
abstract class TableResizeColumnCommand with _$TableResizeColumnCommand {
  const factory TableResizeColumnCommand({
    required TableResizeColumnCommandKind kind,

    /// Sütun kimliği.
    required String id,
    required int width,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = _TableResizeColumnCommand;

  factory TableResizeColumnCommand.fromJson(Map<String, Object?> json) =>
      _$TableResizeColumnCommandFromJson(json);
}
