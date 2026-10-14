import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_search_field.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzSearchField(size: size, hint: 'Ara ${size.name}'),
      cellGap,
    ],
    const NzSearchField(label: 'Kişi ara'),
    cellGap,
    const NzSearchField(enabled: false),
  ],
);

void main() {
  setUpFonts();

  testWidgets('etiket varsayılanı ARB\'den; simge çizilir', (tester) async {
    await tester.pumpWidget(testApp(const NzSearchField()));
    expect(find.text('Ara'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('verilen etiket kullanılır', (tester) async {
    await tester.pumpWidget(testApp(const NzSearchField(label: 'Kişi ara')));
    expect(find.text('Kişi ara'), findsOneWidget);
    expect(find.text('Ara'), findsNothing);
  });

  testWidgets('klavye eylemi "ara"; onChanged / onSubmitted çağrılır', (
    tester,
  ) async {
    final changes = <String>[];
    final submits = <String>[];
    await tester.pumpWidget(
      testApp(NzSearchField(onChanged: changes.add, onSubmitted: submits.add)),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).textInputAction,
      TextInputAction.search,
    );
    await tester.enterText(find.byType(EditableText), 'ada');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    expect(changes, ['ada']);
    expect(submits, ['ada']);
  });

  testWidgets('temizle düğmesi yalnız doluyken; alanı boşaltır, geri çağırır', (
    tester,
  ) async {
    final changes = <String>[];
    var cleared = 0;
    await tester.pumpWidget(
      testApp(NzSearchField(onChanged: changes.add, onClear: () => cleared++)),
    );
    expect(find.byTooltip('Aramayı temizle'), findsNothing);
    await tester.enterText(find.byType(EditableText), 'ada');
    await tester.pump();
    final clear = find.byTooltip('Aramayı temizle');
    expect(clear, findsOneWidget);
    expect(
      tester.getSize(clear).shortestSide,
      greaterThanOrEqualTo(NizamioSpacing.space12),
    );
    await tester.tap(clear);
    await tester.pump();
    expect(find.text('ada'), findsNothing);
    expect(changes, ['ada', '']);
    expect(cleared, 1);
    expect(find.byTooltip('Aramayı temizle'), findsNothing);
  });

  testWidgets('dışarıdan denetleyici: dışarıdan değişiklik düğmeyi gösterir', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(testApp(NzSearchField(controller: controller)));
    controller.text = 'x';
    await tester.pump();
    expect(find.byTooltip('Aramayı temizle'), findsOneWidget);
    await tester.tap(find.byTooltip('Aramayı temizle'));
    expect(controller.text, isEmpty);
  });

  testWidgets('devre dışı: temizle düğmesi yok, yazılamaz', (tester) async {
    final controller = TextEditingController(text: 'x');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      testApp(NzSearchField(controller: controller, enabled: false)),
    );
    expect(find.byTooltip('Aramayı temizle'), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(testApp(NzSearchField(size: size)));
      expect(
        tester.getSize(find.byType(TextField)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
        reason: size.name,
      );
    }
  });

  testWidgets('anlamsal: etiket metin alanına bağlıdır', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzSearchField()));
    expect(tester.getSemantics(find.byType(EditableText)).label, 'Ara');
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, dolgu renkleri', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.backgroundMuted,
      NizamioColors.dark.backgroundMuted,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_search_field.png'),
      );
    },
  );
}
