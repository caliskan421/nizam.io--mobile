// Uygulama kabuğu (W63): `localeProvider` MaterialApp'e bağlıdır; dev flavor prototip modunda
// (login → örnek ana sayfa) açılır, prod faz kapısında kalır.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/app/app.dart';
import 'package:nizamio/app/orientation_policy.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/features/identity/presentation/login_page.dart';
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

  group('yetkisiz dolaşma yok', () {
    for (final flavor in Flavor.values) {
      testWidgets('$flavor: bağ yokken yalnız sunucu ekranı; kabuk açılmaz', (
        tester,
      ) async {
        final h = await _pump(tester, flavor: flavor);
        expect(h.read(appPhaseProvider), AppPhase.unbound);
        expect(find.text(_l.uiServerIntro), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
        expect(find.byType(HomePage), findsNothing);
      });
    }

    testWidgets(
      'doğrulanmış bağ, oturum yok: giriş ekranı; boş gönderim kabuğa geçmez',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 1200);
        addTearDown(tester.view.reset);
        final h = Harness(flavor: Flavor.dev, handler: PilotBackend().handle);
        addTearDown(h.dispose);
        await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: h.container,
            child: const NizamioApp(),
          ),
        );
        await settle(tester);
        expect(find.byType(LoginPage), findsOneWidget);
        await tester.tap(
          find.widgetWithText(NzButton, _l.uiIdentityLoginSubmit),
        );
        await settle(tester);
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(HomePage), findsNothing);
        expect(h.read(appPhaseProvider), AppPhase.serverVerified);
        expect(h.backend.count('POST', '/v1/auth/login'), 0);
      },
    );
  });

  testWidgets(
    'yön politikası kabukta: Android telefon ekranı dikey kilitlenir',
    (tester) async {
      final calls = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'SystemChrome.setPreferredOrientations') {
            calls.add(call.arguments);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      addTearDown(tester.view.display.reset);
      tester.view.display.size = const Size(390, 844);
      await _pump(tester);
      expect(find.byType(OrientationPolicyHost), findsOneWidget);
      expect(calls, [
        ['DeviceOrientation.portraitUp'],
      ]);
    },
  );
}
