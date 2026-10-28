// NzRangeCalendar: ay başlığı ve gezinme, Pazartesi başlangıçlı ızgara, aralık/tek gün
// seçimi, ay dışı ve en erken tarihten önceki günlerin dokunulamaması.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_range_calendar.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  Widget host({
    DateTime? start,
    DateTime? end,
    DateTime? firstDate,
    required List<DateTime> taps,
    required List<int> steps,
  }) => testApp(
    SizedBox(
      width: 360,
      child: NzRangeCalendar(
        month: DateTime(2026, 10),
        start: start,
        end: end,
        today: DateTime(2026, 10, 21),
        firstDate: firstDate,
        onMonthStep: steps.add,
        onDayTap: taps.add,
      ),
    ),
  );

  testWidgets('ay adı, gün başlıkları, ay gezinmesi ve gün dokunuşu', (
    t,
  ) async {
    final taps = <DateTime>[];
    final steps = <int>[];
    await t.pumpWidget(host(taps: taps, steps: steps));
    expect(find.text('Ekim 2026'), findsOneWidget);
    expect(find.text('Pzt'), findsOneWidget);
    await t.tap(find.byIcon(Icons.chevron_left_rounded));
    await t.tap(find.byIcon(Icons.chevron_right_rounded));
    expect(steps, [-1, 1]);
    await t.tap(find.text('15'));
    expect(taps, [DateTime(2026, 10, 15)]);
    // Ekim 2026 Perşembe başlar: ilk satırda Eylül'ün 28–30'u (ay dışı) dokunulamaz.
    await t.tap(find.text('28').first);
    expect(taps, hasLength(1));
  });

  testWidgets(
    'aralık: uçlar ve iç günler seçili; en erken tarih öncesi kapalı',
    (t) async {
      final taps = <DateTime>[];
      await t.pumpWidget(
        host(
          start: DateTime(2026, 10, 21),
          end: DateTime(2026, 11, 4),
          firstDate: DateTime(2026, 10, 21),
          taps: taps,
          steps: [],
        ),
      );
      final selected = find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.selected ?? false),
      );
      // 21–31 Ekim (11 gün) + ay dışı 1 Kasım (aralıkta, sonraki ay satırında).
      expect(selected.evaluate().length, greaterThanOrEqualTo(11));
      await t.tap(find.text('20'));
      expect(taps, isEmpty);
      await t.tap(find.text('22'));
      expect(taps, [DateTime(2026, 10, 22)]);
    },
  );

  testWidgets('açık/koyu temada çizilir', (t) async {
    for (final dark in [false, true]) {
      await t.pumpWidget(
        testApp(
          NzRangeCalendar(
            month: DateTime(2026, 10),
            start: DateTime(2026, 10, 22),
            onMonthStep: (_) {},
            onDayTap: (_) {},
          ),
          dark: dark,
        ),
      );
      expect(t.takeException(), isNull);
    }
  });
}
