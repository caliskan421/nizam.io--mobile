import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../../theme/nz_surfaces.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import 'nz_pressable.dart';

/// Bitişik iki ikincil düğme (prototip sıralama denetimi): solda metinli eylem, sağda dönen
/// ikon (ör. sırayı ters çevir). Görsel yükseklik `controlSm` (36), iç köşeler 4 px; her parça
/// en az 48 dokunma alanıdır. İkon dönüşü `easeSpring` ile.
class NzSplitButton extends StatelessWidget {
  const NzSplitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.semanticLabel,
    required this.icon,
    required this.onIconPressed,
    required this.iconSemanticLabel,
    this.iconTurns = 0,
  });

  final String label;
  final VoidCallback onPressed;

  /// Metinli parçanın okuyucu açıklaması (ör. "Sıralama ölçütünü değiştir: Gecikme").
  final String semanticLabel;
  final IconData icon;
  final VoidCallback onIconPressed;
  final String iconSemanticLabel;

  /// İkonun tur cinsinden dönüşü (0.5 = 180°).
  final double iconTurns;

  static const _inner = Radius.circular(NizamioSpacing.space1);
  static const _outer = Radius.circular(NizamioRadius.tile);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: NizamioSpacing.space1 / 2,
    children: [
      _Segment(
        semanticLabel: semanticLabel,
        onPressed: onPressed,
        radius: const BorderRadius.horizontal(left: _outer, right: _inner),
        padding: NizamioSpacing.space4,
        child: Text(
          label,
          maxLines: 1,
          style: context.text.bodyMd.copyWith(
            fontWeight: context.text.labelLg.fontWeight,
          ),
        ),
      ),
      _Segment(
        semanticLabel: iconSemanticLabel,
        onPressed: onIconPressed,
        radius: const BorderRadius.horizontal(left: _inner, right: _outer),
        padding: NizamioSpacing.space3,
        child: AnimatedRotation(
          turns: iconTurns,
          duration: NzMotion.of(context, NizamioMotion.durSheet),
          curve: NizamioMotion.easeSpring,
          child: const NzIcon(
            NzIcons.chevronDown,
            size: NizamioSize.iconSizeSm,
          ),
        ),
      ),
    ],
  );
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.semanticLabel,
    required this.onPressed,
    required this.radius,
    required this.padding,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback onPressed;
  final BorderRadius radius;
  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      button: true,
      label: semanticLabel,
      onTap: onPressed,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: NizamioSpacing.space12,
            minWidth: NizamioSize.tap,
          ),
          child: Center(
            child: NzPressable(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: c.secondaryFill,
                  border: Border.all(
                    color: c.buttonBorder,
                    width: NizamioSize.borderWidth,
                  ),
                  borderRadius: radius,
                ),
                child: CustomPaint(
                  foregroundPainter: NzEdgeLightPainter(
                    color: c.edgeLight,
                    borderRadius: radius,
                  ),
                  child: SizedBox(
                    height: NizamioSize.controlSm,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Center(
                        widthFactor: 1,
                        child: IconTheme.merge(
                          data: IconThemeData(color: c.text),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
