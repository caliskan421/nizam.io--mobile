// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_row.freezed.dart';
part 'table_row.g.dart';

@Freezed()
abstract class TableRow with _$TableRow {
  const factory TableRow({required String id, required int position}) =
      _TableRow;

  factory TableRow.fromJson(Map<String, Object?> json) =>
      _$TableRowFromJson(json);
}
