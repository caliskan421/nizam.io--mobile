import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/connectivity_monitor.dart';
import '../../providers.dart';
import '../../theme/generated/tokens.gen.dart';
import '../extensions/context_ext.dart';
import '../layout/layout.dart';
import '../motion/page_content_entrance.dart';
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
       pinned = null,
       after = const [],
       afterKey = null,
       paneLead = null,
       _fill = false,
       _bare = false;

  /// Kök akış sayfası (ana sayfa gibi): [topBar] yapışkan cam sliver'dır (`NzTopBar`), [children]
  /// tek kaydırma görünümünde alt alta dizilir. İçerik üst çubuğun ve (kabuk `extendBody` ile)
  /// yüzen alt menünün altından geçer; sonda alt güvenli alan + menü yüksekliği kadar boşluk
  /// kalır. Yatay boşluk ve azami genişlik standart sayfayla aynıdır.
  /// [pinned] verilirse [children]'dan sonra üst çubuğun altına yapışan cam şerittir (prototip
  /// `position: sticky` sekme hapları); ardından [after] öğeleri gelir. Öğeler tembel kurulur
  /// (uzun listeleri tek `Column` yerine ayrı öğe olarak verin).
  const NzPage.feed({
    super.key,
    required Widget this.topBar,
    required this.children,
    this.width = NzContentWidth.list,
    this.onRetry,
    this.pinned,
    this.after = const [],
    this.afterKey,
    this.paneLead,
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
       pinned = null,
       after = const [],
       width = NzContentWidth.list,
       actions = const [],
       floatingAction = null,
       loading = false,
       showTitleBar = false,
       afterKey = null,
       paneLead = null,
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
      pinned = null,
      after = const [],
      width = NzContentWidth.list,
      actions = const [],
      floatingAction = null,
      loading = false,
      onRetry = null,
      showTitleBar = false,
      afterKey = null,
      paneLead = null,
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

  /// [NzPage.feed]: yapışkan şerit (bkz. yapıcı).
  final Widget? pinned;

  /// [NzPage.feed]: [pinned] şeridinden sonraki öğeler.
  final List<Widget> after;

  /// Sekme kimliği değişince tembel panelin girişini yeniler.
  final Key? afterKey;

  /// Tablet sağ bölmesinde üst çubuk ile ilk öğe arası (kaynak ekranın `gap` + ilk öğenin
  /// negatif `margin-top` toplamı, ör. görev ayrıntısı 12); null → `gap-xl`. Telefonda kullanılmaz.
  final double? paneLead;
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
              SliverFillRemaining(
                hasScrollBody: true,
                child: PageContentEntrance(child: body),
              ),
            ],
          ),
        ),
      );
    }
    if (topBar != null) {
      final safe = MediaQuery.paddingOf(context);
      // Tablet bölmesi (`.tb-pane`): liste bölmesinde kök üst çubuk gizli, içerik üstten 18;
      // iki bölmede de sayfa sonu 40 (telefondaki alt menü payı yok); sağ bölmede yan 28.
      final pane = NzPaneScope.maybeOf(context)?.role;
      final bottom = NzPaneScope.pageBottom(context);
      final top = switch (pane) {
        NzPaneRole.master => safe.top + NzTabletMetrics.paneTop,
        NzPaneRole.detail => paneLead ?? NizamioSpacing.gapXl,
        null => NizamioSpacing.gapXl,
      };
      // Pencere değil, gövdeye ayrılan alan (bölünmüş ekran / yan panel); kısıt sliver'ların
      // üstündeki kutu sınırında okunur.
      return NzTextScaleLimit(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final side = NzPaneScope.sideInset(context, constraints, width);
              return CustomScrollView(
                slivers: [
                  if (pane != NzPaneRole.master) topBar,
                  PageContentEntrance.sliver(
                    child: SliverMainAxisGroup(
                      slivers: [
                        if (offline)
                          SliverToBoxAdapter(
                            child: NzBanner.offline(onAction: onRetry),
                          ),
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            side,
                            top,
                            side,
                            pinned == null ? bottom : 0,
                          ),
                          sliver: SliverList.list(children: children),
                        ),
                        if (pinned case final pinned?) ...[
                          PinnedHeaderSliver(
                            child: NzGlass(
                              tone: NzGlassTone.bar,
                              edge: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: side),
                                child: pinned,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(side, 0, side, bottom),
                            sliver: PageContentEntrance.sliver(
                              key: afterKey,
                              child: SliverList.list(children: after),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
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
        body: PageContentEntrance(
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (offline) NzBanner.offline(onAction: onRetry),
                    Expanded(
                      // Dolgu ve azami genişlik pencereye değil, gövdeye ayrılan alana göre.
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final local = NzLayout.fromConstraints(constraints);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: local.pagePadding,
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: local.contentMaxWidth(width),
                                ),
                                child: body,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (loading) const Positioned.fill(child: _LoadingScrim()),
              ],
            ),
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
