// UpdateRequiredPage: açık "güncelleme gerekli" ekranı; giriş başlamaz. compact + expanded.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/features/server/presentation/update_required_page.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('sürümler görünür; giriş alanı yok; giriş isteği çıkmaz', (
    tester,
    screen,
  ) async {
    final h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
    addTearDown(h.dispose);
    await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
    expect(h.read(bindingStateProvider), isA<BindingUpdateRequired>());
    await pumpScreen(tester, h, const UpdateRequiredPage());
    expect(find.text(_l.uiServerUpdateTitle), findsWidgets);
    expect(find.text(_l.uiServerUpdateMessage), findsOneWidget);
    expect(find.text('99.0.0'), findsOneWidget);
    expect(find.text(_l.uiServerUpdateRequiredVersion), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(h.backend.count('POST', '/v1/auth/login'), 0);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testWidgets('"Yeniden denetle" aynı adresi yeniden doğrular', (tester) async {
    final h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
    addTearDown(h.dispose);
    await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
    await pumpScreen(tester, h, const UpdateRequiredPage());
    final before = h.backend.count('GET', '/.well-known/nizamio-instance');
    await tester.tap(find.text(_l.uiServerUpdateRecheck));
    await settle(tester);
    expect(h.backend.count('GET', '/.well-known/nizamio-instance'), before + 1);
  });

  group('API sürümü uyumsuzluğu (CX-W51-5)', () {
    // Keşif ucu v1, profil ucu v2: yalnız profil adımında uyumsuzluk.
    ResponseBody profileV2(Seen r) => r.path == '/v1/instance/profile'
        ? discoveryHandler(r, api: 'v2')
        : discoveryHandler(r);
    final cases = <String, ResponseBody Function(Seen)>{
      'keşif': (r) => discoveryHandler(r, api: 'v2'),
      'profil': profileV2,
    };
    cases.forEach((name, handler) {
      testScreens(
        '$name uyumsuzluğu: API gerekçesi görünür, giriş yok, giriş isteği çıkmaz',
        (tester, screen) async {
          final h = Harness(handler: handler);
          addTearDown(h.dispose);
          await real(
            tester,
            () => h.read(serverBindingProvider).verify(testUrl),
          );
          expect(h.read(bindingStateProvider), isA<BindingFailed>());
          expect(h.read(appPhaseProvider), AppPhase.updateRequired);
          await pumpScreen(tester, h, const UpdateRequiredPage());
          expect(find.text(_l.uiServerUpdateTitle), findsWidgets);
          expect(find.text(_l.uiServerUpdateApiMessage), findsOneWidget);
          expect(find.text(_l.uiServerUpdateMessage), findsNothing);
          expect(find.text(_l.uiServerUpdateRecheck), findsOneWidget);
          expect(find.byType(TextFormField), findsNothing);
          await expectLater(
            h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1'),
            throwsA(isA<ApiError>()),
          );
          expect(h.backend.count('POST', '/v1/auth/login'), 0);
          expect(tester.takeException(), isNull);
        },
        sizes: pilotSizes,
      );
    });

    testWidgets('minimum sürüm gerekçesi API gerekçesinden ayrıdır', (
      tester,
    ) async {
      final h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
      addTearDown(h.dispose);
      await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
      await pumpScreen(tester, h, const UpdateRequiredPage());
      expect(find.text(_l.uiServerUpdateMessage), findsOneWidget);
      expect(find.text(_l.uiServerUpdateApiMessage), findsNothing);
    });

    testWidgets('"Yeniden denetle" başarısız bağdan da aynı adresi doğrular', (
      tester,
    ) async {
      final h = Harness(handler: (r) => discoveryHandler(r, api: 'v2'));
      addTearDown(h.dispose);
      await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
      await pumpScreen(tester, h, const UpdateRequiredPage());
      final before = h.backend.count('GET', '/.well-known/nizamio-instance');
      await tester.tap(find.text(_l.uiServerUpdateRecheck));
      await settle(tester);
      expect(
        h.backend.count('GET', '/.well-known/nizamio-instance'),
        before + 1,
      );
    });
  });
}
