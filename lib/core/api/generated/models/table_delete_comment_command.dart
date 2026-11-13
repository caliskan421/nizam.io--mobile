// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_delete_comment_command_kind.dart';

part 'table_delete_comment_command.freezed.dart';
part 'table_delete_comment_command.g.dart';

/// Yorumun yazarı (hâlâ editor ya da sahip) ya da tablo sahibi siler; fiziksel DELETE'tir (geri alma yok). Aynı anahtarın tekrarı yorum silinmiş olsa da ilk makbuzu döndürür.
@Freezed()
abstract class TableDeleteCommentCommand with _$TableDeleteCommentCommand {
  const factory TableDeleteCommentCommand({
    required TableDeleteCommentCommandKind kind,

    /// Yorum kimliği.
    required String id,
  }) = _TableDeleteCommentCommand;

  factory TableDeleteCommentCommand.fromJson(Map<String, Object?> json) =>
      _$TableDeleteCommentCommandFromJson(json);
}
