// Gantt gövdesi sanallaştırma kararları: yalnız görünür etiket satırları kurulur, çubuk okuyucu
// düğümleri yalnız görünür çubuklar içindir, dokunuş konumu yerleşimde doğru görevi bulur.
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_geometry.dart';

final _today = DateTime(2026, 6, 15);

/// [n] görev, 5 koordinatörlük; başlangıçlar bugünün ±20 günü (bir kısmı yatayda görünmez).
TaskCatalog _catalog(int n) => TaskCatalog(
  today: _today,
  me: 'p1',
  people: const [],
  coordinatorships: [
    for (var g = 0; g < 5; g++)
      CoordinatorshipRef(
        code: 'C$g',
        name: 'Grup $g',
        leads: const [],
        members: const [],
      ),
  ],
  tasks: [
    for (var i = 0; i < n; i++)
      TaskItem(
        code: 'T$i',
        title: 'Görev $i',
        coordinatorship: 'C${i % 5}',
        status: TaskStatus.values[i % 5],
        priority: TaskPriority.medium,
        start: _today.add(Duration(days: i % 40 - 20)),
        due: _today.add(Duration(days: i % 40 - 14)),
        assignees: const [],
      ),
  ],
);

GanttLayout _layout(int n, [GanttState s = const GanttState()]) =>
    GanttLayout.of(buildGanttView(_catalog(n), s));

String _code(GanttRowBox b) => (b.row as GanttTaskRow).task.code;

Future<void> _pump(
  WidgetTester t,
  GanttLayout layout, {
  ValueChanged<String>? onPick,
}) async {
  t.view.physicalSize = const Size(1180, 820);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Material(
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 1100,
            height: 700,
            child: GanttChart(
              layout: layout,
              center: const GanttCenterRequest(0),
              onToggleGroup: (_) {},
              onPick: onPick ?? (_) {},
            ),
          ),
        ),
      ),
    ),
  );
  await t.pump();
}

/// Çubuk okuyucu düğümleri (ressamın çocukları): etiketi " · Görev i · " içerenler.
Iterable<SemanticsNode> _barNodes(WidgetTester t) => find.semantics
    .byPredicate(
      (n) => RegExp(r'^.+ · Görev \d+ · ').hasMatch(n.label),
      describeMatch: (_) => 'çubuk düğümü',
    )
    .evaluate();

/// Çubuğun etiket sütunu dışındaki görünür kısmının ortası (genel koordinat); yoksa null.
Offset? _visiblePoint(WidgetTester t, GanttLayout l, String code) {
  final origin = t.getTopLeft(find.byKey(GanttChart.barsKey));
  final bar = l.barOf(code)!.shift(origin);
  final view = t
      .getRect(find.byKey(GanttChart.horizontalKey))
      .intersect(t.getRect(find.byKey(GanttChart.verticalKey)));
  final right = t.getRect(find.byKey(GanttChart.labelsKey)).right;
  final v = Rect.fromLTRB(
    bar.left > right ? bar.left : right,
    bar.top,
    bar.right,
    bar.bottom,
  ).intersect(view);
  return v.width > 2 && v.height > 2 ? v.center : null;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('yerleşim araması', () {
    final l = _layout(20);

    test('barAt: çubuk içindeki nokta satırın görevini verir', () {
      for (final b in l.rows.where((b) => b.bar != null)) {
        expect(l.barAt(b.bar!.center), _code(b));
      }
    });

    test('barAt: çubuk dışı, grup satırı, sınır dışı → null', () {
      final b = l.rows.firstWhere((b) => b.bar != null);
      expect(l.barAt(Offset(b.bar!.left - 1, b.bar!.center.dy)), isNull);
      expect(l.barAt(Offset(b.bar!.center.dx, b.top + 1)), isNull);
      final head = l.rows.firstWhere((b) => b.row is GanttHeadRow);
      expect(l.barAt(Offset(head.summary!.center.dx, head.top + 20)), isNull);
      expect(l.barAt(const Offset(10, -1)), isNull);
      expect(l.barAt(Offset(10, l.rowsHeight + 1)), isNull);
    });

    test('visibleBars: yalnız pencereyle kesişen görev satırları', () {
      final all = l.visibleBars(Rect.fromLTWH(0, 0, l.width, l.rowsHeight));
      expect(all.length, l.rows.where((b) => b.bar != null).length);
      // İlk üç satır yüksekliği: grup başlığı sayılmaz, alttaki satırlar girmez.
      final top = l.visibleBars(
        Rect.fromLTWH(0, 0, l.width, 3 * GanttGeometry.row),
      );
      expect(top, everyElement(lessThan(3)));
      expect(top, isNotEmpty);
      // Yatayda hiçbir çubuğa ve dış başlığa değmeyen pencere boştur.
      expect(l.visibleBars(Rect.fromLTWH(0, 0, 10, l.rowsHeight)), isEmpty);
      expect(l.visibleBars(Rect.zero), isEmpty);
    });
  });

  group('sanallaştırma', () {
    testWidgets('150 görevde yalnız görünür etiket satırları kurulur', (
      t,
    ) async {
      final l = _layout(150);
      expect(l.rows.length, greaterThan(150));
      await _pump(t, l);
      final built = find
          .descendant(
            of: find.byKey(GanttChart.labelsKey),
            matching: find.byType(GestureDetector),
          )
          .evaluate()
          .length;
      // 648 px görünür alan / 40 px satır + önbellek payı.
      expect(built, greaterThan(0));
      expect(built, lessThan(40));
      // Çubuklar tek ressam + tek dokunma algılayıcısı: gövdede etiketler dışında yalnız bir
      // dokunma algılayıcısı (önceden her çubuk için bir tane).
      final all = find
          .descendant(
            of: find.byType(GanttChart),
            matching: find.byType(GestureDetector),
          )
          .evaluate()
          .length;
      expect(all, built + 1);
      expect(find.byKey(GanttChart.barsKey), findsOneWidget);
    });

    testWidgets('görünmeyen çubuk için okuyucu düğümü yok; kayınca gelir', (
      t,
    ) async {
      final semantics = t.ensureSemantics();
      final l = _layout(150);
      await _pump(t, l);
      final nodes = _barNodes(t).toList();
      expect(nodes, isNotEmpty);
      expect(nodes.length, lessThan(40));
      final last = (l.rows.last.row as GanttTaskRow).task.item.title;
      bool has(String title) =>
          _barNodes(t).any((n) => n.label.contains(' · $title · '));
      expect(has(last), isFalse);

      final pos = t
          .state<ScrollableState>(find.byKey(GanttChart.verticalKey))
          .position;
      pos.jumpTo(pos.maxScrollExtent);
      await t.pump();
      expect(has(last), isTrue);
      final first = l.rows.firstWhere((b) => b.bar != null);
      expect(
        has((first.row as GanttTaskRow).task.item.title),
        isFalse,
        reason: 'üstte kalan satırın düğümü kalkar',
      );
      semantics.dispose();
    });

    testWidgets('okuyucu dokunma eylemi seçimle aynı', (t) async {
      final semantics = t.ensureSemantics();
      final picked = <String>[];
      final l = _layout(30);
      await _pump(t, l, onPick: picked.add);
      final node = _barNodes(t).first;
      final code = _code(
        l.rows
            .where((b) => b.bar != null)
            .firstWhere((b) => node.label.contains(' · ${b.titleOf()} · ')),
      );
      t.semantics.tap(find.semantics.byLabel(node.label));
      expect(picked, [code]);
      semantics.dispose();
    });
  });

  group('dokunma', () {
    testWidgets('dokunuş konumundan doğru görev seçilir', (t) async {
      final picked = <String>[];
      final l = _layout(30);
      await _pump(t, l, onPick: picked.add);
      final shown = [
        for (final b in l.rows.where((b) => b.bar != null))
          if (_visiblePoint(t, l, _code(b)) case final p?) (_code(b), p),
      ];
      expect(shown.length, greaterThan(3));
      for (final (_, p) in shown.take(4)) {
        await t.tapAt(p);
      }
      expect(picked, [for (final (c, _) in shown.take(4)) c]);
    });

    testWidgets('çubuk dışı boşluğa dokunuş seçmez', (t) async {
      final picked = <String>[];
      final l = _layout(30);
      await _pump(t, l, onPick: picked.add);
      final b = l.rows.firstWhere(
        (b) => b.bar != null && _visiblePoint(t, l, _code(b)) != null,
      );
      final origin = t.getTopLeft(find.byKey(GanttChart.barsKey));
      final p = _visiblePoint(t, l, _code(b))!;
      // Aynı x, çubuğun üstündeki satır içi boşluk.
      await t.tapAt(Offset(p.dx, origin.dy + b.top + 2));
      expect(picked, isEmpty);
    });
  });
}

extension on GanttRowBox {
  String titleOf() => (row as GanttTaskRow).task.item.title;
}
