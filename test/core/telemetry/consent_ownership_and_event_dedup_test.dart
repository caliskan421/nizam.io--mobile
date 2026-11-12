// (1) Rıza sahipliği: yerine başka bileşim bağlanmış ya da dispose edilmiş denetleyici HİÇBİR
// SDK/tercih yan etkisi yapmaz; başlamış geç `true` yazısı depo sırasında geri alınır.
// (2) Tekrar önleme OLAY bazlıdır (nesne ömrü bazlı değil), genel hız sınırı/oturum tavanı delinmez.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/error_reporting_controller.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/unexpected_error.dart';

import '../../support/fake_error_reporter.dart';

/// Okuma [release]'e dek bekler ve değer döner; yazma/silme sayılır.
class _CountingStore extends MemoryPreferenceStore {
  _CountingStore({String? initial}) {
    if (initial != null) values[AppPreferences.errorReportingKey] = initial;
  }

  final _gate = Completer<void>();
  var writes = 0;
  var removes = 0;

  void release() => _gate.complete();

  @override
  Future<String?> getString(String key) async {
    await _gate.future;
    return super.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    writes++;
    return super.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    removes++;
    return super.remove(key);
  }
}

/// `true` yazısı [releaseGrant]'a dek FİZİKSEL olarak bekler (başlamış, iptal edilemez yazı).
class _DelayedGrantStore extends MemoryPreferenceStore {
  final _grantGate = Completer<void>();
  var grantStarted = false;

  void releaseGrant() => _grantGate.complete();

  @override
  Future<void> setString(String key, String value) async {
    if (value == 'true') {
      grantStarted = true;
      await _grantGate.future;
    }
    return super.setString(key, value);
  }

  String? get stored => values[AppPreferences.errorReportingKey];
}

void main() {
  group('rıza sahipliği (gerçek yan etki sayıları)', () {
    late FakeErrorReporter oldSdk;
    late FakeErrorReporter newSdk;

    setUp(() {
      oldSdk = FakeErrorReporter();
      newSdk = FakeErrorReporter();
      ErrorReporting.reset();
    });
    tearDown(ErrorReporting.reset);

    ErrorReportingController make(AppPreferences prefs, FakeErrorReporter sdk) {
      final c = ErrorReportingController(
        prefs,
        sdk,
        sdkTimeout: const Duration(milliseconds: 200),
      );
      addTearDown(c.dispose);
      return c;
    }

    test(
      'eski load okuması geç döner (true): yeni bileşim onayı kapalı yükledi => '
      'ESKİ SEND 0, kapı kapalı, yeni SDK yalnız kendi discard\'ını görür',
      () async {
        final oldStore = _CountingStore(initial: 'true');
        final old = make(AppPreferences(oldStore), oldSdk);
        final oldLoad = old.load();
        await pumpEventQueue(); // eski okuma kapıda bekliyor, bağ eski denetleyicide

        final newStore = _CountingStore()..release();
        final fresh = make(AppPreferences(newStore), newSdk);
        await fresh.load(); // yeni bağ + onay yok => discard
        expect(newSdk.calls, ['discard']);

        oldStore.release(); // eski okuma `true` ile döner
        await oldLoad;

        expect(
          oldSdk.calls,
          isEmpty,
          reason: 'eski sendPending/discard çağrılmadı',
        );
        expect(ErrorReporting.enabled, isFalse);
        expect(old.state.value, isFalse);
        expect(newSdk.calls, ['discard'], reason: 'yeni SDK etkilenmedi');
        expect(fresh.state.value, isFalse);
      },
    );

    test('eski kuyruktaki set(true)/set(false) bağ el değiştirince: SDK 0, '
        'tercih yazma/silme 0', () async {
      final oldStore = _CountingStore(initial: 'true');
      final old = make(AppPreferences(oldStore), oldSdk);
      final oldLoad = old.load();
      final queuedOn = old.set(true);
      await pumpEventQueue();

      final newStore = _CountingStore()..release();
      final fresh = make(AppPreferences(newStore), newSdk);
      await fresh.load();
      newSdk.calls.clear();
      // Sahiplik kaybından SONRA istenen geri alma: ortak şeridi kilitlemez, yan etki yapmaz.
      final queuedOff = old.set(false);

      oldStore.release();
      await Future.wait([oldLoad, queuedOn, queuedOff]);

      expect(oldSdk.calls, isEmpty);
      expect(oldStore.writes, 0, reason: 'eski denetleyici tercih yazmadı');
      expect(oldStore.removes, 0);
      expect(newSdk.calls, isEmpty);
      expect(newStore.writes, 0);
      expect(ErrorReporting.enabled, isFalse);
    });

    test(
      'dispose sonrası kuyruktaki load/set/discard hiçbir yan etki yapmaz',
      () async {
        final store = _CountingStore(initial: 'true');
        final c = make(AppPreferences(store), oldSdk);
        final load = c.load();
        await pumpEventQueue();
        c.dispose();
        store.release();
        await load;
        expect(oldSdk.calls, isEmpty);
        expect(store.writes, 0);
        expect(store.removes, 0);
        expect(ErrorReporting.enabled, isFalse);
      },
    );

    test(
      'sahip denetleyici etkilenmez (kontrol): onay açıkken gönderim 1',
      () async {
        final store = _CountingStore(initial: 'true')..release();
        final c = make(AppPreferences(store), oldSdk);
        await c.load();
        expect(oldSdk.calls, ['send']);
        expect(c.state.value, isTrue);
      },
    );

    test('BAŞLAMIŞ geç true + yeni bileşim iptali (iki AppPreferences, ortak '
        'depo): kalıcı false, yeniden load gönderim 0', () async {
      final store = _DelayedGrantStore();
      final old = make(AppPreferences(store), oldSdk);
      final enabling = old.set(
        true,
      ); // discard onaylanır, sonra `true` yazısı BAŞLAR
      await pumpEventQueue();
      expect(store.grantStarted, isTrue, reason: 'fiziksel yazı başladı');

      // Yeni bileşim: ayrı AppPreferences, aynı kalıcı depo; bağı devralır ve iptal eder.
      final fresh = make(AppPreferences(store), newSdk);
      final loading = fresh
          .load(); // bağı devralır (okuma `true` yazısının ardında)
      final revoking = fresh.set(false);
      await pumpEventQueue();
      store.releaseGrant(); // eski geç `true` EN SON tamamlanır
      await Future.wait([enabling, loading, revoking]);
      await pumpEventQueue();

      expect(store.stored, isNot('true'), reason: 'kalıcı kayıt açık kalmadı');
      expect(old.state.value, isFalse);
      expect(ErrorReporting.enabled, isFalse);
      expect(oldSdk.calls.where((c) => c == 'send'), isEmpty);

      // Sonraki açılış: kapalı yüklenir, gönderim 0.
      ErrorReporting.reset();
      final third = FakeErrorReporter();
      final reopened = make(AppPreferences(store), third);
      await reopened.load();
      expect(third.calls.where((c) => c == 'send'), isEmpty);
      expect(third.calls, ['discard']);
      expect(reopened.state.value, isFalse);
    });

    test(
      'BAŞLAMIŞ geç true + eski denetleyici dispose: depoda false kalır',
      () async {
        final store = _DelayedGrantStore();
        final old = AppPreferences(store);
        final c = ErrorReportingController(
          old,
          oldSdk,
          sdkTimeout: const Duration(milliseconds: 200),
        );
        final enabling = c.set(true);
        await pumpEventQueue();
        expect(store.grantStarted, isTrue);
        c.dispose(); // composition atıldı; yazı iptal edilemez
        store.releaseGrant();
        await enabling;
        await pumpEventQueue();

        expect(store.stored, 'false');
        expect(ErrorReporting.enabled, isFalse);
        expect(oldSdk.calls.where((c) => c == 'send'), isEmpty);
      },
    );

    test('bayat geri alma daha YENİ gerçek true onayını ezmez', () async {
      final store = _DelayedGrantStore();
      final old = make(AppPreferences(store), oldSdk);
      final oldEnabling = old.set(true);
      await pumpEventQueue();
      expect(store.grantStarted, isTrue);

      final fresh = make(AppPreferences(store), newSdk);
      final newEnabling = fresh.set(
        true,
      ); // bağı devralır; kendi true'su daha yeni
      await pumpEventQueue();
      store.releaseGrant();
      await Future.wait([oldEnabling, newEnabling]);
      await pumpEventQueue();

      expect(store.stored, 'true', reason: 'eski geri alma yeni onayı ezmedi');
      expect(fresh.state.value, isTrue);
      expect(old.state.value, isFalse);
    });

    test(
      'depo ortak şerit: iki örnekte yazılar istek sırasıyla bitar',
      () async {
        final store = _DelayedGrantStore();
        final a = AppPreferences(store);
        final b = AppPreferences(store);
        final grant = a.setErrorReportingConsent(true);
        await pumpEventQueue();
        final revoke = b.setErrorReportingConsent(
          false,
        ); // `true` bitmeden başlamaz
        store.releaseGrant();
        await Future.wait([grant, revoke]);
        expect(store.stored, 'false');
        expect(await b.errorReportingConsent(), isFalse);
      },
    );
  });

  group('tekrar önleme olay bazlıdır', () {
    late FakeErrorReporter sdk;
    var now = DateTime(2026, 11, 12, 10);
    const same = FormatException('sabit');

    StackTrace site(String name) => StackTrace.fromString(
      '#0 $name (package:nizamio/features/x/$name.dart:1:1)',
    );

    void send(Object e, StackTrace st) =>
        ErrorReporting.report(e, st, kind: ReportKind.serialization);

    setUp(() {
      now = DateTime(2026, 11, 12, 10);
      sdk = FakeErrorReporter();
      ErrorReporting.reset(clock: () => now);
      ErrorReporting.attach(sdk).setEnabled(true);
    });
    tearDown(ErrorReporting.reset);

    test('aynı olay katmanlarda 1: aynı (nesne, yığın) iki yoldan', () {
      final st = site('a');
      send(same, st);
      reportUnexpected(same, st, source: ReportSource.tasks);
      send(same, st);
      expect(sdk.reports, hasLength(1));
    });

    test('const hata farklı fırlatma noktasından: YENİ olay (yeni rapor)', () {
      send(same, site('a'));
      send(same, site('b'));
      expect(sdk.reports, hasLength(2));
      expect(ErrorReporting.alreadyHandled(same, site('c')), isFalse);
    });

    test('yeniden kullanılan nesne hız sınırı aralığından sonra yeniden raporlanır', () {
      send(same, site('a'));
      now = now.add(const Duration(minutes: 1)); // aynı anahtar, aralık dolmadı
      send(same, site('a')); // yeni olay ama genel hız sınırı reddeder
      expect(sdk.reports, hasLength(1));
      now = now.add(const Duration(minutes: 6));
      send(same, site('a')); // aralık doldu: yeniden fırlatma = yeni rapor
      expect(sdk.reports, hasLength(2));
    });

    test(
      'AYNI saklanan yığın nesnesi + aynı hata, aralık sonrası yeniden 1 rapor',
      () {
        final stored = site('stored'); // tek yığın nesnesi, yeniden kullanılır
        send(same, stored);
        expect(sdk.reports, hasLength(1));
        send(same, stored); // aynı yayılım: pencere içinde yinelenmez
        expect(sdk.reports, hasLength(1));
        now = now.add(const Duration(minutes: 6)); // pencere VE aralık geçti
        expect(ErrorReporting.alreadyHandled(same, stored), isFalse);
        send(same, stored);
        expect(sdk.reports, hasLength(2));
        send(same, stored); // yine aynı yayılım
        expect(sdk.reports, hasLength(2));
      },
    );

    test('aynı yığın nesnesi hız sınırında reddedilse de aralık dolunca uygun olur', () {
      final stored = site('stored');
      send(same, stored);
      now = now.add(const Duration(minutes: 1)); // pencere dışı, aralık içi
      send(same, stored); // yeni olay ama hız sınırı reddeder
      expect(sdk.reports, hasLength(1));
      now = now.add(const Duration(minutes: 5)); // aralık doldu
      send(same, stored);
      expect(sdk.reports, hasLength(2));
    });

    test('başta hız sınırında reddedilen olay nesneyi sonsuza bastırmaz', () {
      send(same, site('a'));
      now = now.add(const Duration(seconds: 40));
      // ignore: prefer_const_constructors
      final e2 = FormatException('başka nesne, aynı tür ve yığın');
      send(
        e2,
        site('a'),
      ); // aynı anahtar => hız sınırı reddi (e2 olay olarak işaretlenir)
      expect(sdk.reports, hasLength(1));
      now = now.add(const Duration(minutes: 6));
      send(e2, site('a')); // aralık doldu: aynı nesne yeniden fırlatıldı
      expect(sdk.reports, hasLength(2));
    });

    test('genel oturum tavanı ve hız sınırı delinmez', () {
      for (var i = 0; i < ErrorReporting.sessionCap + 10; i++) {
        send(StateError('e$i'), site('s$i'));
      }
      expect(sdk.reports, hasLength(ErrorReporting.sessionCap));
      // Aynı yığınla art arda: hız sınırı tek rapor.
      ErrorReporting.reset(clock: () => now);
      ErrorReporting.attach(sdk).setEnabled(true);
      sdk.reports.clear();
      for (var i = 0; i < 5; i++) {
        send(StateError('x$i'), site('same'));
      }
      expect(sdk.reports, hasLength(1));
    });

    test(
      'yeni kurulan hata: katmanlar `throw e` ile yığını yenilese de aynı olay',
      () {
        final created = invalidResponseError();
        expect(sdk.reports, hasLength(1));
        reportUnexpected(created, site('catch1'), source: ReportSource.tasks);
        reportUnexpected(created, site('catch2'), source: ReportSource.tasks);
        expect(sdk.reports, hasLength(1));
      },
    );

    test('dönüştürülmüş ApiError + gözlemci + kanca: tek olay', () {
      final dio = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 502,
          data: '<html>',
        ),
      );
      final st = site('orig');
      final api = toReportedApiError(dio, st, source: ReportSource.tasks);
      expect(sdk.reports, hasLength(1));
      reportUnexpected(api, site('observer'), source: ReportSource.provider);
      ErrorReporting.report(api, site('hook'), kind: ReportKind.uncaughtAsync);
      expect(sdk.reports, hasLength(1));
    });
  });
}
