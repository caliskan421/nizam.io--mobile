// Denetim bulguları: (6) indirme gövde akışı hatası — beklenmeyen hata özgün hata ve yığınla
// raporlanır, normal taşıma kopması 0; kullanıcıya/yeniden denemeye her durumda `network_error`.
// (8) `streamApiError` özgün istek yığınını ve semantik kaynak/işlemi korur (gövde okuma `await`
// sonrası `StackTrace.current` kullanılmaz).
import 'dart:async';
import 'dart:io' show SocketException;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/file_download.dart';
import 'package:nizamio/core/http/sse.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';

import '../../support/fake_error_reporter.dart';

final _marker = StackTrace.fromString(
  '#0 originalRequestSite (package:nizamio/core/http/marker.dart:7:3)',
);

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body);
  final ResponseBody Function() body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => body();

  @override
  void close({bool force = false}) {}
}

Dio _dio(ResponseBody Function() body) =>
    Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = _Adapter(body);

ResponseBody _bytesThenError(Object error, StackTrace st) {
  Stream<Uint8List> s() async* {
    yield Uint8List.fromList([1, 2, 3]);
    Error.throwWithStackTrace(error, st);
  }

  return ResponseBody(s(), 200);
}

void main() {
  late FakeErrorReporter sdk;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
  });
  tearDown(ErrorReporting.reset);

  group('getBinaryStream gövde akışı hatası', () {
    Future<Object?> drain(Object error) async {
      final dio = _dio(() => _bytesThenError(error, _marker));
      final stream = await getBinaryStream(dio, path: '/v1/x', extras: {});
      try {
        await stream.drain<void>();
        return null;
      } on Object catch (e) {
        return e;
      }
    }

    test('StateError/TypeError beklenmeyen: özgün tür ve yığınla TEK rapor, kullanıcı network_error', () async {
      for (final error in [StateError('bug'), TypeError()]) {
        sdk.reports.clear();
        ErrorReporting.reset();
        ErrorReporting.attach(sdk).setEnabled(true);
        final e = await drain(error);
        expect((e as ApiError).code, ClientErrorCode.networkError);
        final r = sdk.reports.single;
        expect(
          r.errorType,
          error is StateError
              ? ReportErrorType.stateError
              : ReportErrorType.typeError,
        );
        expect(r.stack.toString(), contains('originalRequestSite'));
      }
    });

    test('SocketException / zaman aşımı normal taşıma kopması: 0 rapor, network_error', () async {
      final e = await drain(const SocketException('kopuk'));
      expect((e as ApiError).code, ClientErrorCode.networkError);
      expect(sdk.reports, isEmpty);
      expect(
        ((await drain(TimeoutException('t'))) as ApiError).code,
        ClientErrorCode.networkError,
      );
      expect(sdk.reports, isEmpty);
    });

    test(
      'dönüştürülmüş ApiError tekrar raporlanmaz (üst katman aynı olay)',
      () async {
        final e = await drain(StateError('bug')) as ApiError;
        sdk.reports.clear();
        // Aynı olayın yukarı katmanları: aynı ApiError nesnesi aynı yığınla.
        ErrorReporting.report(e, _marker, kind: ReportKind.unexpected);
        expect(sdk.reports, isEmpty);
      },
    );
  });

  group('streamApiError özgün yığın ve semantik bağlam', () {
    DioException streamed503() {
      final req = RequestOptions(path: '/v1/assistant/chat');
      return DioException(
        requestOptions: req,
        type: DioExceptionType.badResponse,
        response: Response<ResponseBody>(
          requestOptions: req,
          statusCode: 503,
          data: ResponseBody.fromString(
            '{"code":"platform.internal"}',
            503,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          ),
        ),
      );
    }

    test('503 akış isteği: rapordaki yığın çağıranın özgün yığınıdır; kaynak/işlem korunur', () async {
      final api = await streamApiError(
        streamed503(),
        _marker,
        ReportOperation.assistantChat,
        ReportSource.assistant,
      );
      expect(api.status, 503);
      final r = sdk.reports.single;
      expect(r.kind, ReportKind.serverError);
      expect(r.stack.toString(), contains('originalRequestSite'));
      expect(r.stack.toString(), isNot(contains('streamApiError')));
      expect(r.operation, ReportOperation.assistantChat);
      expect(r.source, ReportSource.assistant);
    });

    test(
      'yığın verilmezse çağrı yerine düşer (geriye uyum), rapor yine tek',
      () async {
        await streamApiError(streamed503());
        expect(sdk.reports, hasLength(1));
      },
    );
  });
}
