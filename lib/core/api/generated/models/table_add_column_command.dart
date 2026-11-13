// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_add_column_command_kind.dart';
import 'table_column_type.dart';
import 'table_command.dart';

part 'table_add_column_command.freezed.dart';
part 'table_add_column_command.g.dart';

/// Yeni sütun kimliği sunucuda üretilir ve sonuçta `id` olarak döner; `id` gönderilirse 422. Tablo başına en çok 100 sütun (aşımda 409 `tables.limit_reached`).
@Freezed()
abstract class TableAddColumnCommand with _$TableAddColumnCommand {
  const factory TableAddColumnCommand({
    required TableAddColumnCommandKind kind,
    required String name,
    required TableColumnType type,
    required int width,
    @JsonKey(name: 'expected_schema') required int expectedSchema,

    /// Çoklu referans sütunu (TABLES-K14); yalnız `*_reference` tiplerinde true olabilir, aksi 422.
    @Default(false) bool multiple,
  }) = _TableAddColumnCommand;

  factory TableAddColumnCommand.fromJson(Map<String, Object?> json) =>
      _$TableAddColumnCommandFromJson(json);
}
