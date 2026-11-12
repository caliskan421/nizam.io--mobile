import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_search_field.dart';
import 'package:nizamio/features/tasks/application/tasks_list_controller.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/presentation/tasks_page.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

void main() {
  setUpFonts();

  testWidgets('görev araması boşken klavyeden veya üst simgeden kapanır', (
    tester,
  ) async {
    final h = await real(tester, () async {
      final h = await pilotHarness(CoordBackend(), signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      return h;
    });
    await pumpScreen(tester, h, const TasksPage());
    await settle(tester);
    final provider = tasksListControllerProvider(TaskView.all, '');
    final toggle = find.bySemanticsLabel('Ara');
    final field = find.byType(NzSearchField);
    for (final query in ['', '   ']) {
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(h.container.read(provider).searchOpen, isTrue);
      expect(field, findsOneWidget);
      await tester.enterText(find.byType(EditableText), query);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(h.container.read(provider).searchOpen, isFalse);
      expect(h.container.read(provider).filter.query, isEmpty);
      expect(field, findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);

      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(field, findsOneWidget);
      await tester.enterText(find.byType(EditableText), query);
      await tester.pump();
      final tap = await tester.startGesture(tester.getCenter(toggle));
      await tester.pump(const Duration(milliseconds: 100));
      await tap.up();
      await tester.pumpAndSettle();
      expect(h.container.read(provider).searchOpen, isFalse);
      expect(field, findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);
    }

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'Hidrofor');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(h.container.read(provider).searchOpen, isTrue);
    expect(h.container.read(provider).filter.query, 'Hidrofor');
    expect(field, findsOneWidget);
  });
}
