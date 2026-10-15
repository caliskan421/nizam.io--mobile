// ProfilePage: hesap e-postası (GET /v1/me) ve çıkış (onay diyaloğu). compact + expanded.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/identity/presentation/profile_page.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('e-posta me() yanıtından gelir; taşma yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(tester, h, const ProfilePage());
    await settle(tester);
    expect(find.text('a@b.test'), findsOneWidget);
    expect(find.text(_l.uiIdentityProfileEmail), findsOneWidget);
    expect(find.text(_l.uiIdentitySignOut), findsOneWidget);
    expect(h.backend.count('GET', '/v1/me'), 1);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens('çıkış: iptal oturumu korur; onay oturumu kapatır', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(tester, h, const ProfilePage());
    await settle(tester);
    await tester.tap(find.text(_l.uiIdentitySignOut));
    await settle(tester);
    expect(find.text(_l.uiIdentitySignOutConfirmMessage), findsOneWidget);
    await tester.tap(find.text(_l.uiCommonCancel));
    await settle(tester);
    expect(h.backend.count('POST', '/v1/auth/logout'), 0);
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);

    await tester.tap(find.text(_l.uiIdentitySignOut));
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(_l.uiIdentitySignOut),
      ),
    );
    await settle(tester);
    expect(h.backend.count('POST', '/v1/auth/logout'), 1);
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);
  }, sizes: pilotSizes);

  testWidgets(
    'me() hatası: errorText, sunucu iletisi yok; yeniden dene çalışır',
    (tester) async {
      final backend = PilotBackend();
      final h = await real(tester, () => pilotHarness(backend, signedIn: true));
      var failing = true;
      h.backend.handler = (r) => r.path == '/v1/me' && failing
          ? errorBody(500, 'platform.internal')
          : backend.handle(r);
      await pumpScreen(tester, h, const ProfilePage());
      await settle(tester);
      expect(
        find.text(errorText(_l, ApiError('platform.internal'))),
        findsOneWidget,
      );
      expect(find.textContaining(serverMessage), findsNothing);
      failing = false;
      await tester.tap(find.text(_l.uiCommonRetry));
      await settle(tester);
      expect(find.text('a@b.test'), findsOneWidget);
    },
  );
}
