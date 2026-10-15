import 'package:flutter/material.dart';

import '../../core/theme/generated/tokens.gen.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/widgets/buttons/buttons.dart';
import '../../core/ui/widgets/nz_size.dart';

/// Dev flavor'daki katalog giriş noktası: sağ üst köşede küçük simge düğmesi. Yalnız dev
/// flavor'da ağaca eklenir (karar `app.dart`'ta); rota fazdan muaf olduğundan her fazda çalışır.
class CatalogEntryButton extends StatelessWidget {
  const CatalogEntryButton({super.key, required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: NizamioSpacing.space8),
        child: Material(
          type: MaterialType.transparency,
          child: NzIconButton(
            size: NzSize.sm,
            icon: Icons.widgets_outlined,
            semanticLabel: context.l10n.uiRouterDevCatalogOpen,
            onPressed: onOpen,
          ),
        ),
      ),
    ),
  );
}
