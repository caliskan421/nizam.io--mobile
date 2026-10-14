import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_error_state.dart';

import '../../../../support/golden.dart';
import 'feedback_test_support.dart';

final _network = ApiError(ClientErrorCode.networkError);
ApiError _limited(int seconds) =>
    ApiError('platform.rate_limited', retryAfter: Duration(seconds: seconds));

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    NzErrorState(error: _network, onRetry: () {}),
    cellGap,
    NzErrorState(error: _limited(30), onRetry: () {}),
    cellGap,
    NzErrorState(error: _network),
    cellGap,
    NzErrorState.inline(error: _network, onRetry: () {}),
    cellGap,
    NzErrorState.inline(error: _limited(30), onRetry: () {}),
  ],
);

void main() {
  setUpFonts();

  group('metin', () {
    testWidgets('yalnız errorText; başlık ARB\'den', (tester) async {
      await tester.pumpWidget(testApp(NzErrorState(error: _network)));
      final l = tester.element(find.byType(NzErrorState)).l10n;
      expect(find.text(errorText(l, _network)), findsOneWidget);
      expect(find.text('Bir sorun oluştu'), findsOneWidget);
    });

    testWidgets('bilinmeyen kod genel metne düşer', (tester) async {
      final unknown = ApiError('yeni.bilinmeyen_kod');
      await tester.pumpWidget(testApp(NzErrorState.inline(error: unknown)));
      final l = tester.element(find.byType(NzErrorState)).l10n;
      expect(find.text(errorText(l, unknown)), findsOneWidget);
    });
  });

  group('yeniden dene', () {
    testWidgets('onRetry null → düğme yok', (tester) async {
      await tester.pumpWidget(testApp(NzErrorState(error: _limited(5))));
      expect(find.byType(FilledButton), findsNothing);
      expect(find.text('Yeniden dene'), findsNothing);
      expect(find.text('5'), findsNothing); // geri sayım da yok
      await tester.pump(const Duration(seconds: 10));
    });

    testWidgets('retryAfter yok → düğme etkin, dokunuşta bir kez çağrılır', (
      tester,
    ) async {
      var n = 0;
      await tester.pumpWidget(
        testApp(NzErrorState(error: _network, onRetry: () => n++)),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
      await tester.tap(find.text('Yeniden dene'));
      expect(n, 1);
    });

    testWidgets('dokunma alanı >= 48 (sayfa ve satır içi)', (tester) async {
      await tester.pumpWidget(
        testApp(NzErrorState(error: _network, onRetry: () {})),
      );
      expect(
        tester.getSize(find.byType(FilledButton)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
      );
      await tester.pumpWidget(
        testApp(NzErrorState.inline(error: _network, onRetry: () {})),
      );
      expect(
        tester.getSize(find.byType(TextButton)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
      );
    });

    testWidgets('retryAfter boyunca düğme devre dışı; süre dolunca yalnız '
        'etkinleşir, onRetry KENDİLİĞİNDEN ÇAĞRILMAZ', (tester) async {
      var n = 0;
      await tester.pumpWidget(
        testApp(NzErrorState(error: _limited(3), onRetry: () => n++)),
      );
      bool enabled() =>
          tester.widget<FilledButton>(find.byType(FilledButton)).onPressed !=
          null;

      expect(enabled(), isFalse);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Yeniden denemek için bekleyin'), findsOneWidget);

      // Devre dışı düğmeye dokunuş etkisizdir.
      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      expect(n, 0);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('2'), findsOneWidget);
      expect(enabled(), isFalse);

      await tester.pump(const Duration(seconds: 2));
      expect(enabled(), isTrue);
      expect(find.text('Yeniden denemek için bekleyin'), findsNothing);
      expect(n, 0, reason: 'süre dolunca onRetry kendiliğinden çağrılmamalı');

      await tester.pump(const Duration(seconds: 30));
      expect(n, 0, reason: 'otomatik yeniden deneme yok');

      await tester.tap(find.byType(FilledButton));
      expect(n, 1);
    });

    testWidgets('satır içi: aynı geri sayım sözleşmesi', (tester) async {
      var n = 0;
      await tester.pumpWidget(
        testApp(NzErrorState.inline(error: _limited(2), onRetry: () => n++)),
      );
      bool enabled() =>
          tester.widget<TextButton>(find.byType(TextButton)).onPressed != null;
      expect(enabled(), isFalse);
      expect(find.text('2'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(enabled(), isTrue);
      await tester.pump(const Duration(seconds: 20));
      expect(n, 0);
      await tester.tap(find.byType(TextButton));
      expect(n, 1);
    });

    testWidgets('sıfır süre geri sayım başlatmaz', (tester) async {
      await tester.pumpWidget(
        testApp(NzErrorState(error: _limited(0), onRetry: () {})),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      expect(find.text('Yeniden denemek için bekleyin'), findsNothing);
    });

    testWidgets('yeni hata geri sayımı yeniden başlatır', (tester) async {
      await tester.pumpWidget(
        testApp(NzErrorState(error: _limited(2), onRetry: () {})),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      await tester.pumpWidget(
        testApp(NzErrorState(error: _limited(4), onRetry: () {})),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(find.text('4'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets(
      'ağaçtan çıkınca sayaç iptal edilir (bekleyen zamanlayıcı yok)',
      (tester) async {
        await tester.pumpWidget(
          testApp(NzErrorState(error: _limited(60), onRetry: () {})),
        );
        await tester.pumpWidget(testApp(const SizedBox()));
        // testWidgets sonunda bekleyen Timer kalırsa test düşer.
      },
    );
  });

  testWidgets('anlamsal: geri sayım tek etikette birleşir', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(NzErrorState(error: _limited(7), onRetry: () {})),
    );
    expect(
      find.bySemanticsLabel(RegExp('Yeniden denemek.*7.*sn', dotAll: true)),
      findsOneWidget,
    );
    handle.dispose();
    await tester.pump(const Duration(seconds: 7));
  });

  testWidgets('piksel: tabaka 1024 geniş, tehlike ve birincil renkler', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.dark.primary,
      NizamioColors.light.danger,
      NizamioColors.dark.danger,
    ]);
    await tester.pump(const Duration(seconds: 31));
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_error_state.png'),
      );
      await tester.pump(const Duration(seconds: 31));
    },
  );
}
