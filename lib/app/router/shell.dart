import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/generated/app_localizations.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import '../../core/ui/page/nz_shell_events.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_floating_nav.dart';
import 'router.dart' show catalogPath;
import 'routes.dart';

/// Kabuk sekmesi: simge + ARB etiketi (+ etkinken alt yazı) + dal kökü. Sıra, `routes.dart`
/// içindeki dal sırasıyla birebirdir.
class NzShellTab {
  const NzShellTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.root,
    this.caption,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String Function(AppLocalizations l10n) label;
  final String? Function(AppLocalizations l10n)? caption;

  /// Dalın kök konumu (kökteyken yeniden dokunma kısayol menüsü olayıdır).
  final String root;
}

/// Sekme listesi. Prototipin üçüncü öğesi "son girilen modül"dür; modül ekranları gelene kadar
/// profil (çıkış) sekmesi yerinde kalır.
final shellTabs = <NzShellTab>[
  NzShellTab(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    label: (l) => l.uiRouterTabHome,
    caption: (l) => l.uiRouterTabHomeCaption,
    root: const HomeRoute().location,
  ),
  NzShellTab(
    icon: Icons.checklist_rounded,
    selectedIcon: Icons.checklist_rounded,
    label: (l) => l.uiRouterTabWork,
    root: const WorkRoute().location,
  ),
  NzShellTab(
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    label: (l) => l.uiRouterTabProfile,
    root: const ProfileRoute().location,
  ),
];

/// Yalnız `scoped` fazında kurulan kabuk (A2 gezinme kalıbı): compact → yüzen cam alt menü
/// ([NzFloatingNav], içerik altından geçer), medium → [NavigationRail], expanded →
/// genişletilmiş ray. Her sekmenin yığını korunur (`StatefulShellRoute.indexedStack`). Kabuk
/// core/app'te durur; features'ta Scaffold yasaktır (U6).
class NzAdaptiveShell extends ConsumerWidget {
  const NzAdaptiveShell({
    super.key,
    required this.navigationShell,
    this.location,
  });

  final StatefulNavigationShell navigationShell;

  /// Geçerli konum (yeniden dokunmada dal kökünde olup olmadığını ayırır).
  final String? location;

  /// Başka sekme → o sekme. Seçili sekmeye yeniden dokunma: dal kökündeyse sayfanın kısayol
  /// menüsü olayı ([ShellReselectEvents]), değilse köke dönüş.
  void _select(WidgetRef ref, int index) {
    final current = index == navigationShell.currentIndex;
    if (current && location == shellTabs[index].root) {
      ref.read(shellReselectEventsProvider.notifier).fire(index);
      return;
    }
    navigationShell.goBranch(index, initialLocation: current);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AdaptiveBuilder(
    compact: (context) => Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: NzFloatingNav(
        currentIndex: navigationShell.currentIndex,
        onSelect: (i) => _select(ref, i),
        semanticLabel: context.l10n.uiRouterNavLabel,
        items: [
          for (final tab in shellTabs)
            NzNavItem(
              icon: tab.icon,
              label: tab.label(context.l10n),
              caption: tab.caption?.call(context.l10n),
            ),
        ],
        action: NzNavAction(
          icon: Icons.smart_toy_outlined,
          semanticLabel: context.l10n.uiRouterAssistant,
          onPressed: () =>
              NzToast.show(context, context.l10n.uiRouterAssistantSoon),
        ),
      ),
    ),
    medium: (context) => _railScaffold(context, ref, extended: false),
    expanded: (context) => _railScaffold(context, ref, extended: true),
  );

  Widget _railScaffold(
    BuildContext context,
    WidgetRef ref, {
    required bool extended,
  }) => Scaffold(
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
              onDestinationSelected: (i) => _select(ref, i),
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
