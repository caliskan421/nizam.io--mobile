// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_cell.freezed.dart';
part 'table_cell.g.dart';

@Freezed()
abstract class TableCell with _$TableCell {
  const factory TableCell({
    @JsonKey(name: 'row_id') required String rowId,
    @JsonKey(name: 'column_id') required String columnId,

    /// Sütun tipine göre tipli JSON değeri; `null` boş hücredir (TABLES-K06). Referans tipleri tekli sütunda kimlik string'i, çoklu sütunda 1–50 benzersiz, boş olmayan kimlik dizisidir (TABLES-K14): istekte boş dizi, `null`/boş/yinelenen öğe 422 `tables.input_invalid`; okuma yanıtında okuyana görünmeyen öğe AYNI konumda `null` olur (hücre `redacted: true`) — yanıt dizisi bu yüzden istek olarak geri gönderilemez. text/phone/email/date string (date `YYYY-MM-DD`, email tek adres, phone en çok 40 bayt, metin en çok 10000 bayt), number JSON ondalık (en çok 1000 karakter, mutlak üs en çok 1000), checkbox boolean. Hücre başına JSON en çok 16 KiB. Bozuk UTF-8 ya da eşlenmemiş UTF-16 vekil kaçışı (`"\uD800"`) taşıyan gövde 422 `tables.input_invalid` alır (adlar dahil).
    @JsonKey(includeIfNull: true) required dynamic value,

    /// Hücre sürümü. Okumada hiç yazılmamış hücre yanıtta yoktur; yazımda 0 ilk yazımdır, sonraki yazım mevcut pozitif sürümü ister (TABLES-K03); eksik ya da `null` sürüm 0 sayılmaz, 422 `tables.input_invalid`. Okumada erişimi kaybolmuş tablo referansı `null` döner (TABLES-K07).
    required int version,

    /// Yalnız okuma yanıtında ve yalnız `true` olarak bulunur: hücredeki referansın tamamı (tekli) ya da bazı öğeleri (çoklu, aynı konumda `null`) okuyana görünmediği için gizlendi; saklanan değer ve sürüm değişmedi (TABLES-K14). İstekte `true` 422 `tables.input_invalid`: kısmi redakte okuma körlemesine geri yazılamaz; gizli öğeyi bırakmak ancak açık tam değiştirmeyle olur.
    bool? redacted,
  }) = _TableCell;

  factory TableCell.fromJson(Map<String, Object?> json) =>
      _$TableCellFromJson(json);
}
