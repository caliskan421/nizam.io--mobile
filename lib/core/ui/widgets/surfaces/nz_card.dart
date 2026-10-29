import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_pane.dart';
import '../../theme/nz_surfaces.dart';
import '../buttons/nz_pressable.dart';
import '../nz_size.dart';

enum _CardVariant { filled, outlined }

/// İçerik kartı. Varyantlar isimli yapıcıdır; [size] iç boşluğu belirler ([padding] verilirse o).
/// [onTap] verilirse kart dokunulabilir olur (en az 48 yükseklik, düğme anlamı, basınca `.985`).
class NzCard extends StatelessWidget {
  /// Dolu zeminli kart (`bg-raised`; form satırı grubu gibi iç yüzeyler).
  const NzCard.filled({
    super.key,
    required this.child,
    this.size = NzSize.md,
    this.padding,
    this.onTap,
    this.semanticLabel,
  }) : _variant = _CardVariant.filled;

  /// Tasarım kartı (README "Yüzeyler ve derinlik"): `surface-top → bg-surface` degradesi, 1 px
  /// `border-subtle`, üst iç ışık `edge-light`, köşe `m-r-card`; açık temada kart gölgesi.
  const NzCard.outlined({
    super.key,
    required this.child,
    this.size = NzSize.md,
    this.padding,
    this.onTap,
    this.semanticLabel,
  }) : _variant = _CardVariant.outlined;

  final Widget child;
  final NzSize size;

  /// İç boşluk; null → [size] (sm 12 · md 16 · lg 24). KPI/satır kartı `NizamioSpacing.rowPad`.
  final EdgeInsetsGeometry? padding;

  /// null → dokunulamaz.
  final VoidCallback? onTap;

  /// Dokunulabilir kartta okuyucu etiketi (null → içerik metni).
  final String? semanticLabel;
  final _CardVariant _variant;

  static const _overlayAlpha = 0.04;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(NizamioRadius.card);
    final pad =
        padding ??
        EdgeInsets.all(
          size.pick(
            sm: NizamioSpacing.space3,
            md: NizamioSpacing.space4,
            lg: NizamioSpacing.space6,
          ),
        );
    // Tablet kaynağı `t-card` border-box: 1 px kenarlık dolgunun dışındadır.
    final borderBox =
        _variant == _CardVariant.outlined &&
        NzTabletMetrics.tabletVisualAt(MediaQuery.sizeOf(context).width);
    final content = Padding(
      padding: borderBox
          ? pad.add(const EdgeInsets.all(NizamioSize.borderWidth))
          : pad,
      child: child,
    );
    final decoration = switch (_variant) {
      _CardVariant.filled => BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: radius,
      ),
      _CardVariant.outlined => BoxDecoration(
        gradient: colors.cardFill,
        border: Border.all(
          color: colors.border,
          width: NizamioSize.borderWidth,
        ),
        borderRadius: radius,
        boxShadow: context.shadows.card,
      ),
    };
    final tap = onTap;
    final Widget inner = tap == null
        ? SizedBox(width: double.infinity, child: content)
        : Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: tap,
              borderRadius: radius,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith(
                (s) =>
                    s.contains(WidgetState.hovered) ||
                        s.contains(WidgetState.focused)
                    ? colors.text.withValues(alpha: _overlayAlpha)
                    : null,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NizamioSpacing.space12,
                  minWidth: double.infinity,
                ),
                child: content,
              ),
            ),
          );
    final card = DecoratedBox(
      decoration: decoration,
      child: _variant == _CardVariant.outlined
          ? CustomPaint(
              foregroundPainter: NzEdgeLightPainter(
                color: colors.edgeLight,
                borderRadius: radius,
              ),
              child: inner,
            )
          : inner,
    );
    return Semantics(
      container: true,
      button: tap != null,
      label: semanticLabel,
      onTap: tap,
      excludeSemantics: semanticLabel != null,
      child: tap == null ? card : NzPressable.card(child: card),
    );
  }
}
