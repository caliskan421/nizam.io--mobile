import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/nz_bleed.dart';

void main() {
  testWidgets(
    'çocuk iki yanda bleed kadar taşar, kendi genişliği üst kısıttır',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: SizedBox(
                width: 200,
                child: NzHorizontalBleed(
                  bleed: 8,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => taps++,
                    child: const SizedBox(key: Key('c'), height: 40),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getRect(find.byType(NzHorizontalBleed)),
        const Rect.fromLTWH(100, 0, 200, 40),
      );
      expect(
        tester.getRect(find.byKey(const Key('c'))),
        const Rect.fromLTWH(92, 0, 216, 40),
      );
      await tester.tapAt(const Offset(104, 20));
      expect(taps, 1, reason: 'çocuk dokunmayı alır');
    },
  );
}
