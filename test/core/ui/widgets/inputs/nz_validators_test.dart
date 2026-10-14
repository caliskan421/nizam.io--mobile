import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_validators.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  group('requiredText', () {
    test('null, boş ve yalnız boşluk geçmez', () {
      for (final v in [null, '', '   ', '\n\t']) {
        expect(NzValidators.requiredText(v), NzValidationIssue.required);
      }
    });
    test('metin içeren geçer', () {
      expect(NzValidators.requiredText('a'), isNull);
      expect(NzValidators.requiredText(' a '), isNull);
    });
  });

  group('email', () {
    test('boş geçerli sayılır (zorunluluk ayrı kural)', () {
      expect(NzValidators.email(null), isNull);
      expect(NzValidators.email(''), isNull);
      expect(NzValidators.email('  '), isNull);
    });
    test('geçerli biçimler', () {
      expect(NzValidators.email('a@b.co'), isNull);
      expect(NzValidators.email(' ada@ornek.org '), isNull);
    });
    test('geçersiz biçimler', () {
      for (final v in ['a', 'a@', '@b.c', 'a@b', 'a b@c.d', 'a@@b.c']) {
        expect(NzValidators.email(v), NzValidationIssue.email, reason: v);
      }
    });
  });

  test('minLength: boş geçerli, kısa geçmez, sınır geçer', () {
    final v = NzValidators.minLength(3);
    expect(v(null), isNull);
    expect(v(''), isNull);
    expect(v('ab'), NzValidationIssue.tooShort);
    expect(v('abc'), isNull);
  });

  test('maxLength: sınır geçer, aşan geçmez', () {
    final v = NzValidators.maxLength(3);
    expect(v(null), isNull);
    expect(v('abc'), isNull);
    expect(v('abcd'), NzValidationIssue.tooLong);
  });

  test('matches: güncel değeri her çağrıda okur', () {
    var other = 'x';
    final v = NzValidators.matches(() => other);
    expect(v(''), isNull);
    expect(v('x'), isNull);
    expect(v('y'), NzValidationIssue.mismatch);
    other = 'y';
    expect(v('y'), isNull);
  });

  test('mustAccept yalnız true ile geçer', () {
    expect(NzValidators.mustAccept(true), isNull);
    expect(NzValidators.mustAccept(false), NzValidationIssue.mustAccept);
    expect(NzValidators.mustAccept(null), NzValidationIssue.mustAccept);
  });

  test('mustChoose null geçmez', () {
    expect(NzValidators.mustChoose<int>(null), NzValidationIssue.mustChoose);
    expect(NzValidators.mustChoose<int>(0), isNull);
  });

  test('all: ilk sorunu döndürür, sıra önemlidir', () {
    final v = NzValidators.all<String>([
      NzValidators.requiredText,
      NzValidators.email,
    ]);
    expect(v(''), NzValidationIssue.required);
    expect(v('x'), NzValidationIssue.email);
    expect(v('a@b.co'), isNull);
    expect(NzValidators.all<String>([])('x'), isNull);
  });

  testWidgets('her sorunun ARB metni var, yer tutucusuz ve benzersiz', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const Placeholder()));
    final l = AppLocalizations.of(tester.element(find.byType(Placeholder)));
    final texts = [for (final i in NzValidationIssue.values) i.text(l)];
    expect(texts.toSet().length, NzValidationIssue.values.length);
    for (final t in texts) {
      expect(t, isNotEmpty);
      expect(t.contains('{') || t.contains('}'), isFalse);
    }
    expect(NzValidationIssue.required.text(l), 'Bu alan zorunludur.');
  });
}
