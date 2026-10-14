import 'package:flutter/material.dart';

import '../../core/i18n/generated/app_localizations.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_page.dart';
import '../../core/ui/widgets/feedback/feedback.dart';
import 'routes.dart';

/// Yer tutucu ekranlar (D-0174: ekran çalışması bu rotaları doldurur). Her ekran [NzPage]
/// ile kurulur; başlık ARB'den gelir.
class RouterPlaceholderPage extends StatelessWidget {
  const RouterPlaceholderPage({super.key, required this.title, this.detailId});

  /// AppBar başlığını ARB'den seçer.
  final String Function(AppLocalizations l10n) title;

  /// Ayrıntı yer tutucusunda gösterilen kimlik (yalnız kimlik taşınır; veri controller'dan gelir).
  final String? detailId;

  @override
  Widget build(BuildContext context) => NzPage(
    title: title(context.l10n),
    body: Center(
      child: Text(
        detailId == null
            ? context.l10n.uiRouterPlaceholder
            : '${context.l10n.uiRouterPlaceholder}\n$detailId',
        textAlign: TextAlign.center,
        style: context.text.bodyMd,
      ),
    ),
  );
}

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
      icon: Icons.search_off_outlined,
      actionLabel: context.l10n.uiRouterNotFoundAction,
      onAction: () => const HomeRoute().go(context),
    ),
  );
}
