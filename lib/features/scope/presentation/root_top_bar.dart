import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../application/current_program_controller.dart';
import '../application/home_dashboard_controller.dart';
import 'home/home_texts.dart';

/// Kök sayfaların (Ana sayfa, Görevler, Koordinatörlükler, Arşiv, Mesajlar) ortak üst çubuğu
/// (prototip kök `header`): ürün işareti ve adı, altında seçili program (S2), bildirim zili
/// (bekleyen iş varsa nokta) ve uygulama menüsünü açan cam daire. Sliver'dır.
class RootTopBar extends ConsumerWidget {
  const RootTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final program = ref.watch(currentProgramControllerProvider).value;
    final waiting =
        ref.watch(homeDashboardControllerProvider).value?.pending.length ?? 0;
    return NzTopBar(
      leading: NzBrandMark(monogram: l.uiHomeAppName.characters.first),
      title: l.uiHomeAppName,
      subtitle: program?.name,
      actions: [
        NzIconButton(
          icon: Icons.notifications_none_rounded,
          semanticLabel: l.notificationsLabel(waiting),
          dot: waiting > 0 ? context.colors.danger : null,
          onPressed: () => NzToast.show(context, l.soon(l.uiHomeNotifications)),
        ),
        NzIconButton.glass(
          icon: Icons.menu_rounded,
          semanticLabel: l.uiHomeMenu,
          onPressed: () => context.appNav.openMenu(context),
        ),
      ],
    );
  }
}
