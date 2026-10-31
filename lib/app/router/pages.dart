import 'package:flutter/material.dart';

import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_page.dart';
import '../../core/ui/widgets/feedback/feedback.dart';
import '../../core/ui/widgets/nz_icons.dart';
import 'routes.dart';

/// Bilinmeyen rota (404). Yalnız `scoped` fazında görünür; diğer fazlarda bilinmeyen yol faz
/// kapısına yönlendirilir ([gateRedirect]).
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => NzPage(
    title: context.l10n.uiRouterNotFoundTitle,
    body: NzEmptyState(
      title: context.l10n.uiRouterNotFoundTitle,
      message: context.l10n.uiRouterNotFoundMessage,
      icon: NzIcons.searchOff,
      actionLabel: context.l10n.uiRouterNotFoundAction,
      onAction: () => const HomeRoute().go(context),
    ),
  );
}
