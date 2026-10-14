// Golden altyapısı araç kanıtı: etiketli, Linux dışında atlanan, referansı CI'da üretilen test.
// Referans: test/support/goldens/golden_smoke.png (yalnız Linux'ta üretilir; elle commit'lenmez).
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden.dart';

void main() {
  goldenTestWidgets('altyapı örneği: sabit boyutlu iki kutu', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
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
    await expectLater(
      find.byType(RepaintBoundary).first,
      matchesGoldenFile('goldens/golden_smoke.png'),
    );
  });
}
