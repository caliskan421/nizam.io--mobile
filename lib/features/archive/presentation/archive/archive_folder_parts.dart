import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/records.dart';
import 'archive_preview_sheet.dart';
import 'archive_texts.dart';

/// Görev klasörleri ızgarasının bir satırı (3 sütun, prototip `gap: 20px 10px`).
class ArchiveTaskFolderRow extends StatelessWidget {
  const ArchiveTaskFolderRow({
    super.key,
    required this.tasks,
    required this.onOpen,
  });

  final List<ArchiveTaskSummary> tasks;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var j = 0; j < 3; j++) ...[
            if (j > 0) const Gap(NizamioSpacing.gapMd),
            Expanded(
              child: j < tasks.length
                  ? NzFolder(
                      small: true,
                      name: tasks[j].title,
                      caption: l.files(tasks[j].fileCount),
                      onTap: () => onOpen(tasks[j].workItemId),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Süzgeç hapı (etiket rayı, yükleyen ve sıralama).
class ArchiveChip extends StatelessWidget {
  const ArchiveChip({
    super.key,
    required this.label,
    required this.on,
    required this.onTap,
    this.dot,
    this.icon,
  });

  final String label;
  final bool on;
  final VoidCallback onTap;
  final Color? dot;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final dot = this.dot;
    final icon = this.icon;
    return Semantics(
      button: true,
      selected: on,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: on ? c.surfaceOverlay : null,
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            border: Border.all(color: on ? c.accentText : c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dot != null) ...[NzDot(color: dot, size: 7), const Gap(6)],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodySm,
                ),
              ),
              if (icon != null) ...[
                const Gap(NizamioSpacing.space1),
                NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Etiket süzgeci: yatay kaydırılan haplar (prototip `.rp-wheel`, kenardan kenara).
class ArchiveTagRail extends StatelessWidget {
  const ArchiveTagRail({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RecordTag? selected;
  final ValueChanged<RecordTag?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Semantics(
      label: l.uiArchiveTagFilter,
      container: true,
      // Prototip `.rp-wheel`: haplar kenar boşluğunun dışına taşarak kayar.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          spacing: 6,
          children: [
            ArchiveChip(
              label: l.uiArchiveFilterAll,
              on: selected == null,
              onTap: () => onSelected(null),
            ),
            for (final x in archiveTags)
              ArchiveChip(
                label: l.tagLabel(x),
                dot: c.tag(x),
                on: selected == x,
                onTap: () => onSelected(x),
              ),
          ],
        ),
      ),
    );
  }
}

/// Seçili görev süzgeci şeridi (başlık + kaldır).
class ArchiveTaskFilter extends StatelessWidget {
  const ArchiveTaskFilter({
    super.key,
    required this.title,
    required this.onClear,
  });

  final String title;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
      ),
      child: Row(
        children: [
          NzIcon(
            NzIcons.folder,
            size: NizamioSize.iconSizeSm,
            color: c.textMuted,
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodySm,
            ),
          ),
          IconButton(
            tooltip: l.uiArchiveRemoveTaskFilter,
            onPressed: onClear,
            icon: NzIcon(
              NzIcons.close,
              size: NizamioSize.iconSizeSm,
              color: c.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dosya satırı; satırlar birlikte `bg-raised`, 18 köşeli tek kart gibi görünür (ilk/son satır
/// köşeleri yuvarlanır, aradakiler üstte ince çizgiyle ayrılır). Alt satır: görev başlığı
/// (biliniyorsa) ve boyut.
class ArchiveFileRow extends StatelessWidget {
  const ArchiveFileRow({
    super.key,
    required this.file,
    required this.taskTitle,
    required this.first,
    required this.last,
    required this.onTap,
  });

  final RecordFile file;
  final String? taskTitle;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final title = taskTitle;
    final sub = [
      if (title != null) l.short(title),
      l.size(file.sizeBytes),
    ].join(' · ');
    const r = Radius.circular(NizamioRadius.row);
    final radius = BorderRadius.vertical(
      top: first ? r : Radius.zero,
      bottom: last ? r : Radius.zero,
    );
    return Semantics(
      button: true,
      label: '${file.displayName}, $sub, ${l.tagLabel(file.tag)}',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: c.surfaceRaised,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: first ? null : Border(top: BorderSide(color: c.border)),
            ),
            child: Row(
              children: [
                ArchiveKindTile(kind: file.kind),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.mono.copyWith(fontSize: 12),
                      ),
                      const Gap(2),
                      Text(
                        sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                NzDot(color: c.tag(file.tag)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
