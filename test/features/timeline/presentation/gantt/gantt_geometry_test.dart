// Yatay çizelge geometrisi kaynak ölçülerinden (`S_hgantt`, 1180 × 820 tuval, ray 100 → çizelge
// 1080): ppd, LW 300, satır 40, çubuk 9/22, gecikme şeridi, iç/dış başlık eşiği, ay/gün
// işaretleri, haftalık ızgara, bugün ortalama.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/horizontal_timeline_view.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_geometry.dart';

import '../../../pilot_support.dart';

int _d(int m, int day) => seasonDay(DateTime(2026, m, day), 2026);

void main() {
  late TaskCatalog catalog;
  setUp(() async {
    final h = await pilotHarness(PilotBackend());
    catalog = await h.container.read(taskCatalogControllerProvider.future);
  });

  GanttLayout layout([GanttState s = const GanttState()]) =>
      GanttLayout.of(horizontalTimelineView(catalog, s));

  test('kaynak sabitleri', () {
    expect(GanttGeometry.header, 72);
    expect(GanttGeometry.stickyHeader, 52);
    expect(GanttGeometry.labelWidth, 300);
    expect(GanttGeometry.row, 40);
    expect(GanttGeometry.ppd(GanttZoom.week), 28);
    expect(GanttGeometry.ppd(GanttZoom.month), 10);
    expect(GanttGeometry.ppd(GanttZoom.season), 3.4);
  });

  test('ay ölçeği: genişlik 365 × 10, satırlar 40, çubuk ve gecikme', () {
    final l = layout();
    expect(l.width, 3650);
    expect(l.totalWidth, 3950);
    expect(l.rowsHeight, 87 * 40);
    expect(l.todayX, _d(10, 21) * 10);

    // İlk satır ALT başlığı, ikinci ALT-13 (2 Mar – 31 Mar).
    expect(l.rows.first.row, isA<GanttHeadRow>());
    final alt13 = l.barOf('ALT-13')!;
    expect(alt13.top, 40 + 9);
    expect(alt13.height, 22);
    expect(alt13.left, _d(3, 2) * 10);
    expect(alt13.width, (_d(3, 31) + 1 - _d(3, 2)) * 10);
    expect(l.boxOf('ALT-13')!.late, isNull);

    // ALT-5 (16 Haz – 15 Tem, gecikmede): şerit bitişin ertesinden bugüne.
    final alt5 = l.boxOf('ALT-5')!;
    expect(alt5.late!.left, (_d(7, 15) + 1) * 10);
    expect(alt5.late!.right, _d(10, 21) * 10);
    expect(alt5.late!.top, alt5.top + 10);
    expect(alt5.late!.height, 20);
    expect(alt5.outsideX, _d(10, 21) * 10 + 8);
  });

  test('iç/dış başlık eşiği: genişlik ≥ min(260, harf × 6.6 + 24)', () {
    expect(GanttGeometry.titleInside(260, 'x' * 100), isTrue);
    expect(GanttGeometry.titleInside(259, 'x' * 100), isFalse);
    expect(GanttGeometry.titleInside(6.6 * 5 + 24, 'abcde'), isTrue);
    // ALT-9 (19 – 29 Haz, 11 gün × 10 = 110) dışarıda yazılır (kaynak ax: ayrı metin).
    final l = layout();
    expect(l.boxOf('ALT-9')!.inside, isFalse);
    expect(l.boxOf('ALT-1')!.inside, isTrue);
  });

  test('ay başlıkları ve gün işaretleri', () {
    final month = layout();
    expect(month.months, hasLength(12));
    expect(month.months[1].x, 31 * 10);
    expect(month.months[1].width, 28 * 10);
    // Ay ölçeği: pazartesiler (ilk 5 Ocak).
    expect(month.ticks.first.date, 5);
    expect(month.ticks.first.x, 4 * 10);
    expect(month.ticks.every((t) => (t.day - 4) % 7 == 0), isTrue);

    final week = layout(const GanttState(zoom: GanttZoom.week));
    expect(week.ticks, hasLength(365));
    expect(week.ticks.where((t) => t.today).single.day, _d(10, 21));
    expect(week.ticks[3].weekend, isTrue); // 4 Ocak 2026 pazar
    expect(week.width, 365 * 28);

    expect(layout(const GanttState(zoom: GanttZoom.season)).ticks, isEmpty);
  });

  test('haftalık ızgara pazartesilerde (4·ppd kaydırma, 7·ppd adım)', () {
    final g = layout().gridLines.take(3).toList();
    expect(g, [40, 110, 180]);
  });

  test('grup özet çizgisi: en erken başlangıç – en geç uç (en az 4)', () {
    final l = layout();
    final head = l.rows.first;
    expect(head.summary!.top, 18);
    expect(head.summary!.height, 4);
    expect(head.summary!.left, _d(3, 2) * 10);
  });

  test('Teknofest gölgesi 12 Kasım, 4 gün', () {
    final f = layout().festival(500);
    expect(f.left, _d(11, 12) * 10);
    expect(f.width, 40);
    expect(f.height, 500);
  });

  test(
    'bugün ortalama: max(0, TD·ppd − (görünür − 300) × 0.4), sınırda kesilir',
    () {
      final td = _d(10, 21);
      expect(
        GanttGeometry.centerOffset(today: td, ppd: 10, viewport: 1080),
        td * 10 - 780 * 0.4,
      );
      expect(GanttGeometry.centerOffset(today: 2, ppd: 10, viewport: 1080), 0);
      expect(
        GanttGeometry.centerOffset(
          today: td,
          ppd: 28,
          viewport: 1080,
          maxExtent: 1000,
        ),
        1000,
      );
    },
  );
}
