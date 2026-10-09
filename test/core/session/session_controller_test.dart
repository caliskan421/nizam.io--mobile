// SessionController: K-05 istemci kuralı, tek uçuş, "yeni kaydedilmeden eski silinmez".
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/models/refresh_response.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/session/session_controller.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_pair.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

/// İşlem sırasını kaydeden depo.
class RecordingStore extends MemorySecureStore {
  final List<String> ops = [];

  @override
  Future<void> write(String key, String value) async {
    ops.add('write:${TokenPair.decode(value)?.refreshToken}');
    await super.write(key, value);
  }

  @override
  Future<void> delete(String key) async {
    ops.add('delete');
    await super.delete(key);
  }
}

const _future = 4102444800; // 2100-01-01

TokenPair pair(String n, {bool force = false}) => TokenPair(
  accountId: 'acc-1',
  accessToken: 'access-token-$n',
  accessExpiresAt: _future,
  refreshToken: 'refresh-token-$n',
  refreshExpiresAt: _future,
  forcePasswordChange: force,
);

RefreshResponse rotated(String n) => RefreshResponse(
  accountId: 'acc-1',
  accessToken: 'access-token-$n',
  refreshToken: 'refresh-token-$n',
  expiresAt: _future,
  refreshExpiresAt: _future,
);

void main() {
  late RecordingStore store;
  late List<String> calls;
  late FutureOr<RefreshResponse> Function(String) respond;
  late SessionController session;

  setUp(() async {
    store = RecordingStore();
    calls = [];
    respond = (_) => rotated('2');
    session = SessionController(TokenStore(store), (t) async {
      calls.add(t);
      return respond(t);
    });
    await session.establish(pair('1'));
    store.ops.clear();
  });

  group('K-05: yenileme belirsiz düşerse aynı belirteçle tekrar yok', () {
    final belirsiz = <String, ApiError>{
      'zaman aşımı': ApiError(ClientErrorCode.timeout),
      'ağ hatası': ApiError(ClientErrorCode.networkError),
      'TLS hatası': ApiError(ClientErrorCode.tlsError),
      '500': ApiError('platform.internal', status: 500),
      '409 conflict_retry': ApiError('platform.conflict_retry', status: 409),
      'geçersiz yanıt': ApiError(ClientErrorCode.invalidResponse, status: 502),
    };
    belirsiz.forEach((name, error) {
      test(name, () async {
        respond = (_) => throw error;
        await expectLater(
          session.refresh(),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.reauthRequired,
            ),
          ),
        );
        expect(calls, ['refresh-token-1']);
        expect(session.state.value, isA<SessionReauthRequired>());
        expect(
          (session.state.value as SessionReauthRequired).reason,
          ReauthReason.refreshAmbiguous,
        );
        expect(session.accessToken, isNull);
        expect(
          store.values,
          isEmpty,
          reason: 'iptal edilmiş olabilecek belirteç depoda kalmaz',
        );

        // İkinci, üçüncü deneme ağa ÇIKMAZ.
        for (var i = 0; i < 3; i++) {
          await expectLater(
            session.refresh(),
            throwsA(
              isA<ApiError>().having(
                (e) => e.code,
                'code',
                ClientErrorCode.reauthRequired,
              ),
            ),
          );
        }
        expect(calls, hasLength(1));
      });
    });

    test('yanıt 200 ama belirteç eksik → belirsiz', () async {
      respond = (_) => RefreshResponse(
        accountId: 'acc-1',
        expiresAt: 1,
        refreshExpiresAt: 1,
      );
      await expectLater(session.refresh(), throwsA(isA<ApiError>()));
      expect(session.state.value, isA<SessionReauthRequired>());
      expect(calls, hasLength(1));
    });

    test('belirsiz hatadan sonra yeniden giriş yeni oturum açar', () async {
      respond = (_) => throw ApiError(ClientErrorCode.timeout);
      await expectLater(session.refresh(), throwsA(isA<ApiError>()));
      await session.establish(pair('9'));
      expect(session.state.value, isA<SessionActive>());
      respond = (_) => rotated('10');
      expect(await session.refresh(), 'access-token-10');
    });
  });

  test('401 → reddedildi: belirteçler silinir, session_ended', () async {
    respond = (_) => throw ApiError('identity.session_invalid', status: 401);
    await expectLater(
      session.refresh(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.sessionEnded,
        ),
      ),
    );
    expect(
      (session.state.value as SessionReauthRequired).reason,
      ReauthReason.refreshRejected,
    );
    expect(store.values, isEmpty);
  });

  test('429 → işlenmedi: belirteç korunur, otomatik tekrar yok', () async {
    respond = (_) => throw ApiError(
      'platform.rate_limited',
      status: 429,
      retryAfter: const Duration(seconds: 7),
    );
    await expectLater(
      session.refresh(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.retryAfter,
          'retryAfter',
          const Duration(seconds: 7),
        ),
      ),
    );
    expect(calls, hasLength(1));
    expect(session.state.value, isA<SessionActive>());
    expect(session.accessToken, 'access-token-1');
  });

  test(
    'başarı: yeni çift ÖNCE depoya yazılır; eski kayıt önceden silinmez',
    () async {
      final token = await session.refresh();
      expect(token, 'access-token-2');
      expect(store.ops, [
        'write:refresh-token-2',
      ], reason: 'silme yok, tek üzerine yazma');
      expect((await TokenStore(store).load())!.refreshToken, 'refresh-token-2');
      expect(session.accessToken, 'access-token-2');
    },
  );

  test('başarı ama depo yazılamadı: bellekte yeni çift, iptal edilmiş eski kayıt silinir', () async {
    store.failWrites = true;
    expect(await session.refresh(), 'access-token-2');
    expect(
      store.values,
      isEmpty,
      reason: 'sonraki açılışta iptal edilmiş belirteç tekrar kullanılmaz',
    );
    expect(session.state.value, isA<SessionActive>());
  });

  test('tek uçuş: eşzamanlı üç yenileme → tek istek', () async {
    final gate = Completer<RefreshResponse>();
    respond = (_) => gate.future;
    final futures = [session.refresh(), session.refresh(), session.refresh()];
    gate.complete(rotated('2'));
    expect(await Future.wait(futures), everyElement('access-token-2'));
    expect(calls, hasLength(1));
  });

  test('401 alan istek eski belirteçliyse yenileme yapılmaz, güncel belirteç döner', () async {
    await session.refresh();
    expect(
      await session.refresh(failedAccessToken: 'access-token-1'),
      'access-token-2',
    );
    expect(calls, hasLength(1));
  });

  test('force_password_change yenilemede taşınır', () async {
    await session.markForcePasswordChange(true);
    await session.refresh();
    final s = session.state.value as SessionActive;
    expect(s.forcePasswordChange, isTrue);
  });

  test('giriş çifti depoya yazılamazsa oturum açılmaz', () async {
    final s2 = SessionController(
      TokenStore(MemorySecureStore()..failWrites = true),
      (_) async {
        throw StateError('çağrılmamalı');
      },
    );
    await expectLater(
      s2.establish(pair('1')),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.secureStorageError,
        ),
      ),
    );
    expect(s2.state.value, isA<SessionNone>());
    expect(s2.accessToken, isNull);
  });

  test('açılış: süresi dolmuş kayıt silinir', () async {
    final mem = MemorySecureStore();
    await TokenStore(mem).save(
      TokenPair(
        accountId: 'a',
        accessToken: 'x' * 10,
        accessExpiresAt: 1,
        refreshToken: 'y' * 10,
        refreshExpiresAt: 1,
        forcePasswordChange: false,
      ),
    );
    final s2 = SessionController(
      TokenStore(mem),
      (_) async => throw StateError('x'),
    );
    await s2.restore();
    expect(s2.state.value, isA<SessionNone>());
    expect(mem.values, isEmpty);
  });

  test('açılış: geçerli kayıt geri yüklenir', () async {
    final s2 = SessionController(
      TokenStore(store),
      (_) async => throw StateError('x'),
    );
    await s2.restore();
    expect(s2.accessToken, 'access-token-1');
  });

  test('TokenPair.toString belirteç içermez', () {
    expect(pair('1').toString(), isNot(contains('token-1')));
  });
}
