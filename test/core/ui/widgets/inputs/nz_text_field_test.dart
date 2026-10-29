import 'dart:ui' show SemanticsValidationResult;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_text_field.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

const _serverError = ApiFieldError(
  field: 'x',
  code: 'identity.invalid_full_name',
  message: 'SUNUCU METNİ',
);

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzTextField(
        label: 'Etiket ${size.name}',
        hint: 'İpucu',
        helper: 'Yardım metni',
        size: size,
      ),
      cellGap,
    ],
    const NzTextField.email(label: 'E-posta', initialValue: 'ada@ornek.org'),
    cellGap,
    const NzTextField.multiline(label: 'Açıklama'),
    cellGap,
    const NzTextField.number(label: 'Sayı'),
    cellGap,
    const NzTextField(
      label: 'Simgeli',
      leading: Icon(Icons.person_outline),
      trailing: Icon(Icons.check),
    ),
    cellGap,
    const NzTextField(label: 'Hatalı', fieldError: _serverError),
    cellGap,
    const NzTextField(label: 'Devre dışı', enabled: false),
  ],
);

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText).first);

void main() {
  setUpFonts();

  testWidgets('etiket, ipucu ve yardım metni gösterilir', (tester) async {
    await tester.pumpWidget(
      testApp(const NzTextField(label: 'Ad', helper: 'Yardım')),
    );
    expect(find.text('Ad'), findsOneWidget);
    expect(find.text('Yardım'), findsOneWidget);
  });

  testWidgets('yazı onChanged / onSubmitted çağırır; controller ile çalışır', (
    tester,
  ) async {
    final changes = <String>[];
    final submits = <String>[];
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      testApp(
        NzTextField(
          label: 'Ad',
          controller: controller,
          onChanged: changes.add,
          onSubmitted: submits.add,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'ada');
    expect(changes, ['ada']);
    expect(controller.text, 'ada');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    expect(submits, ['ada']);
  });

  testWidgets('initialValue gösterilir', (tester) async {
    await tester.pumpWidget(
      testApp(const NzTextField(label: 'Ad', initialValue: 'Ada')),
    );
    expect(find.text('Ada'), findsOneWidget);
  });

  group('varyantlar', () {
    testWidgets('düz metin', (tester) async {
      await tester.pumpWidget(testApp(const NzTextField(label: 'Ad')));
      final e = _editable(tester);
      expect(e.keyboardType, TextInputType.text);
      expect(e.autofillHints, isNull);
      expect(e.textInputAction, TextInputAction.next);
    });

    testWidgets('autofillHints parametresi iletilir', (tester) async {
      await tester.pumpWidget(
        testApp(
          const NzTextField(label: 'Ad', autofillHints: [AutofillHints.name]),
        ),
      );
      expect(_editable(tester).autofillHints, [AutofillHints.name]);
    });

    testWidgets('email: e-posta klavyesi, e-posta ipucu, düzeltme kapalı', (
      tester,
    ) async {
      await tester.pumpWidget(testApp(const NzTextField.email(label: 'E')));
      final e = _editable(tester);
      expect(e.keyboardType, TextInputType.emailAddress);
      expect(e.autofillHints, [AutofillHints.email]);
      expect(e.autocorrect, isFalse);
      expect(e.enableSuggestions, isFalse);
      expect(e.textCapitalization, TextCapitalization.none);
    });

    testWidgets('multiline: 3–6 satır, klavye eylemi satır sonu', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(const NzTextField.multiline(label: 'Not')),
      );
      final e = _editable(tester);
      expect(e.minLines, 3);
      expect(e.maxLines, 6);
      expect(e.keyboardType, TextInputType.multiline);
      expect(e.textInputAction, TextInputAction.newline);
    });

    testWidgets('number: sayısal klavye, rakam dışı elenir', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        testApp(NzTextField.number(label: 'Sayı', onChanged: values.add)),
      );
      expect(_editable(tester).keyboardType, TextInputType.number);
      await tester.enterText(find.byType(EditableText), '1a2b3');
      expect(values.last, '123');
    });
  });

  group('boyut', () {
    testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
      for (final size in NzSize.values) {
        await tester.pumpWidget(testApp(NzTextField(label: 'Ad', size: size)));
        expect(
          tester.getSize(find.byType(TextFormField)).height,
          greaterThanOrEqualTo(NizamioSpacing.space12),
          reason: size.name,
        );
      }
    });

    testWidgets('yazı rolü boyuta göre seçilir', (tester) async {
      final sizes = <NzSize, double>{};
      for (final size in NzSize.values) {
        await tester.pumpWidget(testApp(NzTextField(label: 'Ad', size: size)));
        sizes[size] = _editable(tester).style.fontSize!;
      }
      expect(sizes[NzSize.sm]!, lessThan(sizes[NzSize.md]!));
      expect(sizes[NzSize.md]!, lessThan(sizes[NzSize.lg]!));
    });
  });

  group('doğrulama', () {
    testWidgets('validator metni ARB\'den gelir', (tester) async {
      final key = GlobalKey<FormState>();
      await tester.pumpWidget(
        testApp(
          Form(
            key: key,
            child: NzTextField(
              label: 'E',
              validator: NzValidators.all([
                NzValidators.requiredText,
                NzValidators.email,
              ]),
            ),
          ),
        ),
      );
      expect(key.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Bu alan zorunludur.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'abc');
      expect(key.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Geçerli bir e-posta adresi girin.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'a@b.co');
      expect(key.currentState!.validate(), isTrue);
    });
  });

  group('sunucu alan hatası', () {
    testWidgets('fieldError code\'dan ARB metniyle gösterilir', (tester) async {
      await tester.pumpWidget(
        testApp(const NzTextField(label: 'Ad', fieldError: _serverError)),
      );
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
      expect(find.textContaining('SUNUCU'), findsNothing);
    });

    testWidgets('kullanıcı düzenleyince gizlenir', (tester) async {
      await tester.pumpWidget(
        testApp(const NzTextField(label: 'Ad', fieldError: _serverError)),
      );
      await tester.enterText(find.byType(EditableText), 'x');
      await tester.pump();
      expect(find.text('Ad soyad geçersiz.'), findsNothing);
    });

    testWidgets('yeni hata nesnesi yeniden gösterilir', (tester) async {
      Widget build(ApiFieldError e) =>
          testApp(NzTextField(label: 'Ad', fieldError: e));
      await tester.pumpWidget(build(_serverError));
      await tester.enterText(find.byType(EditableText), 'x');
      await tester.pump();
      expect(find.text('Ad soyad geçersiz.'), findsNothing);
      await tester.pumpWidget(
        build(
          const ApiFieldError(
            field: 'x',
            code: 'identity.invalid_full_name',
            message: 'yeni',
          ),
        ),
      );
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
    });
  });

  testWidgets('invalid: metinsiz hata kenarlığı (enabled + focused)', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(const NzTextField(label: 'E', invalid: true)),
    );
    final theme = Theme.of(tester.element(find.byType(TextField)));
    final d = tester.widget<TextField>(find.byType(TextField)).decoration!;
    expect(d.enabledBorder, theme.inputDecorationTheme.errorBorder);
    expect(d.focusedBorder, theme.inputDecorationTheme.focusedErrorBorder);
    expect(d.errorText, isNull);
    await tester.pumpWidget(testApp(const NzTextField(label: 'E')));
    final plain = tester.widget<TextField>(find.byType(TextField)).decoration!;
    expect(plain.enabledBorder, isNot(theme.inputDecorationTheme.errorBorder));
  });

  testWidgets('devre dışı: yazılamaz', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(
      testApp(NzTextField(label: 'Ad', enabled: false, onChanged: changes.add)),
    );
    await tester.tap(find.byType(TextFormField), warnIfMissed: false);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(changes, isEmpty);
  });

  testWidgets('leading ve trailing yuvaları çizilir', (tester) async {
    await tester.pumpWidget(
      testApp(
        const NzTextField(
          label: 'Ad',
          leading: Icon(Icons.person_outline),
          trailing: Icon(Icons.check),
        ),
      ),
    );
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('anlamsal: etiket metin alanına bağlıdır', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzTextField(label: 'Ad')));
    expect(
      tester.getSemantics(find.byType(EditableText)),
      matchesSemantics(
        label: 'Ad',
        isTextField: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
        validationResult: SemanticsValidationResult.valid,
      ),
    );
    handle.dispose();
  });

  testWidgets('odak sırası: sırayla ilerler', (tester) async {
    final a = FocusNode();
    final b = FocusNode();
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    await tester.pumpWidget(
      testApp(
        Column(
          children: [
            NzTextField(label: 'A', focusNode: a),
            NzTextField(label: 'B', focusNode: b),
          ],
        ),
      ),
    );
    a.requestFocus();
    await tester.pump();
    expect(a.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(b.hasFocus, isTrue);
  });

  testWidgets('piksel: tabaka 1024 geniş, dolgu ve kenarlık renkleri', (
    tester,
  ) async {
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
        matchesGoldenFile('goldens/nz_text_field.png'),
      );
    },
  );

  testWidgets('labelAbove: etiket alanın üstünde, kutuda yüzen etiket yok', (
    t,
  ) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      testApp(
        const NzTextField.email(
          label: 'E-posta',
          labelAbove: true,
          hint: 'ad@alan.com',
        ),
      ),
    );
    expect(find.text('E-posta'), findsOneWidget);
    final field = t.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.labelText, isNull);
    expect(
      t.getBottomLeft(find.text('E-posta')).dy,
      lessThanOrEqualTo(t.getTopLeft(find.byType(TextField)).dy),
    );
    expect(find.bySemanticsLabel(RegExp('E-posta')), findsOneWidget);
    handle.dispose();
  });
}
