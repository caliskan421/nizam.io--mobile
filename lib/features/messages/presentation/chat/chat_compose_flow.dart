import 'package:flutter/material.dart';

import '../../../../core/errors/api_error.dart';
import '../../../tasks/tasks.dart';
import '../../domain/chat.dart';
import '../../domain/chat_share_option.dart';
import 'chat_compose_attachment.dart';
import 'chat_compose_share.dart';
import 'chat_poll_sheets.dart';

final class ChatComposeSelection {
  const ChatComposeSelection({
    this.share,
    this.poll,
    this.file,
    this.attachment,
  });

  final ChatShareOption? share;
  final ChatPollInput? poll;
  final ChatUpload? file;
  final ChatAttachmentInput? attachment;
}

/// Seçimler ağ yazması yapmaz. Her bekleme sonrası aynı sohbet sahibinde kalınır.
Future<ChatComposeSelection?> chooseChatCompose(
  BuildContext context, {
  required bool group,
  required bool canShare,
  required bool pickerAvailable,
  required Future<UploadSource?> Function(UploadOrigin) pick,
  required VoidCallback onPickerMissing,
  required bool Function() isCurrent,
  required String caption,
  ChatMessage? reply,
}) async {
  final kind = await showAttachMenu(context, group: group, canShare: canShare);
  if (!context.mounted || !isCurrent() || kind == null) return null;
  switch (kind) {
    case ChatAttachKind.task ||
        ChatAttachKind.department ||
        ChatAttachKind.archive:
      final item = await showChatSharePicker(context, switch (kind) {
        ChatAttachKind.task => ChatRefKind.task,
        ChatAttachKind.department => ChatRefKind.department,
        _ => ChatRefKind.file,
      });
      return isCurrent() && item != null
          ? ChatComposeSelection(share: item)
          : null;
    case ChatAttachKind.poll:
      final poll = await showPollComposer(context);
      return isCurrent() && poll != null
          ? ChatComposeSelection(poll: poll)
          : null;
    case ChatAttachKind.photos || ChatAttachKind.files:
      if (!pickerAvailable) {
        onPickerMissing();
        return null;
      }
      final source = await pick(
        kind == ChatAttachKind.photos
            ? UploadOrigin.photos
            : UploadOrigin.files,
      );
      if (source == null || !context.mounted || !isCurrent()) return null;
      final type = source.contentType;
      if (type == null) throw ApiError('messaging.file_rejected');
      final file = ChatUpload(
        path: source.path,
        name: source.name,
        sizeBytes: source.sizeBytes,
        contentType: type,
      );
      final input = await showChatAttachmentPreview(
        context,
        file: file,
        caption: caption,
        reply: reply,
      );
      return isCurrent() && input != null
          ? ChatComposeSelection(file: file, attachment: input)
          : null;
  }
}
