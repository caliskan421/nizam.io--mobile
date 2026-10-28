import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_form.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_select.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

const _items = [
  NzSelectItem(value: 'a', label: 'Seçenek A'),
  NzSelectItem(value: 'b', label: 'Seçenek B'),
  NzSelectItem(value: 'c', label: 'Seçenek C', enabled: false),
];

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzSelect<String>(
        label: 'Rol ${size.name}',
        hint: 'Seçin',
        items: _items,
        value: null,
        onChanged: (_) {},
        size: size,
      ),
      cellGap,
      NzSelect<String>(
        label: 'Seçili ${size.name}',
        items: _items,
        value: 'a',
        onChanged: (_) {},
        helper: 'Yardım metni',
        size: size,
      ),
      cellGap,
    ],
    NzSelect<String>(
      label: 'Simgeli',
      items: _items,
      value: 'b',
      onChanged: (_) {},
      leading: const Icon(Icons.person_outline),
    ),
    cellGap,
    const NzSelect<String>(
      label: 'Devre dışı',
      items: _items,
      value: 'a',
      onChanged: null,
    ),
    cellGap,
    NzSelect<String>(
      label: 'Hatalı',
      items: _items,
      value: null,
      onChanged: (_) {},
      fieldError: const ApiFieldError(
        field: 'role',
        code: 'identity.invalid_full_name',
        message: 'sunucu',
      ),
    ),
  ],
);

Widget _stateful({
  NzValidator<String>? validator,
  String? name,
  ValueChanged<String?>? onChanged,
}) {
  String? value;
  return StatefulBuilder(
    builder: (context, setState) => NzSelect<String>(
      label: 'Rol',
      hint: 'Seçin',
      items: _items,
      value: value,
      name: name,
      validator: validator,
      onChanged: (v) {
        onChanged?.call(v);
        setState(() => value = v);
      },
    ),
  );
}

void main() {
  setUpFonts();

  testWidgets('etiket ve ipucu gösterilir; seçim yapılınca değer görünür', (
    tester,
  ) async {
    final changes = <String?>[];
    await tester.pumpWidget(testApp(_stateful(onChanged: changes.add)));
    expect(find.text('Rol'), findsOneWidget);
    expect(find.text('Seçin'), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seçenek B').last);
    await tester.pumpAndSettle();
    expect(changes, ['b']);
    expect(find.text('Seçenek B'), findsOneWidget);
    expect(find.text('Seçin'), findsNothing);
  });

  testWidgets('devre dışı seçenek seçilemez', (tester) async {
    final changes = <String?>[];
    await tester.pumpWidget(testApp(_stateful(onChanged: changes.add)));
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seçenek C').last, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
  });

  testWidgets('onChanged null → devre dışı, menü açılmaz', (tester) async {
    await tester.pumpWidget(
      testApp(
        const NzSelect<String>(
          label: 'Rol',
          items: _items,
          value: 'a',
          onChanged: null,
        ),
      ),
    );
    await tester.tap(find.byType(DropdownButton<String>), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Seçenek B'), findsNothing);
  });

  testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          NzSelect<String>(
            label: 'Rol',
            items: _items,
            value: null,
            onChanged: (_) {},
            size: size,
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(InputDecorator)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
        reason: size.name,
      );
    }
  });

  testWidgets(
    'form: mustChoose seçim yokken submit engellenir, seçince geçer',
    (tester) async {
      var submitted = 0;
      await tester.pumpWidget(
        testApp(
          NzForm(
            onSubmit: () => submitted++,
            child: _stateful(validator: NzValidators.mustChoose),
          ),
        ),
      );
      final form = NzForm.of(tester.element(find.byType(NzSelect<String>)));
      expect(form.submit(), isFalse);
      await tester.pump();
      expect(find.text('Bir seçim yapın.'), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seçenek A').last);
      await tester.pumpAndSettle();
      expect(find.text('Bir seçim yapın.'), findsNothing);
      expect(form.submit(), isTrue);
      expect(submitted, 1);
    },
  );

  testWidgets('sunucu alan hatası: name ile eşlenir, seçince gizlenir', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        NzForm(
          serverError: ApiError(
            'identity.input_invalid',
            fields: const [
              ApiFieldError(
                field: 'role',
                code: 'identity.invalid_full_name',
                message: 'SUNUCU',
              ),
            ],
          ),
          child: _stateful(name: 'role'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
    expect(find.textContaining('SUNUCU'), findsNothing);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seçenek A').last);
    await tester.pumpAndSettle();
    expect(find.text('Ad soyad geçersiz.'), findsNothing);
  });

  testWidgets('anlamsal: etiket ve seçili değer tek düğümde', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        NzSelect<String>(
          label: 'Rol',
          items: _items,
          value: 'a',
          onChanged: (_) {},
        ),
      ),
    );
    final node = tester.getSemantics(find.byType(InputDecorator));
    expect(node.label, contains('Rol'));
    expect(node.label, contains('Seçenek A'));
    handle.dispose();
  });

  testWidgets('odak düğmeye gelince çerçeve odak durumuna geçer', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(_stateful()));
    final decorator = find.byType(InputDecorator);
    expect(tester.widget<InputDecorator>(decorator).isFocused, isFalse);
    FocusScope.of(tester.element(decorator)).nextFocus();
    await tester.pump();
    expect(tester.widget<InputDecorator>(decorator).isFocused, isTrue);
  });

  testWidgets('piksel: tabaka 1024 geniş, dolgu renkleri', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.surface,
      NizamioColors.dark.surface,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_select.png'),
      );
    },
  );
}
