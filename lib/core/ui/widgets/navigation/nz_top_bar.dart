import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';
import '../buttons/nz_icon_button.dart';
import '../nz_size.dart';
import '../surfaces/nz_glass.dart';

/// Kök sayfa üst çubuğu (tasarım `AppBar`, kök biçimi) — kaydırma görünümünün ilk sliver'ı:
/// yapışkan, `glass-bar` cam; içerik altından bulanıklaşarak geçer. Solda [leading] (32 px
/// işaret), ürün adı ([title], `m-brand`) ve altında [subtitle] (`m-program`); sağda [actions].
/// Yükseklik: üst güvenli alan + 8 px + `m-appbar` (56; prototip `header` 56 + 8 üst dolgu).
///
/// Çubuk metni en çok [maxTextScale] kadar büyür (sabit yükseklikli gezinme çubuğu; tam metin
/// okuyucu etiketinde kalır).
class NzTopBar extends StatelessWidget {
  const NzTopBar({
    super.key,
    required String this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
  }) : code = null,
       onBack = null,
       backLabel = null,
       _detail = false;

  /// Ayrıntı sayfası çubuğu (görev ayrıntısı, işlem geçmişi, koordinatörlük ayrıntısı): aynı
  /// yapışkan `glass-bar` cam; solda geri düğmesi (48 dokunma), yanında ya soluk mono [code]
  /// (`m-code`, `ink-muted`; ör. `ALT-7`) ya da [title] (17/24 600 → `labelLg`); sağda en çok
  /// iki ikon eylem ([actions], ör. `NzIconButton`). [onBack] null → `Navigator.maybePop`.
  /// [backLabel] null → Material yerel "Geri" metni.
  const NzTopBar.detail({
    super.key,
    this.code,
    this.title,
    this.onBack,
    this.backLabel,
    this.actions = const [],
  }) : assert(code == null || title == null, 'code ve title birlikte verilmez'),
       assert(actions.length <= 2, 'en çok iki eylem'),
       subtitle = null,
       leading = null,
       _detail = true;

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  /// Ayrıntı çubuğunda mono kimlik.
  final String? code;
  final VoidCallback? onBack;
  final String? backLabel;
  final bool _detail;

  static const maxTextScale = 1.3;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _TopBarDelegate(
      top: MediaQuery.paddingOf(context).top,
      bar: this,
    ),
  );
}

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  _TopBarDelegate({required this.top, required this.bar});

  final double top;
  final NzTopBar bar;

  @override
  double get maxExtent => top + NizamioSpacing.space2 + NizamioSize.appbar;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(_TopBarDelegate old) => old.top != top || old.bar != bar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    if (bar._detail) return _detail(context);
    final c = context.colors;
    final t = context.text;
    final subtitle = bar.subtitle;
    return NzGlass(
      tone: NzGlassTone.bar,
      edge: false,
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: NzTopBar.maxTextScale,
        child: Padding(
          padding: EdgeInsets.only(
            top: top + NizamioSpacing.space2,
            left: NizamioSpacing.gutter,
            right: NizamioSpacing.space1,
          ),
          child: Row(
            children: [
              if (bar.leading case final leading?) ...[
                leading,
                const Gap(NizamioSpacing.gapMd),
              ],
              Expanded(
                child: Semantics(
                  header: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bar.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.brand,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.program.copyWith(color: c.textFaint),
                        ),
                    ],
                  ),
                ),
              ),
              ...bar.actions,
            ],
          ),
        ),
      ),
    );
  }
}

extension on _TopBarDelegate {
  Widget _detail(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final code = bar.code;
    final title = bar.title;
    final back = bar.onBack ?? () => Navigator.maybePop(context);
    return NzGlass(
      tone: NzGlassTone.bar,
      edge: false,
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: NzTopBar.maxTextScale,
        child: SizedBox.expand(
          child: Padding(
            // Prototip `header`: 8 px üst ve yan dolgu; düğmeler 44 görsel / 48 dokunma.
            padding: EdgeInsets.only(
              top: top + NizamioSpacing.space2,
              left: NizamioSpacing.space1,
              right: NizamioSpacing.space1,
            ),
            child: Row(
              children: [
                NzIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  semanticLabel:
                      bar.backLabel ??
                      MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: back,
                  size: NzSize.sm,
                ),
                const Gap(NizamioSpacing.space1),
                Expanded(
                  child: code != null
                      ? Text(
                          code,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.mono.copyWith(color: c.textMuted),
                        )
                      : Semantics(
                          header: true,
                          child: Text(
                            title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelLg,
                          ),
                        ),
                ),
                ...bar.actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ürün işareti (üst çubukta 32 px): `accent-top → accent` karo üstünde baş harf. Marka logosu
/// değildir — marka politikası (ad/simge) ayrı karardır; işaret yalnız yerleşimi taşır.
class NzBrandMark extends StatelessWidget {
  const NzBrandMark({super.key, required this.monogram});

  final String monogram;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: c.primaryFill,
          borderRadius: BorderRadius.circular(NizamioRadius.folder),
        ),
        child: SizedBox.square(
          dimension: NizamioSpacing.space8,
          child: Center(
            child: Text(
              monogram,
              textScaler: TextScaler.noScaling,
              style: context.text.brand.copyWith(color: c.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
