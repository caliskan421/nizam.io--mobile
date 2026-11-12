// Onay şeridi: (1) bayat `true` sıra işinin İÇİNDE geri alınır, yeni sahibin okuması onu görmez;
// (2) geri alma + silme ikisi de düşerse okuma KAPALI (kilit); (3) GERÇEK yazı hatası 500 ms
// önce/sonra tam bir kez raporlanır, yalnız zaman aşımı rapor üretmez.
//
// Dürüst sınırlar: başlamış fiziksel yazı iptal EDİLEMEZ (platform ack'i beklenir); geri alma ve
// silme ikisi de başarısızsa kayıtta `true` fiziksel olarak kalır ve yalnız bu süreçte okuma
// kapalı tutulur (fail-closed); süreç ondan önce ölürse sonraki açılış onaylı görünebilir.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/error_reporting_controller.dart';

import '../../support/fake_error_reporter.dart';

const _key = AppPreferences.errorReportingKey;

/// `true` yazısı kapıda bekler; hatalar ve okuma günlüğü ayarlanabilir.
class _Store extends MemoryPreferenceStore {
  Completer<void>? grantGate;
  Completer<void>? failingTrueGate; // tamamlanınca `true` yazısı HATA verir
  bool failFalse = false;
  bool failRemove = false;
  final reads = <String?>[];

  @override
  Future<String?> getString(String key) async {
    final v = await super.getString(key);
    reads.add(v);
    return v;
  }

  @override
  Future<void> setString(String key, String value) async {
    if (value == 'true') {
      await grantGate?.future;
      if (failingTrueGate != null) {
        await failingTrueGate!.future;
        throw StateError('gerçek yazı hatası');
      }
    }
    if (value == 'false' && failFalse) throw StateError('false yazılamadı');
    return super.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    if (failRemove) throw StateError('silinemedi');
    return super.remove(key);
  }
}

/// Aynı platform deposunu gösteren AYRI bağdaştırıcı (üretimde her bileşim kendi örneğini kurar).
class _PlatformView implements PreferenceStore, PlatformBackedStore {
  _PlatformView(this.inner);
  final _Store inner;

  @override
  Future<String?> getString(String key) => inner.getString(key);
  @override
  Future<void> setString(String key, String value) =>
      inner.setString(key, value);
  @override
  Future<void> remove(String key) => inner.remove(key);
}

void main() {
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

  // Aynı depo örneği ve ayrı platform bağdaştırıcısı: ikisi de aynı şeridi paylaşmalı.
  final variants =
      <
        String,
        (PreferenceStore Function(_Store), PreferenceStore Function(_Store))
      >{
        'aynı depo': ((s) => s, (s) => s),
        'ayrı platform bağdaştırıcısı': (_PlatformView.new, _PlatformView.new),
      };

  group('bayat true sıra içinde geri alınır', () {
    for (final v in variants.entries) {
      test(
        '${v.key}: geç true bitince yeni load okuması false görür => send 0',
        () async {
          final inner = _Store()..grantGate = Completer<void>();
          final old = make(AppPreferences(v.value.$1(inner)), oldSdk);
          final enabling = old.set(true);
          await pumpEventQueue();

          final fresh = make(AppPreferences(v.value.$2(inner)), newSdk);
          final loading = fresh
              .load(); // bağı devralır; okuma eski yazının ardında bekler
          await pumpEventQueue();
          inner.grantGate!.complete(); // eski geç `true` fiziksel olarak biter
          await Future.wait([enabling, loading]);
          await pumpEventQueue();

          expect(inner.reads, [
            'false',
          ], reason: 'okuma bayat true\'yu hiç görmedi');
          expect(newSdk.calls, ['discard'], reason: 'send 0');
          expect(inner.values[_key], 'false');
          expect(fresh.state.value, isFalse);
          expect(old.state.value, isFalse);
          // Şerit temiz: sonraki geçerli onay yazılabilir.
          expect(
            await AppPreferences(v.value.$1(inner))
                .setErrorReportingConsent(false),
            isTrue,
          );
        },
      );

      test(
        '${v.key}: yeni GERÇEK true sonda kalır, geçerli denetleyici etkin',
        () async {
          final inner = _Store()..grantGate = Completer<void>();
          final old = make(AppPreferences(v.value.$1(inner)), oldSdk);
          final oldEnabling = old.set(true);
          await pumpEventQueue();

          final fresh = make(AppPreferences(v.value.$2(inner)), newSdk);
          final newEnabling = fresh.set(true);
          await pumpEventQueue();
          inner.grantGate!.complete();
          await Future.wait([oldEnabling, newEnabling]);
          await pumpEventQueue();

          expect(
            inner.values[_key],
            'true',
            reason: 'eski geri alma yeni true\'yu ezmedi',
          );
          expect(fresh.state.value, isTrue);
          expect(old.state.value, isFalse);
          expect(
            await AppPreferences(v.value.$1(inner))
                .setErrorReportingConsent(false),
            isTrue,
          );
        },
      );
    }
  });

  test('geri alma false + silme ikisi de düşer => kilit: yeni load send 0; '
      'açık başarılı kapatma kilidi kaldırır', () async {
    final inner = _Store()
      ..grantGate = Completer<void>()
      ..failFalse = true
      ..failRemove = true;
    final prefsOld = AppPreferences(inner);
    final old = make(prefsOld, oldSdk);
    final enabling = old.set(true);
    await pumpEventQueue();

    final fresh = make(AppPreferences(inner), newSdk);
    final loading = fresh.load();
    await pumpEventQueue();
    inner.grantGate!.complete();
    await Future.wait([enabling, loading]);
    await pumpEventQueue();

    expect(
      inner.values[_key],
      'true',
      reason: 'fiziksel bayat kayıt (dürüst sınır)',
    );
    expect(inner.reads, isEmpty, reason: 'kilitliyken depo okunmadı');
    expect(newSdk.calls.where((c) => c == 'send'), isEmpty);
    expect(fresh.state.value, isFalse);
    expect(await AppPreferences(inner).errorReportingConsent(), isFalse);

    inner.failFalse = false; // açık, başarılı kapatma kilidi kaldırır
    expect(await AppPreferences(inner).setErrorReportingConsent(false), isTrue);
    expect(inner.values[_key], 'false');
    // Yeni geçerli açık onay da güvenle çalışır.
    expect(await AppPreferences(inner).setErrorReportingConsent(true), isTrue);
    expect(await AppPreferences(inner).errorReportingConsent(), isTrue);
    await AppPreferences(inner).setErrorReportingConsent(false);
  });

  testWidgets('yazı 500 ms zaman aşımından SONRA biterse bariyer geri almadan '
      'önce yeni load okuması yapılmaz', (tester) async {
    final store = _Store()..grantGate = Completer<void>();
    final prefs = AppPreferences(store);
    var stale = false;
    bool? written;
    unawaited(
      prefs
          .grantErrorReportingConsent(isCurrent: () => !stale)
          .written
          .then((v) => written = v),
    );

    await tester.pump(const Duration(milliseconds: 501));
    expect(written, isFalse, reason: 'çağıran 500 ms sonra bıraktı');

    stale = true; // sahip değişti
    bool? read;
    unawaited(prefs.errorReportingConsent().then((v) => read = v));
    await tester.pump(const Duration(milliseconds: 100));
    expect(store.reads, isEmpty, reason: 'gerçek yazı bitmeden okuma yok');

    store.grantGate!.complete(); // eski true tamamlanır
    await tester.pump(const Duration(milliseconds: 10));
    expect(read, isFalse);
    expect(store.reads, ['false'], reason: 'okuma yalnız geri almadan SONRA');
    expect(store.values[_key], 'false');
    await tester.pump(const Duration(seconds: 1)); // kalan zamanlayıcılar
  });

  group('gerçek yazı hatası: tam bir kez, özgün hata', () {
    late FakeErrorReporter sdk;
    setUp(() {
      sdk = FakeErrorReporter();
      ErrorReporting.reset();
      ErrorReporting.attach(sdk).setEnabled(true);
    });

    // Her iki yol (onay yazısı, sürüm politikası) aynı üç durumla sınanır; tüm yazılar `gate`
    // tamamlanana dek bekler, sonra [fails] ise StateError ile düşer.
    final writers = <String, Future<void> Function(_GatedStore)>{
      'onay': (s) => AppPreferences(s).setErrorReportingConsent(true),
      'sürüm politikası': (s) =>
          AppPreferences(s)
              .setReleasePolicy(const MobileReleasePolicy.disabled()),
    };

    for (final w in writers.entries) {
      testWidgets('${w.key}: 500 ms ÖNCE hata => rapor 1', (tester) async {
        final store = _GatedStore(fails: true);
        unawaited(w.value(store));
        await tester.pump(const Duration(milliseconds: 100));
        store.gate.complete();
        await tester.pump(const Duration(milliseconds: 10));
        expect(sdk.reports, hasLength(1));
        await tester.pump(const Duration(seconds: 1));
        expect(
          sdk.reports,
          hasLength(1),
          reason: 'zaman aşımı ikinci rapor değil',
        );
      });

      testWidgets('${w.key}: 501 ms SONRA hata => rapor 1 (özgün hata)', (
        tester,
      ) async {
        final store = _GatedStore(fails: true);
        unawaited(w.value(store));
        await tester.pump(const Duration(milliseconds: 501));
        expect(sdk.reports, isEmpty, reason: 'yalnız zaman aşımı rapor değil');
        store.gate.complete();
        await tester.pump(const Duration(milliseconds: 10));
        expect(sdk.reports, hasLength(1));
        expect(sdk.reports.single.errorType.name, 'stateError');
      });

      testWidgets(
        '${w.key}: yalnız zaman aşımı, yazı sonra başarılı => rapor 0',
        (tester) async {
          final store = _GatedStore(fails: false);
          unawaited(w.value(store));
          await tester.pump(const Duration(milliseconds: 501));
          store.gate.complete();
          await tester.pump(const Duration(seconds: 1));
          expect(sdk.reports, isEmpty);
        },
      );
    }
  });
}

/// Tüm yazılar [gate]'e dek bekler; [fails] ise sonra StateError verir.
class _GatedStore extends MemoryPreferenceStore {
  _GatedStore({required this.fails});
  final bool fails;
  final gate = Completer<void>();

  @override
  Future<void> setString(String key, String value) async {
    await gate.future;
    if (fails) throw StateError('gerçek yazı hatası');
    return super.setString(key, value);
  }
}
