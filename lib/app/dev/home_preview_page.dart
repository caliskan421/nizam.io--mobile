import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_shell_events.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_floating_nav.dart';
import '../../features/scope/scope.dart';
import '../router/shell.dart' show shellTabs;

/// Ana sayfa önizlemesi (yalnız dev flavor, `/dev/home`): oturum ve kapsam kapısından geçmeden
/// ana sayfayı kabuğun yüzen alt menüsüyle birlikte gösterir (simülatörde görsel denetim). Özet
/// geliştirme örneğidir; program seçili olmadığından üst çubukta program satırı yoktur. Gezinme
/// hedefleri bildirim gösterir (önizlemede rota yığını yoktur).
class HomePreviewPage extends ConsumerWidget {
  const HomePreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    void note(String what) => NzToast.show(context, 'Önizleme: $what');
    return Scaffold(
      extendBody: true,
      body: HomePage(
        navigation: HomeNavigation(
          openTasks: () => note('görev listesi'),
          openTask: (code) => note('görev $code'),
          openCoordinatorship: (code) => note('koordinatörlük $code'),
          openProfile: () => note('profil'),
        ),
      ),
      bottomNavigationBar: NzFloatingNav(
        currentIndex: HomePage.shellTab,
        semanticLabel: l.uiRouterNavLabel,
        onSelect: (i) => i == HomePage.shellTab
            ? ref.read(shellReselectEventsProvider.notifier).fire(i)
            : note(shellTabs[i].label(l)),
        items: [
          for (final tab in shellTabs)
            NzNavItem(
              icon: tab.icon,
              label: tab.label(l),
              caption: tab.caption?.call(l),
            ),
        ],
        action: NzNavAction(
          icon: Icons.smart_toy_outlined,
          semanticLabel: l.uiRouterAssistant,
          onPressed: () => NzToast.show(context, l.uiRouterAssistantSoon),
        ),
      ),
    );
  }
}
