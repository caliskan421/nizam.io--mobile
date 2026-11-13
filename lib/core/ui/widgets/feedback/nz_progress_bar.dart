import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Parçalı çubuğun bir dilimi: [weight] göreli pay (sayı ya da oran), [color] anlam rengi.
@immutable
class NzBarSegment {
  const NzBarSegment(this.weight, this.color);

  final num weight;
  final Color color;
}

/// İlerleme çubuğu (prototip `.rp-bar`): tek değer — 4 px, `bg-overlay` rayı üstünde dolgu;
/// parçalı — 6 px, dilimler arası 2 px. Görseldir; değer metni yanında yazılır (anlam
/// ağaçtan çıkarılır, aynı sayı iki kez okunmaz).
class NzProgressBar extends StatelessWidget {
  /// [value] 0–1 arası (taşan değer kırpılır).
  const NzProgressBar({
    super.key,
    required double this.value,
    required Color this.color,
    this.height,
  }) : segments = const [],
       separated = false;

  /// Boş dilimler (pay 0) çizilmez. [separated]: her dilim ayrı yuvarlak uçlu parça
  /// (ana sayfa koordinatörlük kartlarının durum çubuğu); boşken `surfaceRaised` ray.
  const NzProgressBar.segments({
    super.key,
    required this.segments,
    this.height,
    this.separated = false,
  }) : value = null,
       color = null;

  final double? height;
  final bool separated;
  final double? value;
  final Color? color;
  final List<NzBarSegment> segments;

  static const _segmentGap = NizamioSpacing.space1 / 2;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final radius = BorderRadius.circular(NizamioRadius.pill);
    if (value != null) {
      return ExcludeSemantics(
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: context.colors.surfaceOverlay,
            child: SizedBox(
              height: height ?? NizamioSize.progress,
              width: double.infinity,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: value.clamp(0, 1).toDouble(),
                child: ColoredBox(color: color!),
              ),
            ),
          ),
        ),
      );
    }
    final parts = [
      for (final s in segments)
        if (s.weight > 0) s,
    ];
    final total = parts.fold<num>(0, (a, s) => a + s.weight);
    int flex(NzBarSegment s) =>
        (s.weight / total * 1000).round().clamp(1, 1000);
    if (separated) {
      final pill = BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: radius,
      );
      return ExcludeSemantics(
        child: SizedBox(
          height: height ?? NizamioSize.progressLg,
          width: double.infinity,
          child: total == 0
              ? DecoratedBox(decoration: pill)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: _segmentGap,
                  children: [
                    for (final s in parts)
                      Expanded(
                        flex: flex(s),
                        child: DecoratedBox(
                          decoration: pill.copyWith(color: s.color),
                        ),
                      ),
                  ],
                ),
        ),
      );
    }
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: height ?? NizamioSize.progressLg,
          width: double.infinity,
          child: total == 0
              ? ColoredBox(color: context.colors.surfaceOverlay)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: _segmentGap,
                  children: [
                    for (final s in parts)
                      Expanded(
                        flex: flex(s),
                        child: ColoredBox(color: s.color),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
