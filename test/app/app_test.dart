// Uygulama kabuğu (W63): `localeProvider` MaterialApp'e bağlıdır; dev flavor prototip modunda
// (oturumsuz ana sayfa) açılır, prod faz kapısında kalır.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/app/app.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../features/pilot_support.dart';
import '../support/harness.dart';

final _l = AppLocalizationsTr();

Future<Harness> _pump(
  WidgetTester tester, {
  Flavor flavor = Flavor.prod,
  List<Override> overrides = const [],
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 1200);
  addTearDown(tester.view.reset);
  final h = Harness(flavor: flavor, handler: PilotBackend().handle);
  addTearDown(h.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: h.container,
      child: ProviderScope(
        retry: (_, _) => null,
        overrides: overrides,
        child: const NizamioApp(),
      ),
    ),
  );
  await settle(tester);
  return h;
}

MaterialApp _materialApp(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp));

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('locale tercihten gelir', () {
    testWidgets('açılışta tercihten okunan değer MaterialApp\'e ulaşır', (
      tester,
    ) async {
      final h = await _pump(tester);
      final stored = h.read(localeProvider);
      expect(stored, AppPreferences.supportedLocales.first);
      expect(_materialApp(tester).locale, stored);
      final context = tester.element(find.byType(Scaffold).first);
      expect(Localizations.localeOf(context), stored);
    });

    testWidgets(
      'desteklenen her dil set edilince uygulama yerelini değiştirir',
      (tester) async {
        final h = await _pump(tester);
        final controller = h.read(localeControllerProvider);
        for (final locale in AppPreferences.supportedLocales) {
          await tester.runAsync(() => controller.set(locale));
          await tester.pump();
          expect(_materialApp(tester).locale, locale);
          final context = tester.element(find.byType(Scaffold).first);
          expect(Localizations.localeOf(context), locale);
        }
      },
    );

    testWidgets('desteklenmeyen dil yok sayılır', (tester) async {
      final h = await _pump(tester);
      final before = _materialApp(tester).locale;
      await tester.runAsync(
        () => h.read(localeControllerProvider).set(const Locale('xx')),
      );
      await tester.pump();
      expect(_materialApp(tester).locale, before);
      expect(h.read(localeProvider), before);
    });

    testWidgets(
      'sabit değil: sağlayıcı değeri doğrudan MaterialApp.locale olur',
      (tester) async {
        await _pump(
          tester,
          overrides: [localeProvider.overrideWithValue(const Locale('de'))],
        );
        expect(_materialApp(tester).locale, const Locale('de'));
      },
    );
  });

  group('prototip modu', () {
    testWidgets('prod flavor: faz kapısında açılır', (tester) async {
      await _pump(tester);
      expect(find.text(_l.uiServerIntro), findsOneWidget);
      expect(find.byIcon(Icons.widgets_outlined), findsNothing);
    });

    testWidgets('dev flavor: bağ yokken ana sayfada açılır, faz değişmez', (
      tester,
    ) async {
      final h = await _pump(tester, flavor: Flavor.dev);
      expect(h.read(appPhaseProvider), AppPhase.unbound);
      expect(find.text(_l.uiServerIntro), findsNothing);
      expect(find.byIcon(Icons.widgets_outlined), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
