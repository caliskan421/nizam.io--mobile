// TaskDetailPage: başlık bölümü, tarih talebi kartı (onay/ret), durum/öncelik alt sayfaları
// ve kuralları, sekmeler (özet, alt görev, dosya, not), düzenle/kanıt yükle/sil formları,
// silinmiş görev + geri al, kısayol menüsü; dar ekran × 2.0 metin × açık/koyu taşma yok.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  String code = 'ALT-7',
  bool dark = false,
}) async {
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectSample();
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    TaskDetailPage(code: code),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (h, nav);
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

Future<void> _top(WidgetTester tester) async {
  await tester.drag(find.byType(Scrollable).first, const Offset(0, 4000));
  await settle(tester);
}

/// Sunucu programında görev kataloğu ve ayrıntı uçları (tek görev `w1`, departman `d1`).
Map<String, Object> _serverBodies() => {
  '/v1/work-items/gantt/admin': {
    'tasks': [
      {
        'work_item_id': 'w1',
        'title': 'Hidrofor kurulumu',
        'program_id': 'prog-1',
        'department_id': 'd1',
        'priority': 'orta',
        'status': 'devam_ediyor',
        'start_on': '2026-10-01',
        'end_on': '2026-12-01',
        'planned_end_on': '',
        'completed_on': '',
        'assignee_account_ids': ['acc-1'],
        'lateness': {
          'is_overdue': false,
          'days_overdue': 0,
          'is_completed_late': false,
          'days_late': 0,
          'is_completed_early': false,
          'days_early': 0,
        },
      },
    ],
    'links': <Object>[],
  },
  '/v1/reports/dashboard/tasks': {'tasks': <Object>[], 'total': 0},
  '/v1/reports/dashboard/coordinatorships': {'coordinatorships': <Object>[]},
  '/v1/departments': {
    'departments': [
      {
        'department_id': 'd1',
        'name': 'Altyapı',
        'kind': 'koordinatorluk',
        'code': 'ALT',
      },
    ],
  },
  '/v1/admin/users': {
    'users': [
      {
        'account_id': 'acc-1',
        'full_name': 'Ayşe Yılmaz',
        'memberships': ['prog-1:d1:koordinator'],
      },
    ],
  },
  '/v1/work-items/w1/subtasks': {
    'subtasks': [
      {
        'subtask_id': 's1',
        'work_item_id': 'w1',
        'title': 'Pompa grubunun indirilmesi',
        'done': true,
        'created_by_account_id': 'acc-1',
        'created_at': '2026-10-02T08:00:00Z',
        'updated_at': '2026-10-02T08:00:00Z',
      },
    ],
    'total': 1,
  },
  '/v1/work-items/w1/notes': {
    'notes': [
      {
        'note_id': 'n1',
        'work_item_id': 'w1',
        'author_account_id': 'acc-1',
        'content': 'Pompa sahaya indi',
        'created_at': '2026-10-03T09:00:00Z',
        'updated_at': '2026-10-03T09:00:00Z',
      },
    ],
    'total': 1,
  },
  '/v1/work-items/w1/files': {
    'files': [
      {
        'file_id': 'f1',
        'work_item_id': 'w1',
        'display_name': 'Tutanak.pdf',
        'content_type': 'application/pdf',
        'size_bytes': 2048,
        'tag': 'cikti',
        'uploaded_by_account_id': 'acc-1',
      },
    ],
  },
  '/v1/date-change-requests': {'requests': <Object>[], 'total': 0},
};

/// Sunucu programıyla ayrıntıyı açar; [failing] yoldan 403 döner (sonra düzelir).
Future<Harness> _openServer(WidgetTester tester, {String? failing}) async {
  final backend = PilotBackend();
  final bodies = _serverBodies();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.backend.handler = (r) {
    if (r.method == 'GET' && r.path == failing) {
      return errorBody(403, 'work.not_assigned');
    }
    final body = r.method == 'GET' ? bodies[r.path] : null;
    return body != null ? jsonResponse(200, body) : backend.handle(r);
  };
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await pumpScreen(tester, h, const TaskDetailPage(code: 'w1'));
  await settle(tester);
  return h;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'sunucu programı: görünen kod departman kodu; ayrıntı görevin departmanıyla yüklenir',
    (tester) async {
      final h = await _openServer(tester);
      expect(find.text('ALT'), findsWidgets);
      expect(
        find.text('w1'),
        findsNothing,
        reason: 'sunucu kimliği gösterilmez',
      );
      expect(find.text('Hidrofor kurulumu'), findsOneWidget);
      for (final p in ['subtasks', 'notes', 'files']) {
        final r = h.backend.requests.lastWhere(
          (r) => r.path == '/v1/work-items/w1/$p',
        );
        expect(r.header('X-Nizamio-Department'), 'd1', reason: p);
        expect(r.header('X-Nizamio-Program'), 'prog-1', reason: p);
      }
      await _tap(tester, find.text(_l.uiTasksTabSubtasks));
      expect(find.text('Pompa grubunun indirilmesi'), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksTabFiles));
      expect(find.text('Tutanak.pdf'), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksTabNotes));
      expect(find.text('Pompa sahaya indi'), findsOneWidget);
    },
  );

  testWidgets(
    'sunucu programı: ayrıntı hatası şeritte; yeniden dene dokunuşla',
    (tester) async {
      final h = await _openServer(tester, failing: '/v1/work-items/w1/notes');
      expect(find.text('Hidrofor kurulumu'), findsOneWidget);
      expect(find.text(_l.uiCommonRetry), findsOneWidget);
      final before = h.backend.requests.length;
      await tester.pump(const Duration(seconds: 5));
      expect(
        h.backend.requests.length,
        before,
        reason: 'kendiliğinden yeniden deneme yok',
      );
      h.backend.handler = (r) {
        final body = r.method == 'GET' ? _serverBodies()[r.path] : null;
        return body != null
            ? jsonResponse(200, body)
            : PilotBackend().handle(r);
      };
      await _tap(tester, find.text(_l.uiCommonRetry));
      expect(find.text(_l.uiCommonRetry), findsNothing);
      await _tap(tester, find.text(_l.uiTasksTabNotes));
      expect(find.text('Pompa sahaya indi'), findsOneWidget);
    },
  );

  testWidgets('başlık, talep kartı, özet ve ilerleme', (tester) async {
    await _open(tester);
    expect(find.text('ALT-7'), findsOneWidget);
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    expect(
      find.text('Havalimanı yerleşkesi hidrofor sistemi kurulumu'),
      findsOneWidget,
    );
    expect(find.text(_l.uiTasksStatusDoing), findsOneWidget);
    expect(find.text(_l.uiTasksPrioHigh), findsOneWidget);
    expect(find.text(_l.uiTasksRequestTitle), findsOneWidget);
    expect(find.text('31.10.2026'), findsOneWidget);
    expect(find.text('+51 ${_l.uiTasksDaysLc}'), findsOneWidget);
    expect(find.text('Abdullah Ateş'), findsOneWidget);
    expect(find.text('10.06.2026'), findsOneWidget);
    expect(find.text('22.06 → 10.09.2026'), findsOneWidget);
    await tester.ensureVisible(find.text('41 ${_l.uiTasksEvLateTail}'));
  });

  testWidgets('sekmeler yapışkan; liste alt sayfaları küçük başlıklı', (
    tester,
  ) async {
    // Kısa görünüm: içerik başlığı aşacak kadar kayar.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 520);
    addTearDown(tester.view.reset);
    await _open(tester);
    await _tap(tester, find.text(_l.uiTasksTabSubtasks));
    final tabs = find.text(_l.uiTasksTabSubtasks);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
    await tester.pump();
    // Başlık kaydı; sekme şeridi üst çubuğun altında kalır.
    final kicker = find.text('Altyapı ve tesisat');
    expect(
      kicker.evaluate().isEmpty || tester.getTopLeft(kicker).dy < 0,
      isTrue,
    );
    expect(tabs, findsOneWidget);
    expect(tester.getTopLeft(tabs).dy, lessThan(140));
    await _top(tester);
    // Durum seçimi: prototip `rp-kicker` başlık, kapat düğmesi yok.
    await _tap(tester, find.text(_l.uiTasksStatusDoing));
    expect(find.text(_l.uiTasksSheetStatus), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('diğer işlemler başlığı Türkçe küçük harf', (tester) async {
    await _open(tester, code: 'İDA-2');
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    expect(find.text('ida-2'), findsOneWidget);
  });

  testWidgets('talep onayı ve durum kuralı bildirimleri', (tester) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiTasksApprove));
    expect(
      find.text(
        '${_l.uiTasksTApproved} · ALT-7 ${_l.uiTasksTNewDue} 31.10.2026',
      ),
      findsOneWidget,
    );
    expect(find.text(_l.uiTasksRequestTitle), findsNothing);
    expect(find.text('22.06 → 31.10.2026'), findsOneWidget);

    await _tap(tester, find.text(_l.uiTasksStatusDoing));
    expect(find.text('2 ${_l.uiTasksOpenSubsTail}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksStatusDone));
    expect(
      find.text('${_l.uiTasksTSubsBlock} · 1/3 ${_l.uiTasksTFinishedLc}'),
      findsOneWidget,
    );
    await _tap(tester, find.text(_l.uiTasksStatusDoing));
    await _tap(tester, find.text(_l.uiTasksStatusReview).last);
    expect(find.text('ALT-7 · ${_l.uiTasksStatusReview}'), findsOneWidget);

    await _tap(tester, find.text(_l.uiTasksPrioHigh));
    await _tap(tester, find.text(_l.uiTasksPrioLow).last);
    expect(
      find.text('${_l.uiTasksPriority}: ${_l.uiTasksPrioLow}'),
      findsOneWidget,
    );
    await _tap(tester, find.byIcon(Icons.notifications_none_rounded));
    expect(find.text('${_l.uiTasksTReminded} · Kadir Özbek'), findsOneWidget);
  });

  testWidgets('alt görev, kanıt yükleme ve not sekmeleri', (tester) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiTasksTabSubtasks));
    expect(find.text('Pompa tedarikçisinden teyit al'), findsOneWidget);
    expect(find.text('1 / 3 ${_l.uiTasksDoneLc}'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(RegExp('Basınç testi')).first);
    await _tap(
      tester,
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.label == 'Basınç testi ${_l.uiTasksDoneLc}',
      ),
    );
    expect(find.text(_l.uiTasksTSubEvidence), findsOneWidget);

    await _top(tester);
    await _tap(tester, find.text(_l.uiTasksUpload));
    expect(find.text(_l.uiTasksUploadTitle), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksUploadOk));
    expect(find.text(_l.uiTasksTUploaded), findsOneWidget);
    expect(find.text('Saha_fotografi_20261021.jpg'), findsOneWidget);

    await _top(tester);
    await _tap(tester, find.text(_l.uiTasksTabNotes));
    expect(find.text(_l.uiTasksInMemory), findsOneWidget);
    // Yükleme bildirimi alt kenardan çekilsin.
    await tester.pump(const Duration(seconds: 6));
    await settle(tester);
    await tester.enterText(
      find.byType(EditableText).last,
      'Basınç testi yarın',
    );
    await _tap(tester, find.byIcon(Icons.arrow_upward_rounded).last);
    expect(find.text('Basınç testi yarın'), findsOneWidget);
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).last)
          .controller
          .text,
      isEmpty,
    );
  });

  testWidgets('düzenle doğrulaması; sil ve geri al', (tester) async {
    await _open(tester);
    await _tap(tester, find.byIcon(Icons.edit_outlined).first);
    expect(find.text(_l.uiTasksEditTask), findsWidgets);
    await tester.enterText(find.byType(EditableText).first, '');
    await _tap(tester, find.text(_l.uiTasksSave));
    expect(find.text(_l.uiTasksErrTitleEmpty), findsOneWidget);
    await tester.enterText(
      find.byType(EditableText).first,
      'Hidrofor kurulumu',
    );
    await _tap(tester, find.text(_l.uiTasksSave));
    expect(find.text('ALT-7 ${_l.uiTasksTUpdatedTail}'), findsOneWidget);
    expect(find.text('Hidrofor kurulumu'), findsOneWidget);

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text(_l.uiTasksDeleteTask));
    expect(find.text('ALT-7 ${_l.uiTasksDeleteQTail}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksDeleteOk));
    expect(find.text('ALT-7 ${_l.uiTasksDeletedTail}'), findsOneWidget);
    expect(find.text(_l.uiTasksTDeleted), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksUndo));
    expect(find.text('Hidrofor kurulumu'), findsOneWidget);
  });

  testWidgets('kısayol menüsü: zaman çizelgesi ve görev listesi', (
    tester,
  ) async {
    final (h, nav) = await _open(tester);
    h.read(shellReselectEventsProvider.notifier).fire(1);
    await settle(tester);
    expect(find.text('ALT-7 · ${_l.uiTasksFlyThisTask}'), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksFlyTimeline));
    h.read(shellReselectEventsProvider.notifier).fire(1);
    await settle(tester);
    await _tap(tester, find.text(_l.uiTasksTaskList));
    expect(nav.calls, ['timeline:ALT', 'tasks']);
  });

  testWidgets('bilinmeyen görev', (tester) async {
    await _open(tester, code: 'YOK-1');
    expect(find.text(_l.uiTasksNotFound), findsOneWidget);
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
          await _open(tester, dark: dark);
          for (final tab in [
            _l.uiTasksTabSubtasks,
            _l.uiTasksTabFiles,
            _l.uiTasksTabNotes,
          ]) {
            await _tap(tester, find.text(tab));
            final scrollable = find.byType(Scrollable).first;
            for (var i = 0; i < 4; i++) {
              await tester.drag(scrollable, const Offset(0, -400));
              await tester.pump();
            }
            await _top(tester);
          }
          await _tap(tester, find.text(_l.uiTasksTabSubtasks));
          await _tap(tester, find.text('Montaj ekibini planla'));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
