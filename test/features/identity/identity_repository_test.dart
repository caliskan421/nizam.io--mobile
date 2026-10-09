// identity data katmanı: üretilmiş DTO → domain varlığı eşlemesi (sınır kuralı A1).
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/identity/data/identity_repository.dart';
import 'package:nizamio/features/identity/domain/current_account.dart';

/// Tek yanıtlı sahte bağdaştırıcı.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

IdentityRepository _repo(String body) => IdentityRepository(
  Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = _Adapter(body),
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
}
