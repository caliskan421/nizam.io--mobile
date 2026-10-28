import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_side_sheet.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'sağdan açılır; genişlik token ya da ekranın %86\'sı; dışarı dokunma kapatır',
    (t) async {
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = const Size(360, 800);
      addTearDown(t.view.reset);
      await t.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => NzSideSheet.show<void>(
                context,
                semanticLabel: 'Menü',
                builder: (_) => const Text('içerik'),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await t.tap(find.text('aç'));
      await t.pumpAndSettle();
      expect(find.text('içerik'), findsOneWidget);
      final panel = t.getRect(
        find
            .ancestor(
              of: find.text('içerik'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(panel.right, 360);
      expect(panel.width, closeTo(360 * 0.86, 0.5));
      expect(panel.width, lessThan(NizamioSize.drawerWidth + 1));
      await t.tapAt(const Offset(10, 400));
      await t.pumpAndSettle();
      expect(find.text('içerik'), findsNothing);
    },
  );
}
