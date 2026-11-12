import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/turkish_collation.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_surfaces.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/chat_controller.dart';
import '../../application/chat_group_sources.dart';
import '../../application/chat_members_controller.dart';
import '../../application/messages_providers.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';
import '../../domain/chat_share_option.dart';
import 'messages_texts.dart';

/// Yazma alanı: taslağı ve yazma durumunu kendisi dinler; tuş vuruşu ve klavye kalkışı (her kare
/// değişen `viewInsets`) yalnız bu alt ağacı yeniden kurar. Gönderim kapalıysa (karşı taraf
/// programda değil, sohbete erişim yok) yazma alanı yerine açıklama görünür. Grupta metnin son
/// `@sorgu` parçası için üye listesinden bahsetme önerisi (yönetici/kurucuya `@herkes`; §10.8);
/// seçim [onMention] ile yapılandırılmış bahsetme olarak ekrana bildirilir.
class ChatComposerArea extends ConsumerWidget {
  const ChatComposerArea({
    super.key,
    required this.room,
    required this.draft,
    required this.focus,
    required this.onSend,
    required this.onAttach,
    required this.onReference,
    required this.onMention,
    this.refs = const [],
    this.onRemoveRef,
  });

  final ChatRoom room;
  final TextEditingController draft;
  final FocusNode focus;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onReference;
  final ValueChanged<MentionPick> onMention;
  final List<ChatShareOption> refs;
  final ValueChanged<ChatShareOption>? onRemoveRef;

  /// Gösterilen en çok öneri.
  static const maxSuggestions = 5;

  List<MentionPick> _suggest(
    String query,
    ChatMembers? members,
    String? me,
    String all,
    List<ChatDepartmentOption> departments,
  ) {
    final q = trLower(query);
    return [
      if (room.chat.canManage && trLower(all).startsWith(q))
        (label: all, mention: const ChatMention.all()),
      for (final d in departments)
        if (trLower(d.name).contains(q))
          (label: d.name, mention: ChatMention.department(d.id)),
      for (final m in members?.items ?? const <ChatMember>[])
        if (m.accountId != me && trLower(m.name).contains(q))
          (label: m.name, mention: ChatMention.account(m.accountId)),
    ].take(maxSuggestions).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    // Kaynak alt dolgu 26 (= 6 + 20); klavye/güvenli alan daha büyükse o.
    final bottom = math.max<double>(keyboard, math.max<double>(safeBottom, 20));
    if (room.blocked || room.gone) {
      final c = context.colors;
      return NzGlass(
        tone: NzGlassTone.bar,
        edge: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottom),
          child: Text(
            room.gone ? l.uiMessagesChatGone : l.uiMessagesPeerLeft,
            textAlign: TextAlign.center,
            style: context.text.bodySm.copyWith(color: c.textMuted),
          ),
        ),
      );
    }
    final view = ref.watch(chatControllerProvider(room.chat.id));
    final ctrl = ref.read(chatControllerProvider(room.chat.id).notifier);
    final me = ref.watch(chatMeProvider);
    final members = room.chat.group
        ? ref.watch(chatMembersControllerProvider(room.chat.id)).value
        : null;
    final sources = room.chat.group
        ? ref.watch(chatGroupSourcesProvider)
        : null;
    final departments = sources == null || sources.isLoading || sources.hasError
        ? const <ChatDepartmentOption>[]
        : sources.value?.departments ?? const <ChatDepartmentOption>[];
    final ctxMsg = view.edit != null
        ? room.message(view.edit!)
        : view.reply != null
        ? room.message(view.reply!)
        : null;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: draft,
      builder: (context, value, _) {
        final query = !room.chat.group || view.edit != null
            ? null
            : mentionQuery(value.text);
        final picks = query == null
            ? const <MentionPick>[]
            : _suggest(query, members, me, l.uiMessagesMentionAll, departments);
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: NzComposer(
            controller: draft,
            focusNode: focus,
            hint: l.uiMessagesMessageHint,
            canSend:
                value.text.trim().isNotEmpty ||
                (view.edit == null && refs.isNotEmpty),
            onSend: onSend,
            sendLabel: l.uiMessagesSend,
            onAttach: onAttach,
            attachLabel: l.uiMessagesAttach,
            onReference: view.edit == null ? onReference : null,
            referenceLabel: l.uiMessagesReference,
            bottomInset: bottom,
            header: [
              if (view.edit == null)
                for (final item in refs)
                  NzComposerContext(
                    icon: switch (item.ref.kind) {
                      ChatRefKind.task => NzIcons.tasks,
                      ChatRefKind.department => NzIcons.coordinatorships,
                      ChatRefKind.file => NzIcons.folder,
                    },
                    title: l.uiMessagesShared,
                    text: item.label,
                    cancelLabel: l.uiMessagesComposeRemove,
                    onCancel: () => onRemoveRef?.call(item),
                  ),
              if (picks.isNotEmpty)
                Semantics(
                  container: true,
                  label: l.uiMessagesMentionSuggestions,
                  child: Wrap(
                    spacing: NizamioSpacing.space1,
                    runSpacing: NizamioSpacing.space1,
                    children: [
                      for (final p in picks)
                        NzButton.ghost(
                          label: '@${p.label}',
                          size: NzSize.sm,
                          onPressed: () {
                            final text = applyMention(draft.text, p.label);
                            draft.value = TextEditingValue(
                              text: text,
                              selection: TextSelection.collapsed(
                                offset: text.length,
                              ),
                            );
                            onMention(p);
                          },
                        ),
                    ],
                  ),
                ),
              if (ctxMsg != null)
                NzComposerContext(
                  icon: view.edit != null ? NzIcons.edit : NzIcons.reply,
                  title: view.edit != null
                      ? l.uiMessagesEditMessage
                      : ctxMsg.senderId == me
                      ? l.uiMessagesReplySelf
                      : '${ctxMsg.senderName ?? room.chat.name} ${l.uiMessagesReplyTo}',
                  text: l.summaryOf(ctxMsg),
                  cancelLabel: l.uiMessagesCancel,
                  onCancel: () {
                    if (view.edit != null) draft.clear();
                    ctrl.clearContext();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
