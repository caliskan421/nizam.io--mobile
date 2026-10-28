// NzPage: kabuk düzeni, çevrimdışı şerit, yükleme örtüsü, metin ölçeği, PrivacyMask altında.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/security/privacy_mask.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/layout/layout.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_banner.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_loader.dart';

const _bodyKey = ValueKey('body');

Widget _app(
  Widget page, {
  ConnectivityState connectivity = ConnectivityState.online,
  PrivacyMaskController? mask,
}) => ProviderScope(
  overrides: [connectivityStateProvider.overrideWithValue(connectivity)],
  child: MaterialApp(
    theme: AppTheme.light(),
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: mask == null
        ? null
        : (context, child) => PrivacyMask(controller: mask, child: child!),
    home: page,
  ),
);

void _size(WidgetTester tester, double width, [double height = 800]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('showTitleBar false: AppBar yok, gövde çizilir', (tester) async {
    await tester.pumpWidget(
      _app(
        const NzPage(title: 'Başlık', showTitleBar: false, body: Text('gövde')),
      ),
    );
    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Başlık'), findsNothing);
    expect(find.text('gövde'), findsOneWidget);
  });

  testWidgets('başlık ve gövde çizilir; Scaffold kabuğu', (tester) async {
    await tester.pumpWidget(
      _app(const NzPage(title: 'Başlık', body: Text('gövde'))),
    );
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('gövde'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(NzBanner), findsNothing);
    expect(find.byType(NzLoader), findsNothing);
  });

  for (final (kind, max) in [
    (NzContentWidth.form, 480.0),
    (NzContentWidth.reading, 720.0),
    (NzContentWidth.list, 960.0),
  ]) {
    testWidgets('$kind: gövde azami $max dp, ortalı', (tester) async {
      _size(tester, 1400);
      await tester.pumpWidget(
        _app(
          NzPage(
            title: 't',
            width: kind,
            body: Container(key: _bodyKey),
          ),
        ),
      );
      final r = tester.getRect(find.byKey(_bodyKey));
      expect(r.width, max);
      expect(r.center.dx, 700);
    });
  }

  testWidgets('dar pencerede yatay boşluk pagePadding (16)', (tester) async {
    _size(tester, 400);
    await tester.pumpWidget(
      _app(
        NzPage(
          title: 't',
          body: Container(key: _bodyKey),
        ),
      ),
    );
    final r = tester.getRect(find.byKey(_bodyKey));
    expect(r.left, NizamioSpacing.space4);
    expect(r.right, 400 - NizamioSpacing.space4);
  });

  testWidgets('çevrimdışı: şerit görünür, dokunuş onRetry çağırır', (
    tester,
  ) async {
    var retried = 0;
    await tester.pumpWidget(
      _app(
        NzPage(title: 't', body: const Text('x'), onRetry: () => retried++),
        connectivity: ConnectivityState.offline,
      ),
    );
    expect(find.byType(NzBanner), findsOneWidget);
    expect(retried, 0, reason: 'kendiliğinden deneme yok');
    await tester.tap(find.text('Yeniden dene'));
    await tester.pump();
    expect(retried, 1);
  });

  testWidgets(
    'fill: üst çubuk + gövde kalan yüksekliği doldurur; çevrimdışı şerit',
    (tester) async {
      _size(tester, 390);
      var retried = 0;
      await tester.pumpWidget(
        _app(
          NzPage.fill(
            topBar: const SliverToBoxAdapter(
              child: SizedBox(height: 60, child: Text('çubuk')),
            ),
            body: const ColoredBox(key: _bodyKey, color: Color(0x00000000)),
            onRetry: () => retried++,
          ),
          connectivity: ConnectivityState.offline,
        ),
      );
      expect(find.text('çubuk'), findsOneWidget);
      final banner = tester.getSize(find.byType(NzBanner)).height;
      expect(tester.getSize(find.byKey(_bodyKey)).height, 800 - 60 - banner);
      await tester.tap(find.text('Yeniden dene'));
      expect(retried, 1);
    },
  );

  for (final s in [ConnectivityState.online, ConnectivityState.unknown]) {
    testWidgets('$s: şerit yok', (tester) async {
      await tester.pumpWidget(
        _app(
          const NzPage(title: 't', body: Text('x')),
          connectivity: s,
        ),
      );
      expect(find.byType(NzBanner), findsNothing);
    });
  }

  testWidgets('loading: NzLoader örtüsü görünür ve dokunmayı keser', (
    tester,
  ) async {
    var taps = 0;
    Widget page(bool loading) => _app(
      NzPage(
        title: 't',
        loading: loading,
        body: TextButton(onPressed: () => taps++, child: const Text('düğme')),
      ),
    );
    await tester.pumpWidget(page(false));
    await tester.tap(find.text('düğme'));
    expect(taps, 1);
    expect(find.byType(NzLoader), findsNothing);

    await tester.pumpWidget(page(true));
    expect(find.byType(NzLoader), findsOneWidget);
    await tester.tap(find.text('düğme'), warnIfMissed: false);
    expect(taps, 1, reason: 'örtü dokunmayı keser');
  });

  testWidgets('metin ölçeği 2.0 ile sınırlanır', (tester) async {
    late double seen;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(3)),
        child: _app(
          NzPage(
            title: 't',
            body: Builder(
              builder: (c) {
                seen = MediaQuery.textScalerOf(c).scale(10) / 10;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
    expect(seen, NzTextScaleLimit.defaultMaxScaleFactor);
  });

  testWidgets('PrivacyMask açıkken şerit/örtü maskenin üstünde görünmez', (
    tester,
  ) async {
    final mask = PrivacyMaskController();
    addTearDown(mask.dispose);
    await tester.pumpWidget(
      _app(
        const NzPage(title: 't', body: Text('x'), loading: true),
        connectivity: ConnectivityState.offline,
        mask: mask,
      ),
    );
    final key = find.byKey(const ValueKey('privacy-mask'));
    expect(key, findsNothing);
    mask.value = true;
    await tester.pump();
    expect(key, findsOneWidget);

    // Maske, sayfanın (şerit + örtü) kardeşi olarak SONDA çizilir; sayfa maskeyi aşan kendi
    // Overlay'ini açmaz: maskeyle aynı Stack'te yalnız [uygulama, maske] vardır.
    final stack = find.ancestor(of: key, matching: find.byType(Stack)).first;
    final children = tester.widget<Stack>(stack).children;
    expect(children.last, isA<Positioned>());
    expect(
      find.descendant(of: stack, matching: find.byType(NzBanner)),
      findsOneWidget,
    );
    expect(
      find.byType(Overlay),
      findsOneWidget,
      reason: 'tek (Navigator) Overlay',
    );

    // Şeridin merkezinde dokunuş isabeti maskeye gider (maske üstte).
    final hit = tester.hitTestOnBinding(
      tester.getCenter(find.byType(NzBanner)),
    );
    final maskObject = tester.renderObject(key);
    final targets = hit.path.map((e) => e.target).toList();
    expect(targets, contains(maskObject));
    expect(
      targets,
      isNot(contains(tester.renderObject(find.byType(NzBanner)))),
      reason: 'şerit maskenin altında kalır; dokunuşu maske keser',
    );
  });

  testWidgets(
    'bare: AppBar ve dolgu yok, gövde tam alan; klavye gövdeyi küçültmez',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(const NzPage.bare(body: SizedBox.expand(key: _bodyKey))),
      );
      expect(find.byType(AppBar), findsNothing);
      expect(tester.getSize(find.byKey(_bodyKey)), const Size(390, 844));
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.resizeToAvoidBottomInset, isFalse);
    },
  );
}
