// PasswordChangePage: mevcut + yeni parola (+ tekrar), eşleşme doğrulaması, hata metni yalnız
// errorText, alanlar temizlenir, başarıda faz sessionOpen. compact + expanded.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/features/identity/presentation/password_change_page.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Finder _field(int i) => find.byType(TextFormField).at(i);

String _text(WidgetTester tester, int i) =>
    tester.widget<TextFormField>(_field(i)).controller!.text;

Future<void> _submit(
  WidgetTester tester, {
  String current = secretCurrent,
  String next = secretNew,
  String? confirm,
}) async {
  await tester.enterText(_field(0), current);
  await tester.enterText(_field(1), next);
  await tester.enterText(_field(2), confirm ?? next);
  await tester.tap(find.widgetWithText(NzButton, _l.uiIdentityPasswordSubmit));
  await settle(tester);
}

Future<PilotBackend> _setUp(
  WidgetTester tester, {
  void Function(PilotBackend)? tune,
}) async {
  final backend = PilotBackend()..force = true;
  tune?.call(backend);
  return backend;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  tearDown(Log.resetSink);

  testScreens('üç parola alanı, düğme ve çıkış çizilir; taşma yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend()..force = true, signedIn: true),
    );
    await pumpScreen(tester, h, const PasswordChangePage());
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text(_l.uiIdentityPasswordIntro), findsOneWidget);
    expect(find.text(_l.uiIdentitySignOut), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens('eşleşmeyen tekrar → doğrulama hatası, istek yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend()..force = true, signedIn: true),
    );
    await pumpScreen(tester, h, const PasswordChangePage());
    await _submit(tester, confirm: 'baska-bir-deger');
    expect(find.text(_l.uiInputsValidationMismatch), findsOneWidget);
    expect(h.backend.count('POST', '/v1/auth/password'), 0);
  }, sizes: pilotSizes);

  testScreens(
    'başarı: istek gövdesi, bayrak düşer (sessionOpen), alanlar temiz',
    (tester, screen) async {
      useScreen(tester, screen);
      final logs = <String>[];
      Log.sink = logs.add;
      final h = await real(
        tester,
        () => pilotHarness(PilotBackend()..force = true, signedIn: true),
      );
      await pumpScreen(tester, h, const PasswordChangePage());
      final tokenBefore = h.read(sessionControllerProvider).accessToken;
      await _submit(tester);
      expect(h.backend.requests.last.body, {
        'current_password': secretCurrent,
        'new_password': secretNew,
      });
      expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
      expect(h.read(sessionControllerProvider).accessToken, tokenBefore);
      for (var i = 0; i < 3; i++) {
        expect(_text(tester, i), isEmpty);
      }
      final all = logs.join('\n');
      expect(all, isNot(contains(secretCurrent)));
      expect(all, isNot(contains(secretNew)));
    },
    sizes: pilotSizes,
  );

  testScreens(
    'hata: errorText gösterilir, sunucu iletisi YOK, alanlar temizlenir',
    (tester, screen) async {
      useScreen(tester, screen);
      final backend = await _setUp(
        tester,
        tune: (b) => b.passwordError = 'identity.credentials_invalid',
      );
      final h = await real(tester, () => pilotHarness(backend, signedIn: true));
      await pumpScreen(tester, h, const PasswordChangePage());
      await _submit(tester);
      expect(
        find.text(errorText(_l, ApiError('identity.credentials_invalid'))),
        findsOneWidget,
      );
      expect(find.textContaining(serverMessage), findsNothing);
      for (var i = 0; i < 3; i++) {
        expect(_text(tester, i), isEmpty, reason: 'alan $i temizlenmeli');
      }
      expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);
      expect(h.read(sessionStateProvider), isA<SessionActive>());
    },
    sizes: pilotSizes,
  );

  testScreens('sunucu alan hatası (new_password) alanda görünür', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final backend = await _setUp(
      tester,
      tune: (b) => b
        ..passwordError = 'identity.input_invalid'
        ..passwordErrorStatus = 422
        ..passwordErrorFields = [
          {
            'field': 'new_password',
            'code': 'identity.input_invalid',
            'message': serverMessage,
          },
        ],
    );
    final h = await real(tester, () => pilotHarness(backend, signedIn: true));
    await pumpScreen(tester, h, const PasswordChangePage());
    await _submit(tester);
    expect(find.textContaining(serverMessage), findsNothing);
    expect(
      find.text(errorText(_l, ApiError('identity.input_invalid'))),
      findsWidgets,
    );
  }, sizes: pilotSizes);

  testWidgets('çıkış: onay → sunucu çıkışı, oturum kapanır', (tester) async {
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend()..force = true, signedIn: true),
    );
    await pumpScreen(tester, h, const PasswordChangePage());
    await tester.ensureVisible(find.text(_l.uiIdentitySignOut));
    await tester.tap(find.text(_l.uiIdentitySignOut));
    await settle(tester);
    expect(find.text(_l.uiIdentitySignOutConfirmTitle), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(_l.uiIdentitySignOut),
      ),
    );
    await settle(tester);
    expect(h.backend.count('POST', '/v1/auth/logout'), 1);
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);
  });
}
