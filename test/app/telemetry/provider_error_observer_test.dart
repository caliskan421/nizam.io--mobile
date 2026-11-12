import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/telemetry/provider_error_observer.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/unexpected_error.dart';

import '../../support/fake_error_reporter.dart';

/// `AsyncValue.guard` ile durumu AsyncError'a çeviren denetleyici (login/parola kalıbı).
class _GuardNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() => 0;

  Future<void> run(Object error) async {
    state = await AsyncValue.guard<int>(
      () async => Error.throwWithStackTrace(error, StackTrace.current),
    );
  }

  /// Sınırda raporlanıp ApiError'a çevrilir; sonra durum AsyncError olur.
  Future<void> runReported(Object error) async {
    state = await AsyncValue.guard<int>(() async {
      try {
        Error.throwWithStackTrace(error, StackTrace.current);
      } on Object catch (e, st) {
        throw toReportedApiError(e, st, source: ReportSource.identity);
      }
    });
  }
}

final _guarded = AsyncNotifierProvider<_GuardNotifier, int>(_GuardNotifier.new);
final _buildFails = FutureProvider<int>((ref) async => throw TypeError());
final _streamFails = StreamProvider<int>(
  (ref) => Stream<int>.error(StateError('akış')),
);
final _expectedFails = FutureProvider<int>(
  (ref) async => throw ApiError('identity.credentials_invalid', status: 401),
);

void main() {
  late FakeErrorReporter sdk;
  late ProviderContainer container;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
    container = ProviderContainer(
      observers: const [ErrorReportingProviderObserver()],
    );
  });
  tearDown(() {
    container.dispose();
    ErrorReporting.reset();
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test(
    'provider build hatası TEK rapor: kaynak provider, işlem none',
    () async {
      container.listen(_buildFails, (_, _) {});
      await settle();
      expect(sdk.reports, hasLength(1));
      final r = sdk.reports.single;
      expect(r.source, ReportSource.provider);
      expect(r.errorType, ReportErrorType.typeError);
      expect(r.operation, ReportOperation.none);
      expect(
        r.message,
        'Yerel veri ayrıştırılırken ya da eşlenirken tür/biçim hatası oluştu. '
        'Tür hatası.',
      );
    },
  );

  test('stream hatası raporlanır', () async {
    container.listen(_streamFails, (_, _) {});
    await settle();
    expect(sdk.reports.single.errorType, ReportErrorType.stateError);
  });

  test(
    'AsyncValue.guard ile state=AsyncError gözlemciye düşer (TEK rapor)',
    () async {
      container.listen(_guarded, (_, _) {});
      await container.read(_guarded.future);
      await container.read(_guarded.notifier).run(TypeError());
      await settle();
      expect(container.read(_guarded).hasError, isTrue);
      expect(sdk.reports, hasLength(1));
      expect(sdk.reports.single.source, ReportSource.provider);
    },
  );

  test('catch sınırında raporlanan hata gözlemcide TEKRARLANMAZ', () async {
    container.listen(_guarded, (_, _) {});
    await container.read(_guarded.future);
    await container.read(_guarded.notifier).runReported(TypeError());
    await settle();
    expect(container.read(_guarded).hasError, isTrue);
    expect(sdk.reports, hasLength(1));
    expect(sdk.reports.single.source, ReportSource.identity);
  });

  test(
    'beklenen hata (ApiError 401, doğrulama, iptal) rapor üretmez',
    () async {
      container.listen(_expectedFails, (_, _) {});
      container.listen(_guarded, (_, _) {});
      await container.read(_guarded.future);
      await container
          .read(_guarded.notifier)
          .run(ApiError(ClientErrorCode.networkError));
      await settle();
      expect(sdk.reports, isEmpty);
    },
  );

  test('rıza kapalıyken hiçbir şey SDK ya verilmez', () async {
    ErrorReporting.setEnabled(false);
    container.listen(_buildFails, (_, _) {});
    await settle();
    expect(sdk.reports, isEmpty);
  });
}
