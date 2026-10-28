import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Kök sayfa başlığı (tasarım `PageHeader`, `.m-pagehead`; Görevler, Koordinatörlükler, Arşiv,
/// Mesajlar): `m-h1` başlık (okuyucuda başlık) + sağda daire düğmeler ([actions], ör.
/// `NzIconButton.circle` / `.circleAccent`, aralarında 8) + isteğe bağlı [subtitle] (caption,
/// `ink-muted`). Başlık büyük metinde sarılır; düğmeler sağda kalır.
class NzPageHeader extends StatelessWidget {
  const NzPageHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.subtitle,
  });

  final String title;
  final List<Widget> actions;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: context.text.titleLg),
              ),
            ),
            for (final a in actions) ...[const Gap(NizamioSpacing.space1), a],
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
      ],
    );
  }
}
