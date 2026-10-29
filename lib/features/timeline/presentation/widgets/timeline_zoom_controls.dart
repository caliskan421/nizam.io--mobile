import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_controls.dart';

/// Çizelgenin sağ altında yüzen kontroller (prototip `zoomIn` / `scaleLabel` / `zoomOut`,
/// `openLegend`; `ctrlB`: geri alma bildirimi varken yukarı kalkar): yakınlaştır, ölçek adı,
/// uzaklaştır; altında genel bakış anahtarı ve lejant. Uçta etkisiz düğme soluk (0.35).
class TimelineZoomControls extends StatelessWidget {
  const TimelineZoomControls({
    super.key,
    required this.scale,
    required this.overview,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onOverview,
    required this.onLegend,
  });

  final TimelineScale scale;
  final bool overview;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onOverview;
  final VoidCallback onLegend;

  /// Düğme genişliği (dokunma 44).
  static const extent = NizamioSize.tap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final canIn = scale.index > 0;
    final canOut = scale.index < TimelineScale.values.length - 1;
    final decoration = BoxDecoration(
      color: c.surfaceRaised.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(NizamioRadius.pill),
      border: Border.all(color: c.border),
      boxShadow: context.shadows.float,
    );
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DecoratedBox(
            decoration: decoration,
            child: SizedBox(
              width: extent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Square(
                    icon: Icons.add_rounded,
                    label: l.uiTimelineZoomIn,
                    onTap: canIn ? onZoomIn : null,
                  ),
                  Semantics(
                    label: '${l.uiTimelineScale}: ${l.scaleLabel(scale)}',
                    excludeSemantics: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        l.scaleLabel(scale).toLowerCase(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: t.monoSm.copyWith(
                          fontSize: 10,
                          color: c.textMuted,
                        ),
                      ),
                    ),
                  ),
                  _Square(
                    icon: Icons.remove_rounded,
                    label: l.uiTimelineZoomOut,
                    onTap: canOut ? onZoomOut : null,
                  ),
                ],
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          Semantics(
            toggled: overview,
            hint: l.uiTimelineOverviewHint,
            child: DecoratedBox(
              decoration: decoration.copyWith(
                color: overview ? c.text : decoration.color,
              ),
              child: _Square(
                icon: Icons.view_week_outlined,
                label: l.uiTimelineOverview,
                color: overview ? c.background : c.text,
                onTap: onOverview,
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          DecoratedBox(
            decoration: decoration,
            child: _Square(
              icon: Icons.info_outline_rounded,
              label: l.uiTimelineLegendOpen,
              onTap: onLegend,
            ),
          ),
        ],
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Uçta etkisiz: prototip `zinOp` / `zoutOp` 0.35 (katman açmadan renk saydamlığıyla).
    final fg = color ?? context.colors.text;
    return TimelineTap(
      onTap: onTap,
      label: label,
      excludeSemantics: true,
      radius: NizamioRadius.pill,
      child: SizedBox.square(
        dimension: TimelineZoomControls.extent,
        child: Icon(
          icon,
          size: NizamioSize.iconSizeSm,
          color: onTap == null ? fg.withValues(alpha: 0.35) : fg,
        ),
      ),
    );
  }
}
