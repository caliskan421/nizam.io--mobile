// NzTimeWheel: başlangıç değerleri, öğeye dokununca kaydırıp bildirme, dakika adımına oturma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_time_wheel.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('seçili saat/dakika ortada; dokunulan öğeye kayar ve bildirir', (
    t,
  ) async {
    final changes = <(int, int)>[];
    await t.pumpWidget(
      testApp(
        SizedBox(
          width: 300,
          child: NzTimeWheel(
            hour: 14,
            minute: 0,
            onChanged: (h, m) => changes.add((h, m)),
          ),
        ),
      ),
    );
    expect(find.text('14'), findsOneWidget);
    expect(find.text(':'), findsOneWidget);
    await t.tap(find.text('15').first);
    await t.pumpAndSettle();
    expect(changes.last, (15, 0));
    await t.tap(find.text('05'));
    await t.pumpAndSettle();
    expect(changes.last, (15, 5));
  });

  testWidgets('adımda olmayan dakika en yakın adıma oturur; koyu tema', (
    t,
  ) async {
    await t.pumpWidget(
      testApp(
        SizedBox(
          width: 300,
          child: NzTimeWheel(hour: 9, minute: 13, onChanged: (_, _) {}),
        ),
        dark: true,
      ),
    );
    final wheels = t.widgetList<ListWheelScrollView>(
      find.byType(ListWheelScrollView),
    );
    final minute = wheels.last.controller! as FixedExtentScrollController;
    expect(minute.selectedItem, 3); // 15
    expect(t.takeException(), isNull);
  });
}
