import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/generated/app_localizations.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import '../../core/ui/page/nz_shell_events.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_floating_nav.dart';
import '../../features/activity/activity.dart';
import '../../features/archive/archive.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/messages/messages.dart';
import '../../features/tasks/tasks.dart';
import 'routes.dart';

/// Alt menünün üçüncü öğesi: son girilen modül (README "Gezinme"). Üçü aynı kabuk dalındadır.
enum ShellModule { coordinatorships, archive, messages }

/// Alt menü öğesinin görünümü (simge, etiket, etkinken alt yazı).
@immutable
class NzShellTab {
  const NzShellTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.caption,
    this.wide = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? caption;

  /// Uzun etiket (Koordinatörlükler): etkinken kapsül öğesi genişler.
  final bool wide;
}

/// Konumdan modül (modül dalı dışında null).
ShellModule? moduleOf(String location) {
  if (location.startsWith(const CoordinatorshipsRoute().location)) {
    return ShellModule.coordinatorships;
  }
  if (location.startsWith(const ArchiveRoute().location)) {
    return ShellModule.archive;
  }
  if (location.startsWith(const MessagesRoute().location)) {
    return ShellModule.messages;
  }
  return null;
}

/// Kabuk sekmeleri (sıra `routes.dart` dal sırasıyla birebir). Etiket ve alt yazı konuma ve
/// modüllerin özet sağlayıcılarına göre.
List<NzShellTab> shellTabsFor(
  AppLocalizations l, {
  required String location,
  required ShellModule module,
  required WidgetRef ref,
}) {
  final inHistory = location.startsWith(const HistoryRoute().location);
  // Her zaman izlenir: işlem geçmişi kayıtları kabukla birlikte yüklenir (keepAlive), sayfaya
  // ilk girişte liste ilk karede dolu gelir (yükleniyor karesi/titreme yok).
  final historyCaption = ref.watch(activityNavCaptionProvider);
  return [
    NzShellTab(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: inHistory ? l.uiRouterTabHistory : l.uiRouterTabHome,
      caption: inHistory ? historyCaption : l.uiRouterTabHomeCaption,
    ),
    NzShellTab(
      icon: Icons.checklist_rounded,
      selectedIcon: Icons.checklist_rounded,
      label: l.uiRouterTabTasks,
      caption: ref.watch(tasksNavCaptionProvider),
    ),
    switch (module) {
      ShellModule.coordinatorships => NzShellTab(
        icon: Icons.apartment_rounded,
        selectedIcon: Icons.apartment_rounded,
        label: l.uiRouterTabCoordinatorships,
        caption: ref.watch(coordinatorshipsNavCaptionProvider),
        wide: true,
      ),
      ShellModule.archive => NzShellTab(
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder_rounded,
        label: l.uiRouterTabArchive,
        caption: ref.watch(archiveNavCaptionProvider),
      ),
      ShellModule.messages => NzShellTab(
        icon: Icons.chat_bubble_outline_rounded,
        selectedIcon: Icons.chat_bubble_rounded,
        label: l.uiRouterTabMessages,
        caption: ref.watch(messagesNavCaptionProvider),
      ),
    },
  ];
}

/// Yalnız `scoped` fazında kurulan kabuk (A2 gezinme kalıbı): compact → yüzen cam alt menü
/// ([NzFloatingNav], içerik altından geçer), medium → [NavigationRail], expanded →
/// genişletilmiş ray. Her sekmenin yığını korunur (`StatefulShellRoute.indexedStack`). Kabuk
/// core/app'te durur; features'ta Scaffold yasaktır (U6).
class NzAdaptiveShell extends ConsumerStatefulWidget {
  const NzAdaptiveShell({
    super.key,
    required this.navigationShell,
    this.location,
  });

  final StatefulNavigationShell navigationShell;

  /// Geçerli konum (modül öğesi ve etiket seçimi).
  final String? location;

  @override
  ConsumerState<NzAdaptiveShell> createState() => _NzAdaptiveShellState();
}

class _NzAdaptiveShellState extends ConsumerState<NzAdaptiveShell> {
  /// Son girilen modül (başlangıçta Koordinatörlükler, prototip varsayılanı).
  var _module = ShellModule.coordinatorships;

  StatefulNavigationShell get _shell => widget.navigationShell;

  @override
  void didUpdateWidget(NzAdaptiveShell old) {
    super.didUpdateWidget(old);
    _remember();
  }

  @override
  void initState() {
    super.initState();
    _remember();
  }

  void _remember() {
    final m = moduleOf(widget.location ?? '');
    if (m != null) _module = m;
  }

  /// Başka sekme → o sekmenin son konumu. Etkin sekmeye yeniden dokunma → o sayfanın kısayol
  /// menüsü ([ShellReselectEvents]; sayfa kendisi görünürse açar).
  void _select(int index) {
    if (index == _shell.currentIndex) {
      ref.read(shellReselectEventsProvider.notifier).fire(index);
      return;
    }
    _shell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = shellTabsFor(
      context.l10n,
      location: widget.location ?? '',
      module: _module,
      ref: ref,
    );
    return AdaptiveBuilder(
      compact: (context) => Scaffold(
        extendBody: true,
        body: _shell,
        bottomNavigationBar: NzFloatingNav(
          currentIndex: _shell.currentIndex,
          onSelect: _select,
          semanticLabel: context.l10n.uiRouterNavLabel,
          items: [
            for (final tab in tabs)
              NzNavItem(
                icon: tab.icon,
                label: tab.label,
                caption: tab.caption,
                wide: tab.wide,
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
      medium: (context) => _rail(context, tabs, extended: false),
      expanded: (context) => _rail(context, tabs, extended: true),
    );
  }

  Widget _rail(
    BuildContext context,
    List<NzShellTab> tabs, {
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
              selectedIndex: _shell.currentIndex,
              onDestinationSelected: _select,
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    selectedIcon: Icon(tab.selectedIcon),
                    label: Text(tab.label),
                  ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _shell),
      ],
    ),
  );
}
