// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_change.dart';

part 'table_changes.freezed.dart';
part 'table_changes.g.dart';

@Freezed()
abstract class TableChanges with _$TableChanges {
  const factory TableChanges({
    @JsonKey(name: 'table_id') required String tableId,
    required List<TableChange> changes,

    /// Son döndürülen olayın sırası; olay yoksa istekteki `after`. Sonraki istekte `after` olarak verilir.
    required int cursor,

    /// Okuma anındaki tablo işlem sırası (`Table.sequence` ile aynı anlam).
    required int sequence,

    /// `cursor < sequence`: aynı imleçle sonraki sayfa vardır.
    required bool more,
  }) = _TableChanges;

  factory TableChanges.fromJson(Map<String, Object?> json) =>
      _$TableChangesFromJson(json);
}
