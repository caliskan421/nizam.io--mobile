// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table.dart';
import 'table_attachment_meta.dart';
import 'table_cell.dart';
import 'table_column.dart';
import 'table_row.dart';

part 'table_snapshot.freezed.dart';
part 'table_snapshot.g.dart';

@Freezed()
abstract class TableSnapshot with _$TableSnapshot {
  const factory TableSnapshot({
    required Table table,
    required List<TableColumn> columns,

    /// Satır konumuna göre sıralı sayfa.
    required List<TableRow> rows,

    /// Sayfadaki satırların yazılmış hücreleri.
    required List<TableCell> cells,

    /// Sonraki satır sayfası; son sayfada yoktur.
    @JsonKey(name: 'next_cursor') String? nextCursor,

    /// Sayfadaki referansların okuyana GÖRÜNEN hedeflerinin görünen adları (TABLES-K14): anahtar tür (`people`, `departments`, `tasks`, `files`, `tables`), değer kimlik → ad. Görünmeyen hedefin adı hiç yer almaz; önizleme, rol ya da açıklama taşınmaz. Kişi adı identity'deki görünen ad, departman adı programdaki ad, görev başlığı, dosya görünen adı, tablo adıdır. Hiç görünür referans yoksa alan yoktur. Adlar 8 MiB okuma bütçesine dahildir.
    Map<String, Map<String, String>>? references,

    /// Sayfadaki `attachment` hücrelerine bağlı AKTİF eklerin bilgisi (TABLES-K15): anahtar ek kimliği (hücre değeri). Depolama anahtarı ve yükleyen yoktur; emekli ek yer almaz. Hiç ek yoksa alan yoktur. Kodlanmış boyutu `references` ve hücrelerle AYNI 8 MiB okuma bütçesine dahildir.
    Map<String, TableAttachmentMeta>? attachments,
  }) = _TableSnapshot;

  factory TableSnapshot.fromJson(Map<String, Object?> json) =>
      _$TableSnapshotFromJson(json);
}
