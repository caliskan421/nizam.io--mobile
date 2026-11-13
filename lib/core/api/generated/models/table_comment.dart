// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'table_comment.freezed.dart';
part 'table_comment.g.dart';

/// Tek yorum (ADR-0040). İçerik yalnız bu yanıttadır.
@Freezed()
abstract class TableComment with _$TableComment {
  const factory TableComment({
    required String id,
    @JsonKey(name: 'row_id') required String rowId,

    /// Yalnız satıra bağlı yorumda `null`.
    @JsonKey(name: 'column_id') required String? columnId,

    /// Yazar okuyana görünmüyorsa `null` (kimlik/e-posta yok).
    required Author? author,

    /// Yorum okuyanındır (yazar görünmese de doludur).
    required bool mine,
    required String body,

    /// Yorumu oluşturan komutun tablo işlem sırası; değişmez, imleç anahtarıdır.
    required int seq,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'edited_at') required DateTime? editedAt,
  }) = _TableComment;

  factory TableComment.fromJson(Map<String, Object?> json) =>
      _$TableCommentFromJson(json);
}
