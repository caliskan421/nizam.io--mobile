// Yerel depo yolları (tercih, kapsam, güvenli depo): bilinçli "varsayılana dön" yolları artık
// sebebi rapor eder (kaynak preferences/scope/session …); davranış (varsayılan değer, yeniden
// giriş) değişmez. Zaman aşımı rapor üretmez; rıza kapalıyken hiçbir şey SDK ya gitmez.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/scope/scope_store.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';

import '../../support/fake_error_reporter.dart';

class _TimeoutStore extends MemoryPreferenceStore {
  @override
  Future<String?> getString(String key) =>
      Future.error(TimeoutException('yavaş'));
}

void main() {
  late FakeErrorReporter sdk;
  late MemoryPreferenceStore store;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
    store = MemoryPreferenceStore();
  });
  tearDown(ErrorReporting.reset);

  test('tercih okunamadı: varsayılan döner ve sebep TEK rapor (kaynak preferences)', () async {
    store.failAll = true;
    final mode = await AppPreferences(store).themeMode();
    expect(mode, ThemeMode.system, reason: 'kullanıcıya görünen davranış aynı');
    expect(sdk.reports, hasLength(1));
    final r = sdk.reports.single;
    expect(r.source, ReportSource.preferences);
    expect(r.errorType, ReportErrorType.stateError);
    expect(r.message, contains('Beklenmeyen'));
  });

  test('tercih yazılamadı: sessiz kalır ama raporlanır', () async {
    store.failAll = true;
    await AppPreferences(store).setThemeMode(ThemeMode.dark);
    expect(sdk.reports.single.source, ReportSource.preferences);
  });

  test('zaman aşımı beklenen durumdur: rapor yok, varsayılan döner', () async {
    final mode = await AppPreferences(_TimeoutStore()).themeMode();
    expect(mode, ThemeMode.system);
    expect(sdk.reports, isEmpty);
  });

  test('sağlıklı depo rapor üretmez', () async {
    final p = AppPreferences(store);
    await p.setThemeMode(ThemeMode.dark);
    expect(await p.themeMode(), ThemeMode.dark);
    expect(sdk.reports, isEmpty);
  });

  test('rıza kapalı: depo arızası SDK ya hiçbir şey vermez', () async {
    ErrorReporting.setEnabled(false);
    store.failAll = true;
    await AppPreferences(store).themeMode();
    expect(sdk.reports, isEmpty);
  });

  test(
    'bozuk kapsam kaydı: null döner, bozulma raporlanır (içerik girmez)',
    () async {
      final secure = MemorySecureStore();
      final scope = ScopeStore(secure);
      await secure.write(ScopeStore.key, '{bozuk Gizli-Kayit');
      expect(await scope.load(), isNull);
      expect(sdk.reports, hasLength(1));
      final r = sdk.reports.single;
      expect(r.source, ReportSource.scope);
      final wire = '${r.label}\n${r.message}\n${r.stack}';
      expect(wire, isNot(contains('Gizli')));
    },
  );
}
