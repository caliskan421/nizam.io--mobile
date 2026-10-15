// ScopePage: program listesi, boş durum, program.not_authorized, seçim; sunucu iletisi
// gösterilmez. compact + expanded.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_empty_state.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_error_state.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_list_tile.dart';
import 'package:nizamio/features/scope/presentation/scope_page.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens('programlar listelenir; kapsam başlığı gönderilmez; taşma yok', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(tester, h, const ScopePage());
    await settle(tester);
    expect(find.text('Program Bir'), findsOneWidget);
    expect(find.text('Program İki'), findsOneWidget);
    expect(find.byType(NzListTile), findsNWidgets(2));
    expect(find.text(_l.uiScopeIntro), findsOneWidget);
    expect(h.backend.requests.last.header('X-Nizamio-Program'), isNull);
    expect(tester.takeException(), isNull);
  }, sizes: pilotSizes);

  testScreens('dokunma programı seçer: kapsam yazılır, faz scoped olur', (
    tester,
    screen,
  ) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(tester, h, const ScopePage());
    await settle(tester);
    await tester.tap(find.text('Program İki'));
    await settle(tester);
    expect(h.read(scopeStateProvider).programId, 'prog-2');
    expect(h.read(appPhaseProvider), AppPhase.scoped);
  }, sizes: pilotSizes);

  testScreens('program yok → boş durum', (tester, screen) async {
    useScreen(tester, screen);
    final backend = PilotBackend()..programs = [];
    final h = await real(tester, () => pilotHarness(backend, signedIn: true));
    await pumpScreen(tester, h, const ScopePage());
    await settle(tester);
    expect(find.byType(NzEmptyState), findsOneWidget);
    expect(find.text(_l.uiScopeEmptyTitle), findsOneWidget);
    expect(find.byType(NzListTile), findsNothing);
  }, sizes: pilotSizes);

  testScreens(
    'program.not_authorized → NzErrorState, errorText; sunucu iletisi yok',
    (tester, screen) async {
      useScreen(tester, screen);
      final backend = PilotBackend()..programsError = 'program.not_authorized';
      final h = await real(tester, () => pilotHarness(backend, signedIn: true));
      await pumpScreen(tester, h, const ScopePage());
      await settle(tester);
      expect(find.byType(NzErrorState), findsOneWidget);
      expect(
        find.text(errorText(_l, ApiError('program.not_authorized'))),
        findsOneWidget,
      );
      expect(find.textContaining(serverMessage), findsNothing);
      // Yeniden dene yalnız dokunuşla: tek istek yapılmıştı.
      expect(h.backend.count('GET', '/v1/programs'), 1);
      backend.programsError = null;
      await tester.tap(find.text(_l.uiCommonRetry));
      await settle(tester);
      expect(find.text('Program Bir'), findsOneWidget);
    },
    sizes: pilotSizes,
  );

  testWidgets('200 satıra ulaşan liste kesilmiş bildirimi gösterir', (
    tester,
  ) async {
    final backend = PilotBackend()
      ..programs = [
        for (var i = 0; i < 200; i++) {'program_id': 'p$i', 'name': 'P $i'},
      ];
    final h = await real(tester, () => pilotHarness(backend, signedIn: true));
    await pumpScreen(tester, h, const ScopePage());
    await settle(tester);
    expect(find.text(_l.uiScopeTruncated), findsOneWidget);
  });

  testWidgets(
    'çıkış düğmesi görünür (kapsam seçilmeden oturumdan çıkış yolu)',
    (tester) async {
      final h = await real(
        tester,
        () => pilotHarness(PilotBackend(), signedIn: true),
      );
      await pumpScreen(tester, h, const ScopePage());
      await settle(tester);
      expect(find.text(_l.uiIdentitySignOut), findsOneWidget);
    },
  );
}
