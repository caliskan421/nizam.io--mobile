import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_pill_tabs.dart';

import '../feedback/feedback_test_support.dart';

const _tabs = [
  NzPillTab(label: 'Tümü', count: 76),
  NzPillTab(label: 'Geciken', count: 15),
  NzPillTab(label: 'Devam', count: 20),
];

Widget _host({List<NzPillTab> tabs = _tabs, ValueChanged<int>? onPick}) {
  var selected = 0;
  return StatefulBuilder(
    builder: (context, setState) => NzPillTabs(
      tabs: tabs,
      selected: selected,
      semanticLabel: 'Durum',
      onSelected: (i) {
        onPick?.call(i);
        setState(() => selected = i);
      },
    ),
  );
}

void main() {
  setUpFonts();

  testWidgets('dokunuş seçer; başparmak seçili sekmenin altına kayar', (
    t,
  ) async {
    final picks = <int>[];
    await t.pumpWidget(testApp(_host(onPick: picks.add)));
    Rect thumb() => t.getRect(find.byType(TweenAnimationBuilder<double>));
    final before = thumb();
    await t.tap(find.text('Devam'));
    await t.pumpAndSettle();
    expect(picks, [2]);
    final after = thumb();
    expect(after.left, greaterThan(before.left));
    final tab = t.getRect(find.text('Devam'));
    expect(after.left, lessThanOrEqualTo(tab.left));
    expect(after.right, greaterThanOrEqualTo(tab.right));
  });

  testWidgets('yaylı geçişte başparmak ilk/son sekmede raydan taşmaz', (
    t,
  ) async {
    await t.pumpWidget(testApp(_host()));
    Rect thumb() => t.getRect(find.byType(TweenAnimationBuilder<double>));
    final rail = t.getRect(find.byType(NzPillTabs));
    final first = thumb();
    // Son sekmeye ve geri ilk sekmeye: her karede başparmak ray içinde, uçta tam yerinde.
    for (final (label, edge) in [('Devam', 2), ('Tümü', 0)]) {
      await t.tap(find.text(label));
      for (var i = 0; i < 40; i++) {
        await t.pump(const Duration(milliseconds: 16));
        final r = thumb();
        expect(r.left, greaterThanOrEqualTo(first.left - 0.01));
        expect(r.right, lessThanOrEqualTo(rail.right));
      }
      await t.pumpAndSettle();
      if (edge == 0) expect(thumb().left, closeTo(first.left, 0.01));
    }
  });

  testWidgets('seçili 600 ink, diğerleri 500 ink-muted; sayaç ink-muted', (
    t,
  ) async {
    await t.pumpWidget(testApp(_host()));
    final c = NizamioColors.light;
    final sel = t.widget<Text>(find.text('Tümü')).style!;
    final other = t.widget<Text>(find.text('Geciken')).style!;
    expect(sel.color, c.text);
    expect(sel.fontWeight, FontWeight.w600);
    expect(other.color, c.textMuted);
    expect(other.fontWeight, FontWeight.w500);
    expect(t.widget<Text>(find.text('76')).style!.color, c.textMuted);
  });

  testWidgets('koyu tema: ray bg-raised, başparmak bg-overlay', (t) async {
    await t.pumpWidget(testApp(_host(), dark: true));
    await t.pumpAndSettle();
    final c = NizamioColors.dark;
    bool has(Color color) => find
        .byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration?)?.color == color,
        )
        .evaluate()
        .isNotEmpty;
    expect(has(c.surfaceRaised), isTrue);
    expect(has(c.surfaceOverlay), isTrue);
  });

  testWidgets('her sekme >= 48 yükseklik; anlamsal seçili + grup', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(testApp(_host()));
    expect(t.getSize(find.byType(NzPillTabs)).height, greaterThanOrEqualTo(48));
    final node = t.getSemantics(find.bySemanticsLabel('Tümü, 76'));
    final flags = node.getSemanticsData().flagsCollection;
    expect(flags.isSelected.toBoolOrNull(), isTrue);
    expect(flags.isInMutuallyExclusiveGroup, isTrue);
    expect(node.rect.height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('baştaki ikon çizilir', (t) async {
    await t.pumpWidget(
      testApp(
        _host(
          tabs: const [
            NzPillTab(label: 'Liste', icon: Icons.view_list_rounded),
            NzPillTab(label: 'Zaman çizelgesi', icon: Icons.view_timeline),
          ],
        ),
      ),
    );
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
  });

  testWidgets('360 / 2.0 metinde taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 640);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        _host(
          tabs: const [
            NzPillTab(label: 'Tümü', count: 76),
            NzPillTab(label: 'Geciken', count: 15),
            NzPillTab(label: 'Devam ediyor', count: 20),
            NzPillTab(label: 'Onayda', count: 3),
          ],
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
