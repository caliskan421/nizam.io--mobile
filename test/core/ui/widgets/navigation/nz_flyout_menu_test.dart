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

  testWidgets('tablet rol menüsü overlay boyutuyla sağ kenarda açılır', (
    t,
  ) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(1376, 1032);
    addTearDown(t.view.reset);
    var selected = false;
    await t.pumpWidget(
      MediaQuery(
        // Navigator'ın miras aldığı boyut ile gerçek yerleşim farklı olabilir.
        data: const MediaQueryData(size: Size(800, 1032)),
        child: testApp(
          Align(
            alignment: Alignment.topRight,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  final box = context.findRenderObject()! as RenderBox;
                  NzFlyoutMenu.show(
                    context,
                    semanticLabel: 'Rol seç',
                    anchor: box.localToGlobal(Offset.zero) & box.size,
                    below: true,
                    alignEnd: true,
                    entries: [
                      NzFlyoutItem(
                        label: 'Üye',
                        onSelected: () => selected = true,
                      ),
                    ],
                  );
                },
                child: const Text('Rol kartı'),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('Rol kartı'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.text('Üye'), findsOneWidget);
    await t.tap(find.text('Üye'));
    await t.pumpAndSettle();
    expect(selected, isTrue);
    expect(find.text('Üye'), findsNothing);
  });

  testWidgets('sayaç sağda; seçili satır okuyucuda seçili ve vurgulu', (
    t,
  ) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => NzFlyoutMenu.show(
              context,
              semanticLabel: 'Kısayollar',
              entries: [
                NzFlyoutItem(
                  label: 'Tümü',
                  icon: Icons.list,
                  count: '38',
                  selected: true,
                  onSelected: () {},
                ),
                NzFlyoutItem(label: 'Görev', count: '9', onSelected: () {}),
              ],
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    );
    await t.tap(find.text('aç'));
    await t.pumpAndSettle();
    expect(find.text('38'), findsOneWidget);
    expect(
      t.getTopLeft(find.text('38')).dx,
      greaterThan(t.getTopLeft(find.text('Tümü')).dx),
    );
    expect(
      t.getSemantics(find.bySemanticsLabel('Tümü, 38')),
      matchesSemantics(
        label: 'Tümü, 38',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    expect(
      t.widget<Text>(find.text('Tümü')).style?.fontWeight,
      FontWeight.w600,
    );
    handle.dispose();
  });
}
