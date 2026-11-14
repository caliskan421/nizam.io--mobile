// Denetim bulguları: (2) beklenen alan sonuçları (ExpectedFailure) gerçek sağlayıcı yolunda ve
// üretim gözlemcisinde 0 rapor; (3) Riverpod `ProviderException` bağımlılık sarmalayıcıları asıl
// hata ve özgün yığına iner: beklenen kök => 0, beklenmeyen kök => TEK rapor, sarmalayıcı hiçbir
// zaman ayrı "beklenmeyen" hata olmaz.
import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/telemetry/error_hooks.dart';
import 'package:nizamio/app/telemetry/provider_error_observer.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/unexpected_error.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';
import 'package:nizamio/features/archive/application/archive_image_preview.dart';
import 'package:nizamio/features/assistant/domain/assistant.dart';

import '../../support/fake_error_reporter.dart';

Never _boom() => throw TypeError();

void main() {
  late FakeErrorReporter sdk;
  late ProviderContainer container;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
    container = ProviderContainer(
      retry: (_, _) =>
          null, // Exception türleri varsayılan olarak yeniden denenir
      observers: const [ErrorReportingProviderObserver()],
    );
  });
  tearDown(() {
    container.dispose();
    ErrorReporting.reset();
  });

  Future<void> settle() async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// `a` hata verir; `b` ve `c` zincirle ona bağlıdır (her biri ayrı ProviderException sarar).
  List<FutureProvider<int>> chain(FutureOr<int> Function(Ref) source) {
    final a = FutureProvider<int>((ref) async => source(ref));
    final b = FutureProvider<int>((ref) => ref.watch(a.future));
    final c = FutureProvider<int>((ref) => ref.watch(b.future));
    return [a, b, c];
  }

  group(
    'beklenen alan sonuçları: 0 rapor (gerçek sağlayıcı + üretim gözlemcisi)',
    () {
      for (final (name, make) in <(String, Object Function())>[
        ('ActivityUnavailable', () => const ActivityUnavailable()),
        ('ArchiveImageTooLarge', () => const ArchiveImageTooLarge()),
        ('AssistantDisabled', () => const AssistantDisabled()),
      ]) {
        test(name, () async {
          final [a, b, c] = chain(
            (_) => Error.throwWithStackTrace(make(), StackTrace.current),
          );
          container.listen(c, (_, _) {});
          container.listen(a, (_, _) {});
          await settle();
          expect(container.read(a).hasError, isTrue);
          expect(sdk.reports, isEmpty);
        });
      }

      test(
        'yönetici olmayana kapalı işlem geçmişi (ActivityUnavailable) 0 rapor',
        () async {
          final p = FutureProvider<ActivityLog>(
            (ref) => throw const ActivityUnavailable(),
          );
          container.listen(p, (_, _) {});
          await settle();
          expect(container.read(p).error, isA<ActivityUnavailable>());
          expect(sdk.reports, isEmpty);
        },
      );
    },
  );

  group('ProviderException sarmalayıcıları', () {
    test('upstream beklenen ApiError + 2 bağımlı sağlayıcı => 0', () async {
      final [a, b, c] = chain(
        (_) => throw ApiError('identity.credentials_invalid', status: 401),
      );
      container.listen(c, (_, _) {});
      await expectLater(container.read(c.future), throwsA(isA<ApiError>()));
      await settle();
      expect(sdk.reports, isEmpty);
    });

    test('upstream beklenmeyen TypeError + 2 bağımlı => 1 (kök hata, sarmalayıcı değil)', () async {
      final [a, b, c] = chain((_) => _boom());
      container.listen(c, (_, _) {});
      await settle();
      expect(sdk.reports, hasLength(1));
      expect(sdk.reports.single.errorType, ReportErrorType.typeError);
      expect(sdk.reports.single.source, ReportSource.provider);
    });

    test('upstream apiCall zaten raporladı + 2 bağımlı => 1', () async {
      final [a, b, c] = chain((_) => apiCall<int>(() async => _boom()));
      container.listen(c, (_, _) {});
      await settle();
      expect(sdk.reports, hasLength(1));
      expect(sdk.reports.single.kind, ReportKind.invalidResponse);
    });

    test('sarmalayıcı: catch sınırı ve küresel kanca asıl hataya iner', () {
      final a = Provider<int>((ref) => _boom());
      final b = Provider<int>((ref) => ref.watch(a));
      final expected = Provider<int>(
        (ref) => throw ApiError('identity.credentials_invalid', status: 401),
      );
      final eb = Provider<int>((ref) => ref.watch(expected));

      // Gözlemcisiz kap: sarmalayıcıyı yalnız elle üretir, rapor gözlemciden gelmez.
      final plain = ProviderContainer();
      addTearDown(plain.dispose);
      Object wrap(Provider<int> p, StackTrace Function(StackTrace) keep) {
        try {
          plain.read(p);
        } on Object catch (e, st) {
          keep(st);
          return e;
        }
        throw StateError('hata bekleniyordu');
      }

      StackTrace st = StackTrace.empty;
      final wrapperA = wrap(b, (s) => st = s);
      expect(wrapperA, isA<ProviderException>());
      final wrapperE = wrap(eb, (s) => s);
      expect(wrapperE, isA<ProviderException>());

      // Beklenen kök: sarmalayıcı 0 rapor (catch sınırı ve ApiError çevirisi).
      reportUnexpected(wrapperE, st, source: ReportSource.tasks);
      expect(
        toReportedApiError(wrapperE, st, source: ReportSource.tasks).code,
        'identity.credentials_invalid',
      );
      expect(sdk.reports, isEmpty);

      // Beklenmeyen kök: catch sınırı tek rapor; aynı sarmalayıcı küresel kancadan tekrar yok.
      reportUnexpected(wrapperA, st, source: ReportSource.tasks);
      expect(sdk.reports, hasLength(1));
      expect(sdk.reports.single.errorType, ReportErrorType.typeError);

      final savedPlatform = PlatformDispatcher.instance.onError;
      final uninstall = installErrorHooks();
      addTearDown(() {
        uninstall();
        expect(PlatformDispatcher.instance.onError, same(savedPlatform));
      });
      PlatformDispatcher.instance.onError!(wrapperA, st);
      expect(sdk.reports, hasLength(1), reason: 'aynı olay tekrar sayılmaz');
      PlatformDispatcher.instance.onError!(wrapperE, st);
      expect(sdk.reports, hasLength(1), reason: 'beklenen kök 0');
    });
  });
}
