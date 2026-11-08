import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../tasks/tasks.dart';
import '../../application/horizontal_timeline_controller.dart';
import '../../application/horizontal_timeline_view.dart';
import '../../domain/horizontal_timeline.dart';
import '../timeline_texts.dart';
import '../widgets/timeline_controls.dart';
import 'gantt_texts.dart';

/// Koordinatörlük seçimi (telefondaki tek düğmenin tablet karşılığı): "Tüm koordinatörlükler"
/// ve etiket çipleri, çoklu seçim; seçim çizelgeye anında uygulanır.
Future<void> showGanttCoordSheet(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineCoord,
      builder: (_) => const _CoordBody(),
    );

/// Durum süzgeci (Tümü / Açık / Geciken · N); seçim çizelgeye anında uygulanır.
Future<void> showGanttFilterSheet(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineFilters,
      builder: (_) => const _FilterBody(),
    );

/// Açık sayfanın görünümü: durum ve katalog değiştikçe yeniden kurulur.
GanttView? _watchView(WidgetRef ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return null;
  return horizontalTimelineView(
    catalog,
    ref.watch(horizontalTimelineControllerProvider),
  );
}

class _CoordBody extends ConsumerWidget {
  const _CoordBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final view = _watchView(ref);
    if (view == null) return const SizedBox.shrink();
    final ctrl = ref.read(horizontalTimelineControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: NizamioSpacing.space2,
          runSpacing: NizamioSpacing.space2,
          children: [
            TimelineChip(
              label: l.uiTimelineGanttAllCoords,
              selected: view.state.coords.isEmpty,
              onTap: ctrl.clearCoords,
            ),
            for (final c in view.chips)
              TimelineChip(
                label: c.label == c.name ? c.name : '${c.label} · ${c.name}',
                selected: c.selected,
                onTap: () => ctrl.toggleCoord(c.code),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        _ShowButton(view: view),
      ],
    );
  }
}

class _FilterBody extends ConsumerWidget {
  const _FilterBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final view = _watchView(ref);
    if (view == null) return const SizedBox.shrink();
    final ctrl = ref.read(horizontalTimelineControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
          child: Text(
            l.uiTimelineStatus,
            style: t.labelMd.copyWith(color: c.textMuted),
          ),
        ),
        NzFilterRail(
          semanticLabel: l.uiTimelineGanttFilter,
          selected: view.state.filter.index,
          onSelected: (i) => ctrl.setFilter(GanttFilter.values[i]),
          options: [
            for (final f in GanttFilter.values)
              NzFilterOption(label: l.ganttFilterLabel(f, view.lateAll)),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        _ShowButton(view: view),
      ],
    );
  }
}

/// "N görevi göster": sayfayı kapatır (seçim zaten uygulanmıştır).
class _ShowButton extends StatelessWidget {
  const _ShowButton({required this.view});

  final GanttView view;

  @override
  Widget build(BuildContext context) => NzButton.primary(
    label: context.l10n.showTasks(view.visible),
    size: NzSize.lg,
    expand: true,
    onPressed: () => Navigator.of(context).pop(),
  );
}
