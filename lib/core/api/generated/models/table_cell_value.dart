// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_cell_value.freezed.dart';
part 'table_cell_value.g.dart';

/// Sütun tipine göre tipli JSON değeri; `null` boş hücredir (TABLES-K06). Referans tipleri tekli sütunda kimlik string'i, çoklu sütunda 1–50 benzersiz, boş olmayan kimlik dizisidir (TABLES-K14): istekte boş dizi, `null`/boş/yinelenen öğe 422 `tables.input_invalid`; okuma yanıtında okuyana görünmeyen öğe AYNI konumda `null` olur (hücre `redacted: true`) — yanıt dizisi bu yüzden istek olarak geri gönderilemez. text/phone/email/date string (date `YYYY-MM-DD`, email tek adres, phone en çok 40 bayt, metin en çok 10000 bayt), number JSON ondalık (en çok 1000 karakter, mutlak üs en çok 1000), checkbox boolean. Hücre başına JSON en çok 16 KiB. Bozuk UTF-8 ya da eşlenmemiş UTF-16 vekil kaçışı (`"\uD800"`) taşıyan gövde 422 `tables.input_invalid` alır (adlar dahil).
@Freezed()
abstract class TableCellValue with _$TableCellValue {
  const factory TableCellValue() = _TableCellValue;

  factory TableCellValue.fromJson(Map<String, Object?> json) =>
      _$TableCellValueFromJson(json);
}
