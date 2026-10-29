// Yatay (tablet) çizelgenin görünümü: ortak katalog, prototip `S_hgantt` sayıları (76 görev,
// 15 geciken, 11 grup kaynak sırasıyla), grup içi kararlı başlangıç sırası, süzgeçler, çoklu
// koordinatörlük seçimi (seçim sırası), grup aç/kapa, seçim ve gecikme şeridi kuralı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/horizontal_timeline_view.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';

import '../../pilot_support.dart';

const _sourceOrder = [
  'ALT',
  'MEK',
  'ULA',
  'ELE',
  'İDA',
  'EĞİ',
  'OPE',
  'SAT',
  'MİM',
  'FUA',
  'SİS',
];

Future<TaskCatalog> _catalog() async {
  final h = await pilotHarness(PilotBackend());
  return h.container.read(taskCatalogControllerProvider.future);
}

List<GanttHeadRow> _heads(GanttView v) =>
    v.rows.whereType<GanttHeadRow>().toList();

List<String> _codes(GanttView v) => [
  for (final r in v.rows.whereType<GanttTaskRow>()) r.task.code,
];

void main() {
  late TaskCatalog catalog;
  setUp(() async => catalog = await _catalog());

  GanttView view([GanttState s = const GanttState()]) =>
      horizontalTimelineView(catalog, s);

  test('açılış: ay ölçeği, tümü, 76 görev, 15 geciken, bugün 21 Ekim', () {
    final v = view();
    expect(v.state.zoom, GanttZoom.month);
    expect(v.state.filter, GanttFilter.all);
    expect(v.visible, 76);
    expect(v.lateAll, 15);
    expect(v.today, seasonDay(DateTime(2026, 10, 21), 2026));
    expect(v.days, 365);
    expect(v.rows, hasLength(76 + 11));
    expect(v.selection, isNull);
  });

  test('gruplar ve çipler kaynak sırasıyla; başlık sayıları', () {
    final v = view();
    expect([for (final h in _heads(v)) h.code], _sourceOrder);
    expect([for (final c in v.chips) c.code], _sourceOrder);
    expect(
      [for (final h in _heads(v)) h.count],
      [13, 8, 4, 6, 11, 6, 8, 7, 5, 4, 4],
    );
    expect(
      [for (final h in _heads(v)) h.late],
      [3, 1, 3, 1, 4, 2, 0, 0, 0, 1, 0],
    );
    expect(_heads(v).first.name, 'Altyapı ve tesisat');
  });

  test('grup içi başlangıca göre kararlı sıra (ALT)', () {
    final alt = _codes(view()).takeWhile((c) => c.startsWith('ALT')).toList();
    expect(alt, [
      'ALT-13',
      'ALT-14',
      'ALT-1',
      'ALT-5',
      'ALT-8',
      'ALT-9',
      'ALT-6',
      'ALT-7',
      'ALT-4',
      'ALT-10',
      'ALT-12',
      'ALT-11',
      'ALT-15',
    ]);
  });

  test('gecikme kuralı: açık + bitişi geçmiş → bugüne dek; tamamlanan zamanında → yok', () {
    final v = view();
    final alt5 = v.rowOf('ALT-5')!.task;
    expect(alt5.late, isTrue);
    expect(alt5.lateTo, v.today);
    expect(alt5.end, seasonDay(DateTime(2026, 7, 15), 2026) + 1);
    expect(alt5.lateDays, 98);
    final alt13 = v.rowOf('ALT-13')!.task;
    expect(alt13.status, TaskStatus.done);
    expect(alt13.late, isFalse);
    // ELE-6: 27 Ekim bitişli, başlamadı → bugün (21 Ekim) gecikmede değil.
    expect(v.rowOf('ELE-6')!.task.late, isFalse);
    // Grup özet çizgisi gecikme şeridini kapsar.
    final altHead = _heads(v).first;
    expect(altHead.start, v.rowOf('ALT-13')!.task.start);
    expect(altHead.end, greaterThanOrEqualTo(v.today));
  });

  test('durum süzgeci: açık / geciken; geciken sayısı katalog geneli', () {
    final open = view(const GanttState(filter: GanttFilter.open));
    expect(
      open.rows.whereType<GanttTaskRow>().every(
        (r) => r.task.status != TaskStatus.done,
      ),
      isTrue,
    );
    final late = view(const GanttState(filter: GanttFilter.late));
    expect(late.visible, 15);
    expect(late.lateAll, 15);
    expect(_heads(late).map((h) => h.code), [
      'ALT',
      'MEK',
      'ULA',
      'ELE',
      'İDA',
      'EĞİ',
      'FUA',
    ]);
  });

  test(
    'koordinatörlük çipleri: çoklu seçim seçim sırasıyla; tümü temizler',
    () {
      var s = const GanttState().toggleCoord('MEK').toggleCoord('ALT');
      expect(s.coords, ['MEK', 'ALT']);
      final v = view(s);
      expect(v.visible, 21);
      // Gruplar yine kaynak sırasıyla.
      expect(_heads(v).map((h) => h.code), ['ALT', 'MEK']);
      expect(v.chips.where((c) => c.selected).map((c) => c.code), [
        'ALT',
        'MEK',
      ]);
      s = s.toggleCoord('MEK');
      expect(s.coords, ['ALT']);
      expect(s.clearCoords().coords, isEmpty);
    },
  );

  test('withCoords: yalnız seçim değişir', () {
    final s = const GanttState(
      zoom: GanttZoom.week,
      coords: ['ALT', 'MEK'],
    ).withCoords(['ULA']);
    expect(s.coords, ['ULA']);
    expect(s.zoom, GanttZoom.week);
    expect(view(s).visible, 4);
  });

  test(
    'grup kapatma: başlık kalır, görev satırları gizlenir; tekrar açılır',
    () {
      final s = const GanttState().toggleGroup('ALT');
      final v = view(s);
      final head = _heads(v).first;
      expect(head.open, isFalse);
      expect(head.count, 13);
      expect(v.rows, hasLength(76 - 13 + 11));
      expect(v.rowOf('ALT-1'), isNull);
      expect(view(s.toggleGroup('ALT')).rowOf('ALT-1'), isNotNull);
    },
  );

  test('seçim: aynı göreve tekrar dokunma kaldırır; kart verisi', () {
    final s = const GanttState().pick('ALT-10');
    final v = view(s);
    expect(v.rowOf('ALT-10')!.selected, isTrue);
    final sel = v.selection!;
    expect(sel.task.code, 'ALT-10');
    expect(sel.coordinatorshipName, 'Altyapı ve tesisat');
    expect(sel.assignees, isNotEmpty);
    expect(sel.task.lateDays, 21);
    expect(s.pick('ALT-10').selected, isNull);
    expect(s.clearSelection().selected, isNull);
    // Süzgeç seçimi kaldırmaz (prototip): görev görünmese de kart kalır.
    final hidden = view(s.withFilter(GanttFilter.late).toggleCoord('MEK'));
    expect(hidden.rowOf('ALT-10'), isNull);
    expect(hidden.selection?.task.code, 'ALT-10');
  });

  test('boş sonuç', () {
    final v = view(
      const GanttState(filter: GanttFilter.late).toggleCoord('SİS'),
    );
    expect(v.empty, isTrue);
    expect(v.visible, 0);
  });

  test('Teknofest günleri 12–15 Kasım', () {
    final f = view().festival;
    expect(f.start, seasonDay(DateTime(2026, 11, 12), 2026));
    expect(f.length, 4);
  });

  test('durum eşitliği (önbellek anahtarı)', () {
    expect(
      const GanttState().toggleCoord('ALT').toggleGroup('MEK'),
      const GanttState(coords: ['ALT'], closed: {'MEK'}),
    );
    expect(
      const GanttState().withZoom(GanttZoom.week),
      isNot(const GanttState()),
    );
  });
}
