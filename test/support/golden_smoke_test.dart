// Golden altyapısı araç kanıtı: etiketli, Linux dışında atlanan, referansı CI'da üretilen test.
// Referans: test/support/goldens/golden_smoke.png (yalnız Linux'ta üretilir; elle commit'lenmez).
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden.dart';

const _boundaryKey = ValueKey('golden-smoke');

// Center: kök sıkı kısıtı SizedBox'ı 800x600'e zorlamasın.
Widget _tree() => const Directionality(
  textDirection: TextDirection.ltr,
  child: Center(
    child: RepaintBoundary(
      key: _boundaryKey,
      child: SizedBox(
        width: 120,
        height: 60,
        // stretch: çocuksuz ColoredBox gevşek kısıtta 0 boyuta iner (boş yakalamanın kök nedeni).
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: ColoredBox(color: Color(0xFF336699))),
            Expanded(child: ColoredBox(color: Color(0xFFCC9933))),
          ],
        ),
      ),
    ),
  ),
);

void main() {
  // Platformdan bağımsız: golden'ın hedefi doğru sınırı yakalıyor.
  testWidgets('golden hedefi 120x60 ve iki kutu içerir', (tester) async {
    await tester.pumpWidget(_tree());
    expect(tester.getSize(find.byKey(_boundaryKey)), const Size(120, 60));
    expect(
      find.descendant(
        of: find.byKey(_boundaryKey),
        matching: find.byType(ColoredBox),
      ),
      findsNWidgets(2),
    );
  });

  // Yakalama dolu mu: golden'ın kullandığı yolla (RepaintBoundary → toImage) piksel okunur.
  // Boş (saydam) yakalama bu testi her platformda kırar; referansa güvenmeden önce kanıttır.
  testWidgets('yakalanan görüntü içerik taşır (piksel kanıtı)', (tester) async {
    await tester.pumpWidget(_tree());
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_boundaryKey),
    );
    final bytes = (await tester.runAsync(() async {
      final image = await boundary.toImage();
      expect((image.width, image.height), (120, 60));
      return image.toByteData(format: ui.ImageByteFormat.rawRgba);
    }))!;
    List<int> px(int x, int y) {
      final o = (y * 120 + x) * 4;
      return [for (var i = 0; i < 4; i++) bytes.getUint8(o + i)];
    }

    expect(px(30, 30), [0x33, 0x66, 0x99, 0xFF]);
    expect(px(90, 30), [0xCC, 0x99, 0x33, 0xFF]);
  });

  goldenTestWidgets('altyapı örneği: sabit boyutlu iki kutu', (tester) async {
    await tester.pumpWidget(_tree());
    await expectLater(
      find.byKey(_boundaryKey),
      matchesGoldenFile('goldens/golden_smoke.png'),
    );
  });
}
