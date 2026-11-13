// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_cell.dart';
import 'table_result_status.dart';
import 'table_skipped_cell.dart';

part 'table_result.freezed.dart';
part 'table_result.g.dart';

/// İşlem makbuzu. Hücre içeriği taşımaz (TABLES-K07).
@Freezed()
abstract class TableResult with _$TableResult {
  const factory TableResult({
    @JsonKey(name: 'table_id') required String tableId,
    required int sequence,
    @JsonKey(name: 'schema_version') required int schemaVersion,

    /// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı, alanlar ilk sonucun makbuzudur (audit yazılmaz).
    required bool replayed,

    /// Oluşturmada yeni tablo, `add_column`/`add_row`'da yeni sütun/satır kimliği; diğer komutlarda istekteki `id`.
    String? id,

    /// Yalnız `set_cells` ve `undo_cells`; her yazılan hücrenin yeni sürümü, `value` her zaman `null`.
    List<TableCell>? cells,

    /// Yalnız `undo_cells`; geri alınamayan hücreler kaynak olay sırasıyla (yoksa alan yok).
    List<TableSkippedCell>? skipped,

    /// Yalnız `move_table`; temizlenen açık paylaşım sayısı (sıfırsa yok).
    @JsonKey(name: 'cleared_grants') int? clearedGrants,

    /// Yalnız öneri komutları; `id` öneri kimliğidir.
    TableResultStatus? status,

    /// Yalnız `convert_column`; sürümü artan saklı hücre sayısı (sıfırsa yok).
    int? converted,
  }) = _TableResult;

  factory TableResult.fromJson(Map<String, Object?> json) =>
      _$TableResultFromJson(json);
}
