// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_column_type.dart';

part 'table_column.freezed.dart';
part 'table_column.g.dart';

@Freezed()
abstract class TableColumn with _$TableColumn {
  const factory TableColumn({
    /// Çoklu referans sütunu (TABLES-K14): hücre değeri 1–50 benzersiz kimlik dizisidir. Yalnız referans tiplerinde true olabilir; oluşturulduktan sonra değişmez.
    required bool multiple,
    required String id,
    required String name,
    required TableColumnType type,

    /// Piksel genişliği.
    required int width,
    required int position,
  }) = _TableColumn;

  factory TableColumn.fromJson(Map<String, Object?> json) =>
      _$TableColumnFromJson(json);
}
