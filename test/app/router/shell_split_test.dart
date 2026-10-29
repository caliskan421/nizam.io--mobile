// Tablet çift bölmesi (prototip `12-Tablet.dc.html` `Component`): gerçek yönlendirici +
// StatefulNavigationShell. Liste sol bölmede, kayıt sağ bölmede; seçim sağı değiştirir, sol
// liste (State) kalır; modül değişimi varsayılana döner; telefon ↔ tablet geçişinde liste ve
// ayrıntı State'i korunur.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/app/router/split.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/core/ui/widgets/nz_icon.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/calendar/calendar.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart';
import 'package:nizamio/features/messages/application/chat_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

Finder _rail(String label) =>
    find.descendant(of: find.byType(NzTabletRail), matching: find.text(label));

/// Üst çubuk "Geri" ikonu (tablette kaynak SVG'si çizilir; bileşen [NzIcon]).
final _backIcon = find.byWidgetPredicate(
  (w) => w is NzIcon && w.icon == Icons.arrow_back_ios_new_rounded,
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
    '1180×820: ray 100 + liste 390 (+1 kenar) + ayrıntı 689; varsayılan kayıt',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/tasks');
      await settle(tester);
      expect(find.byType(NzFloatingNav), findsNothing);
      expect(tester.getSize(find.byType(NzTabletRail)).width, 100);
      final master = find.byWidgetPredicate(
        (w) => w is NzPaneScope && w.role == NzPaneRole.master,
      );
      // Dıştaki sağ bölme bağlamı (sağ yığın içte kendi bağlamını verir).
      final detail = find
          .byWidgetPredicate(
            (w) => w is NzPaneScope && w.role == NzPaneRole.detail,
          )
          .first;
      expect(tester.getRect(master), const Rect.fromLTWH(100, 0, 390, 820));
      expect(tester.getRect(detail), const Rect.fromLTWH(491, 0, 689, 820));
      expect(
        _inPane(NzPaneRole.master, find.byType(TasksPage)),
        findsOneWidget,
      );
      expect(
        tester
            .widget<TaskDetailPage>(
              _inPane(NzPaneRole.detail, find.byType(TaskDetailPage)),
            )
            .code,
        SplitDefaults.task,
      );
      // Tek ekranlık sağ yığında "Geri" yok.
      expect(tester.widget<NzPaneScope>(detail).canBack, isFalse);
      expect(_inPane(NzPaneRole.detail, _backIcon), findsNothing);
      expect(
        tester.widget<NzTabletRail>(find.byType(NzTabletRail)).currentIndex,
        RailModule.tasks.index,
      );
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

  testWidgets('modül değişimi varsayılana döner; sohbet sağ bölmede açılır', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/tasks/ALT-7');
    await settle(tester);
    await tester.tap(_rail('Mesajlar'));
    await settle(tester);
    // Modüle giriş tabanın kaydıyla: daralınca aynı sohbet sayfası görünür.
    expect(locationOf(router), '/messages/${SplitDefaults.chat}');
    expect(
      _inPane(NzPaneRole.master, find.byType(MessagesPage)),
      findsOneWidget,
    );
    final chat = _inPane(NzPaneRole.detail, find.byType(ChatPage));
    expect(tester.widget<ChatPage>(chat).id, SplitDefaults.chat);
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
    expect(locationOf(router), '/archive/${SplitDefaults.archiveFolder}');
    expect(
      _inPane(NzPaneRole.master, find.byType(ArchivePage)),
      findsOneWidget,
    );
    expect(
      tester
          .widget<ArchiveFolderPage>(
            _inPane(NzPaneRole.detail, find.byType(ArchiveFolderPage)),
          )
          .code,
      SplitDefaults.archiveFolder,
    );
  });

  testWidgets('takvim: liste solda, sağda "Bir kayıt seç"; görev sağa itilir', (
    tester,
  ) async {
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
    expect(
      _inPane(NzPaneRole.detail, find.byType(CalendarEmptyDetail)),
      findsOneWidget,
    );
    final list = tester.state(find.byType(CalendarPage));
    tester.element(find.byType(CalendarPage)).appNav.openTask('ALT-5');
    await settle(tester);
    expect(locationOf(router), '/calendar?trail=task%3AALT-5');
    expect(tester.state(find.byType(CalendarPage)), same(list));
    expect(find.byType(TaskDetailPage).hitTestable(), findsOneWidget);
    // Sağ yığın iki ekran: "Geri" görünür ve izi kısaltır.
    await tester.tap(_inPane(NzPaneRole.detail, _backIcon).hitTestable().first);
    await settle(tester);
    expect(locationOf(router), '/calendar');
    expect(tester.state(find.byType(CalendarPage)), same(list));
  });

  testWidgets(
    'modüller arası sağ yığın: koordinatörlük → klasör → görev; sol liste sabit, geri yığında',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/coordinatorships');
      await settle(tester);
      final list = tester.state(find.byType(CoordinatorshipsPage));
      final nav = tester.element(find.byType(CoordinatorshipsPage)).appNav;
      // Varsayılan ALT zaten sağda: aynı kayıt yenilenir, konum değişmez (prototip `rHide`).
      nav.openCoordinatorship('ALT');
      await settle(tester);
      expect(locationOf(router), '/coordinatorships');
      router.go('/coordinatorships/ALT');
      await settle(tester);
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

  testWidgets(
    'aynı sohbet satırını yeniden seç taslağı ve yazma bağlamını sıfırlar '
    '(S_chat.load); yeniden boyut korur',
    (tester) async {
      final router = await _pump(tester, const Size(1180, 820));
      router.go('/messages/gen');
      await settle(tester);
      final field = find
          .descendant(
            of: find.byType(NzComposer),
            matching: find.byType(TextField),
          )
          .hitTestable();
      ChatViewState view() =>
          ProviderScope.containerOf(tester.element(find.byType(ChatPage)))
              .read(chatControllerProvider('gen'));
      ChatController ctrl() =>
          ProviderScope.containerOf(tester.element(find.byType(ChatPage)))
              .read(chatControllerProvider('gen').notifier);
      await tester.enterText(field.first, 'Taslak');
      ctrl()
        ..reply('g1')
        ..toggleRef(const ChatRef(ChatRefKind.task, 'ALT-5'))
        ..nextPin();
      await settle(tester);
      for (final size in const [Size(1032, 1376), Size(1180, 820)]) {
        tester.view.physicalSize = size;
        await settle(tester);
        expect(
          tester.widget<TextField>(field.first).controller!.text,
          'Taslak',
          reason: '$size',
        );
        expect(view().reply, 'g1', reason: '$size: yanıt bağlamı kalır');
        expect(view().refs, hasLength(1), reason: '$size');
      }
      // Ek paneli sağ bölmededir; sol satır basılabilir kalır.
      ctrl().toggleAttach();
      await settle(tester);
      expect(view().attach, isNotNull);
      await tester.tap(_inPane(NzPaneRole.master, find.text('Genel')));
      await settle(tester);
      expect(locationOf(router), '/messages/gen');
      expect(tester.widget<TextField>(field.first).controller!.text, isEmpty);
      final v = view();
      expect(v.reply, isNull, reason: 'yanıt çipi kalkar');
      expect(v.edit, isNull);
      expect(v.refs, isEmpty);
      expect(v.attach, isNull);
      expect(v.pin, 0);
    },
  );

  testWidgets('modüle dönünce son açılan kayıt (prototip alt ekranı kalıcı)', (
    tester,
  ) async {
    final router = await _pump(tester, const Size(1180, 820));
    router.go('/tasks/ALT-7');
    await settle(tester);
    await tester.tap(_rail('Arşiv'));
    await settle(tester);
    await tester.tap(_rail('Görevler'));
    await settle(tester);
    expect(locationOf(router), '/tasks/ALT-7');
    expect(
      tester
          .widget<TaskDetailPage>(
            _inPane(NzPaneRole.detail, find.byType(TaskDetailPage)),
          )
          .code,
      'ALT-7',
    );
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

  testWidgets(
    'telefon ↔ tablet: liste ve ayrıntı State korunur, rota aynı, hata yok',
    (tester) async {
      final router = await _pump(tester, const Size(390, 844));
      router.go('/tasks/ALT-7');
      await settle(tester);
      expect(find.byType(NzFloatingNav), findsOneWidget);
      final list = tester.state(find.byType(TasksPage, skipOffstage: false));
      final detail = tester.state(find.byType(TaskDetailPage));
      for (final size in const [
        Size(1180, 820),
        Size(390, 844),
        Size(1032, 1376),
        Size(820, 1180),
        Size(1376, 1032),
      ]) {
        tester.view.physicalSize = size;
        await settle(tester);
        final why = 'boyut $size';
        expect(tester.takeException(), isNull, reason: why);
        expect(locationOf(router), '/tasks/ALT-7', reason: why);
        expect(
          tester.state(find.byType(TasksPage, skipOffstage: false)),
          same(list),
          reason: why,
        );
        final top = find
            .byWidgetPredicate((w) => w is TaskDetailPage && w.code == 'ALT-7')
            .hitTestable();
        expect(tester.state(top), same(detail), reason: why);
        expect(
          find.byType(NzTabletRail),
          size.width >= 600 ? findsOneWidget : findsNothing,
          reason: why,
        );
        expect(
          _inPane(NzPaneRole.master, find.byType(TasksPage)),
          size.width >= 840 ? findsOneWidget : findsNothing,
          reason: why,
        );
      }
    },
  );

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
