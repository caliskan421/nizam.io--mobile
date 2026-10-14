import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Başlıklı içerik bölümü: başlık (başlık anlamı), isteğe bağlı [trailing] yuvası ve [child].
class NzSection extends StatelessWidget {
  const NzSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.size = NzSize.md,
  });

  final String title;
  final Widget child;

  /// Başlık satırının sonundaki yuva (ör. bir bağlantı ya da rozet).
  final Widget? trailing;
  final NzSize size;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: style.titleStyle),
              ),
            ),
            if (trailing != null) ...[
              const Gap(NizamioSpacing.space3),
              trailing!,
            ],
          ],
        ),
        Gap(style.gap),
        child,
      ],
    );
  }

  // Boyut görünümünün tek yeri.
  ({TextStyle titleStyle, double gap}) _resolveStyle(BuildContext context) {
    final text = context.text;
    return (
      titleStyle: size.pick(
        sm: text.titleSm,
        md: text.titleMd,
        lg: text.titleLg,
      ),
      gap: size.pick(
        sm: NizamioSpacing.space2,
        md: NizamioSpacing.space3,
        lg: NizamioSpacing.space4,
      ),
    );
  }
}
