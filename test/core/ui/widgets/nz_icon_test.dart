import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_path_icon.dart';
import 'package:nizamio/core/ui/widgets/nz_icon.dart';

import 'feedback/feedback_test_support.dart';

Future<void> _pump(WidgetTester tester, double width, Widget child) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(testApp(Center(child: child)));
}

void main() {
  setUpFonts();

  testWidgets('telefonda Material Icon (değişmez)', (tester) async {
    await _pump(tester, 390, const NzIcon(Icons.search_rounded, size: 20));
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byType(NzPathIcon), findsNothing);
  });

  testWidgets('tablette eşlenen ikon kaynak SVG yolu; boyut ve renk korunur', (
    tester,
  ) async {
    await _pump(
      tester,
      1180,
      const NzIcon(
        Icons.search_rounded,
        size: 16,
        color: Color(0xFFFF0000),
        semanticLabel: 'Ara',
      ),
    );
    final drawn = tester.widget<NzPathIcon>(find.byType(NzPathIcon));
    expect(drawn.data, NzIconPaths.search);
    expect(drawn.size, 16);
    expect(drawn.color, const Color(0xFFFF0000));
    expect(find.bySemanticsLabel('Ara'), findsOneWidget);
  });

  testWidgets('tablette eşlemesi olmayan ikon Material kalır', (tester) async {
    await _pump(tester, 1180, const NzIcon(Icons.star_rounded));
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  test('eşleme tablosu: geri, kapat, ekle, filtre kaynakla aynı', () {
    expect(
      NzIconPaths.material[Icons.arrow_back_ios_new_rounded],
      'M15 5l-7 7 7 7',
    );
    expect(NzIconPaths.material[Icons.close_rounded], 'M6 6l12 12M18 6L6 18');
    expect(NzIconPaths.material[Icons.add_rounded], 'M12 5v14M5 12h14');
    expect(NzIconPaths.material[Icons.tune_rounded], 'M4 6h16M7 12h10M10 18h4');
  });
}
