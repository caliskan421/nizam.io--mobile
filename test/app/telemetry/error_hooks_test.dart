import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/telemetry/error_hooks.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';

import '../../support/fake_error_reporter.dart';

void main() {
  late FakeErrorReporter sdk;
  late FlutterExceptionHandler? savedFlutter;
  late ErrorCallback? savedPlatform;
  void Function() uninstall = () {};

  setUp(() {
    savedFlutter = FlutterError.onError;
    savedPlatform = PlatformDispatcher.instance.onError;
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk);
  });
  tearDown(() {
    uninstall();
    uninstall = () {};
    ErrorReporting.reset();
    // Kancalar uninstall ile geri geldi mi?
    expect(FlutterError.onError, same(savedFlutter));
    expect(PlatformDispatcher.instance.onError, same(savedPlatform));
  });

  test('kapalıyken kancalar yalnız önceki davranışı çalıştırır', () {
    final seen = <Object>[];
    uninstall = installErrorHooks(
      previousFlutter: (d) => seen.add(d.exception),
      previousPlatform: (e, s) {
        seen.add(e);
        return true;
      },
    );
    FlutterError.onError!(FlutterErrorDetails(exception: StateError('a')));
    final handled = PlatformDispatcher.instance.onError!(
      StateError('b'),
      StackTrace.current,
    );
    expect(seen, hasLength(2));
    expect(handled, isTrue);
    expect(sdk.reports, isEmpty);
  });

  test(
    'çerçeve hatası: fatal değil, ham ayrıntı yok, önceki kanca çağrılır',
    () {
      ErrorReporting.setEnabled(true);
      var previousCalled = false;
      uninstall = installErrorHooks(
        previousFlutter: (_) => previousCalled = true,
      );
      FlutterError.onError!(
        FlutterErrorDetails(
          exception: const FormatException('ali@example.com maaş.pdf'),
          stack: StackTrace.fromString(
            '#0 f (package:nizamio/a.dart:1:2)\n#1 g (file:///Users/ali/x.dart:3:4)',
          ),
          library: 'ali@example.com kütüphanesi',
          context: ErrorDescription('parola=Gizli'),
          informationCollector: () => [ErrorDescription('token=abc')],
        ),
      );
      expect(previousCalled, isTrue);
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.framework);
      expect(r.fatal, isFalse);
      expect(r.errorType, ReportErrorType.formatException);
      final out = wireOf(r);
      for (final leak in [
        'ali@',
        'Users',
        'maaş',
        'Gizli',
        'abc',
        'kütüphanesi',
        'x.dart',
      ]) {
        expect(out, isNot(contains(leak)), reason: leak);
      }
      expect(out, contains('package:nizamio/a.dart:1:2'));
    },
  );

  test('yakalanmamış eşzamansız hata raporlanır; önceki sonuç korunur', () {
    ErrorReporting.setEnabled(true);
    uninstall = installErrorHooks(previousPlatform: (_, _) => true);
    expect(
      PlatformDispatcher.instance.onError!(StateError('x'), StackTrace.current),
      isTrue,
    );
    expect(sdk.reports.single.kind, ReportKind.uncaughtAsync);
    expect(sdk.reports.single.fatal, isFalse);
  });

  test('önceki platform kancası yoksa false: motorun işlenmedi davranışı', () {
    ErrorReporting.setEnabled(true);
    PlatformDispatcher.instance.onError = null;
    uninstall = installErrorHooks();
    expect(
      PlatformDispatcher.instance.onError!(StateError('x'), StackTrace.current),
      isFalse,
    );
    uninstall();
    uninstall = () {};
    PlatformDispatcher.instance.onError =
        savedPlatform; // testin kendi değişikliği
  });

  test('ikinci kurulum sarmalamaz (yığılma yok); ayırıcı geri koyar', () {
    ErrorReporting.setEnabled(true);
    uninstall = installErrorHooks(previousFlutter: (_) {});
    final first = FlutterError.onError;
    final second = installErrorHooks();
    expect(FlutterError.onError, same(first));
    second(); // boş ayırıcı: gerçek kancayı sökmez
    expect(FlutterError.onError, same(first));
    FlutterError.onError!(FlutterErrorDetails(exception: StateError('k')));
    expect(sdk.reports, hasLength(1));
  });

  test('ApiError: beklenmeyen sınıf bir kez, beklenen hiç raporlanmaz', () {
    ErrorReporting.setEnabled(true);
    uninstall = installErrorHooks(
      previousFlutter: (_) {},
      previousPlatform: (_, _) => true,
    );
    PlatformDispatcher.instance.onError!(
      ApiError('identity.credentials_invalid'),
      StackTrace.current,
    );
    expect(sdk.reports, isEmpty);
    final bad = ApiError('client.invalid_response');
    final st = StackTrace.current;
    PlatformDispatcher.instance.onError!(bad, st);
    FlutterError.onError!(FlutterErrorDetails(exception: bad, stack: st));
    expect(sdk.reports, hasLength(1));
  });

  test('aynı hata iki kancadan gelse tek rapor', () {
    ErrorReporting.setEnabled(true);
    uninstall = installErrorHooks(
      previousFlutter: (_) {},
      previousPlatform: (_, _) => true,
    );
    final e = StateError('çift');
    final st = StackTrace.current;
    FlutterError.onError!(FlutterErrorDetails(exception: e, stack: st));
    PlatformDispatcher.instance.onError!(e, st);
    expect(sdk.reports, hasLength(1));
  });
}
