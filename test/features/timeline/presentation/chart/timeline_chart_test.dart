// Dikey çizelge: dokunuş konumundan öğe, okuyucu düğümü yalnız görünür alan için, yerleşim
// önbelleği (aynı girdi → aynı örnek; ölçek/genişlik değişince yeni).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_chart.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_layout.dart';
import 'package:nizamio/features/timeline/presentation/chart/timeline_painters.dart';

import 'timeline_fixture.dart';

void main() {
  final catalog = timelineCatalog();
  final view = timelineViewOf(catalog);

  void phone(WidgetTester tester, {double width = 390}) {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget chart(
    TimelineView v, {
    ValueChanged<String>? onSelect,
    VoidCallback? onBlankTap,
    double bottomInset = 0,
  }) => timelineApp(
    TimelineChart(
      view: v,
      onSelect: onSelect ?? (_) {},
      onOverview: (_) {},
      onDrag: (_) {},
      onBlankTap: onBlankTap,
      bottomInset: bottomInset,
    ),
  );

  TimelineLayout layoutOf(WidgetTester tester) =>
      (tester
                  .widget<CustomPaint>(
                    find.byWidgetPredicate(
                      (w) =>
                          w is CustomPaint && w.painter is TimelineChartPainter,
                    ),
                  )
                  .painter!
              as TimelineChartPainter)
          .layout;

  bool hasNode(String code) => find.semantics
      .byPredicate((n) => n.label.startsWith('$code '))
      .tryEvaluate();

  group('dokunuş', () {
    test('çubuğun içi o çubuk, boşluk hiçbiri; seçili çubuk önce', () {
      final l = TimelineLayout.of(view, 390);
      final b = l.barOf('T40')!;
      expect(l.barAt(b.rect.center)?.task.code, 'T40');
      expect(l.barAt(Offset(b.rect.center.dx, l.bodyHeight - 1)), isNull);

      // Taslağı aynı şeritteki T46'nın üstüne sürüklenen seçili çubuk önce bulunur.
      final dragged = TimelineLayout.of(
        timelineViewOf(
          catalog,
          const TimelineState(
            startAll: true,
            selected: 'T40',
            draft: DayRange(92, 98),
          ),
        ),
        390,
      );
      final under = dragged.barOf('T46')!;
      expect(dragged.barOf('T40')!.rect.overlaps(under.rect), isTrue);
      expect(dragged.barAt(under.rect.center)?.task.code, 'T40');
    });

    testWidgets('çubuğa dokunma seçer, boş alana dokunma onBlankTap', (
      tester,
    ) async {
      phone(tester);
      String? selected;
      var blank = 0;
      await tester.pumpWidget(
        chart(view, onSelect: (c) => selected = c, onBlankTap: () => blank++),
      );
      final l = layoutOf(tester);
      final origin = tester.getTopLeft(find.byKey(TimelineChart.canvasKey));
      final bar = l.bars.firstWhere((b) {
        final c = origin + b.rect.center;
        return c.dy > 100 && c.dy < 600 && c.dx > 60 && c.dx < 380;
      });
      await tester.tapAt(origin + bar.rect.center);
      await tester.pump(const Duration(milliseconds: 500));
      expect(selected, bar.task.code);
      expect(blank, 0);

      // Tarih sütunu ile ilk şerit arası (çubuk yok).
      await tester.tapAt(origin + Offset(55, bar.rect.center.dy));
      await tester.pump(const Duration(milliseconds: 500));
      expect(blank, 1);
    });
  });

  group('okuyucu', () {
    testWidgets('görünür alandan uzak çubuğun düğümü yok; kaydırınca gelir', (
      tester,
    ) async {
      phone(tester);
      final handle = tester.ensureSemantics();
      String? selected;
      await tester.pumpWidget(chart(view, onSelect: (c) => selected = c));
      await tester.pump();

      // Çizelge yılın başında açılır: ilk görevin düğümü var, yıl sonundakinin yok.
      expect(hasNode('T0'), isTrue);
      expect(hasNode('T149'), isFalse);
      expect(
        find.semantics.byPredicate((n) => n.label.startsWith('T')).evaluate(),
        hasLength(lessThan(view.shown.length)),
      );

      // Okuyucu eylemi seçimi yapar.
      tester.semantics.tap(
        find.semantics.byPredicate((n) => n.label.startsWith('T0 ')),
      );
      expect(selected, 'T0');

      await tester.dragFrom(const Offset(200, 400), const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(hasNode('T149'), isTrue);
      expect(hasNode('T0'), isFalse);
      handle.dispose();
    });

    // İçerik daralınca kaydırma konumu bildirimsiz düzeltilir; pencere yerleşimden sonra eşitlenir.
    testWidgets('içerik daralınca görünür çubukların düğümü var', (
      tester,
    ) async {
      phone(tester);
      final handle = tester.ensureSemantics();
      final wide = timelineCatalog(groups: 8);
      await tester.pumpWidget(chart(timelineViewOf(wide)));
      await tester.dragFrom(const Offset(200, 400), const Offset(-3000, 0));
      await tester.pumpAndSettle();
      expect(hasNode('T0'), isFalse, reason: 'ilk grup görünür alanın solunda');

      await tester.pumpWidget(
        chart(
          timelineViewOf(wide, const TimelineState(coordinatorships: ['A'])),
        ),
      );
      await tester.pump();
      expect(hasNode('T0'), isTrue);
      handle.dispose();
    });
  });

  group('yerleşim önbelleği', () {
    testWidgets('aynı görünüm + genişlik → aynı örnek', (tester) async {
      phone(tester);
      await tester.pumpWidget(chart(view));
      final first = layoutOf(tester);
      await tester.pumpWidget(chart(view, bottomInset: 20));
      expect(identical(layoutOf(tester), first), isTrue);
    });

    testWidgets('ölçek ya da genişlik değişince yeniden', (tester) async {
      phone(tester);
      await tester.pumpWidget(chart(view));
      final first = layoutOf(tester);

      final day = timelineViewOf(
        catalog,
        const TimelineState(startAll: true, scale: TimelineScale.day),
      );
      await tester.pumpWidget(chart(day));
      final second = layoutOf(tester);
      expect(identical(second, first), isFalse);
      expect(second.dayScale, isTrue);

      phone(tester, width: 420);
      await tester.pump();
      expect(identical(layoutOf(tester), second), isFalse);
    });
  });
}
