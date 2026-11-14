// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_skipped_cell_reason.dart';

part 'table_skipped_cell.freezed.dart';
part 'table_skipped_cell.g.dart';

/// Geri alınamayan hücre; değer, önceki değer ya da referans kimliği taşımaz.
@Freezed()
abstract class TableSkippedCell with _$TableSkippedCell {
  const factory TableSkippedCell({
    @JsonKey(name: 'row_id') required String rowId,
    @JsonKey(name: 'column_id') required String columnId,
    required TableSkippedCellReason reason,
  }) = _TableSkippedCell;

  factory TableSkippedCell.fromJson(Map<String, Object?> json) =>
      _$TableSkippedCellFromJson(json);
}
