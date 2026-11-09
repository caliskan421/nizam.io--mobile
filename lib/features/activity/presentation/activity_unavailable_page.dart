import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_empty_state.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';

class ActivityUnavailablePage extends StatelessWidget {
  const ActivityUnavailablePage({super.key});
  @override
  Widget build(BuildContext context) {
    final pane = NzPaneScope.maybeOf(context);
    return NzPage.fill(
      topBar: NzTopBar.detail(
        title: context.l10n.uiActivityTitle,
        actions: [
          if (pane?.role == NzPaneRole.detail)
            NzIconButton.circle(
              icon: NzIcons.close,
              semanticLabel: context.l10n.uiCommonClose,
              onPressed: () => pane!.canBack
                  ? NzPaneScope.back(context)
                  : context.appNav.openHome(),
            ),
        ],
      ),
      body: const NzEmptyState(
        title: 'İşlem geçmişi kullanılamıyor',
        message: 'Bu sunucu sürümü işlem geçmişi okumayı desteklemiyor.',
        icon: NzIcons.history,
      ),
    );
  }
}
