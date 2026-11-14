import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/archive_controller.dart';
import '../../domain/archive.dart';
import '../../domain/archive_summary.dart';
import 'archive_folder_card.dart';
import 'archive_texts.dart';

// Yönetici arşiv ana sayfasının parçaları: etiket süzgeci, depolama kartı, sıralama denetimi
// ve koordinatörlük kartı. Sayılar [ArchiveStats]'tan (sunucu dosya listesi + görevin
// koordinatörlüğü); yükleme zamanı sunucuda olmadığından "son yükleme" gösterilmez.

/// Tür rengi (depolama şeridi, açıklama).
Color archiveKindColor(NizamioColors c, ArchiveFileKind k) => switch (k) {
  ArchiveFileKind.image => c.inProgress,
  ArchiveFileKind.document => c.warning,
  ArchiveFileKind.pdf => c.danger,
};

/// Etiket süzgeci hapı: seçili etiketlerin renk noktaları (yoksa bütün etiketlerin ilk üçü),
/// "Etiketler · n" ve aşağı ok; dokunma çoklu seçim sayfasını açar.
class ArchiveTagChip extends ConsumerWidget {
  const ArchiveTagChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final tags = ref.watch(archiveControllerProvider.select((s) => s.tags));
    final shown = [
      for (final tag in archiveTags)
        if (tags.isEmpty || tags.contains(tag)) tag,
    ].take(3).toList();
    final label = tags.isEmpty
        ? l.uiArchiveTags
        : '${l.uiArchiveTags} · ${tags.length}';
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: NzPressable(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showArchiveTagSheet(context),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(NizamioRadius.pill),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.space4,
                  vertical: NizamioSpacing.space2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Üst üste binen noktalar.
                    SizedBox(
                      width: 10.0 + 7 * (shown.length - 1),
                      height: 10,
                      child: Stack(
                        children: [
                          for (final (i, tag) in shown.indexed)
                            Positioned(
                              left: 7.0 * i,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: c.tag(tag),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: c.surfaceRaised,
                                    width: 1.5,
                                  ),
                                ),
                                child: const SizedBox.square(dimension: 10),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Text(label, style: t.list),
                    const Gap(NizamioSpacing.space2),
                    NzIcon(
                      NzIcons.chevronDown,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiket seçimi (çoklu); değişiklik hemen uygulanır, "Temizle" bütün etiketlere döner.
Future<void> showArchiveTagSheet(BuildContext context) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiArchiveTags,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final c = context.colors;
        final tags = ref.watch(archiveControllerProvider.select((s) => s.tags));
        final ctrl = ref.read(archiveControllerProvider.notifier);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final tag in archiveTags)
              NzCheckbox(
                label: l.tagLabel(tag),
                labelLeading: NzDot(color: c.tag(tag)),
                value: tags.contains(tag),
                onChanged: (on) =>
                    ctrl.setTags({...tags.where((x) => x != tag), if (on) tag}),
              ),
            if (tags.isNotEmpty) ...[
              const Gap(NizamioSpacing.space3),
              NzButton.secondary(
                label: l.uiArchiveTagsClear,
                onPressed: () => ctrl.setTags(const {}),
              ),
            ],
          ],
        );
      },
    ),
  );
}

/// Depolama kartı: toplam boyut (büyük), sağda dosya / klasör / görev, türe göre boyut şeridi
/// (ayrık parçalar) ve açıklama ("Görsel 268,4 MB"). [stats] yüklenirken "—".
class ArchiveStorageCard extends StatelessWidget {
  const ArchiveStorageCard({
    super.key,
    required this.stats,
    required this.folders,
  });

  final ArchiveStats? stats;
  final int folders;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = stats;
    final size = s == null ? null : l.size(s.bytes);
    // "559,3 MB" → büyük sayı + küçük birim.
    final cut = size?.lastIndexOf(' ') ?? -1;
    final number = size == null ? '—' : size.substring(0, cut);
    final unit = size == null ? '' : size.substring(cut + 1);
    Widget stat(String label, String value) => Container(
      padding: const EdgeInsetsDirectional.only(
        start: NizamioSpacing.space4,
        end: NizamioSpacing.space2,
      ),
      decoration: BoxDecoration(
        border: BorderDirectional(start: BorderSide(color: c.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.caption.copyWith(color: c.textMuted)),
          const Gap(NizamioSpacing.space1),
          Text(value, style: t.mono.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
    final head = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.uiArchiveStorage, style: t.bodyMd.copyWith(color: c.textMuted)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: number, style: t.displayLg),
              TextSpan(
                text: ' $unit',
                style: t.mono.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
    final stats3 = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        stat(l.uiArchiveSummaryFiles, s == null ? '—' : '${s.files}'),
        stat(l.uiArchiveStatFolders, '$folders'),
        stat(l.uiArchiveStatTasks, s == null ? '—' : '${s.tasks}'),
      ],
    );
    final kinds = [
      for (final k in ArchiveFileKind.values)
        if ((s?.kindBytes[k] ?? 0) > 0) k,
    ];
    return NzCard.outlined(
      size: NzSize.lg,
      semanticLabel: [
        l.uiArchiveStorage,
        ?size,
        if (s != null) l.files(s.files),
      ].join(', '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dar ekranda sayılar başlığın altına iner.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: NizamioSpacing.space4,
            runSpacing: NizamioSpacing.space3,
            children: [head, stats3],
          ),
          const Gap(NizamioSpacing.space4),
          NzProgressBar.segments(
            separated: true,
            height: 8,
            segments: [
              for (final k in kinds)
                NzBarSegment(s!.kindBytes[k]!, archiveKindColor(c, k)),
            ],
          ),
          if (kinds.isNotEmpty) ...[
            const Gap(NizamioSpacing.space3),
            Wrap(
              spacing: NizamioSpacing.space4,
              runSpacing: NizamioSpacing.space1,
              children: [
                for (final k in kinds)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NzDot(color: archiveKindColor(c, k)),
                      const Gap(NizamioSpacing.space2),
                      Text(
                        l.kindLabel(k),
                        style: t.bodyMd.copyWith(color: c.textMuted),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Text(l.size(s!.kindBytes[k]!), style: t.mono),
                    ],
                  ),
              ],
            ),
          ],
          if (s?.partial ?? false) ...[
            const Gap(NizamioSpacing.space2),
            Text(
              l.uiArchiveSummaryPartial,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Kart sırası: ölçüt adı (dokunma sıradakine geçer) ve yön oku (dokunma çevirir).
class ArchiveSortControl extends ConsumerWidget {
  const ArchiveSortControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final (sort, descending) = ref.watch(
      archiveControllerProvider.select((s) => (s.sort, s.descending)),
    );
    final ctrl = ref.read(archiveControllerProvider.notifier);
    final label = switch (sort) {
      ArchiveFolderSort.size => l.uiArchiveSortBySize,
      ArchiveFolderSort.files => l.uiArchiveSortByFiles,
      ArchiveFolderSort.name => l.uiArchiveSortByName,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ctrl.cycleSort,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NizamioSpacing.space2,
              ),
              child: Text(label, style: t.list.copyWith(color: c.textMuted)),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: l.uiArchiveSortFlip,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ctrl.flipDirection,
            child: Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space2),
              child: AnimatedRotation(
                turns: descending ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: NzIcon(
                  NzIcons.swapVertical,
                  size: NizamioSize.iconSizeSm,
                  color: c.textMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Koordinatörlük klasörü kartı: klasör simgesi, sağ üstte depolamadaki payı, ad, "5 dosya ·
/// 3 görev", altta boyut ve en büyük klasöre göre çubuk.
class ArchiveStatFolderCard extends StatelessWidget {
  const ArchiveStatFolderCard({
    super.key,
    required this.folder,
    required this.stats,
    required this.total,
    required this.largest,
    required this.onTap,
    this.filtered = false,
  });

  final ArchiveFolder folder;

  /// Etiket süzgeci açık: dosya sayısı süzülmüş istatistikten; değilse sunucunun klasör sayısı
  /// (yetkili; istemci sayımı kısmi olabilir).

  /// null → istatistik yükleniyor (sunucu dosya sayısı gösterilir).
  final ArchiveFolderStats? stats;
  final int total;
  final int largest;
  final VoidCallback onTap;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = stats;
    final files = filtered ? (s?.files ?? 0) : folder.files;
    final summary = [
      files > 0 ? l.files(files) : l.uiArchiveNoFiles,
      if (s != null && s.tasks > 0) '${s.tasks} ${l.uiArchiveTasksLc}',
    ].join(' · ');
    final share = s == null || total == 0 || s.bytes == 0
        ? null
        : l.percentShare(s.bytes / total);
    return NzCard.outlined(
      onTap: onTap,
      semanticLabel: [
        folder.name,
        summary,
        if (s != null) l.size(s.bytes),
      ].join(', '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExcludeSemantics(child: ArchiveFolderIcon()),
              const Spacer(),
              if (share != null)
                Text(share, style: t.bodyMd.copyWith(color: c.textMuted)),
            ],
          ),
          const Gap(NizamioSpacing.space4),
          Text(
            folder.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.list.copyWith(fontWeight: FontWeight.w700),
          ),
          const Gap(NizamioSpacing.space1),
          Text(
            summary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMd.copyWith(color: c.textMuted),
          ),
          const Gap(NizamioSpacing.space5),
          Row(
            children: [
              Text(
                s == null ? '—' : l.size(s.bytes),
                style: t.mono.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: NzProgressBar(
                  value: s == null || largest == 0 ? 0 : s.bytes / largest,
                  color: c.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
