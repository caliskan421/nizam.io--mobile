import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_surfaces.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/chat_controller.dart';
import '../../application/messages_providers.dart';
import '../../domain/chat_room.dart';
import 'messages_texts.dart';

/// Yazma alanı: taslağı ve yazma durumunu kendisi dinler; tuş vuruşu ve klavye kalkışı (her kare
/// değişen `viewInsets`) yalnız bu alt ağacı yeniden kurar. Gönderim kapalıysa (karşı taraf
/// programda değil, sohbete erişim yok) yazma alanı yerine açıklama görünür.
class ChatComposerArea extends ConsumerWidget {
  const ChatComposerArea({
    super.key,
    required this.room,
    required this.draft,
    required this.focus,
    required this.onSend,
    required this.onAttach,
  });

  final ChatRoom room;
  final TextEditingController draft;
  final FocusNode focus;
  final VoidCallback onSend;
  final VoidCallback onAttach;

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
    final ctxMsg = view.edit != null
        ? room.message(view.edit!)
        : view.reply != null
        ? room.message(view.reply!)
        : null;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: draft,
      builder: (context, value, _) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: NzComposer(
          controller: draft,
          focusNode: focus,
          hint: l.uiMessagesMessageHint,
          canSend: value.text.trim().isNotEmpty,
          onSend: onSend,
          sendLabel: l.uiMessagesSend,
          onAttach: onAttach,
          attachLabel: l.uiMessagesAttach,
          bottomInset: bottom,
          header: [
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
      ),
    );
  }
}
