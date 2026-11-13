// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_move_row_command_kind.dart';

part 'table_move_row_command.freezed.dart';
part 'table_move_row_command.g.dart';

/// Editor ya da sahip; satırı `after_id` satırının hemen ardına taşır, `after_id` verilmez ya da boşsa başa (TABLES-K19). Kendisinin ardına 422, olmayan satır 404. İşlem sırası artar; sıra imleçlerini bayatlatır.
@Freezed()
abstract class TableMoveRowCommand with _$TableMoveRowCommand {
  const factory TableMoveRowCommand({
    required TableMoveRowCommandKind kind,
    required String id,
    @JsonKey(name: 'after_id') String? afterId,
  }) = _TableMoveRowCommand;

  factory TableMoveRowCommand.fromJson(Map<String, Object?> json) =>
      _$TableMoveRowCommandFromJson(json);
}
