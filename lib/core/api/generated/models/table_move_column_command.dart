// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_move_column_command_kind.dart';

part 'table_move_column_command.freezed.dart';
part 'table_move_column_command.g.dart';

/// Editor ya da sahip; sütunu `after_id` sütununun ardına (boşsa başa) taşır; şema sürümü artar (TABLES-K19).
@Freezed()
abstract class TableMoveColumnCommand with _$TableMoveColumnCommand {
  const factory TableMoveColumnCommand({
    required TableMoveColumnCommandKind kind,
    required String id,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
    @JsonKey(name: 'after_id') String? afterId,
  }) = _TableMoveColumnCommand;

  factory TableMoveColumnCommand.fromJson(Map<String, Object?> json) =>
      _$TableMoveColumnCommandFromJson(json);
}
