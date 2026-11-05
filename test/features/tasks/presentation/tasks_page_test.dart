// TasksPage: görünüm kutucukları ve sayıları, sıralama menüsü (yön, gruplu liste), arama,
// filtre alt sayfası ve çipler, sayfalama, kart/zaman çizelgesi gezinmesi, başlangıç
// süzgeci, kısayol menüsü; dar ekran × 2.0 metin × açık/koyu taşma yok.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/nz_alert_icon.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_task_card.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  Widget page = const TasksPage(),
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectSample();
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, page, nav: nav, dark: dark);
  await settle(tester);
  return (h, nav);
}

/// Akışı başa kaydırır (başlık daireleri tembel listeden düşmüş olabilir).
Future<void> _top(WidgetTester tester) async {
  await tester.drag(find.byType(Scrollable).first, const Offset(0, 4000));
  await settle(tester);
}

/// Akış tembeldir (ekran dışı öğeler kurulmaz): [f] ağaçta yoksa başa dönüp bulunana dek
/// aşağı kaydırır.
Future<void> _reveal(WidgetTester tester, Finder f) async {
  final s = find.byType(Scrollable).first;
  if (f.evaluate().isEmpty) {
    await tester.drag(s, const Offset(0, 6000));
    await tester.pump();
  }
  for (var i = 0; i < 40 && f.evaluate().isEmpty; i++) {
    await tester.drag(s, const Offset(0, -240));
    await tester.pump();
  }
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await _reveal(tester, f);
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('görünümler, liste başlığı, ilk kart ve sayfalama', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text(_l.uiTasksTitle), findsOneWidget);
    for (final n in ['76', '15', '20', '3', '14', '39']) {
      expect(find.text(n), findsWidgets);
    }
    // Liste başlığı yazısı yok; sayılar görünüm kutularında.
    expect(find.text('Su deposu temel betonunun yapılması'), findsOneWidget);
    // Gecikme rozeti yok (bitiş tarihi kırmızı).
    expect(find.text('98 ${_l.uiTasksLateTail}'), findsNothing);
    await _reveal(tester, find.text('8 / 76 ${_l.uiTasksTasksLc}'));
    expect(find.text('8 / 76 ${_l.uiTasksTasksLc}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksShowMore));
    await _reveal(tester, find.text('16 / 76 ${_l.uiTasksTasksLc}'));
    expect(find.text('16 / 76 ${_l.uiTasksTasksLc}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksViewLate));
    expect(find.text('Su deposu temel betonunun yapılması'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksViewRequest));
    // Bekleyen tarih talebi metin rozeti değil ünlem ikonu.
    expect(find.textContaining(_l.uiTasksRequestBadge), findsNothing);
    expect(find.byType(NzAlertIcon), findsNWidgets(3));
  });

  testWidgets(
    'sıralama düğmesi: ölçüt döngüsü, yön ve koordinatörlüğe göre gruplar',
    (tester) async {
      await _open(tester);
      // Etiket ölçütü sırayla değiştirir (bitiş → başlangıç → koordinatörlük); ok yönü çevirir.
      expect(find.text(_l.uiTasksSortDue), findsOneWidget);
      await _tap(tester, find.byIcon(NzIcons.chevronDown).first);
      expect(find.text(_l.uiTasksSortDue), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksSortDue));
      expect(find.text(_l.uiTasksSortStart), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksSortStart));
      expect(find.text(_l.uiTasksSortCoord), findsOneWidget);
      expect(find.text('Altyapı ve tesisat'), findsOneWidget);
      expect(find.text('ALT-5'), findsOneWidget);
      await _tap(tester, find.text('Altyapı ve tesisat'));
      expect(find.text('ALT-5'), findsNothing);
      // Gruplar kapalıyken liste kısalır; sayı satırı görünür.
      await _reveal(
        tester,
        find.text('76 ${_l.uiTasksTasksLc} · 11 ${_l.uiTasksCoordsLc}'),
      );
      expect(
        find.text('76 ${_l.uiTasksTasksLc} · 11 ${_l.uiTasksCoordsLc}'),
        findsOneWidget,
      );
    },
  );

  testWidgets('arama ve filtre alt sayfası; çipler ve temizle', (tester) async {
    final (h, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(EditableText), 'hidrofor');
    await settle(tester);
    expect(find.byType(NzTaskCard), findsOneWidget);
    expect(find.text('ALT-7'), findsOneWidget);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    expect(find.byType(NzTaskCard), findsWidgets);
    expect(find.text('Su deposu temel betonunun yapılması'), findsOneWidget);

    await _top(tester);
    h.read(shellReselectEventsProvider.notifier).fire(TasksPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiTasksFlyFilter));
    expect(find.text(_l.uiTasksFilters), findsOneWidget);
    await _tap(tester, find.text('Kadir Özbek').last);
    final show = find.textContaining(_l.uiTasksShowTasksTail);
    expect(show, findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksGroupCoord));
    await _tap(tester, find.text('Mekanik sistemler').last);
    expect(find.text('0 ${_l.uiTasksShowTasksTail}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksClearAll));
    await _tap(tester, find.text('Kadir Özbek').last);
    await _tap(tester, show);
    expect(find.text(_l.uiTasksFilters), findsNothing);
    expect(find.text('Kadir Özbek'), findsWidgets);
    await _tap(tester, find.text(_l.uiTasksClear));
    expect(find.text('Su deposu temel betonunun yapılması'), findsOneWidget);
  });

  testWidgets('gezinme: kart, zaman çizelgesi; yeni görev alt sayfası', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    await _tap(tester, find.text('Su deposu temel betonunun yapılması'));
    await _top(tester);
    await _tap(tester, find.bySemanticsLabel('Zaman çizelgesi'));
    expect(nav.calls, ['task:ALT-5', 'timeline']);
    await _top(tester);
    await _tap(tester, find.byIcon(Icons.add_rounded).first);
    expect(find.text(_l.uiTasksNtDesc), findsOneWidget);
  });

  // F57 D2 (Codex 1): "Yeni görev" yalnız seçili kapsamda görev açabilene; üye ekranı ve
  // kısayol menüsü girişi göstermez, departman ekibi (`listMembers`) hiç istenmez.
  for (final role in ['uye', 'koordinator']) {
    testWidgets('sunucu kataloğu, $role: yeni görev girişi ve ekip isteği', (
      tester,
    ) async {
      final pilot = PilotBackend();
      final h = await real(tester, () => pilotHarness(pilot, signedIn: true));
      h.backend.handler = (r) => switch ('${r.method} ${r.path}') {
        'GET /v1/me' => jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': false,
        }),
        'GET /v1/me/departments' => jsonResponse(200, {
          'departments': [
            {
              'program_id': 'prog-1',
              'program_name': 'Program Bir',
              'department_id': 'd1',
              'display_name': 'Altyapı',
              'role': role,
            },
          ],
        }),
        'GET /v1/program/work-items' => jsonResponse(200, {
          'items': <Object>[],
        }),
        _ => pilot.handle(r),
      };
      h.read(scopeControllerProvider).selectProgram('prog-1');
      await pumpScreen(tester, h, const TasksPage());
      await settle(tester);
      final add = find.byIcon(Icons.add_rounded);
      expect(add, role == 'uye' ? findsNothing : findsWidgets);
      h.read(shellReselectEventsProvider.notifier).fire(TasksPage.shellTab);
      await settle(tester);
      expect(find.text(_l.uiTasksFlyView), findsOneWidget);
      expect(
        find.text(_l.uiTasksNewTask),
        role == 'uye' ? findsNothing : findsOneWidget,
      );
      expect(
        h.backend.requests.where((r) => r.path.endsWith('/members')),
        isEmpty,
      );
    });
  }

  // Tur 2 (Codex 3): gerçek "Yeni görev" düğmesinden açılış — karma rolde (d1 üye, d2
  // koordinatör) varsayılan hedef hesaplanan açılabilir departman (d2), seçici yalnız
  // açılabilen departmanları listeler (d1 üyeliği yok).
  testWidgets(
    'sunucu kataloğu, karma rol: yeni görev varsayılanı ve seçenekleri',
    (tester) async {
      final pilot = PilotBackend();
      final h = await real(tester, () => pilotHarness(pilot, signedIn: true));
      h.backend.handler = (r) => switch ('${r.method} ${r.path}') {
        'GET /v1/me' => jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': false,
        }),
        'GET /v1/me/departments' => jsonResponse(200, {
          'departments': [
            for (final (id, name, role) in [
              ('d1', 'Üyelik Birimi', 'uye'),
              ('d2', 'Koordinasyon Birimi', 'koordinator'),
            ])
              {
                'program_id': 'prog-1',
                'program_name': 'Program Bir',
                'department_id': id,
                'display_name': name,
                'role': role,
              },
          ],
        }),
        'GET /v1/program/work-items' => jsonResponse(200, {
          'items': <Object>[],
        }),
        'GET /v1/departments/d2/members' => jsonResponse(200, {
          'members': <Object>[],
        }),
        _ => pilot.handle(r),
      };
      h.read(scopeControllerProvider).selectProgram('prog-1');
      await pumpScreen(tester, h, const TasksPage());
      await settle(tester);
      await _tap(tester, find.byIcon(Icons.add_rounded).first);
      expect(find.text(_l.uiTasksNtDesc), findsOneWidget);
      expect(find.text('Koordinasyon Birimi'), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksFieldCoord));
      expect(find.text('Koordinasyon Birimi'), findsWidgets);
      expect(
        find.text('Üyelik Birimi'),
        findsNothing,
        reason: 'üyelik departmanında görev açılamaz: seçenek değil',
      );
      expect(h.backend.requests.where((r) => r.path.contains('/d1/')), isEmpty);
    },
  );

  testWidgets('başlangıç süzgeci (ana sayfa kutusu) ve boş görünüm', (
    tester,
  ) async {
    await _open(
      tester,
      page: const TasksPage(view: NzTaskView.review, people: ['ko']),
    );
    // Liste başlığı yazısı yok (sayı görünüm kutusunda); süzgeçli boş görünüm, temizleyince liste.
    expect(find.text(_l.uiTasksEmpty), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksClearFilters));
    expect(find.text(_l.uiTasksEmpty), findsNothing);
    expect(find.byType(NzTaskCard), findsWidgets);
  });

  testWidgets('kabukta yeniden dokunma kısayol menüsünü açar', (tester) async {
    final (h, nav) = await _open(tester);
    h.read(shellReselectEventsProvider.notifier).fire(TasksPage.shellTab);
    await settle(tester);
    expect(find.text(_l.uiTasksFlyView), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksViewDone).last);
    // Tamamlananlar görünümü: geciken (açık) görev listede yok.
    expect(find.text('Su deposu temel betonunun yapılması'), findsNothing);
    expect(find.byType(NzTaskCard), findsWidgets);
    h.read(shellReselectEventsProvider.notifier).fire(TasksPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiTasksModeTimeline).last);
    expect(nav.calls, ['timeline']);
    // Başka sekmenin olayı menü açmaz.
    h.read(shellReselectEventsProvider.notifier).fire(0);
    await settle(tester);
    expect(find.text(_l.uiTasksFlyView), findsNothing);
  });

  for (final (width, scale) in [
    (360.0, 1.0),
    (360.0, 2.0),
    (390.0, 2.0),
    (834.0, 1.0),
    (1024.0, 2.0),
  ]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, dark: dark);
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 10; i++) {
            await tester.drag(scrollable, const Offset(0, -400));
            await tester.pump();
          }
          await _top(tester);
          expect(find.bySemanticsLabel('Liste'), findsOneWidget);
          expect(find.byIcon(Icons.filter_list_rounded), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
