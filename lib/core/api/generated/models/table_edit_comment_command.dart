// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_edit_comment_command_kind.dart';

part 'table_edit_comment_command.freezed.dart';
part 'table_edit_comment_command.g.dart';

/// Yalnız yorumun yazarı ve hâlâ editor ya da sahip olan hesap; tablo sahibi başkasının yorumunu DÜZENLEYEMEZ (403 `tables.forbidden`). Olmayan yorum 404. `seq` değişmez; `edited_at` güncellenir.
@Freezed()
abstract class TableEditCommentCommand with _$TableEditCommentCommand {
  const factory TableEditCommentCommand({
    required TableEditCommentCommandKind kind,

    /// Yorum kimliği.
    required String id,
    required String body,
  }) = _TableEditCommentCommand;

  factory TableEditCommentCommand.fromJson(Map<String, Object?> json) =>
      _$TableEditCommentCommandFromJson(json);
}
