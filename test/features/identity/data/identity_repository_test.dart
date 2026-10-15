// identity data katmanı: üretilmiş DTO → domain varlığı eşlemesi (sınır kuralı A1).
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/identity/data/identity_repository.dart';
import 'package:nizamio/features/identity/domain/current_account.dart';

/// Tek yanıtlı sahte bağdaştırıcı.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200]);

  final String body;
  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

IdentityRepository _repo(String body, {int status = 200}) => IdentityRepository(
  Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = _Adapter(body, status),
);

void main() {
  test('me → CurrentAccount', () async {
    final me = await _repo('{"account_id":"acc-1","email":"a@b.c"}').me();
    expect(me, const CurrentAccount(accountId: 'acc-1', email: 'a@b.c'));
  });

  test('login (mobil) → LoginGrant; toString alan içermez', () async {
    final g = await _repo(
      '{"account_id":"acc-1","expires_at":100,"force_password_change":true,'
      '"access_token":"AT-gizli","refresh_token":"RT-gizli","refresh_expires_at":200}',
    ).login(email: 'a@b.c', password: 'x');
    expect(g.accountId, 'acc-1');
    expect(g.accessToken, 'AT-gizli');
    expect(g.accessExpiresAt, 100);
    expect(g.refreshToken, 'RT-gizli');
    expect(g.refreshExpiresAt, 200);
    expect(g.forcePasswordChange, isTrue);
    for (final secret in ['acc-1', 'AT-gizli', 'RT-gizli', '100', '200']) {
      expect(g.toString(), isNot(contains(secret)));
    }
  });

  test(
    'login (web yanıtı) → mobil belirteç alanları boş, web token taşınmaz',
    () async {
      final g = await _repo(
        '{"account_id":"acc-1","expires_at":100,"force_password_change":false,'
        '"token":"WEB-gizli"}',
      ).login(email: 'a@b.c', password: 'x');
      expect(g.accessToken, isNull);
      expect(g.refreshToken, isNull);
      expect(g.refreshExpiresAt, isNull);
      expect(g.toString(), isNot(contains('gizli')));
    },
  );

  group('changePassword', () {
    test(
      'POST /v1/auth/password: gövde alanları ve revoked_sessions',
      () async {
        final adapter = _Recording('{"revoked_sessions":3}');
        final repo = IdentityRepository(
          Dio(BaseOptions(baseUrl: 'https://api.test'))
            ..httpClientAdapter = adapter,
        );
        final revoked = await repo.changePassword(
          currentPassword: 'eski-p',
          newPassword: 'yeni-p',
        );
        expect(revoked, 3);
        expect(adapter.path, '/v1/auth/password');
        expect(adapter.body, {
          'current_password': 'eski-p',
          'new_password': 'yeni-p',
        });
      },
    );

    test('belirteç içermeyen yanıt; sunucu hatası ApiError olur', () async {
      await expectLater(
        _repo(
          '{"code":"identity.credentials_invalid","message":"x","request_id":"r"}',
          status: 401,
        ).changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'identity.credentials_invalid',
          ),
        ),
      );
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      await expectLater(
        _repo('{"x":1}').changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.invalidResponse,
          ),
        ),
      );
    });
  });
}

/// İsteğin yolunu ve gövdesini kaydeden sahte bağdaştırıcı.
class _Recording implements HttpClientAdapter {
  _Recording(this.response);

  final String response;
  String? path;
  Object? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    path = options.uri.path;
    final bytes = await requestStream!.expand((c) => c).toList();
    body = jsonDecode(utf8.decode(bytes));
    return ResponseBody.fromString(
      response,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
