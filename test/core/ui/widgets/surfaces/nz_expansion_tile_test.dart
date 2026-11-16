import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_expansion_tile.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('içerik ve özel ok açılma durumunu birlikte izler', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const NzExpansionTile(
          title: Text('Rapor'),
          children: [Text('Ayrıntı')],
        ),
      ),
    );
    expect(find.text('Ayrıntı').hitTestable(), findsNothing);
    expect(tester.widget<RotatedBox>(find.byType(RotatedBox)).quarterTurns, 0);
    await tester.tap(find.text('Rapor'));
    await tester.pumpAndSettle();
    expect(find.text('Ayrıntı').hitTestable(), findsOneWidget);
    expect(tester.widget<RotatedBox>(find.byType(RotatedBox)).quarterTurns, 2);
    await tester.tap(find.text('Rapor'));
    await tester.pumpAndSettle();
    expect(find.text('Ayrıntı').hitTestable(), findsNothing);
    expect(tester.widget<RotatedBox>(find.byType(RotatedBox)).quarterTurns, 0);
  });
}
