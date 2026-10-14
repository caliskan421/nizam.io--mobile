import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/api/generated/clients/platform_client.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/network/connectivity_link.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

class FakeLink implements ConnectivityLink {
  FakeLink({this.initial = true});
  bool initial;
  final StreamController<bool> changes = StreamController<bool>.broadcast();

  @override
  Future<bool> hasInterface() async => initial;

  @override
  Stream<bool> get interfaceChanges => changes.stream;

  Future<void> emit(bool v) async {
    changes.add(v);
    await Future<void>.delayed(Duration.zero);
  }
}

class ThrowingLink implements ConnectivityLink {
  @override
  Future<bool> hasInterface() async => throw StateError('platform kanalı yok');

  @override
  Stream<bool> get interfaceChanges => const Stream.empty();
}

Future<ConnectivityMonitor> started(FakeLink link) async {
  final m = ConnectivityMonitor(link);
  addTearDown(m.dispose);
  await m.start();
  return m;
}

void main() {
  group('ConnectivityMonitor', () {
    test(
      'başlangıç bilinmiyor; arayüz var tek başına çevrimiçi demez',
      () async {
        final m = await started(FakeLink());
        expect(m.state.value, ConnectivityState.unknown);
      },
    );

    test('açılışta arayüz yok → çevrimdışı', () async {
      final m = await started(FakeLink(initial: false));
      expect(m.state.value, ConnectivityState.offline);
    });

    test(
      'arayüz olayı yalnız ipucu: yok → çevrimdışı, geri gelme → bilinmiyor',
      () async {
        final link = FakeLink();
        final m = await started(link);
        m.reportSuccess();
        expect(m.state.value, ConnectivityState.online);
        await link.emit(false);
        expect(m.state.value, ConnectivityState.offline);
        await link.emit(true);
        expect(m.state.value, ConnectivityState.unknown);
        await link.emit(true);
        expect(m.state.value, ConnectivityState.unknown);
      },
    );

    test('arayüz var iken çevrimiçi durum bozulmaz', () async {
      final link = FakeLink();
      final m = await started(link)
        ..reportSuccess();
      await link.emit(true);
      expect(m.state.value, ConnectivityState.online);
    });

    test('istek sonucu: başarı → çevrimiçi; ağ hatası → çevrimdışı', () async {
      final m = await started(FakeLink());
      m.reportError(ApiError(ClientErrorCode.networkError));
      expect(m.state.value, ConnectivityState.offline);
      m.reportSuccess();
      expect(m.state.value, ConnectivityState.online);
    });

    test('durumlu hata (sunucu zarfı) sunucuya ulaşıldı demektir; diğer client hataları nötr', () async {
      final m = await started(FakeLink());
      m.reportError(ApiError('identity.credentials_invalid', status: 401));
      expect(m.state.value, ConnectivityState.online);
      m.reportError(ApiError(ClientErrorCode.networkError));
      expect(m.state.value, ConnectivityState.offline);
      m.reportError(ApiError(ClientErrorCode.tlsError));
      m.reportError(ApiError(ClientErrorCode.timeout));
      m.reportError(ApiError(ClientErrorCode.sessionEnded));
      expect(m.state.value, ConnectivityState.offline);
    });

    test('platform kanalı hatası yutulur; istek girdisi çalışır', () async {
      final m = ConnectivityMonitor(ThrowingLink());
      addTearDown(m.dispose);
      await m.start();
      expect(m.state.value, ConnectivityState.unknown);
      m.reportSuccess();
      expect(m.state.value, ConnectivityState.online);
    });

    test('bağdaştırıcısız ve dispose sonrası güvenli', () async {
      final m = ConnectivityMonitor();
      await m.start();
      m.dispose();
      m.reportSuccess();
      m.reportError(ApiError(ClientErrorCode.networkError));
      await m.start();
    });
  });

  group('ConnectivityInterceptor + bileşim (Riverpod)', () {
    Future<(Composition, FakeBackend, FakeLink)> verified(FakeHandler h) async {
      final backend = FakeBackend(h);
      final link = FakeLink();
      final comp = Composition.create(
        flavor: Flavor.prod,
        secureStore: MemorySecureStore(),
        preferenceStore: MemoryPreferenceStore(),
        httpAdapter: backend,
        connectivityLink: link,
      );
      addTearDown(comp.dispose);
      await comp.container.read(serverBindingProvider).verify(testUrl);
      return (comp, backend, link);
    }

    test('durum sağlayıcısı izleyiciyi yansıtır', () async {
      final (comp, _, _) = await verified(discoveryHandler);
      final c = comp.container;
      expect(c.read(connectivityStateProvider), ConnectivityState.unknown);
      c.read(connectivityMonitorProvider).reportSuccess();
      expect(c.read(connectivityStateProvider), ConnectivityState.online);
      c
          .read(connectivityMonitorProvider)
          .reportError(ApiError(ClientErrorCode.networkError));
      expect(c.read(connectivityStateProvider), ConnectivityState.offline);
    });

    test('gerçek istek zinciri: ağ hatası çevrimdışı, sonraki zarf yanıtı çevrimiçi', () async {
      var mode = 'ok';
      final (comp, backend, _) = await verified((r) {
        if (r.path == '/v1/instance/profile' && mode == 'net') {
          throw DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          );
        }
        if (r.path == '/v1/instance/profile' && mode == 'gw') {
          return envelope(503, 'x.y');
        }
        if (r.path == '/v1/instance/profile' && mode == 'env') {
          return envelope(500, 'platform.internal');
        }
        return discoveryHandler(r);
      });
      final dio = comp.container.read(apiDioProvider)!;
      final mon = comp.container.read(connectivityMonitorProvider);
      mode = 'net';
      Future<void> profile() async {
        try {
          await PlatformClient(dio).instanceProfile();
        } on DioException {
          // beklenen
        }
      }

      await profile();
      expect(mon.state.value, ConnectivityState.offline);
      mode = 'gw';
      await profile();
      expect(
        mon.state.value,
        ConnectivityState.offline,
        reason: '503 sinyal değil',
      );
      mode = 'env';
      await profile();
      expect(mon.state.value, ConnectivityState.online);
      mode = 'ok';
      mon.reportError(ApiError(ClientErrorCode.networkError));
      await profile();
      expect(mon.state.value, ConnectivityState.online);
      expect(backend.requests, isNotEmpty);
    });

    test(
      'çevrimiçine dönüş OTOMATİK istek tetiklemez (yalnız durum yayılır)',
      () async {
        final (comp, backend, link) = await verified(discoveryHandler);
        final mon = comp.container.read(connectivityMonitorProvider);
        mon.reportError(ApiError(ClientErrorCode.networkError));
        await link.emit(false);
        final before = backend.requests.length;
        await link.emit(true);
        mon.reportSuccess();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(mon.state.value, ConnectivityState.online);
        expect(backend.requests.length, before);
      },
    );

    test(
      'bileşim kökü kapanınca izleyici bırakılır; sonraki olay sızmaz',
      () async {
        final (comp, _, link) = await verified(discoveryHandler);
        await comp.dispose();
        expect(link.changes.hasListener, isFalse);
      },
    );
  });
}
