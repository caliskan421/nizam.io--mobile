import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show MissingPluginException;
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
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';

import '../../support/fake_backend.dart';
import '../../support/fake_error_reporter.dart';
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
  ThrowingLink({this.hasInterfaceError, this.streamError, this.cancelError});
  final Object? hasInterfaceError;
  final Object? streamError;
  final Object? cancelError;

  @override
  Future<bool> hasInterface() => Future<bool>.error(
    hasInterfaceError ?? MissingPluginException('kanal yok'),
  );

  @override
  Stream<bool> get interfaceChanges {
    // ignore: close_sinks
    late final StreamController<bool> c;
    c = StreamController<bool>(
      onListen: () {
        if (streamError != null) c.addError(streamError!);
      },
      onCancel: () {
        final e = cancelError;
        return e == null ? null : Future<void>.error(e);
      },
    );
    return c.stream;
  }
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

    test(
      'ayrım kararı: arayüz yok → internet yok; var/bilinmiyor → sunucu yok',
      () {
        expect(
          stateAfterNetworkError(hasInterface: false),
          ConnectivityState.offline,
        );
        expect(
          stateAfterNetworkError(hasInterface: true),
          ConnectivityState.unreachable,
        );
        expect(
          stateAfterNetworkError(hasInterface: null),
          ConnectivityState.unreachable,
        );
      },
    );

    test(
      'arayüz yokken ağ hatası çevrimdışı kalır; arayüz gelince bilinmiyor',
      () async {
        final link = FakeLink(initial: false);
        final m = await started(link);
        m.reportError(ApiError(ClientErrorCode.networkError));
        expect(m.state.value, ConnectivityState.offline);
        await link.emit(true);
        expect(m.state.value, ConnectivityState.unknown);
        m.reportError(ApiError(ClientErrorCode.networkError));
        expect(m.state.value, ConnectivityState.unreachable);
        await link.emit(true);
        expect(m.state.value, ConnectivityState.unknown);
      },
    );

    test('bağlantı geri geldi yalnız sorunlu → sorunsuz geçişte', () {
      expect(connectionRestored(null, ConnectivityState.online), isFalse);
      expect(
        connectionRestored(ConnectivityState.unknown, ConnectivityState.online),
        isFalse,
      );
      expect(
        connectionRestored(
          ConnectivityState.unreachable,
          ConnectivityState.online,
        ),
        isTrue,
      );
      expect(
        connectionRestored(
          ConnectivityState.offline,
          ConnectivityState.unknown,
        ),
        isTrue,
      );
      expect(
        connectionRestored(
          ConnectivityState.offline,
          ConnectivityState.unreachable,
        ),
        isFalse,
      );
    });

    test('bağlantı kaynaklı hata: ağ, zaman aşımı, 502–504', () {
      expect(isConnectionError(ApiError(ClientErrorCode.networkError)), isTrue);
      expect(isConnectionError(ApiError(ClientErrorCode.timeout)), isTrue);
      expect(isConnectionError(ApiError('x.y', status: 503)), isTrue);
      expect(
        isConnectionError(ApiError('platform.internal', status: 500)),
        isFalse,
      );
      expect(isConnectionError(ApiError(ClientErrorCode.tlsError)), isFalse);
    });

    test(
      'istek sonucu: başarı → çevrimiçi; ağ hatası → sunucuya ulaşılamıyor',
      () async {
        final m = await started(FakeLink());
        m.reportError(ApiError(ClientErrorCode.networkError));
        expect(m.state.value, ConnectivityState.unreachable);
        m.reportSuccess();
        expect(m.state.value, ConnectivityState.online);
      },
    );

    test('durumlu hata (sunucu zarfı) sunucuya ulaşıldı demektir; diğer client hataları nötr', () async {
      final m = await started(FakeLink());
      m.reportError(ApiError('identity.credentials_invalid', status: 401));
      expect(m.state.value, ConnectivityState.online);
      m.reportError(ApiError(ClientErrorCode.networkError));
      expect(m.state.value, ConnectivityState.unreachable);
      m.reportError(ApiError(ClientErrorCode.tlsError));
      m.reportError(ApiError(ClientErrorCode.timeout));
      m.reportError(ApiError(ClientErrorCode.sessionEnded));
      expect(m.state.value, ConnectivityState.unreachable);
    });

    test('platform kanalı YOK (MissingPluginException): rapor 0; istek girdisi çalışır', () async {
      final sdk = FakeErrorReporter();
      ErrorReporting.reset();
      ErrorReporting.attach(sdk).setEnabled(true);
      addTearDown(ErrorReporting.reset);
      final m = ConnectivityMonitor(
        ThrowingLink(streamError: MissingPluginException('kanal yok')),
      );
      await m.start();
      m.dispose();
      await pumpEventQueue();
      expect(sdk.reports, isEmpty);
      final m2 = ConnectivityMonitor(ThrowingLink());
      addTearDown(m2.dispose);
      await m2.start();
      expect(m2.state.value, ConnectivityState.unknown);
      m2.reportSuccess();
      expect(m2.state.value, ConnectivityState.online);
      expect(sdk.reports, isEmpty);
    });

    group('teknik hata raporlanır, durum davranışı korunur', () {
      late FakeErrorReporter sdk;
      setUp(() {
        sdk = FakeErrorReporter();
        ErrorReporting.reset();
        ErrorReporting.attach(sdk).setEnabled(true);
      });
      tearDown(ErrorReporting.reset);

      test(
        'akış TypeError (bozuk native olay) => rapor 1, durum bilinmiyor',
        () async {
          final m = ConnectivityMonitor(
            ThrowingLink(
              hasInterfaceError: MissingPluginException('x'),
              streamError: TypeError(),
            ),
          );
          addTearDown(m.dispose);
          await m.start();
          await pumpEventQueue();
          expect(sdk.reports, hasLength(1));
          expect(sdk.reports.single.source, ReportSource.network);
          expect(m.state.value, ConnectivityState.unknown);
          m.reportSuccess();
          expect(m.state.value, ConnectivityState.online);
        },
      );

      test('hasInterface StateError => rapor 1, durum bilinmiyor', () async {
        final m = ConnectivityMonitor(
          ThrowingLink(hasInterfaceError: StateError('beklenmeyen')),
        );
        addTearDown(m.dispose);
        await m.start();
        expect(sdk.reports, hasLength(1));
        expect(sdk.reports.single.source, ReportSource.network);
        expect(m.state.value, ConnectivityState.unknown);
      });

      test(
        'abonelik iptali hatası (dispose) => rapor 1, dispose düşmez',
        () async {
          final m = ConnectivityMonitor(
            ThrowingLink(
              hasInterfaceError: MissingPluginException('x'),
              cancelError: StateError('iptal'),
            ),
          );
          await m.start();
          expect(sdk.reports, isEmpty);
          m.dispose();
          await pumpEventQueue();
          expect(sdk.reports, hasLength(1));
        },
      );
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
      expect(c.read(connectivityStateProvider), ConnectivityState.unreachable);
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
      expect(mon.state.value, ConnectivityState.unreachable);
      mode = 'gw';
      await profile();
      expect(
        mon.state.value,
        ConnectivityState.unreachable,
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
