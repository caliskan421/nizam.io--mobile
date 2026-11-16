import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/theme/nz_surfaces.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';
import '../../domain/chat_send_failure.dart';
import 'chat_attachments.dart';
import 'chat_refs.dart';
import 'messages_texts.dart';

/// Çocuğunun boyutunu yerleşimden sonra bildirir (cam çubukların altına akış dolgusu için).
class ChatMeasure extends SingleChildRenderObjectWidget {
  const ChatMeasure({super.key, required this.onSize, required super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      ChatMeasureBox(onSize);

  @override
  void updateRenderObject(BuildContext context, ChatMeasureBox renderObject) =>
      renderObject.onSize = onSize;
}

/// [ChatMeasure] çizim nesnesi.
class ChatMeasureBox extends RenderProxyBox {
  ChatMeasureBox(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _last) {
      _last = size;
      final s = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(s));
    }
  }
}

/// Mesaj gövdesi: paylaşılan öğe kartları (alıntı gibi en üstte; not 30), ekler (fotoğraf küçük
/// resim, dosya kartı; not 32) ve metin.
class ChatMessageBody extends StatelessWidget {
  const ChatMessageBody({
    super.key,
    required this.message,
    required this.onAttachment,
    required this.onSharedFile,
  });

  final ChatMessage message;

  /// Ek dokunuşu (indirme); gönderilmekte olan mesajda null.
  final ValueChanged<ChatAttachment>? onAttachment;
  final void Function(String refId, String name) onSharedFile;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    final base = t.list.copyWith(fontWeight: FontWeight.w400, height: 21 / 15);
    final open = onAttachment;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space1,
      children: [
        for (final r in message.refs)
          ChatRefTile(
            refId: r.refId,
            kind: r.kind,
            targetId: r.targetId,
            onFile: onSharedFile,
          ),
        for (final a in message.attachments)
          Align(
            alignment: Alignment.centerLeft,
            child: ChatAttachmentView(
              attachment: a,
              onServer: message.onServer,
              onTap: open == null ? null : () => open(a),
            ),
          ),
        if (message.text.isNotEmpty) Text(message.text, style: base),
      ],
    );
  }
}

/// Gönderilemeyen kendi mesajımın balon içi satırı (not 33): neden (boyut, tür, ağ, yetki…) ve
/// tekrar anlamlıysa "Tekrar dene" ([onRetry]; aynı istemci kimliğiyle).
class ChatSendFailureRow extends StatelessWidget {
  const ChatSendFailureRow({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final String? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final retry = chatSendRetryable(failure);
    return Row(
      children: [
        NzIcon(NzIcons.error, size: 14, color: c.danger),
        const Gap(NizamioSpacing.space1),
        Expanded(
          child: Text(
            l.sendFailure(failure),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.caption.copyWith(color: c.danger),
          ),
        ),
        if (retry) ...[
          const Gap(NizamioSpacing.space2),
          Semantics(
            button: true,
            label: l.uiMessagesTryAgain,
            excludeSemantics: true,
            onTap: onRetry,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRetry,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l.uiMessagesTryAgain,
                  style: t.caption.copyWith(
                    color: c.accentText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Balon içi anket: soru, seçim türü / sonuçlandı, seçenekler (yüzde çubuğu,
/// benim oyum işaretli; dokununca [onVote]), oy veren sayısı.
class ChatPollView extends StatelessWidget {
  const ChatPollView({
    super.key,
    required this.question,
    required this.poll,
    required this.me,
    required this.onVote,
  });

  final String question;
  final ChatPoll poll;
  final String? me;
  final ValueChanged<int> onVote;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final closed = poll.isClosed(DateTime.now());
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space2,
        children: [
          const Gap(NizamioSpacing.space1),
          Text(question, style: t.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          Text(
            closed
                ? l.uiMessagesConcluded
                : poll.multi
                ? l.uiMessagesMultiChoice
                : l.uiMessagesSingleChoice,
            style: t.caption.copyWith(color: c.textMuted),
          ),
          for (var i = 0; i < poll.options.length; i++)
            _PollOption(
              label: poll.options[i].label,
              percent: poll.percent(i),
              on: poll.options[i].votedBy(me),
              onTap: closed ? null : () => onVote(i),
            ),
          Text(
            l.voters(poll.voters),
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
  }
}

class _PollOption extends StatelessWidget {
  const _PollOption({
    required this.label,
    required this.percent,
    required this.on,
    required this.onTap,
  });

  final String label;
  final int percent;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      checked: on,
      label: '$label %$percent',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NizamioSpacing.gapMd),
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: c.quoteFill)),
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent / 100,
                  child: ColoredBox(
                    color: on
                        ? c.primary.withValues(alpha: 0.26)
                        : c.text.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: on ? c.primary : null,
                        borderRadius: BorderRadius.circular(5),
                        border: on
                            ? null
                            : Border.all(color: c.borderControl, width: 1.5),
                      ),
                      child: on
                          ? NzIcon(NzIcons.check, size: 12, color: c.onPrimary)
                          : null,
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(child: Text(label, style: t.bodySm)),
                    Text(
                      '%$percent',
                      style: t.monoSm.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cam üst çubuk: geri, avatar + ad + alt satır (dokununca sohbet bilgisi), sohbette ara;
/// sabit mesaj varsa altında şerit (dokununca sıradaki).
class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.room,
    required this.pins,
    required this.pinIndex,
    required this.onInfo,
    required this.onSearch,
    required this.onNextPin,
  });

  final ChatRoom room;

  /// Penceredeki sabit mesajlar (en yeni sabit başta).
  final List<ChatMessage> pins;
  final int pinIndex;
  final VoidCallback onInfo;
  final VoidCallback onSearch;
  final VoidCallback onNextPin;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final chat = room.chat;
    final sub = l.chatSubtitle(room, DateTime.now());
    final subAccent =
        room.typing != null || (!chat.group && (chat.peerOnline ?? false));
    final pin = pins.isEmpty ? null : pins[pinIndex % pins.length];
    // Tablet sağ bölmesinde yığın tek ekransa "Geri" gizli (`[data-canback="false"]`).
    final showBack = NzPaneScope.showsBack(NzPaneScope.maybeOf(context));
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: NzGlass(
        tone: NzGlassTone.bar,
        edge: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Kaynak üst çubuk satırı: `height: 56px; padding: 8px 8px 0` (+1 alt kenar).
              Padding(
                padding: EdgeInsets.fromLTRB(
                  showBack ? NizamioSpacing.space1 : NizamioSpacing.space2,
                  MediaQuery.paddingOf(context).top + NizamioSpacing.space2,
                  NizamioSpacing.space2,
                  0,
                ),
                child: ConstrainedBox(
                  // En az 56; büyük metin ölçeğinde taşmadan büyür.
                  constraints: const BoxConstraints(
                    minHeight: NizamioSize.appbar,
                  ),
                  child: Row(
                    children: [
                      if (showBack)
                        NzIconButton(
                          icon: NzIcons.back,
                          semanticLabel: MaterialLocalizations.of(context)
                              .backButtonTooltip,
                          size: NzSize.sm,
                          onPressed: () => NzPaneScope.back(context),
                        ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              '${chat.name} ${chat.group ? l.uiMessagesGroupInfo : l.uiMessagesPersonInfo}',
                          excludeSemantics: true,
                          onTap: onInfo,
                          child: InkWell(
                            onTap: onInfo,
                            borderRadius: BorderRadius.circular(
                              NizamioRadius.tile,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  NzChatAvatar(
                                    initials: chatInitials(chat.name),
                                    group: chat.group,
                                    tone: chat.group
                                        ? 0
                                        : personTone(chat.name),
                                    extent: 38,
                                  ),
                                  const Gap(NizamioSpacing.gapMd),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chat.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.list.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (sub.isNotEmpty)
                                          Text(
                                            sub,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.caption.copyWith(
                                              height: 20 / 12,
                                              color: subAccent
                                                  ? c.accentText
                                                  : c.textMuted,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      NzIconButton(
                        icon: NzIcons.search,
                        semanticLabel: l.uiMessagesSearchChat,
                        size: NzSize.sm,
                        onPressed: onSearch,
                      ),
                    ],
                  ),
                ),
              ),
              if (pin != null)
                Semantics(
                  button: true,
                  label: '${l.uiMessagesPinned}: ${l.summaryOf(pin)}',
                  excludeSemantics: true,
                  onTap: onNextPin,
                  child: InkWell(
                    onTap: onNextPin,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 46),
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: c.border)),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 3,
                              decoration: BoxDecoration(
                                color: c.accentText,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const Gap(NizamioSpacing.gapMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pins.length > 1
                                        ? '${l.uiMessagesPinned} ${pinIndex % pins.length + 1}/${pins.length}'
                                        : l.uiMessagesPinned,
                                    style: t.caption.copyWith(
                                      color: c.accentText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    l.summaryOf(pin),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodySm.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(NizamioSpacing.gapMd),
                            NzIcon(
                              NzIcons.pin,
                              size: NizamioSize.iconSizeSm,
                              color: c.textFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
