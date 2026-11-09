import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    final opacity = find.byType(FadeTransition);
    final box = find.byType(SizedBox);
    expect(tester.widget<FadeTransition>(opacity).opacity.value, 0);
    expect(tester.getTopLeft(box).dy, 10);
    await tester.pump(const Duration(milliseconds: 160));
    final t = RpMotion.enterCurve.transform(0.5);
    expect(
      tester.widget<FadeTransition>(opacity).opacity.value,
      closeTo(t, 0.001),
    );
    expect(tester.getTopLeft(box).dy, closeTo(10 * (1 - t), 0.001));
    await tester.pump(const Duration(milliseconds: 160));
    expect(tester.getTopLeft(box).dy, 0);
    rebuild(() {});
    await tester.pump();
    expect(tester.widget<FadeTransition>(opacity).opacity.value, 1);
  });

  testWidgets(
    'hareketi azalt ilk karede son hal; anahtar yeni giriş başlatır',
    (tester) async {
      Widget panel(int tab, {bool reduced = false}) => app(
        PageContentEntrance(key: ValueKey(tab), child: const SizedBox()),
        reduced: reduced,
      );
      await tester.pumpWidget(panel(0, reduced: true));
      expect(
        tester
            .widget<FadeTransition>(find.byType(FadeTransition))
            .opacity
            .value,
        1,
      );
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(panel(1));
      expect(
        tester
            .widget<FadeTransition>(find.byType(FadeTransition))
            .opacity
            .value,
        0,
      );
      await tester.pump(RpMotion.enterDuration);
      expect(
        tester
            .widget<FadeTransition>(find.byType(FadeTransition))
            .opacity
            .value,
        1,
      );
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
      tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .map((w) => w.opacity.value),
      [0, 1, 1],
    );
    await tester.pump(RpMotion.enterDuration);
  });

  testWidgets(
    'camlı kapsayıcı yalnız öteler; içteki camsız giriş onun eğrisiyle solar',
    (tester) async {
      await tester.pumpWidget(
        app(
          const Align(
            alignment: Alignment.topLeft,
            child: NzPaneTransition(
              motion: NzPaneMotion.rise,
              child: PageContentEntrance(
                fade: false,
                child: PageContentEntrance(
                  child: SizedBox(width: 10, height: 10),
                ),
              ),
            ),
          ),
        ),
      );
      List<double> opacities() => tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .map((w) => w.opacity.value)
          .toList();
      // Bölme geçişinde opaklık katmanı yok; cam taşıyan giriş 1, camsız iç katman 0.
      expect(opacities(), [1, 0]);
      await tester.pump(const Duration(milliseconds: 160));
      final t = RpMotion.enterCurve.transform(0.5);
      expect(opacities(), [1, closeTo(t, 0.001)]);
      await tester.pump(RpMotion.enterDuration);
      expect(opacities(), [1, 1]);
    },
  );

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

  testWidgets('NzEntrance: replay aynıyken oynamaz, değişince kademeli oynar', (
    tester,
  ) async {
    Widget grid(Object replay) => app(
      Column(
        children: [
          for (var i = 0; i < 2; i++)
            NzEntrance(
              replay: (replay, i),
              index: i,
              child: const SizedBox(height: 10),
            ),
        ],
      ),
    );
    double opacity(int i) => tester
        .widgetList<FadeTransition>(find.byType(FadeTransition))
        .elementAt(i)
        .opacity
        .value;
    await tester.pumpWidget(grid('a'));
    await tester.pump(RpMotion.enterDuration + RpMotion.stagger(1));
    expect(opacity(1), 1);
    await tester.pumpWidget(grid('a'));
    expect(opacity(0), 1);
    await tester.pumpWidget(grid('b'));
    await tester.pump(RpMotion.staggerStep * 0.5);
    // İlk öğe yükselmeye başladı, ikincisi gecikmesini bekliyor.
    expect(opacity(0), greaterThan(0));
    expect(opacity(1), 0);
    await tester.pump(RpMotion.enterDuration + RpMotion.stagger(1));
    expect(opacity(0), 1);
    expect(opacity(1), 1);
  });

  group('onRevisit', () {
    var revisits = 0;
    setUp(() => revisits = 0);
    Widget host(bool visible, {bool reduced = false, bool enabled = true}) =>
        app(
          TickerMode(
            enabled: visible,
            child: PageContentEntrance(
              enabled: enabled,
              onRevisit: () {
                expect(
                  SchedulerBinding.instance.schedulerPhase,
                  SchedulerPhase.postFrameCallbacks,
                );
                revisits++;
              },
              child: const SizedBox(),
            ),
          ),
          reduced: reduced,
        );

    testWidgets('ilk görünüş ve dönüş: hareket bitince kare sonunda bir kez', (
      tester,
    ) async {
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      expect(revisits, 1);
      await tester.pumpWidget(host(false));
      await tester.pumpWidget(host(true));
      await tester.pump(
        RpMotion.enterDuration - const Duration(milliseconds: 1),
      );
      expect(revisits, 1);
      await tester.pump(const Duration(milliseconds: 2));
      expect(revisits, 2);
      await tester.pump(RpMotion.enterDuration);
      expect(revisits, 2);
    });

    testWidgets('hareket bitmeden yeniden gizlenirse çağrılmaz', (
      tester,
    ) async {
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(false));
      await tester.pumpWidget(host(true));
      await tester.pump(RpMotion.enterDuration ~/ 2);
      await tester.pumpWidget(host(false));
      await tester.pump(RpMotion.enterDuration * 2);
      expect(revisits, 1);
    });

    testWidgets('hareketi azalt: dönüşte kare sonunda', (tester) async {
      await tester.pumpWidget(host(true, reduced: true));
      await tester.pumpWidget(host(false, reduced: true));
      await tester.pumpWidget(host(true, reduced: true));
      expect(revisits, 2);
      await tester.pump(RpMotion.enterDuration);
      expect(revisits, 2);
    });

    testWidgets('bölme geçişine katılan giriş, bölme hareketi bitince', (
      tester,
    ) async {
      Widget pane(bool visible, Object play) => app(
        TickerMode(
          enabled: visible,
          child: NzPaneTransition(
            motion: NzPaneMotion.pop,
            play: play,
            child: PageContentEntrance(
              onRevisit: () => revisits++,
              child: const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pumpWidget(pane(true, 0));
      await tester.pumpAndSettle();
      await tester.pumpWidget(pane(false, 0));
      await tester.pumpWidget(pane(true, 1));
      await tester.pump(RpMotion.enterDuration);
      // Giriş süresi geçti ama bölme hareketi sürüyor: iç giriş ona katılır, onu bekler.
      expect(tester.hasRunningAnimations, isTrue);
      expect(revisits, 1);
      await tester.pumpAndSettle();
      expect(revisits, 2);
    });

    testWidgets(
      'beklenen hareket yeniden başlatılırsa tamamlanmadan çağrılmaz, tamamlanınca bir kez',
      (tester) async {
        Widget pane(Object play) => app(
          NzPaneTransition(
            motion: NzPaneMotion.pop,
            play: play,
            child: TickerMode(
              enabled: play != 0,
              child: PageContentEntrance(
                onRevisit: () => revisits++,
                child: const SizedBox(),
              ),
            ),
          ),
        );
        await tester.pumpWidget(pane(-1));
        await tester.pumpAndSettle();
        await tester.pumpWidget(pane(0));
        await tester.pumpWidget(pane(1));
        await tester.pump(RpMotion.pushDuration ~/ 2);
        // Bölme hareketi baştan başlar (dismissed): tazeleme hâlâ bitişi bekler.
        await tester.pumpWidget(pane(2));
        await tester.pump();
        expect(revisits, 1);
        await tester.pump(RpMotion.pushDuration ~/ 2);
        expect(revisits, 1);
        await tester.pumpAndSettle();
        expect(revisits, 2);
      },
    );

    testWidgets('ilk gizli kurulum çağırmaz; ilk etkin görünüş bir kez', (
      tester,
    ) async {
      await tester.pumpWidget(host(false));
      await tester.pump(RpMotion.enterDuration * 2);
      expect(revisits, 0);
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      expect(revisits, 1);
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      expect(revisits, 1, reason: 'sıradan rebuild yeni ziyaret değildir');
    });

    testWidgets(
      'hareketsiz ilk görünüş ve hızlı dönüş kare sonunda tek çağrı',
      (tester) async {
        await tester.pumpWidget(host(false, enabled: false));
        expect(revisits, 0);
        await tester.pumpWidget(host(true, enabled: false));
        expect(revisits, 1);
        await tester.pumpWidget(host(false, enabled: false));
        await tester.pumpWidget(host(true, enabled: false));
        await tester.pumpWidget(host(true, enabled: false));
        expect(revisits, 2);
      },
    );

    testWidgets('ilk giriş bitmeden dispose olursa bekleyen çağrı iptal', (
      tester,
    ) async {
      await tester.pumpWidget(host(true));
      await tester.pump(RpMotion.enterDuration ~/ 2);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(RpMotion.enterDuration);
      expect(revisits, 0);
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      expect(revisits, 1);
    });

    testWidgets(
      'bitiş karesinde gizlenip açılınca eski kare sonu işi çağırmaz',
      (tester) async {
        // İlk hareket tamamlandığında build aşamasında gizle; status dinleyicisi daha önce
        // post-frame işi kuyruğa koymuştur. Aynı State tekrar açılınca yalnız yeni ziyaret sayılır.
        var visible = true;
        late StateSetter rebuild;
        await tester.pumpWidget(
          app(
            StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return TickerMode(
                  enabled: visible,
                  child: PageContentEntrance(
                    onRevisit: () => revisits++,
                    child: const SizedBox(),
                  ),
                );
              },
            ),
          ),
        );
        rebuild(() => visible = false);
        await tester.pump(
          RpMotion.enterDuration + const Duration(milliseconds: 1),
        );
        expect(revisits, 0);
        rebuild(() => visible = true);
        await tester.pump();
        await tester.pumpAndSettle();
        expect(revisits, 1);
      },
    );

    testWidgets('bitiş karesinde dispose, kuyruğa alınmış çağrıyı iptal eder', (
      tester,
    ) async {
      await tester.pumpWidget(host(true));
      await tester.pumpWidget(
        const SizedBox(),
        duration: RpMotion.enterDuration + const Duration(milliseconds: 1),
      );
      await tester.pumpAndSettle();
      expect(revisits, 0);
    });

    testWidgets(
      'bitiş karesinde üst hareket yeniden başlarsa yeni bitiş beklenir',
      (tester) async {
        var play = 0;
        late StateSetter rebuild;
        await tester.pumpWidget(
          app(
            StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return NzPaneTransition(
                  motion: NzPaneMotion.pop,
                  play: play,
                  child: PageContentEntrance(
                    onRevisit: () => revisits++,
                    child: const SizedBox(),
                  ),
                );
              },
            ),
          ),
        );
        rebuild(() => play++);
        await tester.pump(
          RpMotion.pushDuration + const Duration(milliseconds: 1),
        );
        expect(revisits, 0);
        await tester.pump(RpMotion.pushDuration ~/ 2);
        expect(revisits, 0);
        await tester.pumpAndSettle();
        expect(revisits, 1);
      },
    );
  });
}
