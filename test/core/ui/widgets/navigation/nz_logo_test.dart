import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_logo.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_path_icon.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  test(
    'roket yolu 24×24 iç koordinatta (SVG translate 6 / scale .8333 öncesi)',
    () {
      final b = NzPathIcon.pathOf(NzLogo.rocket).getBounds();
      expect(b.left, greaterThanOrEqualTo(4.9));
      expect(b.right, lessThanOrEqualTo(21.1));
      expect(b.top, greaterThanOrEqualTo(3.9));
      expect(b.bottom, lessThanOrEqualTo(19.1));
    },
  );

  testWidgets('verilen kenarda çizilir, okuyucuya görünmez; iki temada', (
    tester,
  ) async {
    for (final dark in [true, false]) {
      await tester.pumpWidget(
        testApp(
          const Center(child: NzLogo(key: ValueKey('logo'), extent: 44)),
          dark: dark,
        ),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('logo'))),
        const Size(44, 44),
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('logo')),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
  });
}
