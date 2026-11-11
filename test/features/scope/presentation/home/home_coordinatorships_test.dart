import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/presentation/home/home_coordinatorships.dart';

import '../../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();
  testWidgets('görev özeti ve gezinme telefon ve tablet boyutlarında korunur', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.reset);
    String? opened;
    const c = CoordinatorshipSummary(
      code: 'd',
      name: 'Fuar',
      leads: [],
      todo: 1,
      inProgress: 0,
      inReview: 1,
      done: 2,
      late: 1,
    );
    Widget app(Size size, {required bool wide}) => ProviderScope(
      child: testApp(
        MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: const TextScaler.linear(2),
          ),
          child: SingleChildScrollView(
            child: HomeCoordinatorships(
              items: const [c],
              wide: wide,
              onOpen: (id) => opened = id,
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(const Size(320, 800), wide: false));
    await tester.pumpAndSettle();
    expect(find.text('%50'), findsOneWidget);
    final segments = find.descendant(
      of: find.byKey(const ValueKey('coord-task-distribution')),
      matching: find.byType(DecoratedBox),
    );
    expect(segments, findsNWidgets(3));
    final sizes = [
      for (final element in segments.evaluate())
        tester.getSize(find.byWidget(element.widget)),
    ];
    expect(sizes.every((size) => size.width > 0 && size.height > 0), isTrue);
    expect(sizes.first.width, closeTo(sizes.last.width * 2, 1));

    expect(
      find.bySemanticsLabel('Fuar. %50. 4 görev. 1 geciken'),
      findsOneWidget,
    );
    await tester.tap(find.bySemanticsLabel('Fuar. %50. 4 görev. 1 geciken'));
    expect(opened, 'd');
    tester.view.physicalSize = const Size(1024, 1000);
    await tester.pumpWidget(app(const Size(1024, 1000), wide: true));
    await tester.pumpAndSettle();
    expect(find.text('%50'), findsOneWidget);
  });
}
