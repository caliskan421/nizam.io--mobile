// ServerPage: URL alanı, bağlan; başarısızlık nedenleri (TLS, güvensiz, tanınmayan sunucu)
// AYRI metinlerle ekranda kalır; sunucu iletisi gösterilmez. compact + expanded.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/features/server/presentation/server_page.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();
String _text(String code) => errorText(_l, ApiError(code));

Future<void> _connect(WidgetTester tester, String url) async {
  await tester.enterText(find.byType(TextFormField), url);
  await tester.tap(find.text(_l.uiServerConnect));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('alan ve bağlan düğmesi çizilir; taşma yok', (
    tester,
    screen,
  ) async {
    final h = Harness();
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    expect(find.text(_l.uiServerTitle), findsWidgets);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text(_l.uiServerConnect), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens(
    'geçerli adres: bağ doğrulanır (faz makinesi sonrasını yönlendirir)',
    (tester, screen) async {
      final h = Harness();
      addTearDown(h.dispose);
      await pumpScreen(tester, h, const ServerPage());
      await _connect(tester, testUrl);
      expect(h.read(bindingStateProvider), isA<BindingVerified>());
      expect(h.backend.count('GET', '/.well-known/nizamio-instance'), 1);
    },
    sizes: pilotSizes,
  );

  testScreens('boş adres: istek yok, alan hatası', (tester, screen) async {
    final h = Harness();
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    await tester.tap(find.text(_l.uiServerConnect));
    await settle(tester);
    expect(h.backend.requests, isEmpty);
    expect(find.text(_l.uiInputsValidationRequired), findsOneWidget);
  }, sizes: pilotSizes);

  testScreens('TLS hatası bağ ekranında AYRI metinle görünür (yutulmaz)', (
    tester,
    screen,
  ) async {
    final h = Harness(handler: badCertificate);
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    await _connect(tester, testUrl);
    final failed = h.read(bindingStateProvider) as BindingFailed;
    expect(failed.error.code, ClientErrorCode.tlsError);
    expect(find.text(_text(ClientErrorCode.tlsError)), findsOneWidget);
    expect(
      _text(ClientErrorCode.tlsError),
      isNot(_text(ClientErrorCode.networkError)),
    );
    expect(find.text(_text(ClientErrorCode.networkError)), findsNothing);
  }, sizes: pilotSizes);

  testScreens('prod: http adres → güvensiz sunucu metni; ağa istek çıkmaz', (
    tester,
    screen,
  ) async {
    final h = Harness();
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    await _connect(tester, 'http://nizam.example.test');
    expect(find.text(_text(ClientErrorCode.insecureServer)), findsOneWidget);
    expect(h.backend.requests, isEmpty);
  }, sizes: pilotSizes);

  testScreens('NIZAM.IO olmayan sunucu → tanınmayan sunucu metni', (
    tester,
    screen,
  ) async {
    final h = Harness(handler: (r) => envelope(404, 'platform.not_found'));
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    await _connect(tester, testUrl);
    expect(
      find.text(_text(ClientErrorCode.serverUnrecognized)),
      findsOneWidget,
    );
    expect(find.textContaining('sunucu iletisi'), findsNothing);
  }, sizes: pilotSizes);

  testScreens('API sürümü uyumsuz → ayrı metin', (tester, screen) async {
    final h = Harness(handler: (r) => discoveryHandler(r, api: 'v9'));
    addTearDown(h.dispose);
    await pumpScreen(tester, h, const ServerPage());
    await _connect(tester, testUrl);
    expect(
      find.text(_text(ClientErrorCode.unsupportedApiVersion)),
      findsOneWidget,
    );
  }, sizes: pilotSizes);

  testWidgets('başarısız denemenin adresi alanda kalır (yeniden deneme)', (
    tester,
  ) async {
    final h = Harness(handler: badCertificate);
    addTearDown(h.dispose);
    await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
    await pumpScreen(tester, h, const ServerPage());
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller?.text,
      testUrl,
    );
  });
}
