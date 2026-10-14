import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

enum _DividerAxis { horizontal, vertical }

/// İnce ayırıcı çizgi (1 mantıksal piksel, `border` rengi). [size] çizginin çevresindeki
/// boşluğu belirler. Anlamsal değildir (okuyucudan gizlenir).
class NzDivider extends StatelessWidget {
  /// Yatay: genişliği kadar, çevresinde dikey boşluk.
  const NzDivider.horizontal({super.key, this.size = NzSize.md})
    : _axis = _DividerAxis.horizontal;

  /// Dikey: yüksekliği üst öğeden gelir (sınırlı olmalı, ör. `IntrinsicHeight`).
  const NzDivider.vertical({super.key, this.size = NzSize.md})
    : _axis = _DividerAxis.vertical;

  final NzSize size;
  final _DividerAxis _axis;

  /// Çizgi kalınlığı.
  static const thickness = 1.0;

  @override
  Widget build(BuildContext context) {
    final gap = size.pick(
      sm: NizamioSpacing.space1,
      md: NizamioSpacing.space2,
      lg: NizamioSpacing.space4,
    );
    final line = ColoredBox(color: context.colors.border);
    return ExcludeSemantics(
      child: switch (_axis) {
        _DividerAxis.horizontal => Padding(
          padding: EdgeInsets.symmetric(vertical: gap),
          child: SizedBox(
            height: thickness,
            width: double.infinity,
            child: line,
          ),
        ),
        _DividerAxis.vertical => Padding(
          padding: EdgeInsets.symmetric(horizontal: gap),
          child: SizedBox(
            width: thickness,
            height: double.infinity,
            child: line,
          ),
        ),
      },
    );
  }
}
