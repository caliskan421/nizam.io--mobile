import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_banner.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_checkbox.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_form.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_password_field.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_select.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_text_field.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

ApiFieldError _fe(String field, String code) =>
    ApiFieldError(field: field, code: code, message: 'SUNUCU METNİ');

ApiError _error(List<ApiFieldError> fields) =>
    ApiError('identity.input_invalid', fields: fields, status: 422);

Widget _form({
  ApiError? error,
  VoidCallback? onSubmit,
  bool withEmail = true,
}) => NzForm(
  serverError: error,
  onSubmit: onSubmit,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (withEmail)
        NzTextField.email(
          label: 'E-posta',
          name: 'email',
          validator: NzValidators.all([
            NzValidators.requiredText,
            NzValidators.email,
          ]),
        ),
      const NzTextField(label: 'Ad soyad', name: 'full_name'),
    ],
  ),
);

/// İlk karede kayıtlar oturur, ikinci karede form düzeyi hata çizilir.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    NzForm(
      serverError: _error([
        _fe('email', 'identity.invalid_email'),
        _fe('olmayan_alan', 'identity.weak_password'),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const NzTextField.email(label: 'E-posta', name: 'email'),
          cellGap,
          const NzPasswordField.newPassword(label: 'Parola', name: 'password'),
          cellGap,
          NzCheckbox(
            label: 'Koşulları kabul ediyorum',
            value: false,
            onChanged: (_) {},
          ),
          cellGap,
          NzSelect<String>(
            label: 'Rol',
            items: const [NzSelectItem(value: 'a', label: 'Seçenek A')],
            value: null,
            onChanged: (_) {},
          ),
        ],
      ),
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('submit: geçersizse onSubmit çağrılmaz, hata gösterilir', (
    tester,
  ) async {
    var n = 0;
    await tester.pumpWidget(testApp(_form(onSubmit: () => n++)));
    final form = NzForm.of(tester.element(find.byType(NzTextField).first));
    expect(form.submit(), isFalse);
    await tester.pump();
    expect(n, 0);
    expect(find.text('Bu alan zorunludur.'), findsOneWidget);
  });

  testWidgets('submit: geçerliyse onSubmit bir kez çağrılır', (tester) async {
    var n = 0;
    await tester.pumpWidget(testApp(_form(onSubmit: () => n++)));
    await tester.enterText(find.byType(EditableText).first, 'a@b.co');
    final form = NzForm.of(tester.element(find.byType(NzTextField).first));
    expect(form.submit(), isTrue);
    expect(n, 1);
  });

  testWidgets('reset alanları ilk değere döndürür', (tester) async {
    await tester.pumpWidget(testApp(_form()));
    await tester.enterText(find.byType(EditableText).first, 'x');
    NzForm.of(tester.element(find.byType(NzTextField).first)).reset();
    await tester.pump();
    expect(find.text('x'), findsNothing);
  });

  testWidgets('maybeOf form dışında null', (tester) async {
    await tester.pumpWidget(testApp(const NzTextField(label: 'A')));
    expect(NzForm.maybeOf(tester.element(find.byType(NzTextField))), isNull);
  });

  group('sunucu fields[] eşlemesi', () {
    testWidgets('field adıyla alana eşlenir; metin code\'dan ARB ile', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([
              _fe('email', 'identity.invalid_email'),
              _fe('full_name', 'identity.invalid_full_name'),
            ]),
          ),
        ),
      );
      await _settle(tester);
      expect(
        find.descendant(
          of: find.byType(NzTextField).first,
          matching: find.text('E-posta adresi geçersiz.'),
        ),
        findsOneWidget,
        reason: 'metin sunucu hata kodundan (ARB), message\'dan değil',
      );
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
      expect(find.byType(NzBanner), findsNothing);
      expect(find.textContaining('SUNUCU'), findsNothing);
    });

    testWidgets('eşleşmeyen alan hatası form düzeyinde gösterilir (yutulmaz)', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([
              _fe('full_name', 'identity.invalid_full_name'),
              _fe('olmayan_alan', 'identity.weak_password'),
            ]),
          ),
        ),
      );
      await _settle(tester);
      expect(find.byType(NzBanner), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NzBanner),
          matching: find.text('Parola yeterince güçlü değil.'),
        ),
        findsOneWidget,
        reason: 'form düzeyi metin weak_password kodundan',
      );
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
    });

    testWidgets('ilk karede eşleşen hata geçici form düzeyi hata olmaz', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([_fe('full_name', 'identity.invalid_full_name')]),
          ),
        ),
      );
      expect(find.byType(NzBanner), findsNothing);
      await _settle(tester);
      expect(find.byType(NzBanner), findsNothing);
    });

    testWidgets('hiç alan yoksa bütün alan hataları form düzeyindedir', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          NzForm(
            serverError: _error([
              _fe('a', 'identity.invalid_email'),
              _fe('b', 'identity.invalid_full_name'),
            ]),
            child: const Text('boş form'),
          ),
        ),
      );
      await _settle(tester);
      expect(find.byType(NzBanner), findsNWidgets(2));
    });

    testWidgets('alan kaldırılınca hatası form düzeyine düşer', (tester) async {
      final error = _error([_fe('email', 'identity.invalid_email')]);
      await tester.pumpWidget(testApp(_form(error: error)));
      await _settle(tester);
      expect(find.byType(NzBanner), findsNothing);
      await tester.pumpWidget(testApp(_form(error: error, withEmail: false)));
      await _settle(tester);
      expect(find.byType(NzBanner), findsOneWidget);
    });

    testWidgets('alan düzenlenince yalnız o alanın hatası gizlenir', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([
              _fe('email', 'identity.invalid_email'),
              _fe('full_name', 'identity.invalid_full_name'),
            ]),
          ),
        ),
      );
      await _settle(tester);
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText).last, 'Ada');
      await tester.pump();
      expect(find.text('Ad soyad geçersiz.'), findsNothing);
    });

    testWidgets('yeni gönderimin hatası yeniden gösterilir', (tester) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([_fe('full_name', 'identity.invalid_full_name')]),
          ),
        ),
      );
      await _settle(tester);
      await tester.enterText(find.byType(EditableText).last, 'Ada');
      await tester.pump();
      expect(find.text('Ad soyad geçersiz.'), findsNothing);
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([_fe('full_name', 'identity.invalid_full_name')]),
          ),
        ),
      );
      await _settle(tester);
      expect(find.text('Ad soyad geçersiz.'), findsOneWidget);
    });

    testWidgets('sunucu hatası temizlenince alan hatası kalkar', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          _form(
            error: _error([_fe('full_name', 'identity.invalid_full_name')]),
          ),
        ),
      );
      await _settle(tester);
      await tester.pumpWidget(testApp(_form()));
      await _settle(tester);
      expect(find.text('Ad soyad geçersiz.'), findsNothing);
    });
  });

  testWidgets('odak sırası okuma sırasıdır', (tester) async {
    await tester.pumpWidget(testApp(_form()));
    await tester.tap(find.byType(EditableText).first);
    await tester.pump();
    final first = FocusManager.instance.primaryFocus;
    FocusScope.of(tester.element(find.byType(NzForm))).nextFocus();
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, isNot(same(first)));
    final editables = tester.widgetList<EditableText>(
      find.byType(EditableText),
    );
    expect(editables.last.focusNode.hasFocus, isTrue);
  });

  testWidgets('otomatik doldurma grubu içinde çalışır', (tester) async {
    await tester.pumpWidget(testApp(_form()));
    expect(find.byType(AutofillGroup), findsOneWidget);
  });

  testWidgets('piksel: tabaka 1024 geniş, form düzeyi hata kenarlığı', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await tester.pump();
    await expectSheetPixels(tester, [
      NizamioColors.light.surface,
      NizamioColors.light.danger,
      NizamioColors.dark.danger,
    ]);
  });

  goldenTestWidgets('golden: form × açık/koyu × compact/expanded × 1.0/2.0', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await tester.pump();
    await expectLater(
      find.byKey(sheetKey),
      matchesGoldenFile('goldens/nz_form.png'),
    );
  });
}
