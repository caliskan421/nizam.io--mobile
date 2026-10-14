// errorText: bilinen kod → ARB metni; bilinmeyen kod (yeni backend etiketi) → genel metin.
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('tr'));

  test('bilinen sunucu kodu → kendi ARB metni', () {
    expect(
      errorText(l, ApiError('identity.account_exists')),
      l.errIdentityAccountExists,
    );
    expect(
      errorText(l, ApiError('identity.account_exists')),
      isNot(l.errPlatformInternal),
    );
  });

  test('bilinen istemci kodu → kendi ARB metni', () {
    expect(
      errorText(l, ApiError(ClientErrorCode.serverNotVerified)),
      l.errClientServerNotVerified,
    );
  });

  test('bilinmeyen kod → platform.internal genel metni', () {
    final e = ApiError('yeni.etiket_kodu');
    expect(e.isKnown, isFalse);
    expect(errorText(l, e), l.errPlatformInternal);
    expect(errorText(l, ApiError('')), l.errPlatformInternal);
  });

  test('sunucu iletisi (requestId, alanlar) metni etkilemez', () {
    expect(
      errorText(l, ApiError('yeni.kod', requestId: 'r-1', status: 500)),
      l.errPlatformInternal,
    );
  });
}
