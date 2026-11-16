import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/archive_summary_provider.dart';
import '../../domain/archive.dart';
import 'archive_texts.dart';

/// Arşiv özeti kartları (ana sayfa KPI kutucukları gibi): dosya sayısı (klasör sayısıyla),
/// toplam boyut ve tür dağılımı. Dosya sayısı klasör listesinden hemen gelir; boyut ve tür
/// [archiveSummaryProvider] okununca dolar (okunurken "—"). Yalnız sunucu verisi kullanılır.
class ArchiveSummaryCards extends ConsumerWidget {
  const ArchiveSummaryCards({
    super.key,
    required this.files,
    required this.folders,
  });

  final int files;
  final int folders;

  /// Bu genişliğin altında kartlar ikili ızgaradır (tür kartı tam genişlik).
  static const _threeColumns = 640.0;

  Color _kindColor(NizamioColors c, ArchiveFileKind k) => switch (k) {
    ArchiveFileKind.image => c.info,
    ArchiveFileKind.pdf => c.danger,
    ArchiveFileKind.document => c.warning,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final summary = ref.watch(archiveSummaryProvider).value;
    final partial = summary?.partial ?? false;
    final filesCard = NzKpiTile(
      icon: NzIcons.file,
      tone: c.accentText,
      label: l.uiArchiveSummaryFiles,
      value: '$files',
      progress: files == 0 ? 0 : 1,
      caption: '$folders ${l.uiArchiveFoldersLc}',
    );
    final sizeCard = NzKpiTile(
      icon: NzIcons.folder,
      tone: c.inProgress,
      label: l.uiArchiveSummarySize,
      value: summary == null ? '—' : l.size(summary.bytes),
      progress: summary == null || summary.files == 0 ? 0 : 1,
      caption: summary == null
          ? '—'
          : partial
          ? l.uiArchiveSummaryPartial
          : l.files(summary.files),
    );
    final kinds = summary?.kinds.entries.toList() ?? const [];
    final kindsCard = NzKpiTile(
      icon: NzIcons.attach,
      tone: c.warning,
      label: l.uiArchiveSummaryKinds,
      value: summary == null
          ? '—'
          : summary.files == 0
          ? '0'
          : '${kinds.where((e) => e.value > 0).length}',
      // Dosya yoksa parça yok: kutucuk boş tek değerli çubuğa düşer.
      segments: [
        if (summary != null && summary.files > 0)
          for (final e in kinds) NzBarSegment(e.value, _kindColor(c, e.key)),
      ],
      caption: summary == null
          ? '—'
          : summary.files == 0
          ? l.uiArchiveSummaryNoFiles
          : [
              for (final e in kinds)
                if (e.value > 0) '${l.kindShort(e.key)} ${e.value}',
            ].join(' · '),
    );
    return Semantics(
      label: l.uiArchiveStorage,
      container: true,
      child: LayoutBuilder(
        builder: (context, box) {
          if (box.maxWidth >= _threeColumns) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: filesCard),
                  const Gap(NizamioSpacing.space3),
                  Expanded(child: sizeCard),
                  const Gap(NizamioSpacing.space3),
                  Expanded(child: kindsCard),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: filesCard),
                    const Gap(NizamioSpacing.space3),
                    Expanded(child: sizeCard),
                  ],
                ),
              ),
              const Gap(NizamioSpacing.space3),
              kindsCard,
            ],
          );
        },
      ),
    );
  }
}
