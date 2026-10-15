// UpdateRequiredPage: açık "güncelleme gerekli" ekranı; giriş başlamaz. compact + expanded.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
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
}
