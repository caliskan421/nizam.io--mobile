import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/security/privacy_mask.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
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
}
