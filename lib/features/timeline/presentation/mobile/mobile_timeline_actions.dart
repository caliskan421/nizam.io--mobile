import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';

/// Referanstaki sağ alt üçlü: ölçek, çoklu koordinatörlük, durum/kişi/öncelik.
class MobileTimelineActions extends StatelessWidget {
  const MobileTimelineActions({
    super.key,
    required this.view,
    required this.onScale,
    required this.onCoord,
    required this.onFilter,
    required this.onLegend,
  });
  final TimelineView view;
  final VoidCallback onScale;
  final VoidCallback onCoord;
  final VoidCallback onFilter;
  final VoidCallback onLegend;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget button(
      Widget child,
      String label,
      VoidCallback onTap, {
      int count = 0,
      VoidCallback? onLongPress,
    }) => Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: label,
          onTap: onTap,
          onLongPress: onLongPress,
          hint: onLongPress == null ? null : l.uiTimelineLegendOpen,
          excludeSemantics: true,
          child: Material(
            color: context.colors.surfaceRaised.withValues(alpha: .94),
            shape: CircleBorder(
              side: BorderSide(color: context.colors.borderControl),
            ),
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: 50,
                child: Center(child: child),
              ),
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -3,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: context.text.monoSm.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    final scale = switch (view.state.scale) {
      TimelineScale.day => l.uiTimelineScaleDay,
      TimelineScale.week => l.uiTimelineWeekShort,
      TimelineScale.month => l.uiTimelineScaleMonth,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(
          Text(scale.toLowerCase(), style: context.text.monoSm),
          '${l.uiTimelineScale}: ${l.scaleLabel(view.state.scale)}',
          onScale,
          onLongPress: onLegend,
        ),
        const Gap(10),
        button(
          const NzIcon(NzIcons.coordinatorships),
          '${l.uiTimelineCoord} · ${l.coordSummary(view)}',
          onCoord,
          count: view.allSelected ? 0 : view.selectedCoordinatorships.length,
        ),
        const Gap(10),
        button(
          const NzIcon(NzIcons.filter),
          l.uiTimelineFilterLabel,
          onFilter,
          count: view.state.filterCount,
        ),
      ],
    );
  }
}
