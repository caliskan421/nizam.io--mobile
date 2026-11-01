import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';

import '../feedback/feedback_test_support.dart';

const _labels = [
  'Ana sayfa',
  'Görevler',
  'Takvim',
  'Koordinatörlükler',
  'Arşiv',
  'Mesajlar',
];

Widget _rail({
  int? current = 1,
  ValueChanged<int>? onSelect,
  VoidCallback? onBell,
  VoidCallback? onMenu,
  VoidCallback? onAssistant,
  bool dot = true,
  int? badge = 3,
}) => Scaffold(
  body: Align(
    alignment: Alignment.centerLeft,
    child: NzTabletRail(
      items: [
        for (final (i, l) in _labels.indexed)
          NzRailItem(
            icon: NzIcons.home,
            selectedIcon: NzIcons.homeFilled,
            label: l,
            badge: i == 5 ? badge : null,
          ),
      ],
      currentIndex: current,
      onSelect: onSelect ?? (_) {},
      semanticLabel: 'Ana gezinme',
      brand: const ColoredBox(key: ValueKey('brand'), color: Color(0xFFC8F53C)),
      bellLabel: 'Bildirimler',
      bellDot: dot,
      onBell: onBell ?? () {},
      menuLabel: 'Tüm modüller',
      onMenu: onMenu ?? () {},
      assistantLabel: 'Asistana sor',
      onAssistant: onAssistant ?? () {},
    ),
  ),
);

void main() {
  setUpFonts();

  testWidgets('ölçüler: 100 genişlik, 96 öğe, 60×34 kapsül, 44 alt düğmeler', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(testApp(_rail(), dark: true));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(NzTabletRail)),
      const Size(NzTabletMetrics.railWidth, 820),
    );
    // İşaret 36 px, üstten 20.
    final brand = tester.getRect(find.byKey(const ValueKey('brand')));
    expect(brand.size, const Size(36, 36));
    expect(brand.top, 20);
    expect(brand.center.dx, 50);
    // İlk öğe işaretin 18 + 4 altında, öğe yüksekliği 7 + 34 + 5 + 13 + 7 = 66.
    final first = tester.getRect(
      find.ancestor(
        of: find.text('Ana sayfa'),
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.width == NzTabletMetrics.railItemWidth,
        ),
      ),
    );
    expect(first.top, 20 + 36 + 18 + 4);
    expect(first.height, 66);
    for (final semantics in ['Bildirimler', 'Tüm modüller', 'Asistana sor']) {
      expect(find.bySemanticsLabel(semantics), findsOneWidget);
    }
    // Asistan en altta (alt 20 boşluk); zil, menü ve asistan aynı 44.
    final assistant = tester.getRect(find.bySemanticsLabel('Asistana sor'));
    expect(assistant.size, const Size(44, 44));
    expect(
      tester.getSize(find.bySemanticsLabel(RegExp('^Bildirimler'))),
      const Size(44, 44),
    );
    expect(assistant.bottom, 820 - 20);
    final menu = tester.getRect(find.bySemanticsLabel('Tüm modüller'));
    expect(menu.size, const Size(44, 44));
    expect(assistant.top - menu.bottom, 12);
    expect(tester.takeException(), isNull);
  });

  testWidgets('seçim, etkin öğe semantiği, rozet ve alt düğmeler', (
    tester,
  ) async {
    final picked = <int>[];
    var bell = 0, menu = 0, ai = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.reset);
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        _rail(
          onSelect: picked.add,
          onBell: () => bell++,
          onMenu: () => menu++,
          onAssistant: () => ai++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.bySemanticsLabel('Görevler')),
      matchesSemantics(
        label: 'Görevler',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    expect(find.bySemanticsLabel('Mesajlar · 3'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.text('Arşiv'));
    await tester.tap(find.text('Görevler'));
    await tester.tap(find.bySemanticsLabel('Bildirimler'));
    await tester.tap(find.bySemanticsLabel('Tüm modüller'));
    await tester.tap(find.bySemanticsLabel('Asistana sor'));
    await tester.pumpAndSettle();
    expect(picked, [4, 1]);
    expect((bell, menu, ai), (1, 1, 1));
    semantics.dispose();
  });

  testWidgets('rozet 0 ya da null → yok; etkin öğe yok', (tester) async {
    await tester.pumpWidget(testApp(_rail(current: null, badge: 0)));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);
    expect(find.bySemanticsLabel('Mesajlar'), findsOneWidget);
  });

  testWidgets('kısa pencerede taşmaz (kaydırılır), metin 2x ölçek', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(600, 420);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(testApp(_rail(), dark: true));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
