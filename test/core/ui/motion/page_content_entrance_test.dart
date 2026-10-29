import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/motion/page_content_entrance.dart';
import 'package:nizamio/core/ui/theme/nz_motion.dart';

void main() {
  Widget app(Widget child, {bool reduced = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  testWidgets('sabit 10 px, ortak eğri; yeniden çizimde tekrar başlamaz', (
    tester,
  ) async {
    late StateSetter rebuild;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return const Align(
              alignment: Alignment.topLeft,
              child: PageContentEntrance(
                child: SizedBox(width: 100, height: 40),
              ),
            );
          },
        ),
      ),
    );
    final opacity = find.byType(Opacity);
    final box = find.byType(SizedBox);
    expect(tester.widget<Opacity>(opacity).opacity, 0);
    expect(tester.getTopLeft(box).dy, 10);
    await tester.pump(const Duration(milliseconds: 160));
    final t = RpMotion.enterCurve.transform(0.5);
    expect(tester.widget<Opacity>(opacity).opacity, closeTo(t, 0.001));
    expect(tester.getTopLeft(box).dy, closeTo(10 * (1 - t), 0.001));
    await tester.pump(const Duration(milliseconds: 160));
    expect(tester.getTopLeft(box).dy, 0);
    rebuild(() {});
    await tester.pump();
    expect(tester.widget<Opacity>(opacity).opacity, 1);
  });

  testWidgets(
    'hareketi azalt ilk karede son hal; anahtar yeni giriş başlatır',
    (tester) async {
      Widget panel(int tab, {bool reduced = false}) => app(
        PageContentEntrance(key: ValueKey(tab), child: const SizedBox()),
        reduced: reduced,
      );
      await tester.pumpWidget(panel(0, reduced: true));
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(panel(1));
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);
      await tester.pump(RpMotion.enterDuration);
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    },
  );

  testWidgets('iç içe ilk panel mesafeyi ve opaklığı katlamaz', (tester) async {
    await tester.pumpWidget(
      app(
        const PageContentEntrance(
          child: PageContentEntrance(
            child: PageContentEntrance(child: SizedBox()),
          ),
        ),
      ),
    );
    expect(
      tester.widgetList<Opacity>(find.byType(Opacity)).map((w) => w.opacity),
      [0, 1, 1],
    );
    await tester.pump(RpMotion.enterDuration);
  });

  testWidgets('sliver geometrisi sabit, içerik tek blok; liste tembel kalır', (
    tester,
  ) async {
    var built = 0;
    const headerKey = ValueKey('header');
    const itemKey = ValueKey('item');
    await tester.pumpWidget(
      app(
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(key: headerKey, height: 64),
            ),
            PageContentEntrance.sliver(
              child: SliverList.builder(
                itemCount: 1000,
                itemBuilder: (context, index) {
                  built++;
                  return SizedBox(key: index == 0 ? itemKey : null, height: 50);
                },
              ),
            ),
          ],
        ),
      ),
    );
    final before = tester.getSize(find.byKey(itemKey));
    expect(tester.getTopLeft(find.byKey(headerKey)).dy, 0);
    expect(tester.getTopLeft(find.byKey(itemKey)).dy, 74);
    expect(built, lessThan(40));
    await tester.pump(RpMotion.enterDuration);
    expect(tester.getTopLeft(find.byKey(itemKey)).dy, 64);
    expect(tester.getSize(find.byKey(itemKey)), before);
    expect(tester.getTopLeft(find.byKey(headerKey)).dy, 0);
  });
}
