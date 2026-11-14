// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_add_comment_command_kind.dart';
import 'table_command.dart';

part 'table_add_comment_command.freezed.dart';
part 'table_add_comment_command.g.dart';

/// Editor ya da sahip (viewer yazamaz; yönetici/koordinatör bypass'ı yok). Yorum kimliği sunucuda üretilir ve sonuçta `id` olarak döner; `id` gönderilirse 422. `row_id` zorunlu, `column_id` isteğe bağlıdır; var olmayan satır/sütun 404. `body` 1–4000 Unicode karakter, hücre metniyle aynı kontrol karakteri kuralı (sekme/satır sonu serbest). Satır başına en çok 500 yorum (aşımda 409 `tables.limit_reached`). İşlem sırası artar (yorumun değişmez `seq`'i budur) ve `add_comment` olayı yazılır; olay/makbuz yorum metni taşımaz (ADR-0040).
@Freezed()
abstract class TableAddCommentCommand with _$TableAddCommentCommand {
  const factory TableAddCommentCommand({
    required TableAddCommentCommandKind kind,
    @JsonKey(name: 'row_id') required String rowId,
    required String body,
    @JsonKey(name: 'column_id') String? columnId,
  }) = _TableAddCommentCommand;

  factory TableAddCommentCommand.fromJson(Map<String, Object?> json) =>
      _$TableAddCommentCommandFromJson(json);
}
