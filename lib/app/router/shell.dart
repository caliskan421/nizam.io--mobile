import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/generated/app_localizations.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import 'router.dart' show catalogPath;

/// Kabuk sekmesi: simge + ARB etiketi. Sıra, `routes.dart` içindeki dal sırasıyla birebirdir.
class NzShellTab {
  const NzShellTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String Function(AppLocalizations l10n) label;
}

/// Sekme listesi (yer tutucu içerik: ekran çalışması gerçek sekmeleri belirler).
final shellTabs = <NzShellTab>[
  NzShellTab(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: (l) => l.uiRouterTabHome,
  ),
  NzShellTab(
    icon: Icons.work_outline,
    selectedIcon: Icons.work,
    label: (l) => l.uiRouterTabWork,
  ),
  NzShellTab(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: (l) => l.uiRouterTabProfile,
  ),
];

/// Yalnız `scoped` fazında kurulan kabuk (A2 gezinme kalıbı): compact → alt [NavigationBar],
/// medium → [NavigationRail], expanded → genişletilmiş ray. Her sekmenin yığını korunur
/// (`StatefulShellRoute.indexedStack`). Kabuk core/app'te durur; features'ta Scaffold yasaktır (U6).
class NzAdaptiveShell extends StatelessWidget {
  const NzAdaptiveShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Seçili sekmeye yeniden dokunma kök konuma döner.
  void _select(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) => AdaptiveBuilder(
    compact: (context) => Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _select,
        destinations: [
          for (final tab in shellTabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label(context.l10n),
            ),
        ],
      ),
    ),
    medium: (context) => _railScaffold(context, extended: false),
    expanded: (context) => _railScaffold(context, extended: true),
  );

  Widget _railScaffold(BuildContext context, {required bool extended}) =>
      Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: Semantics(
                container: true,
                label: context.l10n.uiRouterNavLabel,
                child: NavigationRail(
                  extended: extended,
                  labelType: extended
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _select,
                  destinations: [
                    for (final tab in shellTabs)
                      NavigationRailDestination(
                        icon: Icon(tab.icon),
                        selectedIcon: Icon(tab.selectedIcon),
                        label: Text(tab.label(context.l10n)),
                      ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
}

/// Dev flavor'daki katalog girişi için: katalogu yığına koyar (zaten katalogdaysa dokunmaz).
/// Dize tabanlı gezinme (N1) yalnız `lib/app/router/**` içindedir; katalog rotası fazdan muaftır.
void openDevCatalog(GoRouter router) {
  if (router.routeInformationProvider.value.uri.path == catalogPath) return;
  router.push(catalogPath);
}
