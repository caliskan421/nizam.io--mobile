import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../../theme/nz_surfaces.dart';
import '../surfaces/nz_glass.dart';
import 'nz_floating_nav.dart';

/// Kısayol menüsü girdisi: bölüm başlığı ya da satır.
sealed class NzFlyoutEntry {
  const NzFlyoutEntry();
}

/// Küçük harfli mono bölüm başlığı (ilk başlık ayırıcısızdır).
class NzFlyoutSection extends NzFlyoutEntry {
  const NzFlyoutSection(this.label);

  final String label;
}

/// Menü satırı: solda ikon ya da durum noktası, etiket + isteğe bağlı alt satır.
class NzFlyoutItem extends NzFlyoutEntry {
  const NzFlyoutItem({
    required this.label,
    required this.onSelected,
    this.icon,
    this.dot,
    this.caption,
    this.accent = false,
  }) : assert(icon == null || dot == null, 'ikon ya da nokta');

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;

  /// Durum noktası rengi (ör. onay bekliyor `warning`).
  final Color? dot;
  final String? caption;

  /// İkon `accentText` (sayfadaki "yeni" eylemi).
  final bool accent;
}

/// Alt menüden açılan cam kısayol menüsü (README `m-flyout`): `glass-menu`, köşe
/// `m-r-flyout`, arkada `scrim-soft`; kapsülün üstünden büyüyerek (`easeSpring`) açılır,
/// `easeExit` ile kapanır. Satır seçilince menü kapanır, sonra eylem çalışır.
abstract final class NzFlyoutMenu {
  static Future<void> show(
    BuildContext context, {
    required String semanticLabel,
    required List<NzFlyoutEntry> entries,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);
    // Kök Navigator bağlamı: kabuğun `extendBody` dolgusu (menü yüksekliği) burada yoktur;
    // yalnız cihazın alt güvenli alanı vardır.
    final reserved = NzFloatingNav.reservedHeight(navigator.context);
    return navigator.push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierLabel: context.l10n.uiCommonClose,
        barrierColor: context.colors.scrimSoft,
        transitionDuration: NzMotion.of(context, NizamioMotion.durSheet),
        reverseTransitionDuration: NzMotion.of(context, NizamioMotion.durExit),
        pageBuilder: (routeContext, _, _) => _FlyoutPanel(
          semanticLabel: semanticLabel,
          entries: entries,
          bottom: reserved + NizamioSpacing.space3,
        ),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: NizamioMotion.easeSpring,
            reverseCurve: NizamioMotion.easeExit,
          );
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: NizamioMotion.easeOut,
              reverseCurve: NizamioMotion.easeExit,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1).animate(curved),
              alignment: Alignment.bottomLeft,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _FlyoutPanel extends StatelessWidget {
  const _FlyoutPanel({
    required this.semanticLabel,
    required this.entries,
    required this.bottom,
  });

  final String semanticLabel;
  final List<NzFlyoutEntry> entries;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + NizamioSize.appbar;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NizamioSpacing.gutter,
        top,
        NizamioSpacing.gutter,
        bottom,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: NizamioSize.flyoutWidth),
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: semanticLabel,
            child: NzGlass(
              tone: NzGlassTone.menu,
              borderRadius: BorderRadius.circular(NizamioRadius.flyout),
              shadow: context.shadows.menu,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(NizamioSpacing.space2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < entries.length; i++)
                      switch (entries[i]) {
                        final NzFlyoutSection s => _Section(
                          label: s.label,
                          divided: i > 0,
                        ),
                        final NzFlyoutItem item => _Row(item: item),
                      },
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.divided});

  final String label;
  final bool divided;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Padding(
      padding: const EdgeInsets.fromLTRB(
        NizamioSpacing.gapMd,
        NizamioSpacing.space2,
        NizamioSpacing.gapMd,
        NizamioSpacing.space2,
      ),
      child: Semantics(
        header: true,
        child: Text(
          label,
          style: context.text.monoSm.copyWith(color: c.glassInkFaint),
        ),
      ),
    );
    if (!divided) return text;
    return Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space1),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: c.glassEdge, width: NizamioSize.borderWidth),
          ),
        ),
        child: text,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item});

  final NzFlyoutItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final caption = item.caption;
    final icon = item.icon;
    final dot = item.dot;
    void select() {
      Navigator.of(context).pop();
      item.onSelected();
    }

    return Semantics(
      button: true,
      label: caption == null ? item.label : '${item.label}, $caption',
      onTap: select,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: select,
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NizamioSpacing.space12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.gapMd,
                vertical: NizamioSpacing.space1,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: NizamioSpacing.space6,
                    child: Center(
                      child: icon != null
                          ? Icon(
                              icon,
                              size: NizamioSize.iconSizeSm,
                              color: item.accent
                                  ? c.accentText
                                  : c.glassInkFaint,
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                color: dot ?? c.textMuted,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(NizamioSize.dot / 2),
                              ),
                            ),
                    ),
                  ),
                  const Gap(NizamioSpacing.gapMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd.copyWith(
                            color: c.glassInk,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (caption != null)
                          Text(
                            caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: c.glassInkFaint),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
