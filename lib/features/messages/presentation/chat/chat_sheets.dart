import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';
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
/// tepki çubuğu, hızlı ızgara (Yanıtla, Kopyala, Sabitle, [canEdit] ise Düzenle), liste (anket
/// sonuçları ya da göreve dönüştür, [canDelete] ise Sil — `danger`). Gönderilemeyen kendi
/// mesajımda yalnız Tekrar gönder ([canRetry]), Kopyala ve Mesajı at. Seçim sonuç olarak döner.
Future<ChatAction?> showMessageActions(
  BuildContext context, {
  required ChatMessage message,
  required bool canEdit,
  required bool canDelete,
  bool canRetry = true,
}) {
  final l = context.l10n;
  final failed = message.state == ChatSendState.failed;
  final myReaction = message.reactions.where((r) => r.mine).firstOrNull?.kind;
  return NzBottomSheet.show<ChatAction>(
    context,
    title: l.uiMessagesMessageActions,
    showHeader: false,
    builder: (sheet) {
      final c = sheet.colors;
      final t = sheet.text;
      void done(ChatAction a) => Navigator.of(sheet).pop(a);
      Widget quick(IconData icon, String label, ChatSimpleAction a) => Expanded(
        child: Material(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: InkWell(
            onTap: () => done(ChatActSimple(a)),
            borderRadius: BorderRadius.circular(NizamioRadius.group),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
              child: Column(
                children: [
                  NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.text),
                  const Gap(6),
                  Text(label, textAlign: TextAlign.center, style: t.caption),
                ],
              ),
            ),
          ),
        ),
      );
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
        if (!failed && message.poll == null)
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
          Row(
            spacing: NizamioSpacing.space2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!failed)
                quick(NzIcons.reply, l.uiMessagesReply, ChatSimpleAction.reply),
              quick(NzIcons.copy, l.uiMessagesCopy, ChatSimpleAction.copy),
              if (!failed)
                quick(
                  NzIcons.pin,
                  message.pinned ? l.uiMessagesUnpin : l.uiMessagesPin,
                  ChatSimpleAction.pin,
                ),
              if (!failed && canEdit)
                quick(NzIcons.edit, l.uiMessagesEdit, ChatSimpleAction.edit),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.row),
            child: ColoredBox(
              color: c.surfaceRaised,
              child: Column(
                children: [
                  for (var i = 0; i < listRows.length; i++)
                    InkWell(
                      onTap: () => done(ChatActSimple(listRows[i].$3)),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          border: i > 0
                              ? Border(top: BorderSide(color: c.border))
                              : null,
                        ),
                        child: Row(
                          children: [
                            NzIcon(
                              listRows[i].$1,
                              size: NizamioSize.iconSizeSm,
                              color: listRows[i].$4,
                            ),
                            const Gap(NizamioSpacing.space3),
                            Expanded(
                              child: Text(
                                listRows[i].$2,
                                style: t.list.copyWith(
                                  color: listRows[i].$4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Sohbet bilgisi seçimi.
sealed class ChatInfoAction {
  const ChatInfoAction();
}

final class ChatInfoSearch extends ChatInfoAction {
  const ChatInfoSearch();
}

final class ChatInfoLeave extends ChatInfoAction {
  const ChatInfoLeave();
}

/// Sohbet bilgisi: büyük avatar, ad, alt satır; Ara ve (grupta) Gruptan çık. Paylaşılanlar ve
/// üye listesi sonraki pakette.
Future<ChatInfoAction?> showChatInfo(
  BuildContext context, {
  required ChatRoom room,
}) {
  final l = context.l10n;
  final chat = room.chat;
  return NzBottomSheet.show<ChatInfoAction>(
    context,
    title: '${chat.name} ${l.uiMessagesInfo}',
    showHeader: false,
    builder: (sheet) {
      final c = sheet.colors;
      final t = sheet.text;
      void done(ChatInfoAction a) => Navigator.of(sheet).pop(a);
      final sub = l.chatSubtitle(room, DateTime.now());
      Widget act(IconData icon, String label, Color color, ChatInfoAction a) =>
          Expanded(
            child: Material(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              child: InkWell(
                onTap: () => done(a),
                borderRadius: BorderRadius.circular(NizamioRadius.group),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      NzIcon(icon, size: NizamioSize.iconSizeSm, color: color),
                      const Gap(6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: t.caption.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space4,
        children: [
          Column(
            spacing: 6,
            children: [
              NzChatAvatar(
                initials: chatInitials(chat.name),
                group: chat.group,
                tone: chat.group ? 0 : personTone(chat.name),
                extent: 84,
              ),
              Text(chat.name, textAlign: TextAlign.center, style: t.titleSm),
              if (sub.isNotEmpty)
                Text(
                  sub,
                  textAlign: TextAlign.center,
                  style: t.caption.copyWith(color: c.textMuted),
                ),
            ],
          ),
          Row(
            spacing: NizamioSpacing.space2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              act(
                NzIcons.search,
                l.uiMessagesSearchChat,
                c.text,
                const ChatInfoSearch(),
              ),
              if (chat.group)
                act(
                  NzIcons.logout,
                  l.uiMessagesLeaveGroup,
                  c.danger,
                  const ChatInfoLeave(),
                ),
            ],
          ),
        ],
      );
    },
  );
}
