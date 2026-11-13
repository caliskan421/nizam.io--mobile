import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/chat_attachment_preview.dart';
import '../../domain/chat.dart';
import 'messages_texts.dart';

/// Mesaj eki (not 32): fotoğraf balonda küçük resim (gönderilirken cihazdaki dosyadan, sonra
/// sunucudan; sınırı aşan ya da okunamayan fotoğraf dosya kartına düşer), diğer dosyalar tür,
/// ad ve boyutla kart. Dokunuş [onTap] (indirme/aç).
class ChatAttachmentView extends ConsumerWidget {
  const ChatAttachmentView({
    super.key,
    required this.attachment,
    required this.onServer,
    required this.onTap,
  });

  final ChatAttachment attachment;
  final bool onServer;
  final VoidCallback? onTap;

  static const _thumbW = 220.0;
  static const _thumbH = 165.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = attachment;
    final card = _FileCard(attachment: a, onTap: onTap);
    if (!a.isImage) return card;
    final local = a.localPath;
    Widget? image;
    if (local != null && !onServer) {
      image = Image.file(
        File(local),
        fit: BoxFit.cover,
        cacheWidth: 600,
        errorBuilder: (_, _, _) => card,
      );
    } else if (onServer && a.sizeBytes <= chatThumbLimit) {
      final bytes = ref.watch(chatAttachmentThumbProvider(a.id));
      image = bytes.when(
        data: (b) => Image.memory(
          b,
          fit: BoxFit.cover,
          cacheWidth: 600,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => card,
        ),
        loading: () => ColoredBox(
          color: context.colors.quoteFill,
          child: Center(
            child: NzIcon(NzIcons.image, color: context.colors.textFaint),
          ),
        ),
        error: (_, _) => null,
      );
    }
    if (image == null) return card;
    return Semantics(
      button: onTap != null,
      image: true,
      label: a.fileName,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.tile),
          child: SizedBox(width: _thumbW, height: _thumbH, child: image),
        ),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({required this.attachment, required this.onTap});

  final ChatAttachment attachment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final a = attachment;
    final type =
        fileTypeLabel(a.fileName, a.contentType) ?? l.uiMessagesRefFile;
    final sub = '$type · ${l.fileSize(a.sizeBytes)}';
    return Semantics(
      button: onTap != null,
      label: '${a.fileName}, $sub',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
          decoration: BoxDecoration(
            color: c.quoteFill,
            borderRadius: BorderRadius.circular(NizamioRadius.tile),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.refChip,
                  borderRadius: BorderRadius.circular(NizamioRadius.bubbleTail),
                ),
                child: NzIcon(
                  a.isImage ? NzIcons.image : NzIcons.document,
                  size: NizamioSize.iconSizeSm,
                  color: c.accentText,
                ),
              ),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      a.fileName,
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

/// Dosya türü etiketi: uzantı ("PDF"), yoksa içerik türünün alt türü; ikisi de yoksa null.
String? fileTypeLabel(String fileName, String contentType) {
  final dot = fileName.lastIndexOf('.');
  if (dot > 0 && dot < fileName.length - 1) {
    final ext = fileName.substring(dot + 1);
    if (ext.length <= 5) return ext.toUpperCase();
  }
  final slash = contentType.indexOf('/');
  if (slash < 0 || slash == contentType.length - 1) return null;
  final sub = contentType.substring(slash + 1).split(RegExp('[;+.]')).first;
  return sub.isEmpty ? null : sub.toUpperCase();
}
