// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_add_row_command_kind.dart';
import 'table_command.dart';

part 'table_add_row_command.freezed.dart';
part 'table_add_row_command.g.dart';

/// Yeni satır kimliği sunucuda üretilir ve sonuçta `id` olarak döner; `id` gönderilirse 422. Tablo başına en çok 100000 satır (aşımda 409 `tables.limit_reached`).
@Freezed()
abstract class TableAddRowCommand with _$TableAddRowCommand {
  const factory TableAddRowCommand({required TableAddRowCommandKind kind}) =
      _TableAddRowCommand;

  factory TableAddRowCommand.fromJson(Map<String, Object?> json) =>
      _$TableAddRowCommandFromJson(json);
}
