// Tablolar rotaları: liste ve ayrıntı açılır, geri liste konumuna döner. Sahte ağ her isteğe
// 404 verdiği için sayfalar sunucu hatası durumunu çizer (veri mantığı controller
// testlerindedir: test/features/tables/application/).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/features/tables/presentation/table_page.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

void main() {
  setUpFonts();
  for (final size in const [Size(390, 844), Size(1180, 820)]) {
    testWidgets('Tablolar liste → ayrıntı → geri: $size', (tester) async {
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = await pumpRouter(
        tester,
        phase,
        width: size.width,
        height: size.height,
      );
      router.go('/tables');
      await settle(tester);
      expect(find.byType(TablesPage), findsOneWidget);
      router.go('/tables/t-1');
      await settle(tester);
      expect(find.byType(TablePage), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(locationOf(router), '/tables');
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Menüden Tablolar açılır', (tester) async {
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(tester, phase, width: 390, height: 844);
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Menü').first);
    await settle(tester);
    await tester.ensureVisible(find.text('Tablolar').last);
    await tester.tap(find.text('Tablolar').last);
    await settle(tester);
    expect(locationOf(router), '/tables');
    expect(find.byType(TablesPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
