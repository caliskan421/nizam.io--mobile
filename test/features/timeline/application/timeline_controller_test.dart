// TimelineController + timelineView: sunucu biçimli program fikstüründen (CoordBackend: ALT 4,
// ELE 2, EGI 3 görev) koordinatörlük seçimi, durum/kişi/öncelik/arama süzgeci, ölçek, genel
// bakış, seçim, tarih taslağı (−/+, kaydır, sürükle), kaydet/geri al ve tarih talebi. Bugün
// sahtelenmez: beklentiler fikstürün sabit tarihlerine ve mevcut aralığa görelidir.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';

import '../../../support/fake_backend.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

const _altItems = {'wi-alt-1', 'wi-alt-2', 'wi-alt-3', 'wi-alt-4'};

Future<(ProviderContainer, TimelineController, TimelineView Function())> _open([
  String? coord = dAlt,
  bool admin = true,
]) async {
  final backend = CoordBackend()..admin = admin;
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  final c = h.container;
  c.listen(timelineViewProvider(coord), (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  await c.read(ganttScheduleProvider.future);
  addTearDown(() => expect(backend.unhandled, isEmpty));
  return (
    c,
    c.read(timelineControllerProvider(coord).notifier),
    () => c.read(timelineViewProvider(coord)).requireValue,
  );
}

Set<String> _codes(TimelineView v) => v.shown.map((t) => t.code).toSet();

void main() {
  test('tarih çakışması eski taslağı kapatır ve yeniden okur', () async {
    final backend = CoordBackend()..admin = false;
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    final c = h.container;
    c.listen(timelineViewProvider(dAlt), (_, _) {});
    await c.read(taskCatalogControllerProvider.future);
    await c.read(ganttScheduleProvider.future);
    final ctrl = c.read(timelineControllerProvider(dAlt).notifier);
    ctrl.select('wi-alt-1');
    ctrl.nudgeEnd(5);
    h.backend.requests.clear();
    h.backend.handler = (r) =>
        r.method == 'POST' && r.path == '/v1/date-change-requests'
        ? envelope(409, 'work.edit_conflict')
        : backend.handle(r);
    await expectLater(ctrl.requestDates(reason: 'Gerekçe'), throwsA(anything));
    expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
    expect(h.backend.count('GET', '/v1/program/work-items'), 1);
    expect(
      await ctrl.requestDates(reason: 'Gerekçe'),
      isA<TimelineRequestNoChange>(),
    );
  });
  test(
    'tarih talebi kaydedildikten sonra katalog hatası başarıyı gizlemez',
    () async {
      final backend = CoordBackend()..admin = false;
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(timelineViewProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await c.read(ganttScheduleProvider.future);
      final ctrl = c.read(timelineControllerProvider(dAlt).notifier);
      ctrl.select('wi-alt-1');
      ctrl.nudgeEnd(5);
      var written = false;
      h.backend.handler = (r) {
        if (r.method == 'POST' && r.path == '/v1/date-change-requests') {
          written = true;
          return backend.handle(r);
        }
        if (written &&
            r.method == 'GET' &&
            r.path == '/v1/program/work-items') {
          return envelope(500, 'platform.internal');
        }
        return backend.handle(r);
      };
      expect(
        await ctrl.requestDates(reason: 'Gerekçe'),
        isA<TimelineRequestSent>(),
      );
      expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
      expect(h.backend.count('GET', '/v1/program/work-items'), greaterThan(1));
    },
  );
  test(
    'tarih talebi belirsizse aynı anahtar, gövde ve açılış sürümüyle yinelenir',
    () async {
      final backend = CoordBackend()..admin = false;
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(timelineViewProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await c.read(ganttScheduleProvider.future);
      final ctrl = c.read(timelineControllerProvider(dAlt).notifier);
      ctrl.select('wi-alt-1');
      ctrl.nudgeEnd(5);
      var posts = 0;
      h.backend.handler = (r) {
        if (r.method == 'POST' &&
            r.path == '/v1/date-change-requests' &&
            ++posts == 1) {
          timeout(null);
        }
        return backend.handle(r);
      };
      await expectLater(
        ctrl.requestDates(reason: 'Gerekçe'),
        throwsA(anything),
      );
      expect(
        await ctrl.requestDates(reason: 'Gerekçe'),
        isA<TimelineRequestSent>(),
      );
      final seen = h.backend.requests
          .where(
            (r) => r.method == 'POST' && r.path == '/v1/date-change-requests',
          )
          .toList();
      expect(seen, hasLength(2));
      expect(seen[0].body, seen[1].body);
      expect(seen[0].header('Idempotency-Key'), isNotEmpty);
      expect(
        seen[0].header('Idempotency-Key'),
        seen[1].header('Idempotency-Key'),
      );
      expect((seen[0].body! as Map)['expected_dates_revision'], isNotNull);
    },
  );
  test(
    'rota parametresi o koordinatörlüğü seçili açar; hafta ölçeği',
    () async {
      final (_, _, view) = await _open();
      final v = view();
      expect(v.selectedCoordinatorships, [dAlt]);
      expect(v.multi, isFalse);
      expect(v.state.scale, TimelineScale.week);
      expect(_codes(v), _altItems);
      expect(v.statusCounts[TimelineStatusFilter.all], 4);
      expect(v.statusCounts[TimelineStatusFilter.done], 2);
      // Bitişi (20 Eki) geçmiş, bitmemiş iki görev gecikmede.
      expect(v.statusCounts[TimelineStatusFilter.late], 2);
    },
  );

  test('rota yok ya da "*": bütün koordinatörlükler seçili', () async {
    final (_, _, none) = await _open(null);
    expect(none().allSelected, isTrue);
    expect(none().shown, hasLength(9));
    final (_, ctrl, all) = await _open(timelineAllCoordinatorships);
    expect(all().allSelected, isTrue);
    expect(all().multi, isTrue);
    ctrl.toggleCoordinatorship(dAlt);
    expect(all().selectedCoordinatorships, isNot(contains(dAlt)));
    expect(_codes(all()).intersection(_altItems), isEmpty);
  });

  test(
    'koordinatörlük seçimi: ekle (katalog sırası), çıkar, hepsi/hiçbiri',
    () async {
      final (c, ctrl, view) = await _open();
      final order = c
          .read(taskCatalogControllerProvider)
          .requireValue
          .coordinatorships
          .map((x) => x.code)
          .toList();
      ctrl
        ..toggleCoordMenu()
        ..toggleCoordinatorship(dEgi)
        ..toggleCoordinatorship(dEle);
      expect(view().selectedCoordinatorships, [
        for (final x in order)
          if ({dAlt, dEgi, dEle}.contains(x)) x,
      ]);
      expect(view().multi, isTrue);
      expect(view().state.coordMenuOpen, isTrue);
      ctrl.toggleCoordinatorship(dAlt);
      expect(view().selectedCoordinatorships.toSet(), {dEgi, dEle});
      ctrl.toggleAllCoordinatorships();
      expect(view().noneSelected, isTrue);
      expect(view().empty, isTrue);
      ctrl.toggleAllCoordinatorships();
      expect(view().allSelected, isTrue);
      ctrl.closeCoordMenu();
      expect(view().state.coordMenuOpen, isFalse);
    },
  );

  test(
    'filtre penceresi temizlenince bütün koordinatörlükler geri gelir',
    () async {
      final (_, ctrl, view) = await _open();
      ctrl
        ..setStatus(TimelineStatusFilter.late)
        ..togglePerson(pKadir)
        ..togglePriority(TaskPriority.high)
        ..clearSheetFilters();
      expect(view().allSelected, isTrue);
      expect(view().state.status, TimelineStatusFilter.all);
      expect(view().state.people, isEmpty);
      expect(view().state.priorities, isEmpty);
      expect(view().shown, hasLength(9));
    },
  );

  test('durum, kişi, öncelik ve arama süzgeci; temizle durumu korur', () async {
    final (_, ctrl, view) = await _open();
    ctrl.setStatus(TimelineStatusFilter.late);
    expect(_codes(view()), {'wi-alt-1', 'wi-alt-2'});
    expect(view().state.filterCount, 1);

    ctrl
      ..setStatus(TimelineStatusFilter.all)
      ..togglePerson(pKadir);
    expect(_codes(view()), {'wi-alt-1', 'wi-alt-4'});
    expect(
      view().personOptions.firstWhere((p) => p.id == pKadir).selected,
      isTrue,
    );
    ctrl.togglePriority(TaskPriority.high);
    expect(view().shown, isEmpty, reason: 'fikstürde yüksek öncelik yok');
    expect(view().state.hasChips, isTrue);
    ctrl.clearFilters();
    expect(_codes(view()), _altItems);
    expect(view().state.hasChips, isFalse);

    ctrl
      ..setStatus(TimelineStatusFilter.late)
      ..togglePerson(pKadir)
      ..clearFilters();
    expect(view().state.status, TimelineStatusFilter.late);
    expect(view().state.filterCount, 1);

    ctrl
      ..setStatus(TimelineStatusFilter.all)
      ..setQuery('hidrofor');
    expect(_codes(view()), {'wi-alt-2'});
    ctrl.setQuery('Ali Avcı');
    expect(_codes(view()), {'wi-alt-2'}, reason: 'atanan kişi adı');
    ctrl.setQuery('');
    expect(_codes(view()), _altItems);
  });

  test('yakınlaştır / uzaklaştır: gün ↔ hafta ↔ ay, uçlarda etkisiz', () async {
    final (_, ctrl, view) = await _open();
    ctrl
      ..zoomIn()
      ..zoomIn();
    expect(view().state.scale, TimelineScale.day);
    ctrl
      ..zoomOut()
      ..zoomOut()
      ..zoomOut();
    expect(view().state.scale, TimelineScale.month);
  });

  test('genel bakış; sütuna dokunma tek koordinatörlük açar', () async {
    final (_, ctrl, view) = await _open();
    ctrl.setOverview(true);
    expect(view().state.overview, isTrue);
    expect(view().overviewGroups.map((g) => g.code), contains(dEle));
    ctrl.openOverviewColumn(dEle);
    expect(view().state.overview, isFalse);
    expect(view().selectedCoordinatorships, [dEle]);
  });

  test(
    'seçim + taslak: −/+, kaydır, sürükle; sınırlar; süzgeç seçimi kapatır',
    () async {
      final (_, ctrl, view) = await _open();
      ctrl.select('wi-alt-2');
      var sel = view().selection!;
      expect(sel.task.code, 'wi-alt-2');
      expect(sel.coordinatorshipName, 'Altyapı ve tesisat');
      expect(sel.changed, isFalse);
      final cur = sel.current;

      ctrl
        ..nudgeStart(-1)
        ..nudgeEnd(1);
      sel = view().selection!;
      expect(sel.draft, DayRange(cur.start - 1, cur.end + 1));
      expect((sel.startDelta, sel.endDelta), (-1, 1));
      expect(
        view().shown.firstWhere((t) => t.code == 'wi-alt-2').range,
        sel.draft,
        reason: 'taslak çubuğa anında yansır',
      );
      ctrl.shiftDraft(7);
      expect(view().selection!.draft, DayRange(cur.start + 6, cur.end + 8));
      ctrl.dragTo(-3);
      expect(view().selection!.draft, cur.shift(-3));

      ctrl.setDraftEnd(seasonDate(cur.start - 10, view().year));
      final d = view().selection!.draft;
      expect(d.end, d.start, reason: 'bitiş başlangıcın önüne geçemez');

      ctrl.setStatus(TimelineStatusFilter.open);
      expect(view().selection, isNull);
      expect(view().state.draft, isNull);
    },
  );

  test(
    'aynı gün başlangıç ve bitiş geçerlidir; ± sınırı tek güne iner',
    () async {
      final (_, ctrl, view) = await _open();
      ctrl.select('wi-alt-2');
      final start = view().selection!.current.start;
      ctrl.setDraftEnd(seasonDate(start, view().year));
      expect(view().selection!.draft, DayRange(start, start));
      ctrl.nudgeEnd(-1);
      expect(view().selection!.draft, DayRange(start, start));
      ctrl.nudgeStart(1);
      expect(view().selection!.draft, DayRange(start, start));
      ctrl.setDraftEnd(seasonDate(start + 1, view().year));
      ctrl.nudgeStart(1);
      expect(view().selection!.draft, DayRange(start + 1, start + 1));
    },
  );

  test('Sıfırla yalnız taslağı kaldırır ve seçili görevi açık tutar', () async {
    final (_, ctrl, view) = await _open();
    ctrl.select('wi-alt-2');
    final current = view().selection!.current;
    ctrl.nudgeEnd(5);
    expect(view().selection!.changed, isTrue);
    ctrl.resetDraft();
    expect(view().state.selected, 'wi-alt-2');
    expect(view().state.draft, isNull);
    expect(view().selection!.draft, current);
    expect(view().selection!.changed, isFalse);
  });

  test('kaydet → geri alma kaydı; geri al önceki düzenlemeye döner', () async {
    final (_, ctrl, view) = await _open();
    ctrl.select('wi-alt-2');
    expect(await ctrl.save(), isFalse, reason: 'değişiklik yok');
    final cur = view().selection!.current;
    ctrl.shiftDraft(3);
    expect(await ctrl.save(), isTrue);
    final u = view().state.undo!;
    expect((u.code, u.isShift, u.startDelta), ('wi-alt-2', true, 3));
    expect(view().selection, isNull);
    final bar = view().shown.firstWhere((t) => t.code == 'wi-alt-2');
    expect(bar.range, cur.shift(3));

    ctrl
      ..select('wi-alt-2')
      ..nudgeEnd(2);
    expect(await ctrl.save(), isTrue);
    expect(view().state.undo!.isShift, isFalse);
    expect(view().state.undo!.serial, 2);
    expect(await ctrl.undo(), 'wi-alt-2');
    expect(
      view().shown.firstWhere((t) => t.code == 'wi-alt-2').range,
      cur.shift(3),
    );
    expect(await ctrl.undo(), isNull);
  });

  test('tarih talebi: değişiklik yok / gönderildi / bekleyen var', () async {
    final (_, ctrl, view) = await _open(dAlt, false);
    expect(
      await ctrl.requestDates(reason: 'Gerekçe'),
      isA<TimelineRequestNoChange>(),
      reason: 'seçim yok',
    );
    ctrl.select('wi-alt-1');
    expect(
      await ctrl.requestDates(reason: 'Gerekçe'),
      isA<TimelineRequestNoChange>(),
    );
    final cur = view().selection!.current;
    ctrl.nudgeEnd(5);
    final r = await ctrl.requestDates(reason: 'Gerekçe');
    expect(r, isA<TimelineRequestSent>());
    expect(
      (r as TimelineRequestSent).end,
      seasonDate(cur.end + 5, view().year),
    );
    expect(view().state.draft, isNull);
    expect(
      view().shown.firstWhere((t) => t.code == 'wi-alt-1').request,
      cur.end + 5,
    );
    ctrl.nudgeEnd(1);
    expect(
      await ctrl.requestDates(reason: 'Gerekçe'),
      isA<TimelineRequestPending>(),
    );
  });
}
