import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';

/// Dokunulabilir yüzey: anlam (düğme, seçili), basma ölçeği ve mürekkep. Görsel çocuktadır.
class TimelineTap extends StatelessWidget {
  const TimelineTap({
    super.key,
    required this.onTap,
    required this.child,
    this.label,
    this.selected,
    this.radius = NizamioRadius.tile,
    this.excludeSemantics = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final String? label;
  final bool? selected;
  final double radius;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    excludeSemantics: excludeSemantics,
    child: NzPressable(
      enabled: onTap != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: child,
        ),
      ),
    ),
  );
}

/// Seçilebilir hap (prototip `.rp-chipbtn`): 36 görsel, 44 dokunma; seçiliyken `ink` dolgu.
class TimelineChip extends StatelessWidget {
  const TimelineChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.count,
    this.mono = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final int? count;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final fg = selected ? c.background : c.text;
    final style = (mono ? t.monoSm : t.labelMd).copyWith(color: fg);
    final count = this.count;
    return TimelineTap(
      onTap: onTap,
      selected: selected,
      radius: NizamioRadius.pill,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: NizamioSize.tap),
        child: Center(
          widthFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? c.text : c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
              border: Border.all(color: selected ? c.text : c.borderStrong),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading case final l?) ...[
                    IconTheme.merge(
                      data: IconThemeData(color: fg),
                      child: l,
                    ),
                    const Gap(6),
                  ],
                  Flexible(child: Text(label, style: style)),
                  if (count != null) ...[
                    const Gap(NizamioSpacing.space1),
                    Text(
                      '$count',
                      style: t.monoSm.copyWith(
                        color: fg.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Çizelge başlık çubuğu düğmesi (prototip 34 yükseklik, 12 köşe, yarı saydam dolgu).
class TimelineBarButton extends StatelessWidget {
  const TimelineBarButton({
    super.key,
    required this.onTap,
    required this.child,
    this.label,
    this.expanded = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final String? label;
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      expanded: expanded,
      child: TimelineTap(
        onTap: onTap,
        label: label,
        excludeSemantics: label != null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.tap),
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.text.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
                border: Border.all(color: c.text.withValues(alpha: 0.1)),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 34),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.space3,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
