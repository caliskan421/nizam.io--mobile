// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_cell_value.dart';

part 'table_cell.freezed.dart';
part 'table_cell.g.dart';

@Freezed()
abstract class TableCell with _$TableCell {
  const factory TableCell({
    @JsonKey(name: 'row_id') required String rowId,
    @JsonKey(name: 'column_id') required String columnId,
    required TableCellValue? value,

    /// Hücre sürümü. Okumada hiç yazılmamış hücre yanıtta yoktur; yazımda 0 ilk yazımdır, sonraki yazım mevcut pozitif sürümü ister (TABLES-K03); eksik ya da `null` sürüm 0 sayılmaz, 422 `tables.input_invalid`. Okumada erişimi kaybolmuş tablo referansı `null` döner (TABLES-K07).
    required int version,

    /// Yalnız okuma yanıtında ve yalnız `true` olarak bulunur: hücredeki referansın tamamı (tekli) ya da bazı öğeleri (çoklu, aynı konumda `null`) okuyana görünmediği için gizlendi; saklanan değer ve sürüm değişmedi (TABLES-K14). İstekte `true` 422 `tables.input_invalid`: kısmi redakte okuma körlemesine geri yazılamaz; gizli öğeyi bırakmak ancak açık tam değiştirmeyle olur.
    bool? redacted,
  }) = _TableCell;

  factory TableCell.fromJson(Map<String, Object?> json) =>
      _$TableCellFromJson(json);
}
