import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Belirsiz ilerleme göstergesi. [NzLoader.page] bulunduğu alanı kaplar ve göstergeyi ortalar.
class NzLoader extends StatelessWidget {
  const NzLoader({super.key, this.size = NzSize.md, this.semanticLabel})
    : _fill = false;

  /// Bulunduğu alanı kaplayan, ortalanmış gösterge (sayfa/bölüm yüklemesi).
  const NzLoader.page({super.key, this.semanticLabel})
    : size = NzSize.lg,
      _fill = true;

  final NzSize size;

  /// null → `ui.feedback.loading`.
  final String? semanticLabel;
  final bool _fill;

  double get _extent => size.pick(
    sm: NizamioSpacing.space6,
    md: NizamioSpacing.space8,
    lg: NizamioSpacing.space12,
  );

  @override
  Widget build(BuildContext context) {
    final indicator = Semantics(
      label: semanticLabel ?? context.l10n.uiFeedbackLoading,
      liveRegion: true,
      excludeSemantics: true,
      child: SizedBox(
        width: _extent,
        height: _extent,
        child: CircularProgressIndicator(
          color: context.colors.primary,
          strokeWidth: NizamioSpacing.space1,
        ),
      ),
    );
    return _fill ? Center(child: indicator) : indicator;
  }
}
