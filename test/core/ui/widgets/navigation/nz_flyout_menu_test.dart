import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_flyout_menu.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'bölümler ve satırlar; seçimde kapanır sonra eylem; dışarı dokunma kapatır',
    (t) async {
      final picked = <String>[];
      await t.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => NzFlyoutMenu.show(
                context,
                semanticLabel: 'Kısayollar',
                entries: [
                  const NzFlyoutSection('seni bekleyenler'),
                  NzFlyoutItem(
                    label: 'Hidrofor',
                    caption: 'ALT-7 · Tarih talebi',
                    dot: NizamioColors.light.warning,
                    onSelected: () => picked.add('a'),
                  ),
                  const NzFlyoutSection('hızlı işlemler'),
                  NzFlyoutItem(
                    label: 'Yeni görev',
                    icon: Icons.add,
                    accent: true,
                    onSelected: () => picked.add('b'),
                  ),
                ],
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await t.tap(find.text('aç'));
      await t.pumpAndSettle();
      expect(find.text('seni bekleyenler'), findsOneWidget);
      expect(find.text('ALT-7 · Tarih talebi'), findsOneWidget);
      expect(
        t.widget<Icon>(find.byIcon(Icons.add)).color,
        NizamioColors.light.accentText,
      );
      final panel = t.getRect(find.text('Yeni görev'));
      expect(panel.left, greaterThanOrEqualTo(NizamioSpacing.gutter));
      await t.tap(find.text('Yeni görev'));
      await t.pumpAndSettle();
      expect(find.text('seni bekleyenler'), findsNothing);
      expect(picked, ['b']);
      await t.tap(find.text('aç'));
      await t.pumpAndSettle();
      await t.tapAt(const Offset(780, 20));
      await t.pumpAndSettle();
      expect(find.text('seni bekleyenler'), findsNothing);
    },
  );
}
