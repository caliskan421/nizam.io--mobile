// Tablet çift bölmesi (prototip `12-Tablet.dc.html` `Component`): gerçek yönlendirici +
// StatefulNavigationShell. Liste sol bölmede, kayıt sağ bölmede; seçim sağı değiştirir, sol
// liste (State) kalır; modül değişimi varsayılana döner; telefon ↔ tablet geçişinde liste ve
// ayrıntı State'i korunur.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/app/router/split.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_pick_record.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/core/ui/widgets/nz_icon.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/calendar/calendar.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

Finder _rail(String label) =>
    find.descendant(of: find.byType(NzTabletRail), matching: find.text(label));

/// Üst çubuk "Geri" ikonu.
final _backIcon = find.byWidgetPredicate(
  (w) => w is NzIcon && w.icon == NzIcons.back,
);

Finder _inPane(NzPaneRole role, Finder f) => find.descendant(
  of: find.byWidgetPredicate((w) => w is NzPaneScope && w.role == role),
  matching: f,
);

Future<GoRouter> _pump(WidgetTester tester, Size size) async {
  final phase = ValueNotifier(AppPhase.scoped);
  addTearDown(phase.dispose);
  final router = await pumpRouter(
    tester,
    phase,
    width: size.width,
    height: size.height,
  );
  await settle(tester);
  return router;
}

void main() {
  setUpFonts();

  testWidgets(
    'Arşiv: kökte liste tam genişlik, klasör açılınca bölünür ve geri kapanır',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/archive');
      await settle(tester);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(tester.getSize(find.byType(NzTabletRail)).width, 100);
      final master = find.byWidgetPredicate(
        (w) => w is NzPaneScope && w.role == NzPaneRole.master,
      );
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
      expect(find.byType(NzPickRecord).hitTestable(), findsNothing);
      final list = tester.state(find.byType(ArchivePage));
      tester.element(find.byType(ArchivePage)).appNav.openArchiveFolder('ALT');
      await settle(tester);
      expect(locationOf(router), '/archive/ALT');
      expect(tester.state(find.byType(ArchivePage)), same(list));
      // Dıştaki sağ bölme bağlamı (sağ yığın içte kendi bağlamını verir).
      final detail = find
          .byWidgetPredicate(
            (w) => w is NzPaneScope && w.role == NzPaneRole.detail,
          )
          .first;
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 390, 820));
      expect(tester.getRect(detail), const Rect.fromLTWH(491, 0, 689, 820));
      expect(
        _inPane(NzPaneRole.master, find.byType(ArchivePage)),
        findsOneWidget,
      );
      expect(
        _inPane(NzPaneRole.detail, find.byType(ArchiveFolderPage)),
        findsOneWidget,
      );
      final back = _inPane(NzPaneRole.detail, _backIcon).hitTestable();
      expect(back, findsOneWidget);
      expect(
        tester.widget<NzTabletRail>(find.byType(NzTabletRail)).currentIndex,
        RailModule.archive.index,
      );
      await tester.tap(back.first);
      await settle(tester);
      expect(locationOf(router), '/archive');
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
    },
  );

  testWidgets(
    'Görevler: kökte liste tam genişlik; görev açılınca 390, Geri kapatır',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/tasks?view=late');
      await settle(tester);
      final master = find.byWidgetPredicate(
        (w) => w is NzPaneScope && w.role == NzPaneRole.master,
      );
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
      expect(find.byType(NzPickRecord).hitTestable(), findsNothing);
      final list = tester.state(find.byType(TasksPage));

      tester.element(find.byType(TasksPage)).appNav.openTask('ALT-7');
      await settle(tester);
      expect(locationOf(router), '/tasks/ALT-7');
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 390, 820));
      expect(tester.state(find.byType(TasksPage)), same(list));
      final back = _inPane(NzPaneRole.detail, _backIcon).hitTestable();
      expect(back, findsOneWidget);

      await tester.tap(back);
      await settle(tester);
      // Süzgeç korunur; liste yeniden tam genişlik, aynı State.
      expect(locationOf(router), '/tasks?view=late');
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
      expect(tester.state(find.byType(TasksPage)), same(list));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Koordinatörlükler: kökte liste tam genişlik; kayıt açılınca 390, Geri kapatır',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/coordinatorships');
      await settle(tester);
      final master = find.byWidgetPredicate(
        (w) => w is NzPaneScope && w.role == NzPaneRole.master,
      );
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));

      tester
          .element(find.byType(CoordinatorshipsPage))
          .appNav
          .openCoordinatorship('ALT');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT');
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 390, 820));

      await tester.tap(_inPane(NzPaneRole.detail, _backIcon).hitTestable());
      await settle(tester);
      expect(locationOf(router), '/coordinatorships');
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
      // Modüle dönüş son kaydı geri getirmez.
      await tester.tap(_rail('Arşiv'));
      await settle(tester);
      await tester.tap(_rail('Koordinatörlükler'));
      await settle(tester);
      expect(locationOf(router), '/coordinatorships');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'seçim sağ bölmeyi değiştirir, sol liste aynı State; aynı modül yeniden dokunuşu',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/tasks');
      await settle(tester);
      final list = tester.state(find.byType(TasksPage));
      tester.element(find.byType(TasksPage)).appNav.openTask('ALT-7');
      await settle(tester);
      expect(locationOf(router), '/tasks/ALT-7');
      expect(tester.state(find.byType(TasksPage)), same(list));
      expect(
        tester
            .widget<TaskDetailPage>(find.byType(TaskDetailPage).hitTestable())
            .code,
        'ALT-7',
      );
      // Prototip `tgo`: aynı modül, sağ yığın tek ekran → değişiklik yok.
      await tester.tap(_rail('Görevler'));
      await settle(tester);
      expect(locationOf(router), '/tasks/ALT-7');
      expect(tester.state(find.byType(TasksPage)), same(list));
    },
  );

  testWidgets(
    'modül değişimi son açılan kayda döner; sohbet sağ bölmede açılır',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/tasks/ALT-7');
      await settle(tester);
      await tester.tap(_rail('Mesajlar'));
      await settle(tester);
      // Sohbet hiç açılmamış: modül kökü, sağda "Bir kayıt seç".
      expect(locationOf(router), '/messages');
      expect(
        _inPane(NzPaneRole.master, find.byType(MessagesPage)),
        findsOneWidget,
      );
      expect(
        _inPane(NzPaneRole.detail, find.byType(NzPickRecord)),
        findsOneWidget,
      );
      final list = tester.state(find.byType(MessagesPage));

      tester.element(find.byType(MessagesPage)).appNav.openChat('gen');
      await settle(tester);
      expect(locationOf(router), '/messages/gen');
      expect(tester.state(find.byType(MessagesPage)), same(list));
      expect(
        tester.widget<ChatPage>(find.byType(ChatPage).hitTestable().first).id,
        'gen',
      );
      expect(find.byType(NzFloatingNav), findsNothing);

      await tester.tap(_rail('Arşiv'));
      await settle(tester);
      expect(locationOf(router), '/archive');
      expect(
        _inPane(NzPaneRole.master, find.byType(ArchivePage)),
        findsOneWidget,
      );
      expect(
        _inPane(NzPaneRole.detail, find.byType(NzPickRecord)),
        findsNothing,
      );
      expect(
        _inPane(NzPaneRole.detail, find.byType(ArchiveFolderPage)),
        findsNothing,
      );

      // Modüle giriş tabanın son kaydıyla: daralınca aynı kayıt sayfası görünür.
      await tester.tap(_rail('Mesajlar'));
      await settle(tester);
      expect(locationOf(router), '/messages/gen');
      final chat = _inPane(NzPaneRole.detail, find.byType(ChatPage));
      expect(tester.widget<ChatPage>(chat).id, 'gen');
      // Görevler son görevi geri getirmez: kök, liste tam genişlik.
      await tester.tap(_rail('Görevler'));
      await settle(tester);
      expect(locationOf(router), '/tasks');
    },
  );

  testWidgets(
    'ana sayfa: kökte tam genişlik (geçmiş kapalı); geçmiş açılınca 390, "Kapat" genişletir',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/home');
      await settle(tester);
      final master = find.byWidgetPredicate(
        (w) => w is NzPaneScope && w.role == NzPaneRole.master,
      );
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));
      expect(
        find.byType(NzPickRecord),
        findsNothing,
        reason: 'sağ bölme gizli',
      );
      expect(find.byType(ActivityPage), findsNothing);

      tester.element(find.byType(NzTabletRail)).appNav.openHistory();
      await settle(tester);
      expect(locationOf(router), '/home/history');
      expect(find.byType(ActivityPage).hitTestable(), findsOneWidget);
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 390, 820));

      await tester.tap(find.bySemanticsLabel('Kapat').hitTestable());
      await settle(tester);
      expect(locationOf(router), '/home');
      expect(find.byType(ActivityPage), findsNothing);
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 1080, 820));

      // Modüle geri giriş geçmişi hatırlamaz (kimliksiz; yalnız dokunuşla açılır).
      tester.element(find.byType(NzTabletRail)).appNav.openHistory();
      await settle(tester);
      await tester.tap(_rail('Görevler'));
      await settle(tester);
      await tester.tap(_rail('Ana sayfa'));
      await settle(tester);
      expect(locationOf(router), '/home');
      expect(find.byType(ActivityPage), findsNothing);
    },
  );

  testWidgets(
    'takvim: kök tam genişlik; görev sağa itilir, geri tam genişliğe döner',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/home');
      await settle(tester);
      await tester.tap(_rail('Takvim'));
      await settle(tester);
      expect(locationOf(router), '/calendar');
      expect(
        _inPane(NzPaneRole.master, find.byType(CalendarPage)),
        findsOneWidget,
      );
      expect(find.byType(CalendarEmptyDetail).hitTestable(), findsNothing);
      final list = tester.state(find.byType(CalendarPage));
      tester.element(find.byType(CalendarPage)).appNav.openTask('ALT-5');
      await settle(tester);
      expect(locationOf(router), '/calendar?trail=task%3AALT-5');
      expect(tester.state(find.byType(CalendarPage)), same(list));
      expect(find.byType(TaskDetailPage).hitTestable(), findsOneWidget);
      // "Geri" kaydı kapatır: kök yeniden tam genişlik.
      await tester.tap(
        _inPane(NzPaneRole.detail, _backIcon).hitTestable().first,
      );
      await settle(tester);
      expect(locationOf(router), '/calendar');
      expect(tester.state(find.byType(CalendarPage)), same(list));
    },
  );

  testWidgets(
    'modüller arası sağ yığın: koordinatörlük → klasör → görev; sol liste sabit, geri yığında',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/coordinatorships');
      await settle(tester);
      final list = tester.state(find.byType(CoordinatorshipsPage));
      final nav = tester.element(find.byType(CoordinatorshipsPage)).appNav;
      // Taban boş ("Bir kayıt seç"): listeden seçilen kayıt tabana oturur.
      nav.openCoordinatorship('ALT');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT');
      // Aynı kayıt en üstte: yenilenir, konum değişmez (prototip `rHide`).
      nav.openCoordinatorship('ALT');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT');
      final cdetail = tester.state(
        find.byWidgetPredicate(
          (w) => w is CoordinatorshipPage && w.code == 'ALT',
        ),
      );
      nav.openArchiveFolder('ALT');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT?trail=folder%3AALT');
      expect(find.byType(ArchiveFolderPage).hitTestable(), findsWidgets);
      nav.openTask('ALT-5');
      await settle(tester);
      expect(
        locationOf(router),
        '/coordinatorships/ALT?trail=folder%3AALT&trail=task%3AALT-5',
      );
      expect(tester.state(find.byType(CoordinatorshipsPage)), same(list));
      expect(
        tester.widget<NzTabletRail>(find.byType(NzTabletRail)).currentIndex,
        RailModule.coordinatorships.index,
      );
      // Aynı türün gerideki kaydına dönülür (prototip `rs.slice(0, i + 1)`).
      nav.openArchiveFolder('MEK');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT?trail=folder%3AMEK');
      // Geri: klasör → koordinatörlük ayrıntısı; ayrıntının State'i korunmuş.
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/ALT');
      expect(
        tester.state(
          find.byWidgetPredicate(
            (w) => w is CoordinatorshipPage && w.code == 'ALT',
          ),
        ),
        same(cdetail),
      );
      expect(tester.state(find.byType(CoordinatorshipsPage)), same(list));
      // Taban türü yeniden seçilince iz düşer, taban değişir.
      nav.openArchiveFolder('ALT');
      await settle(tester);
      nav.openCoordinatorship('MEK');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships/MEK');
    },
  );

  testWidgets('sohbetten görev: sol Mesajlar kalır; aynı kaydı yeniden seç', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/messages/gen');
    await settle(tester);
    final list = tester.state(find.byType(MessagesPage));
    final nav = tester.element(find.byType(MessagesPage)).appNav;
    nav.openTask('ALT-5');
    await settle(tester);
    expect(locationOf(router), '/messages/gen?trail=task%3AALT-5');
    final before = tester.state(find.byType(TaskDetailPage).hitTestable());
    ScrollPosition detailScroll() => tester
        .state<ScrollableState>(
          find
              .descendant(
                of: find.byType(TaskDetailPage).hitTestable(),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position;
    detailScroll().jumpTo(200);
    await tester.pump();
    expect(detailScroll().pixels, 200);
    // Aynı kayıt: yığın büyümez, ekran solarak yeniden görünür; State (form/taslak) korunur.
    nav.openTask('ALT-5');
    await settle(tester);
    expect(locationOf(router), '/messages/gen?trail=task%3AALT-5');
    expect(
      tester.state(find.byType(TaskDetailPage).hitTestable()),
      same(before),
    );
    // Kaynak `rHide`: kaydırma başa döner.
    expect(detailScroll().pixels, 0);
    expect(tester.state(find.byType(MessagesPage)), same(list));
  });

  testWidgets('arşive dönünce klasör kapanır ve liste tam genişler', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/archive/ALT');
    await settle(tester);
    await tester.tap(_rail('Takvim'));
    await settle(tester);
    await tester.tap(_rail('Arşiv'));
    await settle(tester);
    expect(locationOf(router), '/archive');
    expect(find.byType(ArchiveFolderPage).hitTestable(), findsNothing);
    expect(find.byType(ArchivePage).hitTestable(), findsOneWidget);
  });

  testWidgets('iz genişlik değişiminde korunur (tablet ↔ telefon)', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/coordinatorships/ALT?trail=folder%3AALT');
    await settle(tester);
    final folder = tester.state(find.byType(ArchiveFolderPage).hitTestable());
    for (final size in const [
      Size(390, 844),
      Size(820, 1180),
      Size(1180, 820),
    ]) {
      tester.view.physicalSize = size;
      await settle(tester);
      expect(tester.takeException(), isNull, reason: '$size');
      expect(
        locationOf(router),
        '/coordinatorships/ALT?trail=folder%3AALT',
        reason: '$size',
      );
      expect(
        tester.state(find.byType(ArchiveFolderPage).hitTestable()),
        same(folder),
        reason: '$size',
      );
    }
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(locationOf(router), '/coordinatorships/ALT');
  });

  testWidgets('zaman çizelgesi: ray kalır, liste gizli; geri ve görev açma', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/coordinatorships/ALT');
    await settle(tester);
    tester
        .element(find.byType(CoordinatorshipsPage))
        .appNav
        .openTimeline(coordinatorship: 'ALT');
    await settle(tester);
    expect(find.byType(HorizontalTimelinePage), findsOneWidget);
    expect(find.byType(NzTabletRail), findsOneWidget);
    expect(find.byType(CoordinatorshipsPage).hitTestable(), findsNothing);
    expect(
      tester.widget<NzTabletRail>(find.byType(NzTabletRail).last).currentIndex,
      RailModule.coordinatorships.index,
    );
    tester
        .widget<HorizontalTimelinePage>(find.byType(HorizontalTimelinePage))
        .onBack!();
    await settle(tester);
    expect(locationOf(router), '/coordinatorships/ALT');
    expect(find.byType(HorizontalTimelinePage), findsNothing);

    tester.element(find.byType(CoordinatorshipsPage)).appNav.openTimeline();
    await settle(tester);
    tester
        .widget<HorizontalTimelinePage>(find.byType(HorizontalTimelinePage))
        .onOpenTask!('ALT-5');
    await settle(tester);
    expect(locationOf(router), '/tasks/ALT-5');
    expect(find.byType(HorizontalTimelinePage), findsNothing);
    // Geri çizelgeye değil modül tabanına döner.
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(locationOf(router), '/tasks');
  });

  testWidgets('telefonda kabuk içi sohbet (tabletten daralınca) alt menüsüz', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(390, 844));
    router.go('/messages/gen');
    await settle(tester);
    expect(find.byType(ChatPage), findsOneWidget);
    expect(find.byType(NzFloatingNav), findsNothing);
    expect(find.byType(NzAdaptiveShell), findsOneWidget);
  });
}
