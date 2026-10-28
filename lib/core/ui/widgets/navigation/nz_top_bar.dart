import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_surfaces.dart';
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
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

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
                        bar.title,
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
