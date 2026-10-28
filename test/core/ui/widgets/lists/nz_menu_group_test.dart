import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_menu_group.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'grup adı, ayırıcılar, satır ≥ 48, dokunma; geçerli ve tehlikeli satır',
    (t) async {
      final handle = t.ensureSemantics();
      final taps = <String>[];
      await t.pumpWidget(
        testApp(
          NzMenuGroup(
            label: 'takip',
            rows: [
              NzMenuRow(
                icon: Icons.home,
                label: 'Ana sayfa',
                current: true,
                onTap: () => taps.add('a'),
              ),
              NzMenuRow(
                icon: Icons.list,
                label: 'Görevler',
                trailing: const Text('15'),
                onTap: () => taps.add('b'),
              ),
              NzMenuRow(
                icon: Icons.logout,
                label: 'Çıkış',
                danger: true,
                onTap: () => taps.add('c'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('takip'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
      expect(find.text('15'), findsOneWidget);
      await t.tap(find.text('Görevler'));
      await t.tap(find.text('Çıkış'));
      expect(taps, ['b', 'c']);
      expect(
        t.getSize(find.byType(NzMenuRow).first).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
      );
      expect(
        t.widget<Icon>(find.byIcon(Icons.home)).color,
        NizamioColors.light.accentText,
      );
      expect(
        t.widget<Icon>(find.byIcon(Icons.logout)).color,
        NizamioColors.light.danger,
      );
      expect(
        t.getSemantics(find.bySemanticsLabel('Ana sayfa')),
        isSemantics(
          label: 'Ana sayfa',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
        ),
      );
      handle.dispose();
    },
  );
}
