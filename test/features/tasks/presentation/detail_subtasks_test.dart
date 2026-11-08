// Alt görev işareti (toplantı gündemiyle aynı hareket): işaret yazma sürerken anında görünür,
// madde 360 ms yerinde kalıp tamamlananların arasına kayar; işaret kaldırma beklemesiz açıkların
// arasındaki yerine döner. Sunucu reddederse işaret geri alınır.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/motion/nz_check_motion.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../task_detail_server.dart';

final _l = AppLocalizationsTr();

List<String> _order(WidgetTester tester) => [
  for (final w in tester.widgetList<NzStrikeText>(find.byType(NzStrikeText)))
    w.text,
];

bool _struck(WidgetTester tester, String title) => tester
    .widget<NzStrikeText>(
      find.byWidgetPredicate((w) => w is NzStrikeText && w.text == title),
    )
    .done;

Future<void> _check(WidgetTester tester, String title) async {
  await tester.tap(find.bySemanticsLabel(RegExp('^$title ')).first);
  await tester.pump();
}

/// Alt görevleri `done` alanını sunucuda gerçekten değiştiren sunucu.
TaskDetailServer _server({bool reject = false}) {
  final s = TaskDetailServer()
    ..subtasks = [
      subtaskWire('s1', done: false),
      subtaskWire('s2', done: false),
      subtaskWire('s3', done: false),
    ];
  for (final id in ['s1', 's2', 's3']) {
    s.writes['PATCH /v1/work-items/w1/subtasks/$id'] = () {
      if (reject) return errorBody(409, 'work.item_completed');
      final i = s.subtasks.indexWhere((x) => x['subtask_id'] == id);
      final row = {...s.subtasks[i], 'done': !(s.subtasks[i]['done']! as bool)};
      s.subtasks[i] = row;
      return jsonResponse(200, row);
    };
  }
  return s;
}

Future<Harness> _open(WidgetTester tester, TaskDetailServer server) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 1600);
  addTearDown(tester.view.reset);
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.backend.handler = server.handle;
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await real(
    tester,
    () => h.container.read(taskCatalogControllerProvider.future),
  );
  h.container
      .read(taskDetailControllerProvider('w1').notifier)
      .selectTab(TaskDetailTab.subtasks);
  await pumpScreen(tester, h, const TaskDetailPage(code: 'w1'));
  await settle(tester);
  return h;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('işaret: anında, yerinde 360 ms, sonra alta; geri alma hemen', (
    tester,
  ) async {
    await _open(tester, _server());
    expect(_order(tester), ['Alt s1', 'Alt s2', 'Alt s3']);

    await _check(tester, 'Alt s1');
    expect(_struck(tester, 'Alt s1'), isTrue, reason: 'iyimser');
    expect(_order(tester).first, 'Alt s1', reason: 'yerinde');
    await tester.pump(const Duration(milliseconds: 380));
    expect(_order(tester), ['Alt s2', 'Alt s3', 'Alt s1']);
    await settle(tester);
    expect(_struck(tester, 'Alt s1'), isTrue, reason: 'sunucu onayladı');

    await _check(tester, 'Alt s1');
    expect(_order(tester), [
      'Alt s1',
      'Alt s2',
      'Alt s3',
    ], reason: 'beklemesiz');
    await settle(tester);
    expect(_struck(tester, 'Alt s1'), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sunucu reddederse işaret geri alınır', (tester) async {
    await _open(tester, _server(reject: true));
    await _check(tester, 'Alt s2');
    expect(_struck(tester, 'Alt s2'), isTrue);
    await settle(tester);
    expect(_struck(tester, 'Alt s2'), isFalse);
    expect(_order(tester), ['Alt s1', 'Alt s2', 'Alt s3']);
  });

  testWidgets('yetkisiz işaret: soluk, dokununca neden bildirilir, istek yok', (
    tester,
  ) async {
    // Şirket yöneticisi, departmanda üye ve göreve atanmamış: kapatamaz (WORK-K71).
    final server = _server()
      ..admin = true
      ..role = 'uye';
    final h = await _open(tester, server);
    h.backend.requests.clear();
    await _check(tester, 'Alt s1');
    await settle(tester);
    expect(_struck(tester, 'Alt s1'), isFalse);
    expect(find.text(_l.uiTasksSubCheckBlocked), findsOneWidget);
    expect(h.backend.requests.where((r) => r.method == 'PATCH'), isEmpty);
  });

  testWidgets('alt görev ekle: onaydan sonra kapanan sayfa hata vermez', (
    tester,
  ) async {
    final h = await _open(tester, _server());
    await tester.tap(find.text(_l.uiTasksSubAdd));
    await settle(tester);
    await tester.enterText(find.byType(EditableText).last, 'Vana kontrolü');
    await tester.pump();
    await tester.tap(find.text(_l.uiTasksCreate).last);
    // Kapanış hareketi boyunca (liste yenilenir, toast çıkar) kare kare çiz.
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(
      h.backend.requests.where(
        (r) => r.method == 'POST' && r.path.endsWith('/subtasks'),
      ),
      hasLength(1),
    );
    await tester.pump(const Duration(seconds: 5));
  });
}
