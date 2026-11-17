// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_comment_author.freezed.dart';
part 'table_comment_author.g.dart';

/// Yazar okuyana görünmüyorsa `null` (kimlik/e-posta yok).
@Freezed()
abstract class TableCommentAuthor with _$TableCommentAuthor {
  const factory TableCommentAuthor({required String id, required String name}) =
      _TableCommentAuthor;

  factory TableCommentAuthor.fromJson(Map<String, Object?> json) =>
      _$TableCommentAuthorFromJson(json);
}
