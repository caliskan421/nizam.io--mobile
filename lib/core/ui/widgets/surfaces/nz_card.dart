import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

enum _CardVariant { filled, outlined }

/// İçerik kartı. Varyantlar isimli yapıcıdır; [size] iç boşluğu belirler.
/// [onTap] verilirse kart dokunulabilir olur (en az 48 yükseklik, düğme anlamı).
class NzCard extends StatelessWidget {
  /// Dolu zeminli kart.
  const NzCard.filled({
    super.key,
    required this.child,
    this.size = NzSize.md,
    this.onTap,
    this.semanticLabel,
  }) : _variant = _CardVariant.filled;

  /// Kenarlıklı kart.
  const NzCard.outlined({
    super.key,
    required this.child,
    this.size = NzSize.md,
    this.onTap,
    this.semanticLabel,
  }) : _variant = _CardVariant.outlined;

  final Widget child;
  final NzSize size;

  /// null → dokunulamaz.
  final VoidCallback? onTap;

  /// Dokunulabilir kartta okuyucu etiketi (null → içerik metni).
  final String? semanticLabel;
  final _CardVariant _variant;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final radius = BorderRadius.circular(NizamioRadius.card);
    final padding = EdgeInsets.all(
      size.pick(
        sm: NizamioSpacing.space3,
        md: NizamioSpacing.space4,
        lg: NizamioSpacing.space6,
      ),
    );
    final content = Padding(padding: padding, child: child);
    final shape = RoundedRectangleBorder(
      borderRadius: radius,
      side: style.border == null
          ? BorderSide.none
          : BorderSide(color: style.border!),
    );
    final tap = onTap;
    return Semantics(
      container: true,
      button: tap != null,
      label: semanticLabel,
      onTap: tap,
      excludeSemantics: semanticLabel != null,
      child: Material(
        color: style.fill,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: tap == null
            ? SizedBox(width: double.infinity, child: content)
            : InkWell(
                onTap: tap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: NizamioSpacing.space12,
                    minWidth: double.infinity,
                  ),
                  child: content,
                ),
              ),
      ),
    );
  }

  // Varyant görünümünün tek yeri.
  ({Color fill, Color? border}) _resolveStyle(BuildContext context) {
    final colors = context.colors;
    return switch (_variant) {
      _CardVariant.filled => (fill: colors.surfaceRaised, border: null),
      _CardVariant.outlined => (fill: colors.surface, border: colors.border),
    };
  }
}
