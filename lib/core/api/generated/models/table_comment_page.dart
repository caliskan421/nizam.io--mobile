// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_comment.dart';

part 'table_comment_page.freezed.dart';
part 'table_comment_page.g.dart';

@Freezed()
abstract class TableCommentPage with _$TableCommentPage {
  const factory TableCommentPage({
    required List<TableComment> items,

    /// Yalnız sonraki sayfa varsa; son öğenin `seq`'i.
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _TableCommentPage;

  factory TableCommentPage.fromJson(Map<String, Object?> json) =>
      _$TableCommentPageFromJson(json);
}
