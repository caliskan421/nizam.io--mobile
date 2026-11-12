// Geri alma (`false`) isteği şeridi İSTEK anında kilitler: `false` yazısı + silme ikisi de
// başarısız olunca kayıttaki fiziksel `true` bu süreçte HİÇ okunmaz (gönderim 0); yalnız başarılı
// `false`/silme ya da geçerli yeni açık onay kilidi kaldırır.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/error_reporting_controller.dart';

import '../../support/fake_error_reporter.dart';

/// Ortak FİZİKSEL depo: yazma/silme hatası ya da `false` yazısını bekletme.
class _PhysicalStore extends MemoryPreferenceStore {
  _PhysicalStore() {
    values[AppPreferences.errorReportingKey] = 'true';
  }

  bool failWrites = false;
  Completer<void>? hangFalse;
  var reads = 0;

  @override
  Future<String?> getString(String key) {
    reads++;
    return super.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    if (value == 'false' && hangFalse != null) await hangFalse!.future;
    if (failWrites) throw StateError('yazma hatası (benzetim)');
    return super.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    if (hangFalse != null) await hangFalse!.future;
    if (failWrites) throw StateError('silme hatası (benzetim)');
    return super.remove(key);
  }

  String? get stored => values[AppPreferences.errorReportingKey];
}

void main() {
  late _PhysicalStore store;
  late FakeErrorReporter sdk;

  setUp(() {
    store = _PhysicalStore();
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
  });
  tearDown(ErrorReporting.reset);

  ErrorReportingController make(FakeErrorReporter s) {
    final c = ErrorReportingController(
      AppPreferences(store),
      s,
      sdkTimeout: const Duration(milliseconds: 200),
    );
    addTearDown(c.dispose);
    return c;
  }

  test(
    'false yazısı + silme başarısız: aynı süreçte yeni/aynı denetleyici load '
    'fiziksel true\'yu okuyup göndermez; state kapalı',
    () async {
      final c = make(sdk);
      await c.load();
      expect(sdk.calls, ['send']);
      expect(c.state.value, isTrue);

      store.failWrites = true;
      await c.set(false);
      expect(c.notice.value, ReportingNotice.revokeNotPersisted);
      expect(c.state.value, isFalse);
      expect(store.stored, 'true', reason: 'fiziksel kayıt bayat true');

      sdk.calls.clear();
      await c.load(); // aynı denetleyici
      expect(sdk.calls, isNot(contains('send')));
      expect(c.state.value, isFalse);

      final freshSdk = FakeErrorReporter();
      final fresh = make(freshSdk); // yeni örnek, küresel kimlik
      await fresh.load();
      expect(freshSdk.calls, isNot(contains('send')));
      expect(fresh.state.value, isFalse);
    },
  );

  test('başarılı geri alma kilidi kaldırır; ardından yeni açık geçerli onay '
      'etkin olur (gönderim 1)', () async {
    final c = make(sdk);
    await c.load();
    store.failWrites = true;
    await c.set(false);
    store.failWrites = false;
    await c.set(false); // başarılı: kilit kalkar
    expect(store.stored, 'false');

    final newSdk = FakeErrorReporter();
    final fresh = make(newSdk);
    expect(await fresh.set(true), isTrue);
    expect(store.stored, 'true');
    expect(fresh.state.value, isTrue);

    final again = FakeErrorReporter();
    final reload = make(again);
    await reload.load();
    expect(again.calls.where((e) => e == 'send').length, 1);
  });

  test(
    'fiziksel yazı belirsiz (500 ms false ACK yok): okuma false, gönderim 0, '
    'güvensiz açık yok',
    () async {
      final c = make(sdk);
      await c.load();
      sdk.calls.clear();
      store.hangFalse = Completer<void>();

      await c.set(false); // set(false)+remove 500 ms zaman aşımları
      expect(c.state.value, isFalse);

      final freshSdk = FakeErrorReporter();
      final fresh = make(freshSdk);
      await fresh.load();
      expect(freshSdk.calls, isNot(contains('send')));
      expect(fresh.state.value, isFalse);
      expect(sdk.calls, isNot(contains('send')));

      // Fiziksel yazılar sonunda hata verir: kilit kalır.
      store.failWrites = true;
      store.hangFalse!.complete();
      await pumpEventQueue();
      final late = FakeErrorReporter();
      final lateC = make(late);
      await lateC.load();
      expect(late.calls, isNot(contains('send')));
      expect(lateC.state.value, isFalse);
    },
  );
}
