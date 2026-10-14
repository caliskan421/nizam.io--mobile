import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

Future<double> _scaleSeenWith(WidgetTester tester, double userScale) async {
  late double seen;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(userScale)),
      child: NzTextScaleLimit(
        child: Builder(
          builder: (context) {
            seen = MediaQuery.textScalerOf(context).scale(10) / 10;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return seen;
}

void main() {
  testWidgets('2.0 üstü ölçek 2.0\'a kısılır', (tester) async {
    expect(await _scaleSeenWith(tester, 3.0), 2.0);
  });

  testWidgets('sınır altındaki kullanıcı ölçeği korunur', (tester) async {
    expect(await _scaleSeenWith(tester, 1.3), closeTo(1.3, 1e-9));
  });
}
