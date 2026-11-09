import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/chat_shared_controller.dart';
import '../../domain/chat.dart';
import 'messages_texts.dart';

/// Paylaşılan öğe kartı (mesaj balonunda ve paylaşılanlar listesinde): tür simgesi, başlık ve
/// kısa alt satır; kart `getChatRefSummary` ile okunur (önbellek [chatRefCardProvider]).
/// Hedef yoksa ya da okunamazsa "artık yok". Dosya kartına dokunuş [onFile] (indirme).
class ChatRefTile extends ConsumerWidget {
  const ChatRefTile({
    super.key,
    required this.refId,
    required this.kind,
    required this.onFile,
  });

  final String refId;
  final ChatRefKind kind;
  final void Function(String refId, String name) onFile;

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
    final tap = kind == ChatRefKind.file && !gone && name != null
        ? () => onFile(refId, name)
        : null;
    return Semantics(
      button: tap != null,
      label: '${l.refKind(kind)}: $title',
      excludeSemantics: true,
      onTap: tap,
      child: GestureDetector(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: c.quoteFill,
            borderRadius: BorderRadius.circular(NizamioRadius.tile),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NzIcon(
                switch (kind) {
                  ChatRefKind.task => NzIcons.tasks,
                  ChatRefKind.department => NzIcons.group,
                  ChatRefKind.file => NzIcons.file,
                },
                size: NizamioSize.iconSizeSm,
                color: gone ? c.textFaint : c.accentText,
              ),
              const Gap(NizamioSpacing.space2),
              Flexible(
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
            ],
          ),
        ),
      ),
    );
  }
}
