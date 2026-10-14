import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/security/privacy_mask.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_dialog.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => const Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    NzConfirmDialog(
      title: 'Kaydı onayla',
      message: 'Bu işlem kaydı onaylar.',
      confirmLabel: 'Onayla',
    ),
    cellGap,
    NzConfirmDialog(
      title: 'Kaydı sil',
      message: 'Bu işlem geri alınamaz.',
      confirmLabel: 'Sil',
      tone: NzDialogTone.destructive,
    ),
  ],
);

/// Açma düğmesi + son sonuç göstergesi.
class _Host extends StatefulWidget {
  const _Host({this.tone = NzDialogTone.normal, this.focus});

  final NzDialogTone tone;
  final FocusNode? focus;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool? result;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        focusNode: widget.focus,
        onPressed: () async {
          final r = await NzDialog.confirm(
            context,
            title: 'Başlık',
            message: 'İleti',
            confirmLabel: 'Evet',
            tone: widget.tone,
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

Finder _button(String label) =>
    find.widgetWithText(NzButton, label, skipOffstage: false);

void main() {
  setUpFonts();

  testWidgets('başlık, ileti ve düğmeler gösterilir; iptal etiketi ARB', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('İleti'), findsOneWidget);
    expect(_button('Evet'), findsOneWidget);
    expect(_button('İptal'), findsOneWidget);
  });

  testWidgets('onay → true', (tester) async {
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    await tester.tap(find.text('Evet'));
    await tester.pumpAndSettle();
    expect(find.text('sonuç: true'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  for (final tone in NzDialogTone.values) {
    group('$tone', () {
      testWidgets('iptal düğmesi → false', (tester) async {
        await tester.pumpWidget(testApp(_Host(tone: tone)));
        await _open(tester);
        await tester.tap(find.text('İptal'));
        await tester.pumpAndSettle();
        expect(find.text('sonuç: false'), findsOneWidget);
      });

      testWidgets('geri tuşu → false (onay değil)', (tester) async {
        await tester.pumpWidget(testApp(_Host(tone: tone)));
        await _open(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('sonuç: false'), findsOneWidget);
      });

      testWidgets('dışarı dokunma → false (onay değil)', (tester) async {
        await tester.pumpWidget(testApp(_Host(tone: tone)));
        await _open(tester);
        await tester.tapAt(const Offset(2, 2));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('sonuç: false'), findsOneWidget);
      });
    });
  }

  testWidgets('birincil eylem rengi: normal → primary, yıkıcı → danger', (
    tester,
  ) async {
    Color? fill(String label) => tester
        .widget<FilledButton>(
          find.descendant(
            of: _button(label),
            matching: find.byType(FilledButton),
          ),
        )
        .style!
        .backgroundColor!
        .resolve({});

    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    expect(fill('Evet'), NizamioColors.light.primary);
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      testApp(const _Host(tone: NzDialogTone.destructive)),
    );
    await _open(tester);
    expect(fill('Evet'), NizamioColors.light.danger);
    // İptal düğmesi birincil değil (dolgusuz).
    expect(
      find.descendant(
        of: _button('İptal'),
        matching: find.byType(FilledButton),
      ),
      findsNothing,
    );
  });

  testWidgets('dokunma alanı >= 48 ve özel iptal etiketi', (tester) async {
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (c) => TextButton(
            onPressed: () => NzDialog.confirm(
              c,
              title: 'T',
              confirmLabel: 'Tamam mı',
              cancelLabel: 'Vazgeç',
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    );
    await _open(tester);
    expect(_button('Vazgeç'), findsOneWidget);
    for (final l in ['Vazgeç', 'Tamam mı']) {
      expect(
        tester.getSize(_button(l)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
      );
    }
  });

  testWidgets('odak: açılınca diyalog içinde, kapanınca açana döner', (
    tester,
  ) async {
    final node = FocusNode(debugLabel: 'trigger');
    addTearDown(node.dispose);
    await tester.pumpWidget(testApp(_Host(focus: node)));
    node.requestFocus();
    await tester.pump();
    expect(node.hasPrimaryFocus, isTrue);
    await _open(tester);
    final dialog = tester.element(find.byType(AlertDialog));
    expect(node.hasFocus, isFalse);
    expect(FocusScope.of(dialog).hasFocus, isTrue);
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();
    expect(node.hasPrimaryFocus, isTrue);
  });

  testWidgets('anlamsal: diyalog başlığı anlamsal etiketli', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const _Host()));
    await _open(tester);
    expect(
      tester.getSemantics(find.text('Başlık')),
      matchesSemantics(label: 'Başlık'),
    );
    handle.dispose();
  });

  testWidgets('metin ölçeği 2.0, dar genişlik: taşma yok, düğmeler erişilir', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(compactWidth, 640);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      testApp(const _Host(tone: NzDialogTone.destructive)),
    );
    await _open(tester);
    expect(tester.takeException(), isNull);
    expect(_button('Evet'), findsOneWidget);
    await tester.tap(find.text('Evet'));
    await tester.pumpAndSettle();
    expect(find.text('sonuç: true'), findsOneWidget);
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
        matching: find.byType(AlertDialog),
      ),
      findsOneWidget,
    );
    controller.value = true;
    await tester.pump();
    expect(find.byKey(const ValueKey('privacy-mask')), findsOneWidget);
  });

  testWidgets('piksel: tabaka 1024 geniş, birincil/tehlike dolguları', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.light.danger,
      NizamioColors.dark.primary,
      NizamioColors.dark.danger,
    ]);
  });

  goldenTestWidgets(
    'golden: normal/yıkıcı × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_dialog.png'),
      );
    },
  );
}
