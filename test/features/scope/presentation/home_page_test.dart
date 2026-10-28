// HomePage: seçili programın adı S2 GET /v1/program yanıtından gelir (kapsam başlığı isteğe
// girer, üst çubukta); özet geliştirme örneğinden. Yerel etkileşimler (sıralama, filtre, tümünü
// göster, hızlı işlem, çekmece, kısayol menüsü), gezinme hedefleri, dar ekran ve 2.0 metin.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_split_button.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_kpi_tile.dart';
import 'package:nizamio/features/scope/presentation/home_page.dart';

import '../../../support/harness.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

/// Gezinme çağrılarını kaydeder.
class _Nav {
  final calls = <String>[];

  HomeNavigation get navigation => HomeNavigation(
    openTasks: () => calls.add('tasks'),
    openTask: (code) => calls.add('task:$code'),
    openCoordinatorship: (code) => calls.add('coord:$code'),
    openProfile: () => calls.add('profile'),
  );
}

Future<(Harness, _Nav)> _open(
  WidgetTester tester, {
  PilotBackend? backend,
  String program = 'prog-2',
}) async {
  final h = await real(
    tester,
    () => pilotHarness(backend ?? PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram(program);
  final nav = _Nav();
  await pumpScreen(tester, h, HomePage(navigation: nav.navigation));
  await settle(tester);
  return (h, nav);
}

Future<void> _tapVisible(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens(
    'program adı S2 yanıtından üst çubukta; başlık taşınır; özet çizilir',
    (tester, screen) async {
      useScreen(tester, screen);
      final (h, _) = await _open(tester);
      expect(find.text('Program İki'), findsOneWidget);
      final s2 = h.backend.requests
          .where((r) => r.path == '/v1/program')
          .single;
      expect(s2.header('X-Nizamio-Program'), 'prog-2');
      expect(find.text(_l.uiHomeGreeting), findsOneWidget);
      expect(find.byType(NzKpiTile), findsNWidgets(4));
      expect(find.text('%49'), findsOneWidget);
      expect(find.text(_l.uiHomeCoordinatorships), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
    sizes: pilotSizes,
  );

  testWidgets(
    'S2 hatası: errorText, sunucu iletisi yok; yeniden dene dokunuşla',
    (tester) async {
      final backend = PilotBackend();
      var failing = true;
      final h = await real(tester, () => pilotHarness(backend, signedIn: true));
      h.backend.handler = (r) => r.path == '/v1/program' && failing
          ? errorBody(403, 'program.not_authorized')
          : backend.handle(r);
      h.read(scopeControllerProvider).selectProgram('prog-1');
      await pumpScreen(tester, h, HomePage(navigation: _Nav().navigation));
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

  testWidgets('KPI ve koordinatörlük kartı gezinme hedefini çağırır', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    await tester.tap(find.text(_l.uiHomeKpiLate));
    await settle(tester);
    await _tapVisible(tester, find.text('Altyapı ve tesisat'));
    expect(nav.calls, ['tasks', 'coord:ALT']);
  });

  testWidgets(
    'sıralama: ölçüt döngüsü ve yön; filtre; tümünü göster / daralt',
    (tester) async {
      await _open(tester);
      // Gecikmeye göre büyükten küçüğe: ilk kart en çok geciken.
      expect(find.text('İdari işler'), findsOneWidget);
      expect(find.text('Operasyon'), findsNothing);
      final showAll = find.text('${_l.uiHomeShowAll} (11)');
      await _tapVisible(tester, showAll);
      expect(find.text('Operasyon'), findsOneWidget);
      await _tapVisible(tester, find.text(_l.uiHomeCollapse));
      expect(find.text('Operasyon'), findsNothing);

      // Filtre: koordinatörsüz → tek kart, "tümünü göster" yok.
      await _tapVisible(tester, find.text(_l.uiHomeFilterUnassigned));
      expect(find.text('İdari işler'), findsOneWidget);
      expect(find.text('Altyapı ve tesisat'), findsNothing);
      expect(find.textContaining(_l.uiHomeShowAll), findsNothing);

      // Ölçüt: gecikme → ilerleme → ad.
      await _tapVisible(tester, find.text(_l.uiHomeFilterAll));
      final split = find.byType(NzSplitButton);
      await _tapVisible(
        tester,
        find.descendant(of: split, matching: find.text(_l.uiHomeSortLate)),
      );
      expect(find.text(_l.uiHomeSortProgress), findsOneWidget);
      // İlerlemeye göre: en yüksek (Mekanik %88) görünür, en düşük (İdari %9) daraltılmış dışında.
      expect(find.text('Mekanik sistemler'), findsOneWidget);
      expect(find.text('İdari işler'), findsNothing);
      await _tapVisible(tester, find.text(_l.uiHomeSortProgress));
      expect(find.text(_l.uiHomeSortName), findsOneWidget);
      // Ad A→Z: Türkçe sıra (Altyapı, Eğitim, Elektrik, Fuar).
      expect(find.text('Altyapı ve tesisat'), findsOneWidget);
      expect(find.text('Fuar'), findsOneWidget);
      expect(find.text('İdari işler'), findsNothing);
    },
  );

  testWidgets(
    'hızlı işlem alt sayfası açılır ve kapanır; rapor yer tutucu bildirimi',
    (tester) async {
      await _open(tester);
      await _tapVisible(tester, find.text(_l.uiHomeQaMeeting));
      expect(find.text(_l.uiHomeQaMeetingLong), findsOneWidget);
      expect(find.text(_l.uiHomeFormSoon), findsOneWidget);
      await tester.tap(find.text(_l.uiCommonClose).last);
      await settle(tester);
      expect(find.text(_l.uiHomeFormSoon), findsNothing);
      await _tapVisible(tester, find.text(_l.uiHomeQaReport));
      expect(
        find.text('${_l.uiHomeQaReportLong} ${_l.uiHomeSoonTail}'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'kabukta yeniden dokunma kısayol menüsünü açar; satır görev açar',
    (tester) async {
      final (h, nav) = await _open(tester);
      h.read(shellReselectEventsProvider.notifier).fire(HomePage.shellTab);
      await settle(tester);
      expect(find.text(_l.uiHomeWaitingForYou), findsOneWidget);
      await tester.tap(find.text('Hidrofor sistemi kurulumu'));
      await settle(tester);
      expect(find.text(_l.uiHomeWaitingForYou), findsNothing);
      expect(nav.calls, ['task:ALT-7']);
      // Başka sekmenin olayı bu sayfada menü açmaz.
      h.read(shellReselectEventsProvider.notifier).fire(1);
      await settle(tester);
      expect(find.text(_l.uiHomeWaitingForYou), findsNothing);
    },
  );

  testWidgets('çekmece: modül yer tutucusu, görevler, kapsam değiştirme', (
    tester,
  ) async {
    final (h, nav) = await _open(tester, program: 'prog-1');
    Future<void> openDrawer() async {
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);
    }

    await openDrawer();
    await tester.tap(find.text(_l.uiHomeModuleCalendar));
    await settle(tester);
    expect(
      find.text('${_l.uiHomeModuleCalendar} ${_l.uiHomeSoonTail}'),
      findsOneWidget,
    );
    await openDrawer();
    await tester.tap(find.text(_l.uiHomeModuleTasks));
    await settle(tester);
    expect(nav.calls, ['tasks']);
    await openDrawer();
    await tester.tap(find.textContaining(_l.uiScopeHomeChange));
    await settle(tester);
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0), (390.0, 2.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final h = await real(
            tester,
            () => pilotHarness(PilotBackend(), signedIn: true),
          );
          h.read(scopeControllerProvider).selectProgram('prog-2');
          await pumpScreen(
            tester,
            h,
            HomePage(navigation: _Nav().navigation),
            dark: dark,
          );
          await settle(tester);
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 12; i++) {
            await tester.drag(scrollable, const Offset(0, -300));
            await tester.pump();
          }
          await _tapVisible(tester, find.textContaining(_l.uiHomeShowAll));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
