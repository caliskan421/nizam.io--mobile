// HomePage: seçili programın adı S2 GET /v1/program yanıtından gelir (kapsam başlığı isteğe
// girer, üst çubukta); özet geliştirme örneğinden. Yerel etkileşimler (sıralama, filtre, tümünü
// göster, hızlı işlem, çekmece, kısayol menüsü), gezinme hedefleri, dar ekran ve 2.0 metin.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_split_button.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_kpi_tile.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/presentation/home/home_menus.dart';
import 'package:nizamio/features/scope/presentation/home_page.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  PilotBackend? backend,
  String program = 'prog-2',
}) async {
  final h = await real(
    tester,
    () => pilotHarness(backend ?? PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram(program);
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const HomePage(), nav: nav);
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

  testWidgets('KPI ve koordinatörlük kartı gezinme hedefini çağırır', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    await tester.tap(find.text(_l.uiHomeKpiLate));
    await settle(tester);
    await _tapVisible(tester, find.text('Altyapı ve tesisat'));
    expect(nav.calls, ['tasks:late', 'coord:ALT']);
  });

  testWidgets(
    'her KPI kendi görünümüyle, ekip kutuları rol kişileriyle görevleri açar',
    (tester) async {
      final (_, nav) = await _open(tester);
      for (final label in [
        _l.uiHomeKpiDone,
        _l.uiHomeKpiDoing,
        _l.uiHomeKpiReview,
      ]) {
        await _tapVisible(tester, find.text(label));
      }
      await _tapVisible(tester, find.text(_l.uiHomeRoleAdmin));
      await _tapVisible(tester, find.text(_l.uiHomeRoleMember));
      expect(nav.calls, [
        'tasks:done',
        'tasks:inProgress',
        'tasks:review',
        'tasks:ma,my',
        'tasks:bk,gn,mey',
      ]);
    },
  );

  testWidgets('zil etiketi bekleyenleri türüne göre sayar', (tester) async {
    await _open(tester);
    expect(
      find.bySemanticsLabel(
        '${_l.uiHomeNotifications} · 3 ${_l.uiHomeNotifyDateRequests} '
        '${_l.uiHomeNotifyAnd} 3 ${_l.uiHomeNotifyApprovals} '
        '${_l.uiHomeNotifyTail}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('çekmece: rol · e-posta, sezon kartı, sürüm; satır modül seçer', (
    tester,
  ) async {
    await _open(tester);
    final picked = <HomeModule>[];
    var scope = 0;
    final ctx = tester.element(find.byType(HomePage));
    unawaited(
      showHomeDrawer(
        ctx,
        current: HomeModule.home,
        greetingName: 'Muhammet Ali Çalışkan',
        greetingRole: TeamRole.admin,
        greetingEmail: 'macaliskan@gmail.com',
        programName: 'Örnek Sezon 2026',
        programYear: 2026,
        version: '0.1.0',
        counts: null,
        onModule: picked.add,
        onProfile: () {},
        onChangeScope: () => scope++,
        onSignOut: () {},
      ),
    );
    await settle(tester);
    expect(
      find.text('${_l.uiHomeRoleAdmin} · macaliskan@gmail.com'),
      findsOneWidget,
    );
    expect(find.text('ÖS'), findsOneWidget);
    expect(find.text('2026 ${_l.uiHomeSeasonTail}'), findsOneWidget);
    await tester.tap(find.text('Örnek Sezon 2026'));
    await settle(tester);
    expect(scope, 1);
    // Sürüm satırı çekmecenin sonunda (liste tembel; kaydırınca kurulur).
    unawaited(
      showHomeDrawer(
        tester.element(find.byType(HomePage)),
        current: null,
        greetingName: 'Muhammet Ali Çalışkan',
        programName: null,
        version: '0.1.0',
        counts: null,
        onModule: picked.add,
        onProfile: () {},
        onChangeScope: () {},
        onSignOut: () {},
      ),
    );
    await settle(tester);
    expect(find.text(_l.uiHomeProfile), findsOneWidget);
    final version = find.text(
      '${_l.uiHomeAppName} ${_l.uiHomeVersionPrefix}0.1.0',
    );
    await tester.scrollUntilVisible(
      version,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(version, findsOneWidget);
    await tester.tap(find.text(_l.uiHomeHelp));
    await settle(tester);
    expect(picked, [HomeModule.help]);
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
    'hızlı işlem alt sayfası (görevler feature) açılır ve kapanır; rapor yer tutucu',
    (tester) async {
      await _open(tester);
      await _tapVisible(tester, find.text(_l.uiHomeQaMeeting));
      expect(find.text(_l.uiHomeQaMeetingLong), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await settle(tester);
      expect(find.text(_l.uiHomeQaMeetingLong), findsNothing);
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
      // Prototip: ALT-7 kaydırma olarak ("+51 gün"), diğer tarih talepleri tarih olarak.
      expect(
        find.text(
          'ALT-7 · ${_l.uiHomeDateRequest} · +51 ${_l.uiHomeShiftDaysTail}',
        ),
        findsOneWidget,
      );
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

  testWidgets('menü dairesi uygulama menüsünü, geçmiş kartı geçmişi açar', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await settle(tester);
    await _tapVisible(tester, find.text(_l.uiHomeHistoryTitle));
    expect(nav.calls, ['menu', 'history']);
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
          await pumpScreen(tester, h, const HomePage(), dark: dark);
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
