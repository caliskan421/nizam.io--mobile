// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_cell.dart';
import 'table_command.dart';
import 'table_set_cells_command_kind.dart';

part 'table_set_cells_command.freezed.dart';
part 'table_set_cells_command.g.dart';

/// 1–100 hücrelik atomik batch (TABLES-K05); aynı hücre iki kez verilemez. Tek bayat hücre 409 `tables.cell_conflict` ile tüm batch'i geri alır. Referans hedefi (kişi, departman, görev, dosya, tablo) yoksa ya da yazana görünmüyorsa batch'in tamamı 422 `tables.reference_unavailable` alır; iki durum ayırt edilmez, hata kimlik taşımaz (TABLES-K14). Hücrede `redacted: true` 422.
@Freezed()
abstract class TableSetCellsCommand with _$TableSetCellsCommand {
  const factory TableSetCellsCommand({
    required TableSetCellsCommandKind kind,
    required List<TableCell> cells,
  }) = _TableSetCellsCommand;

  factory TableSetCellsCommand.fromJson(Map<String, Object?> json) =>
      _$TableSetCellsCommandFromJson(json);
}
