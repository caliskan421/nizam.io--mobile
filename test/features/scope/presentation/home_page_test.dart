// HomePage: seçili programın adı S2 GET /v1/program yanıtından gelir (kapsam başlığı isteğe
// girer); "kapsamı değiştir" faz sessionOpen'a döner. compact + expanded.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/scope/presentation/home_page.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('seçili programın adı ve yılı S2 yanıtından; başlık taşınır', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    h.read(scopeControllerProvider).selectProgram('prog-2');
    await pumpScreen(tester, h, const HomePage());
    await settle(tester);
    expect(find.text('Program İki'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text(_l.uiScopeHomeProgram), findsOneWidget);
    final s2 = h.backend.requests.where((r) => r.path == '/v1/program').single;
    expect(s2.header('X-Nizamio-Program'), 'prog-2');
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens('"Kapsamı değiştir": seçim kalkar, faz sessionOpen', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    h.read(scopeControllerProvider).selectProgram('prog-1');
    await pumpScreen(tester, h, const HomePage());
    await settle(tester);
    await tester.tap(find.text(_l.uiScopeHomeChange));
    await settle(tester);
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
  }, sizes: pilotSizes);

  testWidgets(
    'S2 hatası: errorText, sunucu iletisi yok; yeniden dene dokunuşla',
    (tester) async {
      final backend = PilotBackend();
      final h = await real(tester, () => pilotHarness(backend, signedIn: true));
      h.read(scopeControllerProvider).selectProgram('prog-1');
      var failing = true;
      h.backend.handler = (r) => r.path == '/v1/program' && failing
          ? errorBody(403, 'program.not_authorized')
          : backend.handle(r);
      await pumpScreen(tester, h, const HomePage());
      await settle(tester);
      expect(
        find.text(errorText(_l, ApiError('program.not_authorized'))),
        findsOneWidget,
      );
      expect(find.textContaining(serverMessage), findsNothing);
      expect(h.backend.count('GET', '/v1/program'), 1);
      failing = false;
      await tester.tap(find.text(_l.uiCommonRetry));
      await settle(tester);
      expect(find.text('Program Bir'), findsOneWidget);
    },
  );
}
