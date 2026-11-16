import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/chat.dart';
import '../../domain/chat_send_failure.dart';
import 'messages_texts.dart';

/// Mesaj işlemleri sayfasının sonucu (sayfa kapandıktan sonra ekran uygular).
sealed class ChatAction {
  const ChatAction();
}

final class ChatActReact extends ChatAction {
  const ChatActReact(this.reaction);
  final ChatReaction reaction;
}

enum ChatSimpleAction {
  reply,
  copy,
  pin,
  edit,
  pollResults,
  closePoll,
  toTask,
  delete,
  retry,
  discard,
}

final class ChatActSimple extends ChatAction {
  const ChatActSimple(this.action);
  final ChatSimpleAction action;
}

/// Mesaja basılı tutunca açılan işlem sayfası (tasarım sistemi `components/ActionSheet`):
/// tepki çubuğu, hızlı ızgara (Yanıtla, Kopyala, [canPin] ise Sabitle, [canEdit] ise Düzenle),
/// liste (anket sonuçları ve [canClosePoll] ise anketi bitir; [canToTask] ise göreve dönüştür;
/// [canDelete] ise Sil — `danger`). Gönderilemeyen kendi mesajımda yalnız Tekrar gönder
/// (neden tekrarı anlamlıysa; `chatSendRetryable`), Kopyala ve Mesajı at. Seçim sonuç olarak döner.
Future<ChatAction?> showMessageActions(
  BuildContext context, {
  required ChatMessage message,
  required bool canEdit,
  required bool canDelete,
  bool canPin = false,
  bool canToTask = false,
  bool canClosePoll = false,
}) {
  final l = context.l10n;
  final failed = message.state == ChatSendState.failed;
  final canRetry = chatSendRetryable(message.failure);
  final myReaction = message.reactions.where((r) => r.mine).firstOrNull?.kind;
  return NzBottomSheet.show<ChatAction>(
    context,
    title: l.uiMessagesMessageActions,
    builder: (sheet) {
      final c = sheet.colors;
      void done(ChatAction a) => Navigator.of(sheet).pop(a);
      final listRows = <(IconData, String, ChatSimpleAction, Color)>[
        if (failed && canRetry)
          (
            NzIcons.reply,
            l.uiMessagesRetrySend,
            ChatSimpleAction.retry,
            c.accentText,
          ),
        if (failed)
          (
            NzIcons.delete,
            l.uiMessagesDiscardMessage,
            ChatSimpleAction.discard,
            c.danger,
          ),
        if (!failed && message.poll != null)
          (
            NzIcons.barChart,
            l.uiMessagesPollResults,
            ChatSimpleAction.pollResults,
            c.accentText,
          ),
        if (!failed && canClosePoll)
          (
            NzIcons.close,
            l.uiMessagesPollClose,
            ChatSimpleAction.closePoll,
            c.accentText,
          ),
        if (!failed && canToTask)
          (
            NzIcons.add,
            l.uiMessagesToTask,
            ChatSimpleAction.toTask,
            c.accentText,
          ),
        if (!failed && canDelete)
          (
            NzIcons.delete,
            l.uiMessagesDelete,
            ChatSimpleAction.delete,
            c.danger,
          ),
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.gapMd,
        children: [
          if (!failed)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                borderRadius: BorderRadius.circular(NizamioRadius.pill),
              ),
              child: Row(
                spacing: NizamioSpacing.space2,
                children: [
                  for (final r in ChatReaction.values)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: myReaction == r,
                        label: l.reaction(r),
                        excludeSemantics: true,
                        onTap: () => done(ChatActReact(r)),
                        child: Material(
                          color: myReaction == r
                              ? c.primary.withValues(alpha: 0.2)
                              : c.surfaceRaised,
                          shape: const StadiumBorder(),
                          child: InkWell(
                            customBorder: const StadiumBorder(),
                            onTap: () => done(ChatActReact(r)),
                            child: SizedBox(
                              height: NizamioSize.tap,
                              child: NzIcon(
                                nzReaction(r).icon(selected: myReaction == r),
                                size: 22,
                                color: myReaction == r ? c.accentText : c.text,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          NzMenuGroup(
            rows: [
              if (!failed)
                NzMenuRow(
                  icon: NzIcons.reply,
                  label: l.uiMessagesReply,
                  onTap: () =>
                      done(const ChatActSimple(ChatSimpleAction.reply)),
                ),
              NzMenuRow(
                icon: NzIcons.copy,
                label: l.uiMessagesCopy,
                onTap: () => done(const ChatActSimple(ChatSimpleAction.copy)),
              ),
              if (!failed && canPin)
                NzMenuRow(
                  icon: NzIcons.pin,
                  label: message.pinned ? l.uiMessagesUnpin : l.uiMessagesPin,
                  onTap: () => done(const ChatActSimple(ChatSimpleAction.pin)),
                ),
              if (!failed && canEdit)
                NzMenuRow(
                  icon: NzIcons.edit,
                  label: l.uiMessagesEdit,
                  onTap: () => done(const ChatActSimple(ChatSimpleAction.edit)),
                ),
              for (final row in listRows)
                NzMenuRow(
                  icon: row.$1,
                  label: row.$2,
                  danger: row.$4 == c.danger,
                  onTap: () => done(ChatActSimple(row.$3)),
                ),
            ],
          ),
        ],
      );
    },
  );
}
