// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_column_type.dart';
import 'table_command.dart';
import 'table_convert_column_command_kind.dart';

part 'table_convert_column_command.freezed.dart';
part 'table_convert_column_command.g.dart';

/// Editor ya da sahip; sütun tipini kayıpsız dönüştürür (TABLES-K20). Her tip metne, metin tekli hedeflere (sayı, telefon, e-posta, tarih, onay kutusu, beş tekli referans) dönüşür; aynı tip ve diğer çiftler 422 (metinden ek ya da çoklu referansa yok). Sayı → metin tam ondalık kanonik metin; referans/ek → metin yalnız görünen ad (çoklu hücrede adların JSON dizisi metni), çokluluk kapanır. null null kalır; boş metin hedef kabul ediyorsa (telefon, e-posta) kalır. Tek kayıplı hücre (geçersiz biçim, görünmeyen ya da olmayan hedef, sınır aşımı) bütün dönüşümü geri alır: 409 `tables.conversion_lossy`, zarfın `fields` öğesinde yalnız kayıplı hücre sayısı. Başarıda sütundaki BÜTÜN saklı hücrelerin sürümü artar (`converted`), şema sürümü artar; ek sütunundan dönüşümde aktif ekler emekli olur (nesneler korunur).
@Freezed()
abstract class TableConvertColumnCommand with _$TableConvertColumnCommand {
  const factory TableConvertColumnCommand({
    required TableConvertColumnCommandKind kind,
    required String id,
    required TableColumnType type,
    @JsonKey(name: 'expected_schema') required int expectedSchema,
  }) = _TableConvertColumnCommand;

  factory TableConvertColumnCommand.fromJson(Map<String, Object?> json) =>
      _$TableConvertColumnCommandFromJson(json);
}
