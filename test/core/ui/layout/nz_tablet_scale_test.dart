// NzTabletScale: telefonda çarpan 1, tablette alt ağaç küçültülmüş pencere görür ve dokunuş
// büyütülmüş konuma doğru düşer.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/nz_tablet_scale.dart';

Future<Size> _seen(WidgetTester tester, Size view) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = view;
  addTearDown(tester.view.reset);
  late Size seen;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: view),
      child: NzTabletScale(
        child: Builder(
          builder: (c) {
            seen = MediaQuery.sizeOf(c);
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return seen;
}

void main() {
  testWidgets('telefon: boyut değişmez', (tester) async {
    expect(await _seen(tester, const Size(390, 844)), const Size(390, 844));
  });

  testWidgets('tablet: alt ağaç boyut / çarpan görür', (tester) async {
    final s = await _seen(tester, const Size(820, 1180));
    expect(s.width, closeTo(820 / NzTabletScale.factor, 0.01));
    expect(s.height, closeTo(1180 / NzTabletScale.factor, 0.01));
  });

  testWidgets('tablet: dokunuş büyütülmüş konuma düşer', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(820, 1180);
    addTearDown(tester.view.reset);
    var taps = 0;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(820, 1180)),
        child: NzTabletScale(
          child: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps++,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      ),
    );
    await tester.tapAt(const Offset(110, 110));
    expect(taps, 1);
    await tester.tapAt(const Offset(120, 120));
    expect(taps, 1);
  });
}
