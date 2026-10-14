import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_field_errors.dart';

import '../feedback/feedback_test_support.dart';

const _email = ApiFieldError(
  field: 'email',
  code: 'identity.invalid_email',
  message: 'SUNUCU METNİ',
);
const _name = ApiFieldError(
  field: 'full_name',
  code: 'identity.invalid_full_name',
  message: 'sunucu',
);
const _ghost = ApiFieldError(
  field: 'ghost',
  code: 'identity.weak_password',
  message: 'sunucu',
);

void main() {
  setUpFonts();

  group('resolve', () {
    test('hata yok → boş', () {
      expect(
        NzFieldErrors.resolve(null, const {'email'}),
        same(NzFieldErrors.empty),
      );
      expect(
        NzFieldErrors.resolve(ApiError('platform.internal'), const {'email'}),
        same(NzFieldErrors.empty),
      );
    });

    test('field adıyla eşler; kayıtsız alan unmatched olur (yutulmaz)', () {
      final r = NzFieldErrors.resolve(
        ApiError(
          'identity.input_invalid',
          fields: const [_email, _ghost, _name],
        ),
        const {'email', 'full_name'},
      );
      expect(r.byField.keys, unorderedEquals(['email', 'full_name']));
      expect(r.byField['email'], [_email]);
      expect(r.unmatched, [_ghost]);
    });

    test('aynı alana birden çok hata sırayla toplanır', () {
      final second = ApiFieldError(
        field: 'email',
        code: _name.code,
        message: 'x',
      );
      final r = NzFieldErrors.resolve(
        ApiError('identity.input_invalid', fields: [_email, second]),
        const {'email'},
      );
      expect(r.byField['email'], [_email, second]);
      expect(r.unmatched, isEmpty);
    });

    test('hiç kayıtlı alan yoksa hepsi unmatched', () {
      final r = NzFieldErrors.resolve(
        ApiError('identity.input_invalid', fields: const [_email, _name]),
        const {},
      );
      expect(r.byField, isEmpty);
      expect(r.unmatched, [_email, _name]);
    });

    test('sonuç değiştirilemez', () {
      final r = NzFieldErrors.resolve(
        ApiError('identity.input_invalid', fields: const [_email, _ghost]),
        const {'email'},
      );
      expect(() => r.unmatched.add(_name), throwsUnsupportedError);
      expect(() => r.byField['email']!.add(_name), throwsUnsupportedError);
    });
  });

  testWidgets('metin code\'dan ARB ile gelir; sunucu message kullanılmaz', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const Text('x')));
    final l = AppLocalizations.of(tester.element(find.byType(Text)));
    expect(NzFieldErrors.text(l, _email), l.errIdentityInvalidEmail);
    expect(NzFieldErrors.text(l, _email), isNot(contains('SUNUCU')));
    const unknown = ApiFieldError(
      field: 'x',
      code: 'yeni.bilinmeyen_kod',
      message: 'SUNUCU',
    );
    expect(NzFieldErrors.text(l, unknown), 'Değer geçersiz.');
    expect(
      NzFieldErrors.textAll(l, [_email, unknown]),
      '${l.errIdentityInvalidEmail}\nDeğer geçersiz.',
    );
  });
}
