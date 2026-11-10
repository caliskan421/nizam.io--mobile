import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';
import 'package:nizamio/features/tasks/presentation/tasks/task_view_grid.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  testWidgets('kesik kaynaktan görünüm sayıları alt sınır olarak gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        TaskViewGrid(
          counts: const {TaskView.all: 3},
          selected: TaskView.all,
          truncated: true,
          onSelected: (_) {},
        ),
      ),
    );
    expect(find.text('≥3'), findsOneWidget);
    expect(find.text('3'), findsNothing);
  });
}
