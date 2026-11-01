import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
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
    final program = ref.watch(
      currentProgramControllerProvider.select((p) => p.value?.name),
    );
    final bell = watchNotificationBell(context, ref);
    return NzTopBar(
      leading: NzBrandMark(monogram: l.uiHomeAppName.characters.first),
      title: l.uiHomeAppName,
      subtitle: program,
      actions: [
        NzIconButton(
          icon: NzIcons.bell,
          semanticLabel: bell.label,
          dot: bell.dot ? context.colors.danger : null,
          onPressed: () => showNotificationsSoon(context),
        ),
        NzIconButton.glass(
          icon: NzIcons.menu,
          semanticLabel: l.uiHomeMenu,
          onPressed: () => context.appNav.openMenu(context),
        ),
      ],
    );
  }
}

/// Tablet liste bölmesinde kök üst çubuk gizlidir (`.tb-pane`); seçili program adı (S2) orada
/// Ana sayfanın başında, telefondaki üst çubuk alt satırıyla aynı `m-program` biçiminde
/// (`text-faint`) durur. Program yokken (yükleniyor/hata) hiçbir şey çizmez; [bottom] yalnız ad
/// varken eklenir.
class RootProgramLine extends ConsumerWidget {
  const RootProgramLine({super.key, this.bottom = 0});

  final double bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(
      currentProgramControllerProvider.select((p) => p.value?.name),
    );
    if (program == null || program.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Text(
        program,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.program.copyWith(color: context.colors.textFaint),
      ),
    );
  }
}

/// Zile dokunuş (bildirim listesi henüz yok); kök üst çubuk ve tablet rayı aynı bildirimi
/// gösterir.
void showNotificationsSoon(BuildContext context) {
  final l = context.l10n;
  NzToast.show(context, l.soon(l.uiHomeNotifications));
}

/// Bildirim zilinin okuyucu etiketi ("Bildirimler · 3 tarih talebi ve 3 onay…") ve bekleyen
/// iş noktası; kök üst çubuk ve tablet rayı aynı kaynağı okur.
({String label, bool dot}) watchNotificationBell(
  BuildContext context,
  WidgetRef ref,
) {
  final pending = ref.watch(
    homeDashboardControllerProvider.select((d) => d.value?.pending ?? const []),
  );
  return (
    label: context.l10n.notificationsLabel(pending),
    dot: pending.isNotEmpty,
  );
}
