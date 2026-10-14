import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/security/privacy_mask.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_toast.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

/// Kurulur kurulmaz [tone] ile bir toast gösterir (golden tabakası için).
class _Fire extends StatefulWidget {
  const _Fire(this.tone);

  final NzToastTone tone;

  @override
  State<_Fire> createState() => _FireState();
}

class _FireState extends State<_Fire> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => NzToast.show(context, 'Kayıt tamamlandı', tone: widget.tone),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

Widget _variants(BuildContext context) => Column(
  children: [
    for (final tone in NzToastTone.values)
      SizedBox(
        height: 120,
        child: ScaffoldMessenger(child: Scaffold(body: _Fire(tone))),
      ),
  ],
);

Widget _trigger(void Function(BuildContext) fire) => Builder(
  builder: (context) =>
      TextButton(onPressed: () => fire(context), child: const Text('göster')),
);

Future<void> _tapShow(WidgetTester tester) async {
  await tester.tap(find.text('göster'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// Toast'lar ilk karede tetiklenir; giriş animasyonu ikinci sabit adımda tamamlanır.
Future<void> _pumpToasts(WidgetTester tester) async {
  await pumpSheet(tester, _variants);
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUpFonts();

  testWidgets('show: ileti ve varsayılan ton (info)', (tester) async {
    await tester.pumpWidget(
      testApp(_trigger((c) => NzToast.show(c, 'Merhaba'))),
    );
    await _tapShow(tester);
    expect(find.text('Merhaba'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      NizamioColors.light.text,
    );
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('ton → arka plan rolü', (tester) async {
    final expected = {
      NzToastTone.info: NizamioColors.light.text,
      NzToastTone.success: NizamioColors.light.success,
      NzToastTone.danger: NizamioColors.light.danger,
    };
    for (final MapEntry(:key, :value) in expected.entries) {
      await tester.pumpWidget(
        testApp(_trigger((c) => NzToast.show(c, 'x', tone: key))),
      );
      await _tapShow(tester);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        value,
        reason: '$key',
      );
      await tester.pump(const Duration(seconds: 10));
    }
  });

  testWidgets('success kısayolu başarı tonudur', (tester) async {
    await tester.pumpWidget(
      testApp(_trigger((c) => NzToast.success(c, 'Kaydedildi'))),
    );
    await _tapShow(tester);
    expect(find.text('Kaydedildi'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      NizamioColors.light.success,
    );
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('error: metin yalnız errorText, tehlike tonu', (tester) async {
    final err = ApiError(ClientErrorCode.networkError);
    await tester.pumpWidget(testApp(_trigger((c) => NzToast.error(c, err))));
    await _tapShow(tester);
    final l = tester.element(find.byType(SnackBar)).l10n;
    expect(find.text(errorText(l, err)), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      NizamioColors.light.danger,
    );
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('eylem: etiket gösterilir ve dokunuşta çağrılır', (tester) async {
    var n = 0;
    await tester.pumpWidget(
      testApp(
        _trigger(
          (c) => NzToast.show(
            c,
            'Silindi',
            actionLabel: 'Geri al',
            onAction: () => n++,
          ),
        ),
      ),
    );
    await _tapShow(tester);
    await tester.tap(find.text('Geri al'));
    expect(n, 1);
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('yeni toast öncekinin yerini alır (kuyruk birikmez)', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (c) => Column(
            children: [
              TextButton(
                onPressed: () => NzToast.show(c, 'birinci'),
                child: const Text('a'),
              ),
              TextButton(
                onPressed: () => NzToast.show(c, 'ikinci'),
                child: const Text('b'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('a'));
    await tester.pump();
    await tester.tap(find.text('b'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('birinci'), findsNothing);
    expect(find.text('ikinci'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
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
        home: Scaffold(body: _trigger((c) => NzToast.show(c, 'Gizli içerik'))),
      ),
    );
    final overlays = find.byType(Overlay).evaluate().length;
    await _tapShow(tester);
    expect(find.byType(Overlay).evaluate().length, overlays);
    expect(
      find.descendant(
        of: find.byType(PrivacyMask),
        matching: find.byType(SnackBar),
      ),
      findsOneWidget,
    );
    controller.value = true;
    await tester.pump();
    // Toast içeriğin parçasıdır; maske aynı Stack'te onun ÜSTÜNE biner.
    expect(find.byKey(const ValueKey('privacy-mask')), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
  });

  test('actionLabel ve onAction birlikte verilmelidir', () {
    // assert, BuildContext gerektirmeden önce çalışır.
    expect(
      () => NzToast.show(_NoContext(), 'x', actionLabel: 'a'),
      throwsAssertionError,
    );
  });

  testWidgets('piksel: tabaka 1024 geniş, ton arka planları', (tester) async {
    await _pumpToasts(tester);
    await expectSheetPixels(tester, [
      NizamioColors.light.text,
      NizamioColors.light.success,
      NizamioColors.light.danger,
      NizamioColors.dark.text,
      NizamioColors.dark.success,
      NizamioColors.dark.danger,
    ]);
    await tester.pump(const Duration(seconds: 10));
  });

  goldenTestWidgets(
    'golden: bütün tonlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await _pumpToasts(tester);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_toast.png'),
      );
      await tester.pump(const Duration(seconds: 10));
    },
  );
}

class _NoContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
