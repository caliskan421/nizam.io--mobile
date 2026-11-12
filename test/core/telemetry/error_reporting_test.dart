import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/file_upload.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/stack_sanitizer.dart';
import 'package:nizamio/core/telemetry/unexpected_error.dart';

import '../../support/fake_error_reporter.dart';

String wire(ErrorReport r) => wireOf(r);

DioException _http(int status, Object? data) {
  final req = RequestOptions(path: '/v1/secret/path/ali@example.com');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: req, statusCode: status, data: data),
  );
}

void main() {
  late FakeErrorReporter sdk;
  var now = DateTime(2026, 11, 12, 10);

  void fresh() {
    ErrorReporting.reset(clock: () => now);
    ErrorReporting.attach(sdk);
  }

  setUp(() {
    now = DateTime(2026, 11, 12, 10);
    sdk = FakeErrorReporter();
    fresh();
  });
  tearDown(ErrorReporting.reset);

  group('onay kapısı', () {
    test('varsayılan kapalı: SDK a hiçbir şey verilmez', () async {
      ErrorReporting.report(
        TypeError(),
        StackTrace.current,
        kind: ReportKind.unexpected,
      );
      await expectLater(
        apiCall<void>(() async => throw TypeError()),
        throwsA(isA<ApiError>()),
      );
      expect(sdk.reports, isEmpty);
    });

    test('raporlayıcı hatası uygulamaya taşmaz ve döngüye girmez', () {
      ErrorReporting.setEnabled(true);
      sdk.recordThrows = StateError('sdk bozuk');
      expect(
        () => ErrorReporting.report(
          TypeError(),
          StackTrace.current,
          kind: ReportKind.unexpected,
        ),
        returnsNormally,
      );
      expect(sdk.reports, hasLength(1));
    });

    test('ayırıcı yalnız kendi bağını sökmez başkasınınkini bozmaz', () {
      final other = FakeErrorReporter();
      final first = ErrorReporting.attach(sdk);
      ErrorReporting.attach(other); // yeni bileşim
      ErrorReporting.setEnabled(true);
      expect(first.setEnabled(false), isFalse); // eski bağ kapıyı değiştiremez
      first.detach(); // eski bileşimin dispose'u: yenisini ezmemeli
      expect(ErrorReporting.enabled, isTrue);
      ErrorReporting.report(
        TypeError(),
        StackTrace.current,
        kind: ReportKind.unexpected,
      );
      expect(other.reports, hasLength(1));
      expect(sdk.reports, isEmpty);
    });
  });

  group('güvenlik', () {
    test('yalnız tanınan yapı geçer; kişisel/tanınmayan satırlar atılır', () {
      ErrorReporting.setEnabled(true);
      const stack = <String>[
        '*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***',
        'Version: 3.9.0 (stable) ali@example.com',
        'pid: 4242, tid: 1, name 1.ui ayse',
        "build_id: 'abcdef0123456789'",
        'os: android arch: arm64 comp: yes sim: no',
        '#00 abs 000000b4b5c3f4f3 virt 00000000003ae4f3 _kDartIsolateSnapshotInstructions+0x1e4f3',
        '#0      Foo.bar (package:nizamio/features/tasks/foo.dart:12:3)',
        '#1      Baz (file:///Users/ali.veli/Projects/maaş-bordrosu.dart:5:1)',
        '#2      Q (/data/user/0/io.nizamio.mobile/files/ayse-cv.dart:9:9)',
        r'#3      R (C:\Users\ayse\proj\z.dart:1:1)',
        '#4      S (https://sunucu.example/v1/me?token=abc123456789:1:1)',
        '#5      T (dart:async/zone.dart:1:1) ali@example.com',
        '#6      U (package:nizamio/maa%C5%9F.dart:1:1)',
        '#7      V (package:nizamio/a.dart?kisi=ali:1:1)',
        '#8      W (package:ali@example.com/a.dart:1:1)',
        '#9      Bearer eyJabc.def.ghi parola=Gizli123',
        'ali@example.com serbest metin',
        '#10     Ok (dart:async/zone.dart:1:1)',
        '<asynchronous suspension>',
      ];
      ErrorReporting.report(
        const FormatException('ali@example.com maaş.pdf'),
        StackTrace.fromString(stack.join('\n')),
        kind: ReportKind.serialization,
        operation: ReportOperation.login,
      );
      expect(sdk.reports.single.stack.toString().split('\n'), [
        '*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***',
        "build_id: 'abcdef0123456789'",
        'os: android arch: arm64 comp: yes sim: no',
        '#00 abs 000000b4b5c3f4f3 virt 00000000003ae4f3 _kDartIsolateSnapshotInstructions+0x1e4f3',
        '#0      Foo.bar (package:nizamio/features/tasks/foo.dart:12:3)',
        '#1 Baz (<local>)',
        '#2 Q (<local>)',
        '#3 R (<local>)',
        '#10     Ok (dart:async/zone.dart:1:1)',
        '<asynchronous suspension>',
      ]);
      final out = wire(sdk.reports.single);
      for (final leak in [
        'ali@',
        'ali.veli',
        'ayse',
        'maaş',
        'sunucu',
        'abc123456789',
        'Gizli',
        'cv.dart',
        'bordrosu',
        '%C5',
        'kisi=',
      ]) {
        expect(out, isNot(contains(leak)), reason: leak);
      }
      expect(sdk.reports.single.errorType, ReportErrorType.formatException);
    });

    test('tanınmayan yığın boş kalmaz: güvenli yer tutucu', () {
      ErrorReporting.setEnabled(true);
      ErrorReporting.report(
        TypeError(),
        StackTrace.fromString('serbest metin ali@example.com'),
        kind: ReportKind.unexpected,
      );
      expect(sdk.reports.single.stack.toString(), '#0 <unknown>');
    });

    test('apiCode yalnız katalog/istemci kodu; durum yalnız sınıf', () {
      for (final code in [
        'Ali Veli <ali@example.com>',
        'identity.ali_veli_x',
        'client.not_a_real_code',
      ]) {
        fresh();
        ErrorReporting.setEnabled(true);
        ErrorReporting.report(
          TypeError(),
          StackTrace.current,
          kind: ReportKind.invalidResponse,
          apiCode: code,
          status: 503,
        );
        expect(sdk.reports.last.apiCode, isNull, reason: code);
        expect(sdk.reports.last.statusClass, '5xx');
      }
      fresh();
      ErrorReporting.setEnabled(true);
      ErrorReporting.report(
        TypeError(),
        StackTrace.current,
        kind: ReportKind.invalidResponse,
        apiCode: ClientErrorCode.invalidResponse,
        status: 9999,
      );
      expect(sdk.reports.last.apiCode, ClientErrorCode.invalidResponse);
      expect(sdk.reports.last.statusClass, isNull);
    });

    test('sanitizeStack satır sayısını sınırlar', () {
      final big = StackTrace.fromString(
        List.generate(400, (i) => '#$i f (package:a/a.dart:1:1)').join('\n'),
      );
      expect(sanitizeStack(big).toString().split('\n'), hasLength(150));
    });
  });

  group('apiCall sınıflandırması', () {
    setUp(() => ErrorReporting.setEnabled(true));

    test('beklenen durumlar raporlanmaz', () async {
      final envelope = {
        'code': 'identity.credentials_invalid',
        'message': 'yanlış parola ali@example.com',
        'request_id': 'r1',
      };
      for (final e in <DioException>[
        _http(401, envelope),
        _http(403, envelope),
        _http(422, envelope),
        _http(409, envelope),
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.connectionTimeout,
        ),
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.connectionError,
        ),
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.cancel,
        ),
      ]) {
        await expectLater(
          apiCall<void>(() async => throw e),
          throwsA(isA<ApiError>()),
        );
      }
      await expectLater(
        apiCall<void>(
          () async => throw ApiError('identity.credentials_invalid'),
        ),
        throwsA(isA<ApiError>()),
      );
      expect(sdk.reports, isEmpty);
    });

    test('beklenmeyen TypeError: raporlanır, özgün yığın korunur', () async {
      Future<void> parseBug() async => throw TypeError();
      ApiError? thrown;
      StackTrace? thrownStack;
      try {
        await ReportContext.run(
          ReportOperation.login,
          () => apiCall<void>(parseBug),
        );
      } on ApiError catch (e, st) {
        thrown = e;
        thrownStack = st;
      }
      expect(thrown?.code, ClientErrorCode.invalidResponse);
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.invalidResponse);
      expect(r.operation, ReportOperation.login);
      expect(r.errorType, ReportErrorType.typeError);
      expect(r.apiCode, ClientErrorCode.invalidResponse);
      expect(r.fatal, isFalse);
      expect(r.stack.toString(), contains('parseBug'));
      expect(thrownStack.toString(), contains('parseBug'));
    });

    test('elle kurulmuş ApiError(invalid_response) apiCall içinde raporlanır; '
        'yukarıda tekrarlanmaz', () async {
      Object? caught;
      try {
        await apiCall<void>(
          () async => decodeJsonObject<void>(<Object?>[1], (_) {}),
        );
      } on ApiError catch (e, st) {
        caught = e;
        // controller sınırı: aynı kök, tek rapor
        reportUnexpected(e, st, source: ReportSource.tasks);
      }
      expect(caught, isA<ApiError>());
      expect(sdk.reports, hasLength(1));
      expect(sdk.reports.single.kind, ReportKind.invalidResponse);
      expect(sdk.reports.single.apiCode, ClientErrorCode.invalidResponse);
    });

    test('apiCall dışı non-map multipart gövdesi raporlanır', () {
      expect(
        () => decodeJsonObject<void>('düz metin', (_) {}),
        throwsA(isA<ApiError>()),
      );
      expect(sdk.reports.single.kind, ReportKind.invalidResponse);
    });

    test('5xx: yalnız durum sınıfı; gövde, yol ve kimlik yok', () async {
      await expectLater(
        apiCall<void>(
          () async => throw _http(503, {
            'code': 'platform.unavailable',
            'message': 'ali@example.com içeriği',
            'request_id': 'REQ-SECRET-77',
          }),
        ),
        throwsA(isA<ApiError>()),
      );
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.serverError);
      expect(r.statusClass, '5xx');
      final out = wire(r);
      for (final leak in ['ali@', 'REQ-SECRET', '/v1/secret', 'içeriği']) {
        expect(out, isNot(contains(leak)));
      }
    });

    test('5xx fırtınası hız sınırına takılır; süre dolunca yeniden', () async {
      Future<void> boom() => apiCall<void>(() async => throw _http(500, null));
      for (var i = 0; i < 10; i++) {
        await expectLater(boom(), throwsA(isA<ApiError>()));
      }
      expect(sdk.reports, hasLength(1));
      now = now.add(ErrorReporting.minInterval + const Duration(seconds: 1));
      await expectLater(boom(), throwsA(isA<ApiError>()));
      expect(sdk.reports, hasLength(2));
    });

    test('oturum başına üst sınır', () {
      for (var i = 0; i < ErrorReporting.sessionCap + 10; i++) {
        ErrorReporting.report(
          TypeError(),
          StackTrace.fromString('#0 f$i (package:a/a$i.dart:1:1)'),
          kind: ReportKind.unexpected,
        );
      }
      expect(sdk.reports, hasLength(ErrorReporting.sessionCap));
    });
  });

  group('işlem bağlamı ve çift rapor', () {
    setUp(() => ErrorReporting.setEnabled(true));

    test('eşzamanlı iki işlem bağlamı karışmaz', () async {
      Future<void> failing(String type, int ms) => apiCall<void>(() async {
        await Future<void>.delayed(Duration(milliseconds: ms));
        if (type == 'a') throw TypeError();
        throw const FormatException();
      });
      await Future.wait(
        [
          ReportContext.run(ReportOperation.login, () => failing('a', 20)),
          ReportContext.run(ReportOperation.fileUpload, () => failing('b', 5)),
        ].map((f) => f.then<void>((_) {}, onError: (Object _) {})),
      );
      final byOp = {for (final r in sdk.reports) r.operation: r.errorType};
      expect(byOp, {
        ReportOperation.login: ReportErrorType.typeError,
        ReportOperation.fileUpload: ReportErrorType.formatException,
      });
      expect(ReportContext.current, ReportOperation.none);
    });

    test('iç bağlam dış bağlamı yalnız none iken değiştirir', () {
      ReportContext.run(ReportOperation.fileUpload, () {
        ReportContext.runIfNone(ReportOperation.taskWrite, () {
          expect(ReportContext.current, ReportOperation.fileUpload);
        });
      });
      ReportContext.runIfNone(ReportOperation.taskWrite, () {
        expect(ReportContext.current, ReportOperation.taskWrite);
      });
    });

    test('fallbackOperation yalnız bağlam yokken; mevcut bağlam korunur', () {
      reportUnexpected(
        StateError('a'),
        StackTrace.current,
        source: ReportSource.tasks,
        fallbackOperation: ReportOperation.taskWrite,
      );
      ReportContext.run(ReportOperation.fileUpload, () {
        reportUnexpected(
          StateError('b'),
          StackTrace.fromString('#0 g (package:a/b.dart:1:1)'),
          source: ReportSource.tasks,
          fallbackOperation: ReportOperation.taskWrite,
        );
      });
      expect(sdk.reports.map((r) => r.operation), [
        ReportOperation.taskWrite,
        ReportOperation.fileUpload,
      ]);
    });

    test('aynı hata nesnesi iki katmanda tek rapor üretir', () {
      final error = StateError('x');
      final st = StackTrace.current;
      ErrorReporting.report(error, st, kind: ReportKind.unexpected);
      reportUnexpected(error, st, source: ReportSource.tasks);
      ErrorReporting.report(error, st, kind: ReportKind.uncaughtAsync);
      expect(sdk.reports, hasLength(1));
      expect(ErrorReporting.alreadyHandled(error), isTrue);
    });

    test('reportUnexpected: beklenen ağ/IO/zaman aşımı atlanır, 5xx Dio raporlanır', () {
      const src = ReportSource.tasks;
      reportUnexpected(ApiError('x.y'), StackTrace.current, source: src);
      reportUnexpected(TimeoutException('t'), StackTrace.current, source: src);
      reportUnexpected(
        const SocketException('x'),
        StackTrace.current,
        source: src,
      );
      expect(sdk.reports, isEmpty);
      reportUnexpected(_http(502, null), StackTrace.current, source: src);
      expect(sdk.reports.single.kind, ReportKind.serverError);
      reportUnexpected(
        const FileSystemException('x'),
        StackTrace.fromString('#0 f (package:a/a.dart:1:1)'),
        source: src,
      );
      expect(sdk.reports.last.kind, ReportKind.storage);
      reportUnexpected(
        const FormatException(),
        StackTrace.fromString('#0 h (package:a/c.dart:1:1)'),
        source: src,
      );
      expect(sdk.reports.last.kind, ReportKind.serialization);
    });
  });
}
