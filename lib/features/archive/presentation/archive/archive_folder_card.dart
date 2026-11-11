import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/surfaces/nz_card.dart';
import '../../domain/archive.dart';
import 'archive_folder_preview.dart';
import 'archive_texts.dart';

/// Arşiv özeti: dosya sayısı sunucudan, ek metrikler geçici önizlemeden gelir.
class ArchiveFolderCard extends StatelessWidget {
  const ArchiveFolderCard({
    super.key,
    required this.folder,
    required this.onTap,
  });
  final ArchiveFolder folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final files = folder.files > 0 ? l.files(folder.files) : l.uiArchiveNoFiles;
    final preview = archiveFolderPreview(folder.name);
    final tasks = '${preview.tasks} ${l.uiTasksTasksLc}';
    final size = l.size(preview.bytes);
    final when = switch (preview.daysAgo) {
      0 => l.uiCalendarRelToday,
      1 => l.uiCalendarRelYesterday,
      final n => '$n ${l.uiCalendarRelBefore}',
    };
    return ArchiveFolderCardSurface(
      title: folder.name,
      summary: '$files · $tasks',
      semanticLabel: '${folder.name}, $files, $tasks, $size, $when',
      badge: preview.group ? l.uiMessagesGroup.toLowerCase() : null,
      size: size,
      date: when,
      onTap: onTap,
    );
  }
}

/// Arşiv ve görev klasörleri için aynı görsel ve erişilebilir kart yüzü.
class ArchiveFolderCardSurface extends StatelessWidget {
  const ArchiveFolderCardSurface({
    super.key,
    required this.title,
    required this.summary,
    required this.onTap,
    this.badge,
    this.size,
    this.date,
    this.semanticLabel,
  });
  final String title;
  final String summary;
  final String? badge;
  final String? size;
  final String? date;
  final String? semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final titleStyle = t.bodyMd.copyWith(
      fontWeight: FontWeight.w700,
      color: c.text,
    );
    final metaStyle = t.bodySm.copyWith(color: c.textMuted);
    final badge = this.badge;
    final size = this.size;
    final date = this.date;
    return NzCard.outlined(
      padding: const EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space5,
        vertical: NizamioSpacing.space3,
      ),
      onTap: onTap,
      semanticLabel: semanticLabel ?? [title, summary, ?size, ?date].join(', '),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 132),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ExcludeSemantics(child: _ArchiveFolderIcon()),
                const Spacer(),
                if (badge != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: c.borderControl),
                      borderRadius: BorderRadius.circular(NizamioRadius.tile),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NizamioSpacing.space2,
                      ),
                      child: Text(
                        badge,
                        style: t.monoSm.copyWith(color: c.textMuted),
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space3),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
            const Gap(NizamioSpacing.space1 / 2),
            Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: metaStyle,
            ),
            if (size != null || date != null) ...[
              const Spacer(),
              const Gap(NizamioSpacing.space2),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: NizamioSpacing.space2,
                  runSpacing: NizamioSpacing.space2,
                  children: [
                    if (size != null)
                      Text(
                        size,
                        style: t.monoSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: c.text,
                        ),
                      ),
                    if (date != null)
                      Text(date, style: t.monoSm.copyWith(color: c.textMuted)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Karttaki küçük klasörün arka sekmesi ve üst ışıklı ön yüzü.
class _ArchiveFolderIcon extends StatelessWidget {
  const _ArchiveFolderIcon();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const radius = BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
    );
    return SizedBox(
      width: 52,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: 22,
            height: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceOverlay,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 6,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.buttonTop, c.surfaceOverlay],
                ),
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 1,
                    child: ColoredBox(color: c.edgeLight),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
