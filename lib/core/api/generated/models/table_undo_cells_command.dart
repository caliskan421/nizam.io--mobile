// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_undo_cells_command_kind.dart';

part 'table_undo_cells_command.freezed.dart';
part 'table_undo_cells_command.g.dart';

/// Koşullu hücre geri alma (ADR-0040, TABLES-K27). Editor ya da sahip (viewer 403); yalnız çağıranın KENDİ `set_cells` olayı geri alınır. `sequence` olayın tablo işlem sırasıdır (`changes` `seq`'i ya da `set_cells` yanıtının `sequence`'i). Kaynak güncel sıradan en çok 1000 olay geride olabilir (sınır dahil; yaş sınırı yok, replay ufkundan bağımsız). Gelecek sıra, olay tabanı ve altı, ufuk dışı, kalıcı olarak eksik olay, başkasının olayı ya da `set_cells` olmayan olay 409 `tables.undo_expired` alır; neden `fields[0].message`'dadır (`future`, `baseline`, `window`, `missing`, `ineligible`; başkasının olayı ile başka tür ayırt edilmez). Hücre başına: güncel sürüm olayın yazdığı sürüme eşitse önceki saklı değer YENİ sürümle yazılır (ilk yazım null'a döner, hücre silinmez, sürüm geri gitmez); araya yazım ya da dönüşüm `changed`, silinmiş satır/sütun `gone`, güncel tip/ referans görünürlüğü/ek kuralına uymayan ya da sürümü tavandaki hücre `unavailable` olarak atlanır (görünmez referans ve emekli/ silinmiş ek diriltilmez; çoklu hücrede tek görünmez öğe bütün hücreyi atlatır). Hiçbir hücre uygun değilse 409 `tables.undo_conflict` ve hiçbir şey yazılmaz. Başarı tek yeni işlem sırası ve tek `undo_cells` olayıdır. Aynı anahtarın tekrarı ilk sonucu (atlananlar dahil) döndürür. `cells` ve `id` gönderilirse 422; `sequence` başka komutta 422.
@Freezed()
abstract class TableUndoCellsCommand with _$TableUndoCellsCommand {
  const factory TableUndoCellsCommand({
    required TableUndoCellsCommandKind kind,
    required int sequence,
  }) = _TableUndoCellsCommand;

  factory TableUndoCellsCommand.fromJson(Map<String, Object?> json) =>
      _$TableUndoCellsCommandFromJson(json);
}
