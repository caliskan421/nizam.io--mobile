import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../domain/chat.dart';
import 'chat_compose_lifetime.dart';
import 'messages_texts.dart';

typedef ChatAttachmentInput = ({String caption, String? replyTo});

/// Hiçbir ağ yazması yapmaz; yalnız açıkça gönderilen değişmez önizleme döner.
Future<ChatAttachmentInput?> showChatAttachmentPreview(
  BuildContext context, {
  required ChatUpload file,
  required String caption,
  ChatMessage? reply,
}) async {
  final text = TextEditingController(text: caption);
  final replyTo = ValueNotifier<String?>(reply?.id);
  return NzBottomSheet.show<ChatAttachmentInput>(
    context,
    title: context.l10n.uiMessagesComposeAttachmentPreview,
    builder: (sheet) => ChatComposeLifetime(
      onDispose: () {
        text.dispose();
        replyTo.dispose();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space3,
        children: [
          NzListTile(title: file.name),
          if (reply != null)
            ValueListenableBuilder<String?>(
              valueListenable: replyTo,
              builder: (_, value, _) => value == null
                  ? const SizedBox.shrink()
                  : NzComposerContext(
                      icon: NzIcons.reply,
                      title: sheet.l10n.uiMessagesReply,
                      text: sheet.l10n.summaryOf(reply),
                      cancelLabel: sheet.l10n.uiMessagesCancel,
                      onCancel: () => replyTo.value = null,
                    ),
            ),
          NzTextField.multiline(
            label: sheet.l10n.uiMessagesComposeCaption,
            controller: text,
          ),
        ],
      ),
    ),
    actions: (sheet) => nzSheetActions(
      sheet,
      cancel: sheet.l10n.uiMessagesCancel,
      ok: sheet.l10n.uiMessagesSend,
      onOk: () =>
          Navigator.of(sheet)
              .pop((caption: text.text.trim(), replyTo: replyTo.value)),
    ),
  );
}
