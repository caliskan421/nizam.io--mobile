import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/display_brand.dart';
import '../../../core/config/flavor.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../notifications/notifications.dart';
import '../application/current_program_controller.dart';

/// Kök sayfaların (Ana sayfa, Görevler, Koordinatörlükler, Arşiv, Mesajlar) ortak üst çubuğu
/// (prototip kök `header`): ürün işareti ve adı, altında seçili program (S2), bildirim zili
/// (okunmamış bildirim varsa nokta; dokununca bildirim listesi) ve uygulama menüsünü açan cam
/// daire. Sliver'dır.
class RootTopBar extends ConsumerWidget {
  const RootTopBar({super.key, this.referenceHeader = false});

  /// Reference list header: central brand identity and menu, without notification bell.
  final bool referenceHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(currentProgramControllerProvider);
    final current = state.isLoading ? null : state.value;
    final program = current?.id == ref.watch(scopeStateProvider).programId
        ? current?.name
        : null;
    final bell = referenceHeader ? null : watchNotificationBell(context, ref);
    final flavor = referenceHeader ? ref.watch(flavorProvider) : null;
    final brand = flavor == null
        ? l.uiHomeAppName
        : displayBrand(flavor).name ?? l.uiHomeAppName;
    return NzTopBar(
      leading: flavor == Flavor.dev
          ? Image.asset(
              'assets/branding/roketportal-mark.png',
              width: NizamioSpacing.space8,
              height: NizamioSpacing.space8,
              excludeFromSemantics: true,
            )
          : NzBrandMark(monogram: brand.characters.first),
      title: brand,
      subtitle: program,
      actions: [
        if (bell != null)
          NzIconButton(
            icon: NzIcons.bell,
            semanticLabel: bell.label,
            dot: bell.dot ? context.colors.danger : null,
            onPressed: () => unawaited(showNotifications(context)),
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
/// (`text-faint`) durur. Yükleme sırasında ve program kimliği seçimle uyuşmadığında etiket
/// gizlenir; ilk yüklemede satırın yeri ayrılır. Aynı programın yenilemesi hata verirse son
/// bilinen ad kalabilir; bu gösterim yetki kanıtı değildir.
class RootProgramLine extends ConsumerWidget {
  const RootProgramLine({super.key, this.bottom = 0});

  final double bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentProgramControllerProvider);
    final current = state.isLoading ? null : state.value;
    final program = current?.id == ref.watch(scopeStateProvider).programId
        ? current?.name
        : null;
    final pending = ref.watch(
      currentProgramControllerProvider.select(
        (p) => p.isLoading && !p.hasValue,
      ),
    );
    final reserve =
        pending && ref.watch(scopeStateProvider.select((s) => s.hasProgram));
    if ((program == null || program.isEmpty) && !reserve) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Text(
        program ?? ' ',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.program.copyWith(color: context.colors.textFaint),
      ),
    );
  }
}
