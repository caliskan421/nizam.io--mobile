import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';

/// Pinli API işlem geçmişi okuması sağlamaz; boş bir kayıt listesi göstermeden
/// kullanıcıya bölümün kullanılabilirliğini bildirir.
class ActivityLogCard extends StatelessWidget {
  const ActivityLogCard({super.key});

  @override
  Widget build(BuildContext context) => NzCard.outlined(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space2,
      children: [
        NzKicker(context.l10n.uiActivityTitle),
        Text(
          context.l10n.uiActivityUnsupported,
          style: context.text.bodySm.copyWith(color: context.colors.textMuted),
        ),
      ],
    ),
  );
}
