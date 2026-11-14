// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_change_kind.dart';

part 'table_change.freezed.dart';
part 'table_change.g.dart';

/// Kalıcı tablo olayının dış metadata'sı (ADR-0039). Değer, önceki değer, aktör, zaman, paylaşım hedefi, referans ya da ek kimliği/adı taşımaz; içerik güncel snapshot'tan okunur.
@Freezed()
abstract class TableChange with _$TableChange {
  const factory TableChange({
    @JsonKey(name: 'table_id') required String tableId,

    /// Olayın tablo işlem sırası; tablo içinde artan ve boşluksuz.
    required int seq,
    required TableChangeKind kind,
  }) = _TableChange;

  factory TableChange.fromJson(Map<String, Object?> json) =>
      _$TableChangeFromJson(json);
}
