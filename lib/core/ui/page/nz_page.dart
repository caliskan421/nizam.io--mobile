import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/connectivity_monitor.dart';
import '../../providers.dart';
import '../../theme/generated/tokens.gen.dart';
import '../extensions/context_ext.dart';
import '../layout/layout.dart';
import '../theme/nz_surfaces.dart';
import '../widgets/feedback/nz_banner.dart';
import '../widgets/feedback/nz_loader.dart';
import '../widgets/surfaces/nz_glass.dart';

/// Her ekranın kabuğu (U6: features presentation'da Scaffold yasağının tek karşılığı).
///
/// Scaffold + SafeArea + [NzTextScaleLimit] + yatay `pagePadding` + [NzContentWidth] azami
/// genişliği (ortalanır) + bağlantı çevrimdışıyken gövdenin üstünde [NzBanner.offline] +
/// [loading] iken dokunmayı kesen [NzLoader] örtüsü. Kendi Overlay'i yoktur: şerit ve örtü
/// sayfa ağacının parçasıdır, `MaterialApp.builder`'daki PrivacyMask'ın altında kalır.
///
/// [onRetry] yalnız kullanıcı dokunuşuyla çalışır (çevrimiçine dönüşte otomatik deneme yok).
class NzPage extends ConsumerWidget {
  const NzPage({
    super.key,
    required this.title,
    required this.body,
    this.width = NzContentWidth.list,
    this.actions = const [],
    this.floatingAction,
    this.loading = false,
    this.onRetry,
    this.showTitleBar = true,
  }) : topBar = null,
       children = const [],
       sticky = null,
       stickyChildren = const [],
       _fill = false,
       _bare = false;

  /// Kök akış sayfası (ana sayfa gibi): [topBar] yapışkan cam sliver'dır (`NzTopBar`), [children]
  /// tek kaydırma görünümünde alt alta dizilir. İçerik üst çubuğun ve (kabuk `extendBody` ile)
  /// yüzen alt menünün altından geçer; sonda alt güvenli alan + menü yüksekliği kadar boşluk
  /// kalır. Yatay boşluk ve azami genişlik standart sayfayla aynıdır.
  ///
  /// [sticky] verilirse [children]'dan sonra üst çubuğun altına yapışan cam şerittir
  /// (prototip ayrıntı sekmeleri: `position: sticky; top: 64px`, 6/10 dikey dolgu, tam
  /// genişlik cam zemin); [stickyChildren] şeridin altında akar.
  const NzPage.feed({
    super.key,
    required Widget this.topBar,
    required this.children,
    this.width = NzContentWidth.list,
    this.onRetry,
    this.sticky,
    this.stickyChildren = const [],
  }) : title = '',
       body = const SizedBox.shrink(),
       actions = const [],
       floatingAction = null,
       loading = false,
       showTitleBar = false,
       _fill = false,
       _bare = false;

  /// Kabuk dışı tam ekran sayfa (zaman çizelgesi gibi): [topBar] kök/ayrıntı üst çubuğu
  /// sliver'ı, [body] kalan yüksekliği doldurur ve kendi kaydırmasını yönetir (dış görünüm
  /// kaymaz). Yatay boşluk ve alt güvenli alan [body]'nindir.
  const NzPage.fill({
    super.key,
    required Widget this.topBar,
    required this.body,
    this.onRetry,
  }) : title = '',
       children = const [],
       sticky = null,
       stickyChildren = const [],
       width = NzContentWidth.list,
       actions = const [],
       floatingAction = null,
       loading = false,
       showTitleBar = false,
       _fill = true,
       _bare = false;

  /// Kendi üst ve alt çubuğunu çizen tam ekran sayfa (sohbet gibi): AppBar, yatay dolgu ve
  /// güvenli alan yoktur; [body] bütün alanı alır ve güvenli alanı/klavyeyi kendisi yönetir
  /// (`MediaQuery.paddingOf` / `viewInsetsOf`; Scaffold gövdeyi klavye için küçültmez).
  /// Metin ölçeği sınırı ve toast kabuğu (Scaffold) standart sayfayla aynıdır.
  const NzPage.bare({super.key, required this.body})
    : title = '',
      topBar = null,
      children = const [],
      sticky = null,
      stickyChildren = const [],
      width = NzContentWidth.list,
      actions = const [],
      floatingAction = null,
      loading = false,
      onRetry = null,
      showTitleBar = false,
      _fill = false,
      _bare = true;

  /// AppBar başlığı (ARB'den).
  final String title;

  /// false → üst AppBar çizilmez (giriş gibi başlığını gövdede taşıyan tam ekranlar).
  final bool showTitleBar;
  final Widget body;

  /// [NzPage.feed]: üst çubuk sliver'ı.
  final Widget? topBar;

  /// [NzPage.feed]: akış öğeleri (aralarındaki boşluğu çağıran `Gap` ile verir).
  final List<Widget> children;

  /// [NzPage.feed]: üst çubuğa yapışan şerit (ör. sekmeler) ve altındaki akış.
  final Widget? sticky;
  final List<Widget> stickyChildren;
  final NzContentWidth width;

  /// AppBar eylemleri.
  final List<Widget> actions;
  final Widget? floatingAction;
  final bool loading;

  /// Çevrimdışı şeridindeki "yeniden dene".
  final VoidCallback? onRetry;
  final bool _fill;

  final bool _bare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline =
        ref.watch(connectivityStateProvider) == ConnectivityState.offline;
    if (_bare) {
      return NzTextScaleLimit(
        child: Scaffold(resizeToAvoidBottomInset: false, body: body),
      );
    }
    final layout = context.layout;
    final topBar = this.topBar;
    if (topBar != null && _fill) {
      return NzTextScaleLimit(
        child: Scaffold(
          body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              topBar,
              if (offline)
                SliverToBoxAdapter(child: NzBanner.offline(onAction: onRetry)),
              SliverFillRemaining(hasScrollBody: true, child: body),
            ],
          ),
        ),
      );
    }
    if (topBar != null) {
      final side = layout.pagePadding;
      final extra =
          (MediaQuery.sizeOf(context).width -
                  2 * side -
                  layout.contentMaxWidth(width))
              .clamp(0, double.infinity) /
          2;
      final bottom =
          MediaQuery.paddingOf(context).bottom + NizamioSpacing.gapXl;
      return NzTextScaleLimit(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              topBar,
              if (offline)
                SliverToBoxAdapter(child: NzBanner.offline(onAction: onRetry)),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  side + extra,
                  NizamioSpacing.gapXl,
                  side + extra,
                  sticky == null ? bottom : 0,
                ),
                sliver: SliverList.list(children: children),
              ),
              if (sticky case final bar?) ...[
                PinnedHeaderSliver(
                  child: NzGlass(
                    tone: NzGlassTone.bar,
                    edge: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        side + extra,
                        NizamioSpacing.space1 + 2,
                        side + extra,
                        NizamioSpacing.gapMd,
                      ),
                      child: bar,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    side + extra,
                    NizamioSpacing.space1,
                    side + extra,
                    bottom,
                  ),
                  sliver: SliverList.list(children: stickyChildren),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return NzTextScaleLimit(
      child: Scaffold(
        appBar: showTitleBar
            ? AppBar(title: Text(title), actions: actions)
            : null,
        floatingActionButton: floatingAction,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (offline) NzBanner.offline(onAction: onRetry),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: layout.pagePadding,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: layout.contentMaxWidth(width),
                          ),
                          child: body,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (loading) const Positioned.fill(child: _LoadingScrim()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dokunmayı keser; gövdeyi yarı saydam örter, ortada [NzLoader.page].
class _LoadingScrim extends StatelessWidget {
  const _LoadingScrim();

  @override
  Widget build(BuildContext context) => AbsorbPointer(
    child: ColoredBox(
      color: context.colors.background.withValues(alpha: 0.6),
      child: const NzLoader.page(),
    ),
  );
}
