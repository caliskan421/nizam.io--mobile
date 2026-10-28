// Pilot dikey dilim, widget düzeyinde uçtan uca (gerçek bileşim kökü + gerçek router + faz
// makinesi; sahte ağ): sunucu bağlama → giriş → zorunlu parola değişikliği → program seçimi →
// ana sayfa (S2, kapsam başlığı) → profil/çıkış. Ekranlar faz değiştirmek için gezinmez: her
// geçişi faz makinesi + redirect yapar. compact (alt çubuk) ve expanded (ray).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/app/app.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';

import '../support/harness.dart';
import '../support/screen_matrix.dart';
import 'pilot_support.dart';

final _l = AppLocalizationsTr();

Future<void> _type(WidgetTester tester, int index, String text) =>
    tester.enterText(find.byType(TextFormField).at(index), text);

Future<void> _tapButton(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(NzButton, label));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('bağ → giriş → parola değişikliği → kapsam → ana sayfa → çıkış', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final backend = PilotBackend()..force = true;
    final h = Harness(handler: backend.handle);
    addTearDown(h.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: h.container,
        child: const NizamioApp(),
      ),
    );
    await settle(tester);

    // 1. Sunucu bağlama.
    expect(h.read(appPhaseProvider), AppPhase.unbound);
    expect(find.text(_l.uiServerIntro), findsOneWidget);
    await _type(tester, 0, testUrl);
    await _tapButton(tester, _l.uiServerConnect);
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);

    // 2. Giriş (yönetici bayrağıyla zorunlu parola değişikliği istenir).
    expect(find.text(_l.uiIdentityLoginEmail), findsOneWidget);
    await _type(tester, 0, 'a@b.test');
    await _type(tester, 1, secretLogin);
    await _tapButton(tester, _l.uiIdentityLoginSubmit);
    expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);

    // 3. Zorunlu parola değişikliği → oturum açık, kapsam seçimi.
    final tokenBefore = h.read(sessionControllerProvider).accessToken;
    expect(find.text(_l.uiIdentityPasswordIntro), findsOneWidget);
    await _type(tester, 0, secretCurrent);
    await _type(tester, 1, secretNew);
    await _type(tester, 2, secretNew);
    await _tapButton(tester, _l.uiIdentityPasswordSubmit);
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
    expect(h.read(sessionControllerProvider).accessToken, tokenBefore);
    expect(find.text(_l.uiScopeIntro), findsOneWidget);
    expect(find.text('Program Bir'), findsOneWidget);

    // 4. Program seçimi → kabuk + ana sayfa; ad S2 yanıtından.
    await tester.tap(find.text('Program İki'));
    await settle(tester);
    expect(h.read(appPhaseProvider), AppPhase.scoped);
    expect(find.text(_l.uiHomeGreeting), findsOneWidget);
    expect(find.text('Program İki'), findsOneWidget);
    final s2 = h.backend.requests.where((r) => r.path == '/v1/program').single;
    expect(s2.header('X-Nizamio-Program'), 'prog-2');
    expect(
      find.byType(
        screen.windowClass.isCompact ? NzFloatingNav : NavigationRail,
      ),
      findsOneWidget,
    );

    // 5. Profil sekmesi: e-posta ve çıkış.
    // Profil çekmecedeki hesap satırından (prototip: alt menüde profil yok).
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await settle(tester);
    await tester.tap(find.text(_l.uiHomeProfile));
    await settle(tester);
    expect(find.text('a@b.test'), findsOneWidget);
    await tester.tap(find.text(_l.uiIdentitySignOut));
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(_l.uiIdentitySignOut),
      ),
    );
    await settle(tester);
    expect(h.read(appPhaseProvider), AppPhase.serverVerified);
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
    expect(find.text(_l.uiIdentityLoginEmail), findsOneWidget);
    expect(h.backend.count('POST', '/v1/auth/logout'), 1);
  }, sizes: pilotSizes);

  testScreens('"kapsamı değiştir" kapsam seçimine döner (faz sessionOpen)', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = Harness(handler: PilotBackend().handle);
    addTearDown(h.dispose);
    await real(tester, () async {
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
    });
    h.read(scopeControllerProvider).selectProgram('prog-1');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: h.container,
        child: const NizamioApp(),
      ),
    );
    await settle(tester);
    expect(find.text('Program Bir'), findsOneWidget);
    // Kapsam değiştirme çekmecede (üst çubuk menü dairesi).
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await settle(tester);
    await tester.tap(find.textContaining(_l.uiScopeHomeChange));
    await settle(tester);
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
    expect(find.text(_l.uiScopeIntro), findsOneWidget);
  }, sizes: pilotSizes);
}
