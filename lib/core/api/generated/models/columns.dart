// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_column_type.dart';

part 'columns.freezed.dart';
part 'columns.g.dart';

@Freezed()
abstract class Columns with _$Columns {
  const factory Columns({
    required String name,
    required TableColumnType type,
    required bool multiple,
  }) = _Columns;

  factory Columns.fromJson(Map<String, Object?> json) =>
      _$ColumnsFromJson(json);
}
