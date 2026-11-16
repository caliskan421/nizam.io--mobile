import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/chat_shared_controller.dart';
import '../../domain/chat.dart';
import 'messages_texts.dart';

/// Paylaşılan öğe kartı (not 30–31): yanıt alıntısıyla aynı dil — sol 3 px şerit, dolgu, tür
/// simgesi, başlık ve kısa alt satır; mesajda metnin üstünde durur. Kart `getChatRefSummary`
/// ile okunur (önbellek [chatRefCardProvider]); hedef yoksa ya da okunamazsa "artık yok".
///
/// Dokunuş ilgili ekranı açar: görev → görev ayrıntısı, koordinatörlük → koordinatörlük,
/// dosya → [onFile] (indirme). [onBeforeOpen] ekran açılmadan önce çağrılır (alt pencereyi
/// kapatmak; dosyada çağrılmaz, [onFile] kendisi yönetir).
class ChatRefTile extends ConsumerWidget {
  const ChatRefTile({
    super.key,
    required this.refId,
    required this.kind,
    required this.targetId,
    required this.onFile,
    this.onBeforeOpen,
  });

  final String refId;
  final ChatRefKind kind;
  final String targetId;
  final void Function(String refId, String name) onFile;
  final VoidCallback? onBeforeOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final card = ref.watch(chatRefCardProvider(refId));
    final v = card.value;
    final gone = card.hasError || (v != null && !v.available);
    final title = gone ? l.uiMessagesRefGone : v?.title ?? '…';
    final sub = gone || v == null ? l.refKind(kind) : l.refSubtitle(v);
    final name = v?.title;
    final VoidCallback? tap = gone || v == null
        ? null
        : () {
            final nav = context.appNav;
            switch (kind) {
              case ChatRefKind.task:
                onBeforeOpen?.call();
                nav.openTask(targetId);
              case ChatRefKind.department:
                onBeforeOpen?.call();
                nav.openCoordinatorship(targetId);
              case ChatRefKind.file:
                if (name != null) onFile(refId, name);
            }
          };
    final tone = gone ? c.textFaint : c.accentText;
    return Semantics(
      button: tap != null,
      label: '${l.refKind(kind)}: $title',
      excludeSemantics: true,
      onTap: tap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 5, 6, 5),
          decoration: BoxDecoration(
            color: c.quoteFill,
            borderRadius: BorderRadius.circular(NizamioRadius.bubbleTail),
            border: Border(left: BorderSide(color: tone, width: 3)),
          ),
          child: Row(
            children: [
              NzIcon(
                switch (kind) {
                  ChatRefKind.task => NzIcons.tasks,
                  ChatRefKind.department => NzIcons.group,
                  ChatRefKind.file => NzIcons.file,
                },
                size: NizamioSize.iconSizeSm,
                color: tone,
              ),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySm.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
              if (tap != null) ...[
                const Gap(NizamioSpacing.space1),
                NzIcon(
                  NzIcons.chevronRight,
                  size: NizamioSize.iconSizeSm,
                  color: c.textFaint,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
