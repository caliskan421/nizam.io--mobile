// Golden altyapısı araç kanıtı: etiketli, Linux dışında atlanan, referansı CI'da üretilen test.
// Referans: test/support/goldens/golden_smoke.png (yalnız Linux'ta üretilir; elle commit'lenmez).
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
        child: Row(
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

  goldenTestWidgets('altyapı örneği: sabit boyutlu iki kutu', (tester) async {
    await tester.pumpWidget(_tree());
    await expectLater(
      find.byKey(_boundaryKey),
      matchesGoldenFile('goldens/golden_smoke.png'),
    );
  });
}
