import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

import '../../../support/screen_matrix.dart';

Widget _tag(String t) => Text(t, textDirection: TextDirection.ltr);

void main() {
  testScreens('AdaptiveBuilder tam ekranda sınıfa göre ağaç seçer', (
    tester,
    screen,
  ) async {
    await tester.pumpWidget(
      AdaptiveBuilder(
        compact: (_) => _tag('c'),
        medium: (_) => _tag('m'),
        expanded: (_) => _tag('e'),
      ),
    );
    final want = switch (screen.windowClass) {
      WindowClass.compact => 'c',
      WindowClass.medium => 'm',
      WindowClass.expanded => 'e',
    };
    expect(find.text(want), findsOneWidget);
  });

  testWidgets('medium verilmediyse compact ağacına düşer', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      AdaptiveBuilder(compact: (_) => _tag('c'), expanded: (_) => _tag('e')),
    );
    expect(find.text('c'), findsOneWidget);
  });

  testWidgets('ekran genişliğine değil üst kısıta bakar', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 400,
          child: AdaptiveBuilder(
            compact: (_) => _tag('c'),
            expanded: (_) => _tag('e'),
          ),
        ),
      ),
    );
    expect(find.text('c'), findsOneWidget);
    expect(find.text('e'), findsNothing);
  });
}
