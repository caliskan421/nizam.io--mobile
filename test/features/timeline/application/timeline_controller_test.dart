// TimelineController + timelineView: koordinatörlük seçimi, durum/kişi/öncelik süzgeci, ölçek,
// genel bakış, seçim, tarih taslağı (−/+, kaydır, sürükle), kaydet/geri al ve tarih talebi.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline_view_builder.dart';

import '../../pilot_support.dart';

Future<(ProviderContainer, TimelineController, TimelineView Function())> _open([
  String? coord,
]) async {
  final h = await pilotHarness(PilotBackend());
  final c = h.container;
  c.listen(timelineViewProvider(coord), (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  return (
    c,
    c.read(timelineControllerProvider(coord).notifier),
    () => c.read(timelineViewProvider(coord)).requireValue,
  );
}

void main() {
  test('açılış: ilk koordinatörlük, hafta ölçeği, bugün 2026-10-21', () async {
    final (_, _, view) = await _open();
    final v = view();
    expect(v.selectedCoordinatorships, ['ALT']);
    expect(v.state.scale, TimelineScale.week);
    expect(v.today, seasonDay(DateTime(2026, 10, 21), 2026));
    expect(v.days, 365);
    expect(v.groups.single.code, 'ALT');
    expect(v.shown, hasLength(13));
    expect(v.weeks, hasLength(53));
    // ALT-5: 2026-07-15 bitişli, devam ediyor → bugüne kadar gecikmede.
    final alt5 = v.shown.firstWhere((t) => t.code == 'ALT-5');
    expect(alt5.late, isTrue);
    expect(alt5.lateDays, 98);
    expect(alt5.visibleEnd, v.today);
    expect(alt5.dependent, isTrue);
    // ALT-7 bekleyen tarih talebi (31 Ekim) çubuğun sonundan uzanır.
    expect(v.shown.firstWhere((t) => t.code == 'ALT-7').hasRequest, isTrue);
  });

  test('rota parametresi o koordinatörlüğü seçili açar', () async {
    final (_, _, view) = await _open('MEK');
    expect(view().selectedCoordinatorships, ['MEK']);
    // MEK-2 geç bitti (26 Ağu planı, 11 Eki bitiş).
    final mek2 = view().shown.firstWhere((t) => t.code == 'MEK-2');
    expect(mek2.doneLate, isTrue);
    expect(mek2.doneLateDays, 46);
  });

  test(
    'koordinatörlük seçimi: ekle (katalog sırası), çıkar, hepsi/hiçbiri',
    () async {
      final (_, ctrl, view) = await _open();
      ctrl
        ..toggleCoordMenu()
        ..toggleCoordinatorship('SİS')
        ..toggleCoordinatorship('MEK');
      expect(view().selectedCoordinatorships, ['ALT', 'MEK', 'SİS']);
      expect(view().multi, isTrue);
      expect(view().state.coordMenuOpen, isTrue);
      ctrl.toggleCoordinatorship('ALT');
      expect(view().selectedCoordinatorships, ['MEK', 'SİS']);
      ctrl.toggleAllCoordinatorships();
      expect(view().noneSelected, isTrue);
      expect(view().empty, isTrue);
      ctrl.toggleAllCoordinatorships();
      expect(view().allSelected, isTrue);
      expect(view().shown, hasLength(76));
      ctrl.closeCoordMenu();
      expect(view().state.coordMenuOpen, isFalse);
    },
  );

  test('durum, kişi, öncelik süzgeci; sayılar; temizle', () async {
    final (_, ctrl, view) = await _open();
    final counts = view().statusCounts;
    expect(counts[TimelineStatusFilter.all], 13);
    expect(
      counts[TimelineStatusFilter.open]! + counts[TimelineStatusFilter.done]!,
      13,
    );
    ctrl.setStatus(TimelineStatusFilter.late);
    expect(view().shown.every((t) => t.late), isTrue);
    expect(view().shown, hasLength(counts[TimelineStatusFilter.late]));
    expect(view().state.filterCount, 1);

    ctrl
      ..setStatus(TimelineStatusFilter.all)
      ..togglePerson('av');
    expect(
      view().shown.map((t) => t.code),
      containsAll(['ALT-1', 'ALT-11', 'ALT-14']),
    );
    expect(view().shown.every((t) => t.item.assignees.contains('av')), isTrue);
    expect(
      view().personOptions.firstWhere((p) => p.id == 'av').selected,
      isTrue,
    );
    ctrl.togglePriority(TaskPriority.medium);
    expect(view().shown.map((t) => t.code), ['ALT-11']);
    expect(view().state.filterCount, 2);
    ctrl.clearFilters();
    expect(view().shown, hasLength(13));
    expect(view().state.filterCount, 0);
  });

  test(
    'ölçek ve genel bakış; sütuna dokunma tek koordinatörlük açar',
    () async {
      final (_, ctrl, view) = await _open();
      ctrl.setScale(TimelineScale.day);
      expect(view().state.scale, TimelineScale.day);
      ctrl.setOverview(true);
      expect(view().overviewGroups, hasLength(11));
      expect(view().overviewGroups.first.total, 13);
      ctrl.openOverviewColumn('OPE');
      expect(view().state.overview, isFalse);
      expect(view().selectedCoordinatorships, ['OPE']);
    },
  );

  test('seçim + taslak: −/+, kaydır, sürükle; sınırlar', () async {
    final (_, ctrl, view) = await _open();
    ctrl.select('ALT-10');
    var sel = view().selection!;
    expect(sel.task.code, 'ALT-10');
    expect(sel.coordinatorshipName, 'Altyapı ve tesisat');
    expect(sel.changed, isFalse);
    final cur = sel.current;

    ctrl
      ..nudgeStart(-1)
      ..nudgeEnd(1);
    sel = view().selection!;
    expect(sel.draft, DayRange(cur.start - 1, cur.end + 1));
    expect(sel.startDelta, -1);
    expect(sel.endDelta, 1);
    // Taslak çubuğa anında yansır.
    expect(view().shown.firstWhere((t) => t.code == 'ALT-10').range, sel.draft);

    ctrl.shiftDraft(7);
    expect(view().selection!.draft, DayRange(cur.start + 6, cur.end + 8));
    ctrl.dragTo(-3);
    expect(view().selection!.draft, cur.shift(-3));

    // Bitiş başlangıcın önüne geçemez.
    ctrl.setDraftEnd(seasonDate(cur.start - 10, 2026));
    final d = view().selection!.draft;
    expect(d.end, d.start + 1);

    ctrl.closeSelection();
    expect(view().selection, isNull);
    expect(view().state.draft, isNull);
  });

  test('kaydet → geri alma kaydı; geri al eski tarihlere döner', () async {
    final (_, ctrl, view) = await _open();
    ctrl.select('ALT-10');
    expect(ctrl.save(), isFalse, reason: 'değişiklik yok');
    final cur = view().selection!.current;
    ctrl.shiftDraft(3);
    expect(ctrl.save(), isTrue);
    final u = view().state.undo!;
    expect(u.code, 'ALT-10');
    expect(u.isShift, isTrue);
    expect(u.startDelta, 3);
    expect(view().selection, isNull);
    expect(
      view().shown.firstWhere((t) => t.code == 'ALT-10').range,
      cur.shift(3),
    );

    ctrl
      ..select('ALT-10')
      ..nudgeEnd(2);
    expect(ctrl.save(), isTrue);
    expect(view().state.undo!.isShift, isFalse);
    expect(view().state.undo!.serial, 2);
    expect(ctrl.undo(), 'ALT-10');
    expect(
      view().shown.firstWhere((t) => t.code == 'ALT-10').range,
      cur.shift(3),
      reason: 'önceki düzenlemeye döner',
    );
    expect(view().state.undo, isNull);
    expect(ctrl.undo(), isNull);
  });

  test('tarih talebi: bekleyen var / değişiklik yok / gönderildi', () async {
    final (_, ctrl, view) = await _open();
    ctrl.select('ALT-7');
    expect(ctrl.requestDates(), isA<TimelineRequestPending>());
    ctrl.select('ALT-10');
    expect(ctrl.requestDates(), isA<TimelineRequestNoChange>());
    final cur = view().selection!.current;
    ctrl.nudgeEnd(5);
    final r = ctrl.requestDates();
    expect(r, isA<TimelineRequestSent>());
    expect((r as TimelineRequestSent).end, seasonDate(cur.end + 5, 2026));
    expect(view().state.draft, isNull);
    expect(view().state.requests.containsKey('ALT-10'), isTrue);
    expect(
      view().shown.firstWhere((t) => t.code == 'ALT-10').request,
      cur.end + 5,
    );
    ctrl.dismissUndo();
  });

  test('şerit yerleşimi: çakışan görevler ayrı şeritte', () async {
    final (_, _, view) = await _open();
    final g = view().groups.single;
    expect(g.lanes, greaterThan(1));
    for (final (a, la) in g.placed) {
      for (final (b, lb) in g.placed) {
        if (a == b || la != lb) continue;
        final overlap =
            a.packStart < b.packEnd + 1 && b.packStart < a.packEnd + 1;
        expect(overlap, isFalse, reason: '${a.code} / ${b.code}');
      }
    }
    expect(packLanes(const []).$1, 0);
  });
}
