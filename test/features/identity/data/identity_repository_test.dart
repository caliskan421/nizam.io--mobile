// identity data katmanı: üretilmiş DTO → domain varlığı eşlemesi (sınır kuralı A1).
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/identity/data/identity_repository.dart';
import 'package:nizamio/features/identity/domain/current_account.dart';
import 'package:nizamio/features/identity/domain/download_ticket.dart';

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
    final me = await _repo(
      '{"account_id":"acc-1","email":"a@b.c","full_name":"Ayşe Yılmaz",'
      '"company_admin":true}',
    ).me();
    expect(
      me,
      const CurrentAccount(
        accountId: 'acc-1',
        email: 'a@b.c',
        fullName: 'Ayşe Yılmaz',
        companyAdmin: true,
      ),
    );
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

  group('issueDownloadTicket', () {
    const ticketBody =
        '{"ticket":"TKT-gizli","url":"/v1/downloads/TKT-gizli",'
        '"expires_at":"2026-10-29T10:00:00Z"}';

    test('GET hedefi: gövdede method/path, body yok', () async {
      final adapter = _Recording(ticketBody);
      final repo = IdentityRepository(
        Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = adapter,
      );
      final t = await repo.issueDownloadTicket('/v1/files/f1/download');
      expect(adapter.path, '/v1/download-tickets');
      expect(adapter.body, {'method': 'GET', 'path': '/v1/files/f1/download'});
      expect(t.ticket, 'TKT-gizli');
      expect(t.path, '/v1/downloads/TKT-gizli');
      expect(t.expiresAt, DateTime.utc(2026, 10, 29, 10));
      expect(t.toString(), isNot(contains('TKT')));
    });

    test('iş yükü PDF: POST hedefi, gövde üretilmiş DTO JSON\'u', () async {
      final adapter = _Recording(ticketBody);
      final repo = IdentityRepository(
        Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = adapter,
      );
      await repo.issueWorkloadPdfTicket(memberIds: ['a1']);
      expect(adapter.body, {
        'method': 'POST',
        'path': '/v1/reports/workload',
        'body': {
          'member_ids': ['a1'],
        },
      });
    });

    test('hata → ApiError', () async {
      await expectLater(
        _repo(
          '{"code":"identity.download_target_invalid","message":"x","request_id":"r"}',
          status: 422,
        ).issueDownloadTicket('/v1/x'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'identity.download_target_invalid',
          ),
        ),
      );
    });

    test('downloadUri: taban + göreli yol (taban yolu korunur)', () {
      final t = DownloadTicket(
        ticket: 'T',
        path: '/v1/downloads/T',
        expiresAt: DateTime.utc(2026),
      );
      for (final (base, want) in [
        ('https://api.test', 'https://api.test/v1/downloads/T'),
        ('https://api.test/', 'https://api.test/v1/downloads/T'),
        ('https://h.test/nz', 'https://h.test/nz/v1/downloads/T'),
      ]) {
        final repo = IdentityRepository(Dio(BaseOptions(baseUrl: base)));
        expect(repo.downloadUri(t).toString(), want, reason: base);
      }
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
