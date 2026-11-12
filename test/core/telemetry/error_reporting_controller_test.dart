import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/error_reporting_controller.dart';

import '../../support/fake_error_reporter.dart';

/// Okunamayan ama yazılabilen depo.
class _UnreadableStore extends MemoryPreferenceStore {
  @override
  Future<String?> getString(String key) async => throw StateError('okunamaz');
}

/// Yazılamayan (yazma ve silme) ama okunabilen depo.
class _UnwritableStore extends MemoryPreferenceStore {
  @override
  Future<void> setString(String key, String value) async =>
      throw StateError('yazılamaz');

  @override
  Future<void> remove(String key) async => throw StateError('silinemez');
}

/// Yazılamayan ama silinebilen depo.
class _RemovableStore extends MemoryPreferenceStore {
  @override
  Future<void> setString(String key, String value) async =>
      throw StateError('yazılamaz');
}

void report() => ErrorReporting.report(
  TypeError(),
  StackTrace.current,
  kind: ReportKind.unexpected,
);

void main() {
  late MemoryPreferenceStore store;
  late FakeErrorReporter sdk;

  ErrorReportingController build([MemoryPreferenceStore? s]) {
    store = s ?? MemoryPreferenceStore();
    final c = ErrorReportingController(
      AppPreferences(store),
      sdk,
      sdkTimeout: const Duration(milliseconds: 200),
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
  });
  tearDown(ErrorReporting.reset);

  test(
    'kayıt yokken kapalı: bekleyen raporlar SİLİNİR, hiçbiri gönderilmez',
    () async {
      final c = build();
      await c.load();
      expect(c.state.value, isFalse);
      expect(ErrorReporting.enabled, isFalse);
      expect(sdk.calls, ['discard']);
      report();
      expect(sdk.reports, isEmpty);
    },
  );

  test('okunamayan tercih onay sayılmaz', () async {
    final c = build(_UnreadableStore());
    await c.load();
    expect(c.state.value, isFalse);
    expect(sdk.calls, ['discard']);
    report();
    expect(sdk.reports, isEmpty);
  });

  test('bozuk değer onay değildir', () async {
    final c = build(
      MemoryPreferenceStore()
        ..values[AppPreferences.errorReportingKey] = 'evet',
    );
    await c.load();
    expect(c.state.value, isFalse);
    expect(sdk.calls, ['discard']);
  });

  test('kayıtlı onay: önceki oturum raporları AÇIKÇA gönderilir, sonra kapı açılır', () async {
    final c = build(
      MemoryPreferenceStore()
        ..values[AppPreferences.errorReportingKey] = 'true',
    );
    await c.load();
    expect(sdk.calls, ['send']);
    expect(c.state.value, isTrue);
    report();
    expect(sdk.reports, hasLength(1));
  });

  test(
    'gönderim SDK hatası/zaman aşımı kapıyı bozmaz, uygulama açılır',
    () async {
      final c = build(
        MemoryPreferenceStore()
          ..values[AppPreferences.errorReportingKey] = 'true',
      );
      sdk.sdkGate = Completer<void>().future; // hiç dönmez
      await c.load();
      expect(c.state.value, isTrue);
    },
  );

  test('açma: tercih yazılır, kapı açılır; SDK ya dokunulmaz (otomatik toplama kapalı)', () async {
    final c = build();
    await c.load();
    sdk.calls.clear();
    expect(await c.set(true), isTrue);
    expect(store.values[AppPreferences.errorReportingKey], 'true');
    expect(sdk.calls, isEmpty);
    expect(c.notice.value, ReportingNotice.none);
    report();
    expect(sdk.reports, hasLength(1));
  });

  test('tercih yazılamazsa AÇILMAZ ve kullanıcıya bildirilir', () async {
    final c = build(_UnwritableStore());
    await c.load();
    expect(await c.set(true), isFalse);
    expect(ErrorReporting.enabled, isFalse);
    expect(c.notice.value, ReportingNotice.enableFailed);
    report();
    expect(sdk.reports, isEmpty);
  });

  test(
    'geri alma: kapı hemen kapanır, kayıt false olur, bekleyenler silinir',
    () async {
      final c = build();
      await c.load();
      await c.set(true);
      final off = c.set(false);
      expect(ErrorReporting.enabled, isFalse); // await edilmeden kapalı
      report();
      expect(sdk.reports, isEmpty);
      expect(await off, isFalse);
      expect(store.values[AppPreferences.errorReportingKey], 'false');
      expect(sdk.calls.last, 'discard');
      expect(c.notice.value, ReportingNotice.none);
    },
  );

  test(
    'geri alma yazılamazsa kaydı siler; silinirse başarılı sayılır',
    () async {
      final c = build(
        _RemovableStore()..values[AppPreferences.errorReportingKey] = 'true',
      );
      ErrorReporting.attach(sdk);
      expect(await c.set(false), isFalse);
      expect(
        store.values.containsKey(AppPreferences.errorReportingKey),
        isFalse,
      );
      expect(c.notice.value, ReportingNotice.none);
    },
  );

  test('geri alma ne yazılır ne silinirse: oturumda kapalı, KALICILIK YOK bildirilir', () async {
    final c = build(
      _UnwritableStore()..values[AppPreferences.errorReportingKey] = 'true',
    );
    expect(await c.set(false), isFalse);
    expect(ErrorReporting.enabled, isFalse);
    expect(c.notice.value, ReportingNotice.revokeNotPersisted);
    // Aynı süreçte şerit kilitli: fiziksel bayat `true` okunmaz (yeniden başlatmada geri gelebilir,
    // bu yüzden bildirim gösterilir).
    final next = ErrorReportingController(AppPreferences(store), sdk);
    addTearDown(next.dispose);
    await next.load();
    expect(next.state.value, isFalse);
  });

  test(
    'açılırken hemen geri alma: yazması geç biten eski istek kapıyı açmaz',
    () async {
      final slow = _SlowWriteStore();
      final c = build(slow);
      await c.load();
      final on = c.set(true);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final off = c.set(false);
      slow.release();
      await Future.wait([on, off]);
      expect(ErrorReporting.enabled, isFalse);
      expect(c.state.value, isFalse);
      expect(store.values[AppPreferences.errorReportingKey], 'false');
    },
  );

  test(
    'raporlayıcı kullanılamıyorsa (prod, geç/başarısız başlatma) açılamaz',
    () async {
      sdk.available = false;
      final c = build();
      expect(c.available, isFalse);
      await c.load();
      expect(await c.set(true), isFalse);
      expect(
        store.values.containsKey(AppPreferences.errorReportingKey),
        isFalse,
      );
      expect(ErrorReporting.enabled, isFalse);
      expect(sdk.calls, isEmpty);
    },
  );

  test(
    'dispose: kapıyı kapatır, raporlayıcıyı ayırır; başka bileşimi bozmaz',
    () async {
      final c = build(
        MemoryPreferenceStore()
          ..values[AppPreferences.errorReportingKey] = 'true',
      );
      await c.load();
      expect(ErrorReporting.enabled, isTrue);
      final other = FakeErrorReporter();
      ErrorReporting.attach(other);
      ErrorReporting.setEnabled(true);
      c.dispose();
      expect(ErrorReporting.enabled, isTrue); // yeni bileşimin bağı bozulmadı
      report();
      expect(other.reports, hasLength(1));
      expect(sdk.reports, isEmpty);
    },
  );

  group('son inceleme', () {
    test(
      'tercih okunurken geri alma: eski true ile GÖNDERİM yapılmaz',
      () async {
        final gated = _GatedReadStore()
          ..values[AppPreferences.errorReportingKey] = 'true';
        final c = build(gated);
        final loading = c.load();
        await Future<void>.delayed(const Duration(milliseconds: 20));
        final off = c.set(false); // okuma sürerken
        gated.release();
        await Future.wait([loading, off]);
        expect(sdk.calls, isNot(contains('send')));
        expect(ErrorReporting.enabled, isFalse);
        expect(c.state.value, isFalse);
      },
    );

    test('açılışta silme hatası: kullanıcı açınca yeniden dener, belirsizse AÇMAZ/YAZMAZ', () async {
      final c = build();
      sdk.discardThrows = StateError('silinemedi');
      await c.load();
      expect(sdk.calls, ['discard']);
      expect(await c.set(true), isFalse);
      expect(sdk.calls, [
        'discard',
        'discard',
      ], reason: 'açık eylemde bir kez yeniden');
      expect(c.notice.value, ReportingNotice.enableFailed);
      expect(
        store.values.containsKey(AppPreferences.errorReportingKey),
        isFalse,
      );
      expect(ErrorReporting.enabled, isFalse);
      // Silme başarılı olunca grant tamamlanır; yeniden başlatmada yalnız gönderim olur.
      sdk.discardThrows = null;
      expect(await c.set(true), isTrue);
      expect(store.values[AppPreferences.errorReportingKey], 'true');
      sdk.calls.clear();
      final restarted = ErrorReportingController(AppPreferences(store), sdk);
      addTearDown(restarted.dispose);
      await restarted.load();
      expect(sdk.calls, ['send']);
    });

    test('silme zaman aşımı (belirsiz): onay yazılmaz, kapı açılmaz', () async {
      final c = build();
      sdk.discardGate = Completer<void>().future; // hiç dönmez
      await c.load();
      expect(await c.set(true), isFalse);
      expect(c.notice.value, ReportingNotice.enableFailed);
      expect(
        store.values.containsKey(AppPreferences.errorReportingKey),
        isFalse,
      );
      report();
      expect(sdk.reports, isEmpty);
    });

    test('eski bileşimin geç load/set sonucu yeni bağın kapısını değiştirmez', () async {
      final gated = _GatedReadStore()
        ..values[AppPreferences.errorReportingKey] = 'true';
      final old = build(gated);
      final oldLoading = old.load();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      // Yeni bileşim bağlanır ve kapıyı kendi kararına göre kurar (onay yok → kapalı).
      final newSdk = FakeErrorReporter();
      final fresh = ErrorReportingController(
        AppPreferences(MemoryPreferenceStore()),
        newSdk,
        sdkTimeout: const Duration(milliseconds: 200),
      );
      addTearDown(fresh.dispose);
      await fresh.load();
      expect(await fresh.set(true), isTrue);
      expect(ErrorReporting.enabled, isTrue);
      gated.release(); // eski load şimdi bitiyor: kendi kapısını açmaya çalışır
      await oldLoading;
      expect(old.state.value, isFalse);
      expect(
        await old.set(false),
        isFalse,
      ); // eski set(false) yeni kapıyı kapatmaz
      expect(ErrorReporting.enabled, isTrue);
      report();
      expect(newSdk.reports, hasLength(1));
      expect(sdk.reports, isEmpty);
    });

    test('SDK send kapısında bekleyen eski load: set(false) ortak şeridi HEMEN kapatır', () async {
      final shared = MemoryPreferenceStore()
        ..values[AppPreferences.errorReportingKey] = 'true';
      final gate = Completer<void>();
      sdk.sdkGate = gate.future;
      final old = ErrorReportingController(
        AppPreferences(shared),
        sdk,
        sdkTimeout: const Duration(seconds: 5),
      );
      addTearDown(old.dispose);
      final oldLoading = old.load();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(sdk.calls, ['send'], reason: 'eski load SDK kapısında');

      final off = old.set(false); // kuyruk SDK kapısında takılı; await edilmez
      expect(await AppPreferences(shared).errorReportingConsent(), isFalse);

      final newSdk = FakeErrorReporter();
      final fresh = ErrorReportingController(
        AppPreferences(shared),
        newSdk,
        sdkTimeout: const Duration(milliseconds: 200),
      );
      addTearDown(fresh.dispose);
      await fresh.load();
      expect(newSdk.calls, ['discard'], reason: 'yeni load send çağırmaz');
      expect(fresh.state.value, isFalse);

      gate.complete(); // eski kuyruk çözülür; bayat false dalı sahiplik yüzünden atlanır
      await Future.wait([oldLoading, off]);
      expect(shared.values[AppPreferences.errorReportingKey], 'true');
      expect(await AppPreferences(shared).errorReportingConsent(), isFalse);
      expect(ErrorReporting.enabled, isFalse);
      expect(newSdk.calls, ['discard']);
    });

    test(
      'sahipliği zaten kaybolmuş eski set(false) yeni geçerli onayı kapatmaz',
      () async {
        final shared = MemoryPreferenceStore();
        final old = ErrorReportingController(
          AppPreferences(shared),
          sdk,
          sdkTimeout: const Duration(milliseconds: 200),
        );
        addTearDown(old.dispose);
        await old.load();
        final newSdk = FakeErrorReporter();
        final fresh = ErrorReportingController(
          AppPreferences(shared),
          newSdk,
          sdkTimeout: const Duration(milliseconds: 200),
        );
        addTearDown(fresh.dispose);
        await fresh.load();
        expect(await fresh.set(true), isTrue);

        await old.set(false);
        expect(shared.values[AppPreferences.errorReportingKey], 'true');
        expect(await AppPreferences(shared).errorReportingConsent(), isTrue);
        expect(ErrorReporting.enabled, isTrue);
      },
    );
  });
}

/// Tercih OKUMASI [release] çağrılana dek bekler (okuma sürerken geri alma benzetimi).
class _GatedReadStore extends MemoryPreferenceStore {
  final _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<String?> getString(String key) async {
    await _gate.future;
    return super.getString(key);
  }
}

/// `true` yazısı [release] çağrılana dek bekler (yazma gecikmesi benzetimi).
class _SlowWriteStore extends MemoryPreferenceStore {
  final _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<void> setString(String key, String value) async {
    if (value == 'true') await _gate.future;
    return super.setString(key, value);
  }
}
