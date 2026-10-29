import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_checkbox.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_form.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzCheckbox(
        label: 'İşaretli ${size.name}',
        value: true,
        onChanged: (_) {},
        size: size,
      ),
      NzCheckbox(
        label: 'İşaretsiz ${size.name} ve oldukça uzun bir etiket metni',
        description: 'Açıklama',
        value: false,
        onChanged: (_) {},
        size: size,
      ),
    ],
    NzCheckbox(
      label: 'Simgeli',
      value: false,
      onChanged: (_) {},
      trailing: const Icon(Icons.info_outline),
    ),
    const NzCheckbox(label: 'Devre dışı', value: true, onChanged: null),
    const NzCheckbox(
      label: 'Hatalı',
      value: false,
      onChanged: null,
      fieldError: ApiFieldError(
        field: 'terms',
        code: 'identity.invalid_email',
        message: 'sunucu',
      ),
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('dokunuş değeri tersler (denetimli) ve onChanged çağrılır', (
    tester,
  ) async {
    final values = <bool>[];
    var value = false;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, setState) => NzCheckbox(
            label: 'Kabul',
            value: value,
            onChanged: (v) {
              values.add(v);
              setState(() => value = v);
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Kabul'));
    await tester.pump();
    expect(values, [true]);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(values, [true, false]);
  });

  testWidgets('devre dışı: dokunuş çalışmaz', (tester) async {
    await tester.pumpWidget(
      testApp(const NzCheckbox(label: 'K', value: false, onChanged: null)),
    );
    await tester.tap(find.text('K'));
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
  });

  testWidgets('satır >= 48 yükseklik; etiket + açıklama gösterilir', (
    tester,
  ) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          NzCheckbox(
            label: 'K',
            description: 'Açıklama',
            value: false,
            onChanged: (_) {},
            size: size,
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(CheckboxListTile)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
        reason: size.name,
      );
      expect(find.text('Açıklama'), findsOneWidget);
    }
  });

  testWidgets('trailing yuvası çizilir', (tester) async {
    await tester.pumpWidget(
      testApp(
        NzCheckbox(
          label: 'K',
          value: false,
          onChanged: (_) {},
          trailing: const Icon(Icons.info_outline),
        ),
      ),
    );
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('labelLeading etiketin solunda; dokunuş satırı tersler', (
    tester,
  ) async {
    var v = false;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, set) => NzCheckbox(
            label: 'Kadir Özbek',
            value: v,
            onChanged: (x) => set(() => v = x),
            labelLeading: const Icon(Icons.person, key: ValueKey('lead')),
          ),
        ),
      ),
    );
    final lead = tester.getRect(find.byKey(const ValueKey('lead')));
    final label = tester.getRect(find.text('Kadir Özbek'));
    expect(lead.right, lessThanOrEqualTo(label.left));
    await tester.tap(find.byKey(const ValueKey('lead')));
    await tester.pump();
    expect(v, isTrue);
  });

  testWidgets('form: mustAccept işaretsizken submit engellenir, metin ARB', (
    tester,
  ) async {
    var checked = false;
    var submitted = 0;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, setState) => NzForm(
            onSubmit: () => submitted++,
            child: NzCheckbox(
              label: 'Kabul',
              name: 'terms',
              value: checked,
              validator: NzValidators.mustAccept,
              onChanged: (v) => setState(() => checked = v),
            ),
          ),
        ),
      ),
    );
    final form = NzForm.of(tester.element(find.byType(NzCheckbox)));
    expect(form.submit(), isFalse);
    await tester.pump();
    expect(find.text('Devam etmek için onaylamanız gerekir.'), findsOneWidget);
    expect(submitted, 0);
    await tester.tap(find.text('Kabul'));
    await tester.pump();
    expect(find.text('Devam etmek için onaylamanız gerekir.'), findsNothing);
    expect(form.submit(), isTrue);
    expect(submitted, 1);
  });

  testWidgets('sunucu alan hatası: gösterilir, değişince gizlenir', (
    tester,
  ) async {
    var checked = false;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, setState) => NzCheckbox(
            label: 'Kabul',
            value: checked,
            onChanged: (v) => setState(() => checked = v),
            fieldError: const ApiFieldError(
              field: 'terms',
              code: 'identity.invalid_full_name',
              message: 'SUNUCU',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
    expect(find.textContaining('SUNUCU'), findsNothing);
    await tester.tap(find.text('Kabul'));
    await tester.pump();
    expect(find.text('Ad soyad geçersiz.'), findsNothing);
  });

  testWidgets('anlamsal: etiket ve işaret durumu tek düğümde', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(NzCheckbox(label: 'Kabul', value: true, onChanged: (_) {})),
    );
    final node = tester.getSemantics(find.byType(CheckboxListTile));
    expect(node.label, contains('Kabul'));
    expect(
      node.getSemanticsData().flagsCollection.isChecked,
      CheckedState.isTrue,
    );
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, onay kutusu dolgusu (primary)', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.dark.primary,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_checkbox.png'),
      );
    },
  );
}
