import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/security/privacy_mask.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_bottom_sheet.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => const Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    NzBottomSheetContent(title: 'Filtrele', child: Text('Sayfa içeriği')),
    cellGap,
    NzBottomSheetContent(
      title: 'Kapatılamaz',
      dismissible: false,
      child: Text('Sayfa içeriği'),
    ),
  ],
);

class _Host extends StatefulWidget {
  const _Host({this.dismissible = true, this.focus, this.tall = false});

  final bool dismissible;
  final FocusNode? focus;
  final bool tall;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  String? result = 'yok';

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        focusNode: widget.focus,
        onPressed: () async {
          final r = await NzBottomSheet.show<String>(
            context,
            title: 'Başlık',
            dismissible: widget.dismissible,
            builder: (sheetContext) => Column(
              children: [
                if (widget.tall)
                  for (var i = 0; i < 40; i++) Text('satır $i'),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop('seçildi'),
                  child: const Text('seç'),
                ),
              ],
            ),
          );
          setState(() => result = r);
        },
        child: const Text('aç'),
      ),
      Text('sonuç: $result'),
    ],
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('aç'));
  await tester.pumpAndSettle();
}

void main() {
  setUpFonts();

  testWidgets('başlık ve içerik gösterilir; içerik sonucu döner', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    expect(find.text('Başlık'), findsOneWidget);
    await tester.tap(find.text('seç'));
    await tester.pumpAndSettle();
    expect(find.text('sonuç: seçildi'), findsOneWidget);
    expect(find.text('Başlık'), findsNothing);
  });

  testWidgets('kapat düğmesi: >= 48, etiketli, null döner', (tester) async {
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    final close = find.byTooltip('Kapat');
    expect(close, findsOneWidget);
    final size = tester.getSize(close);
    expect(size.width, greaterThanOrEqualTo(NizamioSpacing.space12));
    expect(size.height, greaterThanOrEqualTo(NizamioSpacing.space12));
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(find.text('sonuç: null'), findsOneWidget);
  });

  testWidgets('geri tuşu ve dışarı dokunma kapatır (null)', (tester) async {
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('sonuç: null'), findsOneWidget);

    await _open(tester);
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(find.text('Başlık'), findsNothing);
  });

  testWidgets('dismissible:false → geri, dışarı dokunma, kapat düğmesi yok', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const _Host(dismissible: false)));
    await _open(tester);
    expect(find.byTooltip('Kapat'), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Başlık'), findsOneWidget);
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(find.text('Başlık'), findsOneWidget);
    await tester.tap(find.text('seç'));
    await tester.pumpAndSettle();
    expect(find.text('sonuç: seçildi'), findsOneWidget);
  });

  testWidgets('odak: açılınca sayfa içinde, kapanınca açana döner', (
    tester,
  ) async {
    final node = FocusNode(debugLabel: 'trigger');
    addTearDown(node.dispose);
    await tester.pumpWidget(testApp(_Host(focus: node)));
    node.requestFocus();
    await tester.pump();
    await _open(tester);
    expect(node.hasFocus, isFalse);
    await tester.tap(find.byTooltip('Kapat'));
    await tester.pumpAndSettle();
    expect(node.hasPrimaryFocus, isTrue);
  });

  testWidgets('anlamsal: başlık "header" olarak bildirilir', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    expect(
      tester.getSemantics(find.text('Başlık')),
      matchesSemantics(label: 'Başlık', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('uzun içerik kaydırılır; metin ölçeği 2.0 taşmaz', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(compactWidth, 640);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(testApp(const _Host(tall: true)));
    await _open(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsWidgets);
  });

  testWidgets('ayrı Overlay açmaz; PrivacyMask altında kalır', (tester) async {
    final controller = PrivacyMaskController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme(false),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: testLocalizationDelegates,
        builder: (context, child) =>
            PrivacyMask(controller: controller, child: child!),
        home: const Scaffold(body: _Host()),
      ),
    );
    await _open(tester);
    expect(
      find.descendant(
        of: find.byType(PrivacyMask),
        matching: find.byType(NzBottomSheetContent),
      ),
      findsOneWidget,
    );
    controller.value = true;
    await tester.pump();
    expect(find.byKey(const ValueKey('privacy-mask')), findsOneWidget);
  });

  testWidgets('piksel: tabaka 1024 geniş, zemin ve metin renkleri', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.text,
      NizamioColors.dark.text,
    ]);
  });

  goldenTestWidgets(
    'golden: kapatılabilir/kapatılamaz × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_bottom_sheet.png'),
      );
    },
  );

  group('prototip biçimi', () {
    Future<void> openWith(
      WidgetTester tester, {
      String? description,
      bool expandable = false,
      bool withActions = true,
      List<String>? log,
    }) async {
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                final r = await NzBottomSheet.show<String>(
                  context,
                  title: 'Yeni görev',
                  description: description,
                  expandable: expandable,
                  actions: withActions
                      ? (sheet) => [
                          TextButton(
                            onPressed: () => Navigator.of(sheet).pop(),
                            child: const Text('Vazgeç'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(sheet).pop('oluştu'),
                            child: const Text('Oluştur'),
                          ),
                        ]
                      : null,
                  builder: (_) => const Text('gövde'),
                );
                log?.add('$r');
              },
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
    }

    testWidgets('açıklama ve alt eylem satırı (1:2); eylem sonucu döner', (
      tester,
    ) async {
      final log = <String>[];
      await openWith(tester, description: 'Kısa açıklama', log: log);
      expect(find.text('Kısa açıklama'), findsOneWidget);
      final cancel = tester.getSize(find.text('Vazgeç').hitTestable());
      expect(cancel, isNotNull);
      final w1 = tester.getSize(find.byType(TextButton).last).width;
      final w2 = tester.getSize(find.byType(FilledButton)).width;
      expect(w2, greaterThan(w1 * 1.5));
      await tester.tap(find.text('Oluştur'));
      await tester.pumpAndSettle();
      expect(log, ['oluştu']);
    });

    testWidgets('başlık m-sheet-title; zemin surface; tutamak border-control', (
      tester,
    ) async {
      await openWith(tester);
      final ctx = tester.element(find.text('Yeni görev'));
      final title = tester.widget<Text>(find.text('Yeni görev'));
      expect(title.style!.fontSize, NizamioTypography.sheetTitle.size);
      expect(
        find.descendant(
          of: find.byType(NzBottomSheetContent),
          matching: find.byWidgetPredicate(
            (w) =>
                w is DecoratedBox &&
                (w.decoration as BoxDecoration?)?.color ==
                    NizamioColors.light.borderControl,
          ),
        ),
        findsOneWidget,
      );
      expect(ctx, isNotNull);
    });

    testWidgets('expandable: tutamak genişletir/daraltır (anlamsal durum)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await openWith(tester, expandable: true, withActions: false);
      final h0 = tester.getSize(find.byType(NzBottomSheetContent)).height;
      await tester.tap(find.bySemanticsLabel('Genişlet'));
      await tester.pumpAndSettle();
      final h1 = tester.getSize(find.byType(NzBottomSheetContent)).height;
      expect(h1, greaterThan(h0));
      expect(find.bySemanticsLabel('Daralt'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Daralt'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(NzBottomSheetContent)).height, h0);
      handle.dispose();
    });

    testWidgets('360 / 2.0 metin, eylemli: taşma yok', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(compactWidth, 640);
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await openWith(tester, description: 'Uzun bir açıklama metni burada');
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('dış genişlik denetimi (expansion) ve başlık eylemi', (
    tester,
  ) async {
    final expansion = ValueNotifier(false);
    var cleared = 0;
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => NzBottomSheet.show<void>(
              context,
              title: 'Filtreler',
              expandable: true,
              expansion: expansion,
              headerAction: TextButton(
                onPressed: () => cleared++,
                child: const Text('Tümünü temizle'),
              ),
              builder: (_) => const Text('içerik'),
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tümünü temizle'));
    expect(cleared, 1);
    final h0 = tester.getSize(find.byType(NzBottomSheetContent)).height;
    expansion.value = true;
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(NzBottomSheetContent)).height,
      greaterThan(h0),
    );
    expansion.value = false;
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(NzBottomSheetContent)).height, h0);
  });

  testWidgets('showHeader:false → başlık ve kapat çizilmez; ad semantikte', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => NzBottomSheet.show<void>(
              context,
              title: 'Mesaj işlemleri',
              showHeader: false,
              builder: (_) => const Text('içerik'),
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    expect(find.text('içerik'), findsOneWidget);
    expect(find.text('Mesaj işlemleri'), findsNothing);
    expect(find.byTooltip('Kapat'), findsNothing);
    expect(find.bySemanticsLabel('Mesaj işlemleri'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('içerik'), findsNothing);
    handle.dispose();
  });

  testWidgets(
    'compact: küçük başlık (header), kapat düğmesi yok; dışarı kapatır',
    (tester) async {
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => NzBottomSheet.show<void>(
                context,
                title: 'durum',
                compact: true,
                builder: (_) => const Text('Devam ediyor'),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
      expect(find.text('durum'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      final style = tester.widget<Text>(find.text('durum')).style;
      final ctx = tester.element(find.text('Devam ediyor'));
      expect(style?.fontSize, ctx.text.kicker.fontSize);
      expect(
        tester.getSemantics(find.text('durum')),
        matchesSemantics(isHeader: true, label: 'durum'),
      );
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Devam ediyor'), findsNothing);
    },
  );

  testWidgets(
    'kök Navigator: iç gezgindeki sayfadan açılınca alt menüyü örter',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.reset);
      var navTaps = 0;
      await tester.pumpWidget(
        testApp(
          Stack(
            children: [
              // Kabuk benzeri: sekme içeriği iç Navigator'da, alt menü onun üstünde.
              Navigator(
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (context) => Center(
                    child: TextButton(
                      onPressed: () => NzBottomSheet.show<void>(
                        context,
                        title: 'Filtreler',
                        builder: (_) => const Text('içerik'),
                      ),
                      child: const Text('aç'),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 64,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => navTaps++,
                  child: const Text('alt menü'),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
      expect(find.text('içerik'), findsOneWidget);
      // Sayfa alt menünün üstünde: alt kenardaki dokunuş menüye ulaşmaz.
      await tester.tapAt(const Offset(195, 830));
      await tester.pump();
      expect(navTaps, 0);
    },
  );

  group('tablet merkezi modal (prototip [role=dialog])', () {
    Future<Rect> open(WidgetTester tester, Size window) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = window;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => NzBottomSheet.show<void>(
                context,
                title: 'Yeni görev',
                builder: (_) => const SizedBox(height: 2000, child: Text('g')),
              ),
              child: const Text('aç'),
            ),
          ),
          dark: true,
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
      return tester.getRect(find.byType(NzBottomSheetContent));
    }

    for (final w in const [
      Size(1180, 820),
      Size(1376, 1032),
      Size(840, 1000),
    ]) {
      testWidgets('$w: ortada min(560, W−48), en çok H−64', (tester) async {
        final r = await open(tester, w);
        expect(find.byType(Dialog), findsOneWidget);
        expect(r.width, closeTo(w.width - 48 < 560 ? w.width - 48 : 560, 0.01));
        expect(r.height, lessThanOrEqualTo(w.height - 64 + 0.01));
        expect(r.center.dx, closeTo(w.width / 2, 0.5));
        expect(r.center.dy, closeTo(w.height / 2, 0.5));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets(
      'açılış modalın kendi boyu kadar kayar (.42 s); kapanış .24 s',
      (tester) async {
        final end = await open(tester, const Size(1180, 820));
        Navigator.of(tester.element(find.byType(NzBottomSheetContent))).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 239));
        expect(find.byType(NzBottomSheetContent), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 2));
        await tester.pump();
        expect(find.byType(NzBottomSheetContent), findsNothing);
        await tester.tap(find.text('aç'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        final start = tester.getRect(find.byType(NzBottomSheetContent));
        // Başlangıçta tam kendi yüksekliği kadar aşağıda (translateY(100%)), pencere boyu değil.
        expect(start.top - end.top, closeTo(end.height, end.height * 0.01));
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byType(NzBottomSheetContent)), end);
      },
    );

    testWidgets('karartma .3 s\'de tam (sayfa .42 s sürerken)', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1180, 820);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => NzBottomSheet.show<void>(
                context,
                title: 'Yeni görev',
                builder: (_) => const Text('g'),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      final scrim = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.byType(ColoredBox),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(scrim.opacity.value, closeTo(1, 0.001));
      await tester.pumpAndSettle();
    });

    testWidgets('telefonda ve tek bölmede alttan sayfa kalır', (tester) async {
      await open(tester, const Size(820, 1180));
      expect(find.byType(Dialog), findsNothing);
      final r = await open(tester, const Size(390, 844));
      expect(find.byType(Dialog), findsNothing);
      expect(r.bottom, 844);
    });
  });
}
