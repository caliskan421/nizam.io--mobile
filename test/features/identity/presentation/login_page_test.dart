// LoginPage: e-posta + parola, sunucu alan hataları, hata metni yalnız errorText (sunucu iletisi
// gösterilmez), parola alanı hatada temizlenir ve hiçbir yerde saklanmaz. compact + expanded.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_password_field.dart';
import 'package:nizamio/features/identity/presentation/login_page.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Finder get _email => find.byType(TextFormField).at(0);
Finder get _password => find.byType(TextFormField).at(1);

String _passwordText(WidgetTester tester) =>
    tester.widget<TextFormField>(_password).controller!.text;

Future<void> _submit(WidgetTester tester, String email, String password) async {
  await tester.enterText(_email, email);
  await tester.enterText(_password, password);
  await tester.tap(find.widgetWithText(NzButton, _l.uiIdentityLoginSubmit));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  tearDown(Log.resetSink);

  testScreens('alanlar, sunucu adı ve düğme çizilir; taşma yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(tester, () => pilotHarness(PilotBackend()));
    await pumpScreen(tester, h, const LoginPage());
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(NzPasswordField), findsOneWidget);
    expect(find.text(_l.uiIdentityLoginServer), findsOneWidget);
    expect(find.text('Test'), findsOneWidget); // profile.display_name
    expect(find.text(_l.uiIdentityLoginSubmit), findsWidgets);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens('doğrulama: boş alan → istek yok', (tester, screen) async {
    useScreen(tester, screen);
    final h = await real(tester, () => pilotHarness(PilotBackend()));
    await pumpScreen(tester, h, const LoginPage());
    await tester.tap(find.widgetWithText(NzButton, _l.uiIdentityLoginSubmit));
    await settle(tester);
    expect(find.text(_l.uiInputsValidationRequired), findsWidgets);
    expect(h.backend.count('POST', '/v1/auth/login'), 0);
  }, sizes: pilotSizes);

  testScreens(
    'başarılı giriş: istek gövdesi, oturum açılır, parola alanı boş',
    (tester, screen) async {
      useScreen(tester, screen);
      final h = await real(tester, () => pilotHarness(PilotBackend()));
      await pumpScreen(tester, h, const LoginPage());
      await _submit(tester, 'a@b.test', secretLogin);
      expect(h.read(sessionStateProvider), isA<SessionActive>());
      expect(h.backend.requests.last.body, {
        'email': 'a@b.test',
        'password': secretLogin,
      });
      expect(_passwordText(tester), isEmpty);
    },
    sizes: pilotSizes,
  );

  testScreens(
    'hata: errorText gösterilir, sunucu iletisi YOK, parola temizlenir',
    (tester, screen) async {
      useScreen(tester, screen);
      final logs = <String>[];
      Log.sink = logs.add;
      final backend = PilotBackend()
        ..loginError = 'identity.credentials_invalid';
      final h = await real(tester, () => pilotHarness(backend));
      await pumpScreen(tester, h, const LoginPage());
      await _submit(tester, 'a@b.test', secretLogin);
      expect(
        find.text(errorText(_l, ApiError('identity.credentials_invalid'))),
        findsOneWidget,
      );
      expect(find.textContaining(serverMessage), findsNothing);
      expect(_passwordText(tester), isEmpty);
      expect(
        tester.widget<TextFormField>(_email).controller!.text,
        'a@b.test',
        reason: 'e-posta korunur',
      );
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(logs.join('\n'), isNot(contains(secretLogin)));
    },
    sizes: pilotSizes,
  );

  testScreens('sunucu alan hatası ilgili alanda görünür; sunucu iletisi yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final backend = PilotBackend()
      ..loginError = 'identity.input_invalid'
      ..loginErrorFields = [
        {
          'field': 'email',
          'code': 'identity.input_invalid',
          'message': serverMessage,
        },
      ];
    final h = await real(tester, () => pilotHarness(backend));
    await pumpScreen(tester, h, const LoginPage());
    await _submit(tester, 'a@b.test', secretLogin);
    expect(find.textContaining(serverMessage), findsNothing);
    final fieldText = errorText(_l, ApiError('identity.input_invalid'));
    // Alan hatası (e-posta altında) + hata bildirimi: metin ekranda en az bir kez.
    expect(find.text(fieldText), findsWidgets);
  }, sizes: pilotSizes);

  testWidgets('parola gizli girilir; denetleyici ve durum parolayı yazmaz', (
    tester,
  ) async {
    final h = await real(tester, () => pilotHarness(PilotBackend()));
    await pumpScreen(tester, h, const LoginPage());
    await tester.enterText(_password, secretLogin);
    final field = tester.widget<EditableText>(
      find.descendant(of: _password, matching: find.byType(EditableText)),
    );
    expect(field.obscureText, isTrue);
    expect(
      tester.widget<TextFormField>(_password).controller.toString(),
      isNot(contains(secretLogin)),
    );
    expect(
      tester.widget<NzPasswordField>(find.byType(NzPasswordField)).toString(),
      isNot(contains(secretLogin)),
    );
  });
}
