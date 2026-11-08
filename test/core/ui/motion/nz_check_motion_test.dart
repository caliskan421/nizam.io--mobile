// NzCheckHold: işaretlenen madde 360 ms tutulur, ardışık işarette zamanlayıcı yeniden kurulur ve
// tutulanlar birlikte bırakılır; işaret kaldırma beklemesiz; hareketi azalt → tutma ve kayma yok.
// NzStrikeText: çizgi işaretle uzar, kaldırınca geri çekilir (durum anlık değil, hareketli).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/motion/nz_check_motion.dart';

import '../widgets/feedback/feedback_test_support.dart';

void main() {
  testWidgets('tutma, ardışık işaret, bırakma ve geri alma', (tester) async {
    var released = 0;
    final hold = NzCheckHold(() => released++);
    addTearDown(hold.dispose);
    hold.toggle('a', wasDone: false, reduced: false);
    expect(hold.held, {'a'});
    expect(hold.order, 0);
    await tester.pump(const Duration(milliseconds: 300));
    hold.toggle('b', wasDone: false, reduced: false);
    await tester.pump(const Duration(milliseconds: 300));
    expect(hold.held, {'a', 'b'}, reason: 'ilk zamanlayıcı iptal');
    await tester.pump(const Duration(milliseconds: 60));
    expect(hold.held, isEmpty);
    expect((hold.order, released), (1, 1));

    hold.toggle('a', wasDone: true, reduced: false);
    expect(hold.order, 2, reason: 'beklemesiz');
  });

  testWidgets('hareketi azalt: tutma ve sıra kuşağı yok', (tester) async {
    final hold = NzCheckHold(() {});
    addTearDown(hold.dispose);
    hold
      ..toggle('a', wasDone: false, reduced: true)
      ..toggle('b', wasDone: true, reduced: true);
    await tester.pump(const Duration(seconds: 1));
    expect(hold.held, isEmpty);
    expect(hold.order, 0);
  });

  testWidgets('çizgi hareketle uzar ve geri çekilir', (tester) async {
    Widget text(bool done) => testApp(
      NzStrikeText(
        text: 'Basınç testi sonuçları',
        done: done,
        color: Colors.white,
        style: const TextStyle(fontSize: 15),
      ),
    );
    double progress() =>
        (tester
                        .widget<CustomPaint>(
                          find.descendant(
                            of: find.byType(NzStrikeText),
                            matching: find.byType(CustomPaint),
                          ),
                        )
                        .foregroundPainter!
                    as dynamic)
                .progress
            as double;
    await tester.pumpWidget(text(false));
    expect(progress(), 0);
    await tester.pumpWidget(text(true));
    await tester.pump(const Duration(milliseconds: 190));
    expect(progress(), inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(progress(), 1);
    await tester.pumpWidget(text(false));
    await tester.pumpAndSettle();
    expect(progress(), 0);
  });
}
