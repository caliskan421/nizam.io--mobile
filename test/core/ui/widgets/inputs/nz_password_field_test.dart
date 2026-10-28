import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_form.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_password_field.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

const _secret = 'Gizli-Parola-12345';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzPasswordField(label: 'Parola ${size.name}', size: size),
      cellGap,
    ],
    const NzPasswordField.newPassword(label: 'Yeni parola'),
    cellGap,
    const NzPasswordField(
      label: 'Hatalı',
      fieldError: ApiFieldError(
        field: 'p',
        code: 'identity.weak_password',
        message: 'sunucu',
      ),
    ),
    cellGap,
    const NzPasswordField(label: 'Devre dışı', enabled: false),
  ],
);

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText).first);

void main() {
  setUpFonts();

  testWidgets('varsayılan gizli; düğme göster/gizle yapar', (tester) async {
    await tester.pumpWidget(testApp(const NzPasswordField(label: 'Parola')));
    expect(_editable(tester).obscureText, isTrue);
    expect(find.byTooltip('Parolayı göster'), findsOneWidget);
    await tester.tap(find.byTooltip('Parolayı göster'));
    await tester.pump();
    expect(_editable(tester).obscureText, isFalse);
    expect(find.byTooltip('Parolayı gizle'), findsOneWidget);
    await tester.tap(find.byTooltip('Parolayı gizle'));
    await tester.pump();
    expect(_editable(tester).obscureText, isTrue);
  });

  testWidgets('göster/gizle düğmesi >= 48 dokunma alanı', (tester) async {
    await tester.pumpWidget(testApp(const NzPasswordField(label: 'Parola')));
    final size = tester.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(NizamioSpacing.space12));
    expect(size.height, greaterThanOrEqualTo(NizamioSpacing.space12));
  });

  testWidgets('devre dışıyken düğme çalışmaz', (tester) async {
    await tester.pumpWidget(
      testApp(const NzPasswordField(label: 'Parola', enabled: false)),
    );
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
  });

  group('otomatik doldurma ve klavye', () {
    testWidgets('mevcut parola: password ipucu', (tester) async {
      await tester.pumpWidget(testApp(const NzPasswordField(label: 'P')));
      final e = _editable(tester);
      expect(e.autofillHints, [AutofillHints.password]);
      expect(e.textInputAction, TextInputAction.done);
    });

    testWidgets('yeni parola: newPassword ipucu', (tester) async {
      await tester.pumpWidget(
        testApp(const NzPasswordField.newPassword(label: 'P')),
      );
      final e = _editable(tester);
      expect(e.autofillHints, [AutofillHints.newPassword]);
      expect(e.textInputAction, TextInputAction.next);
    });

    testWidgets('öneri ve otomatik düzeltme kapalı', (tester) async {
      await tester.pumpWidget(testApp(const NzPasswordField(label: 'P')));
      final e = _editable(tester);
      expect(e.autocorrect, isFalse);
      expect(e.enableSuggestions, isFalse);
    });

    testWidgets('görünürken klavye visiblePassword', (tester) async {
      await tester.pumpWidget(testApp(const NzPasswordField(label: 'P')));
      expect(_editable(tester).keyboardType, TextInputType.text);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(_editable(tester).keyboardType, TextInputType.visiblePassword);
    });
  });

  group('değer sızmaz', () {
    testWidgets('widget, state ve denetleyici toString değeri içermez', (
      tester,
    ) async {
      final controller = NzPasswordController(text: _secret);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        testApp(NzPasswordField(label: 'P', controller: controller)),
      );
      final widget = tester.widget<NzPasswordField>(
        find.byType(NzPasswordField),
      );
      final state = tester.state(find.byType(NzPasswordField));
      for (final text in [
        widget.toString(),
        widget.toStringShort(),
        state.toString(),
        controller.toString(),
      ]) {
        expect(text, isNot(contains(_secret)));
      }
      expect(controller.text, _secret);
    });

    testWidgets('widget ağacı dökümü değeri içermez', (tester) async {
      final controller = NzPasswordController(text: _secret);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        testApp(NzPasswordField(label: 'P', controller: controller)),
      );
      final dump = tester.binding.rootElement!.toStringDeep();
      expect(dump, isNot(contains(_secret)));
      final renderDump = tester.binding.renderViews.first.toStringDeep();
      expect(renderDump, isNot(contains(_secret)));
    });

    testWidgets('anlamsal değer (gizliyken) parolayı içermez', (tester) async {
      final handle = tester.ensureSemantics();
      final controller = NzPasswordController(text: _secret);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        testApp(NzPasswordField(label: 'Parola', controller: controller)),
      );
      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.value, isNot(contains(_secret)));
      expect(node.label, isNot(contains(_secret)));
      expect(node.flagsCollection.isObscured, isTrue);
      expect(node.getSemanticsData().toString(), isNot(contains(_secret)));
      handle.dispose();
    });

    testWidgets('onChanged yazılan değeri iletir; log/hata yüzeyi yok', (
      tester,
    ) async {
      final values = <String>[];
      await tester.pumpWidget(
        testApp(NzPasswordField(label: 'P', onChanged: values.add)),
      );
      await tester.enterText(find.byType(EditableText), _secret);
      expect(values, [_secret]);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('doğrulayıcı ve sunucu alan hatası (form içinde, name ile)', (
    tester,
  ) async {
    Widget build(ApiError? error) => testApp(
      NzForm(
        serverError: error,
        child: const NzPasswordField.newPassword(
          label: 'Parola',
          name: 'password',
          validator: NzValidators.requiredText,
        ),
      ),
    );
    await tester.pumpWidget(build(null));
    expect(
      NzForm.of(tester.element(find.byType(NzPasswordField))).submit(),
      isFalse,
    );
    await tester.pump();
    expect(find.text('Bu alan zorunludur.'), findsOneWidget);
    await tester.pumpWidget(
      build(
        ApiError(
          'identity.input_invalid',
          fields: [
            const ApiFieldError(
              field: 'password',
              code: 'identity.weak_password',
              message: 'SUNUCU',
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Parola yeterince güçlü değil.'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'x');
    await tester.pump();
    expect(find.text('Parola yeterince güçlü değil.'), findsNothing);
  });

  testWidgets('onSubmitted çağrılır', (tester) async {
    final submits = <String>[];
    await tester.pumpWidget(
      testApp(NzPasswordField(label: 'P', onSubmitted: submits.add)),
    );
    await tester.enterText(find.byType(EditableText), 'abc');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submits, ['abc']);
  });

  testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(testApp(NzPasswordField(label: 'P', size: size)));
      expect(
        tester.getSize(find.byType(TextFormField)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
      );
    }
  });

  testWidgets('piksel: tabaka 1024 geniş, dolgu ve hata renkleri', (
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
        matchesGoldenFile('goldens/nz_password_field.png'),
      );
    },
  );

  testWidgets('labelAbove: etiket alanın üstünde, kutuda yüzen etiket yok', (
    t,
  ) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      testApp(
        const NzPasswordField(
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
