import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/presentation/decision/task_date_comparison.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();
  setUpAll(() => initializeDateFormatting('tr'));
  final l = AppLocalizationsTr();
  final due = DateTime(2026, 6, 15);

  test('geç onayda bitiş değişmez; tamamlanma tarihi ayrı gösterilir', () {
    final facts = approvalDateFacts(
      l,
      due: due,
      today: DateTime(2026, 11, 16),
      pull: false,
    );
    expect(facts.map((f) => (f.label, f.value)), [
      ('Önceki bitiş', '15.06.2026'),
      ('İşlem sonrası bitiş', '15.06.2026'),
      ('Tamamlanma tarihi', '16.11.2026'),
      ('Sonuç', '154 gün geç'),
    ]);
    expect(facts.last.danger, isTrue);
  });

  test('erken onayda yalnız açık seçim bitişi bugüne çeker', () {
    final today = DateTime(2026, 6, 10);
    final keep = approvalDateFacts(l, due: due, today: today, pull: false);
    final pull = approvalDateFacts(l, due: due, today: today, pull: true);
    expect(keep[1].value, '15.06.2026');
    expect(pull[1].value, '10.06.2026');
    expect(keep[2].value, pull[2].value);
    expect(keep.last.value, '5 gün erken');
    expect(pull.last.value, l.uiTasksResultOnTime);
  });

  testWidgets('talebin eski/yeni başlangıç ve bitişleri etiketli gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        TaskDateComparison.request(
          request: DateChangeRequest(
            oldStart: DateTime(2026, 6, 1),
            oldDue: due,
            start: DateTime(2026, 6, 5),
            due: DateTime(2026, 6, 20),
          ),
        ),
      ),
    );
    for (final label in [
      'Önceki başlangıç',
      'Yeni başlangıç',
      'Önceki bitiş',
      'Yeni bitiş',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    for (final date in [
      '01.06.2026',
      '05.06.2026',
      '15.06.2026',
      '20.06.2026',
    ]) {
      expect(find.text(date), findsOneWidget);
    }
  });

  testWidgets('eski başlangıç eksikse tahmin edilmez', (tester) async {
    await tester.pumpWidget(
      testApp(
        TaskDateComparison.request(
          request: DateChangeRequest(
            oldDue: due,
            start: DateTime(2026, 6, 5),
            due: DateTime(2026, 6, 20),
          ),
        ),
      ),
    );
    expect(find.text(l.uiTasksDateUnavailable), findsOneWidget);
    expect(find.text('05.06.2026'), findsOneWidget);
  });
}
