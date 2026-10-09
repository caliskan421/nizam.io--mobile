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
    ops.add(
      key == TokenStore.key
          ? 'write:${TokenPair.decode(value)?.refreshToken}'
          : 'write:$key',
    );
    await super.write(key, value);
  }

  @override
  Future<void> delete(String key) async {
    ops.add('delete:$key');
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
  instanceId: 'inst-1',
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
    session = SessionController(TokenStore(store), (t, _) async {
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
      expect(
        store.ops,
        [
          'write:${TokenStore.inflightKey}',
          'write:refresh-token-2',
          'delete:${TokenStore.inflightKey}',
        ],
        reason: 'çift silinmez, tek üzerine yazma; ağdan önce işaret, kalıcılaşınca silinir',
      );
      expect((await TokenStore(store).load())!.refreshToken, 'refresh-token-2');
      expect(session.accessToken, 'access-token-2');
    },
  );

  group('CX-Ö-04: yeni çift kalıcılaşmazsa oturum etkin sayılmaz; eski belirteç bir daha gitmez', () {
    test('yazma hatası: secure_storage_error, yeniden giriş gerekli, ikinci istek yok', () async {
      store.failWritesFor.add(TokenStore.key);
      await expectLater(
        session.refresh(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.secureStorageError,
          ),
        ),
      );
      expect(
        (session.state.value as SessionReauthRequired).reason,
        ReauthReason.secureStorageFailure,
      );
      expect(session.accessToken, isNull);
      await expectLater(session.refresh(), throwsA(isA<ApiError>()));
      expect(calls, hasLength(1));
      expect(
        store.ops.where((o) => o.startsWith('write:refresh-token')).toSet(),
        {'write:refresh-token-2'},
      );
      // Yerel yazma ağ tekrarı olmadan sınırlı denendi.
      expect(
        store.ops.where((o) => o == 'write:refresh-token-2').length,
        SessionController.storeAttempts,
      );
      // Açılış: kayıt yok ya da işaretli → geri yüklenmez.
      final fresh = SessionController(
        TokenStore(store),
        (_, _) async => throw StateError('gitmemeli'),
      );
      await fresh.restore(instanceId: 'inst-1');
      expect(fresh.state.value, isNot(isA<SessionActive>()));
    });

    test('yazma + silme hatası: iptal edilmiş eski çift diskte kalsa da açılışta gönderilmez', () async {
      store
        ..failWritesFor.add(TokenStore.key)
        ..failDeletes = true;
      await expectLater(session.refresh(), throwsA(isA<ApiError>()));
      expect(session.state.value, isA<SessionReauthRequired>());
      expect(
        (await TokenStore(store).load())!.refreshToken,
        'refresh-token-1',
        reason: 'silme başarısız: eski kayıt diskte',
      );
      expect(store.values.containsKey(TokenStore.inflightKey), isTrue);
      var sent = 0;
      final fresh = SessionController(TokenStore(store), (_, _) async {
        sent++;
        return rotated('3');
      });
      await fresh.restore(instanceId: 'inst-1');
      expect(fresh.state.value, isA<SessionReauthRequired>());
      await expectLater(fresh.refresh(), throwsA(isA<ApiError>()));
      expect(
        sent,
        0,
        reason: 'eski (iptal edilmiş olabilecek) belirteç bir daha gönderilmez',
      );
    });

    test('yazma-öncesi işaret yazılamazsa yenileme ağa ÇIKMAZ', () async {
      store.failWritesFor.add(TokenStore.inflightKey);
      await expectLater(
        session.refresh(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.secureStorageError,
          ),
        ),
      );
      expect(calls, isEmpty);
      expect(
        session.accessToken,
        'access-token-1',
        reason: 'belirteç tüketilmedi',
      );
    });

    test('yenileme sırasında süreç çöktü (işaret diskte): açılışta geri yükleme yok', () async {
      final gate = Completer<RefreshResponse>();
      respond = (_) => gate.future;
      unawaited(session.refresh().then((_) {}, onError: (Object _) {}));
      await Future<void>.delayed(Duration.zero);
      expect(store.values.containsKey(TokenStore.inflightKey), isTrue);
      final fresh = SessionController(
        TokenStore(store),
        (_, _) async => throw StateError('gitmemeli'),
      );
      await fresh.restore(instanceId: 'inst-1');
      expect(fresh.state.value, isA<SessionReauthRequired>());
      expect(store.values.containsKey(TokenStore.key), isFalse);
      gate.complete(rotated('2'));
    });
  });

  test('CX-Ö-01: 200 gövdesi ayrıştırılamadı (DTO hatası) → belirsiz, ikinci istek yok', () async {
    respond = (_) => throw TypeError();
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
    expect(
      (session.state.value as SessionReauthRequired).reason,
      ReauthReason.refreshAmbiguous,
    );
    await expectLater(session.refresh(), throwsA(isA<ApiError>()));
    expect(calls, hasLength(1));
  });

  group('CX-Ö-03: belirteç kaydı kuruluma (instance_id) bağlı', () {
    test('farklı kurulumda açılış: geri yüklenmez, depo temizlenir', () async {
      final fresh = SessionController(
        TokenStore(store),
        (_, _) async => throw StateError('x'),
      );
      await fresh.restore(instanceId: 'inst-2');
      expect(fresh.state.value, isA<SessionNone>());
      expect(store.values.containsKey(TokenStore.key), isFalse);
    });
    test(
      'eski biçimli (kuruluma bağlı olmayan) kayıt geri yüklenmez',
      () async {
        store.values[TokenStore.key] = '{"v":1,"account_id":"a"}';
        final fresh = SessionController(
          TokenStore(store),
          (_, _) async => throw StateError('x'),
        );
        await fresh.restore(instanceId: 'inst-1');
        expect(fresh.state.value, isA<SessionNone>());
        expect(store.values.containsKey(TokenStore.key), isFalse);
      },
    );
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
      (_, _) async {
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
        instanceId: 'inst-1',
      ),
    );
    final s2 = SessionController(
      TokenStore(mem),
      (_, _) async => throw StateError('x'),
    );
    await s2.restore(instanceId: 'inst-1');
    expect(s2.state.value, isA<SessionNone>());
    expect(mem.values, isEmpty);
  });

  test('açılış: geçerli kayıt geri yüklenir', () async {
    final s2 = SessionController(
      TokenStore(store),
      (_, _) async => throw StateError('x'),
    );
    await s2.restore(instanceId: 'inst-1');
    expect(s2.accessToken, 'access-token-1');
  });

  test('TokenPair.toString belirteç içermez', () {
    expect(pair('1').toString(), isNot(contains('token-1')));
  });
}
