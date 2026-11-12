// Asistan SSE hata yolları rapor sahibi: null gövde, bitti/hata olmadan kapanış, şema dışı olay,
// beklenmeyen akış hatası → TEK rapor (kaynak assistant, işlem assistant_chat, API işlem kimliği
// assistantChat). Soru metni ve olay yükü rapora hiçbir koşulda girmez; ağ kopması rapor üretmez.
import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/features/assistant/data/assistant_api_repository.dart';
import 'package:nizamio/features/assistant/domain/assistant.dart';

import '../../../support/fake_error_reporter.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body);
  final ResponseBody Function() body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await requestStream?.drain<void>();
    return body();
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _sse(String text, {Exception? errorAtEnd}) {
  Stream<Uint8List> s() async* {
    yield Uint8List.fromList(utf8.encode(text));
    if (errorAtEnd != null) throw errorAtEnd;
  }

  return ResponseBody(
    s(),
    200,
    headers: {
      Headers.contentTypeHeader: ['text/event-stream'],
    },
  );
}

String _ev(String name, Object data) =>
    'event: $name\ndata: ${jsonEncode(data)}\n\n';

const _secretQuestion = AssistantQuestion(text: 'Ali Veli maaşı ne kadar?');

void main() {
  late FakeErrorReporter sdk;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
  });
  tearDown(ErrorReporting.reset);

  Future<Object?> run(ResponseBody Function() body) async {
    final repo = ApiAssistantRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _Adapter(body),
    );
    try {
      await repo.chat(_secretQuestion).toList();
      return null;
    } on Object catch (e) {
      return e;
    }
  }

  void expectOneAssistantReport() {
    expect(sdk.reports, hasLength(1));
    final r = sdk.reports.single;
    expect(r.source, ReportSource.assistant);
    expect(r.operation, ReportOperation.assistantChat, reason: r.label);
    expect(r.apiOperationId, 'assistantChat');
    expect(r.kind, ReportKind.invalidResponse);
    final wire = '${r.label}\n${r.message}\n${r.stack}';
    for (final leak in ['Ali Veli', 'maaş', 'Gizli', 'api.test']) {
      expect(wire, isNot(contains(leak)), reason: leak);
    }
  }

  test('şema dışı olay yükü (eksik/yanlış tipli alan) TEK rapor', () async {
    final e = await run(
      () => _sse(_ev('metin', {'metin': 42, 'gizli': 'Gizli içerik'})),
    );
    expect(e, isA<ApiError>());
    expectOneAssistantReport();
  });

  test('JSON olmayan olay yükü TEK rapor', () async {
    final e = await run(() => _sse('event: metin\ndata: {bozuk Gizli\n\n'));
    expect(e, isA<ApiError>());
    expectOneAssistantReport();
  });

  test('bitti/hata olmadan kapanış (yarım cevap) TEK rapor', () async {
    final e = await run(() => _sse(_ev('metin', {'metin': 'Yarım'})));
    expect(e, isA<ApiError>());
    expectOneAssistantReport();
  });

  test('ağ kopması beklenen durumdur: rapor yok', () async {
    final e = await run(
      () => _sse(
        _ev('metin', {'metin': 'a'}),
        errorAtEnd: const SocketException('kopuk'),
      ),
    );
    expect((e as ApiError).code, 'client.network_error');
    expect(sdk.reports, isEmpty);
  });

  test(
    'bozuk JSON: tür formatException, ayrıştırıcı yığını, TEK olay',
    () async {
      final e = await run(() => _sse('event: metin\ndata: {bozuk Gizli\n\n'));
      expect(e, isA<ApiError>());
      final r = sdk.reports.single;
      expect(r.errorType, ReportErrorType.formatException);
      expect(r.stack.toString(), contains('sseJsonObject'));
      expect(
        '${r.label}\n${r.message}\n${r.stack}',
        isNot(contains('Gizli')),
        reason: 'ham olay verisi gönderilmez',
      );
    },
  );

  group('HTTP 200 akışındaki sunucu `hata` olayı', () {
    Future<void> failure(String code) async {
      final e = await run(
        () => _sse(_ev('hata', {'kod': code, 'mesaj': 'Gizli ileti'})),
      );
      expect(e, isNull, reason: 'AssistantFailure olaydır, istisna değil');
    }

    test(
      'teknik kodlar TEK rapor: durum sınıfı uydurulmaz, ileti yok',
      () async {
        for (final code in [
          'assistant.provider_unavailable',
          'platform.internal',
        ]) {
          sdk.reports.clear();
          ErrorReporting.reset(); // hız sınırı/dedup temiz
          ErrorReporting.attach(sdk).setEnabled(true);
          await failure(code);
          final r = sdk.reports.single;
          expect(r.kind, ReportKind.streamServerError, reason: code);
          expect(r.apiCode, code);
          expect(
            r.statusClass,
            isNull,
            reason: 'gerçek HTTP 200: 5xx uydurulmaz',
          );
          expect(r.source, ReportSource.assistant);
          expect(r.operation, ReportOperation.assistantChat);
          expect(r.apiOperationId, 'assistantChat');
          expect(r.message, isNot(contains('5xx')));
          expect('${r.label}\n${r.message}', isNot(contains('Gizli')));
        }
      },
    );

    test('reddedilen/sınır kodları beklenen: 0 rapor', () async {
      for (final code in ['assistant.limit_exceeded', 'assistant.refused']) {
        await failure(code);
      }
      expect(sdk.reports, isEmpty);
    });

    test('kota/yoğunluk kodları (katalogda 4xx/429) beklenen: 0 rapor', () {
      for (final code in [
        'assistant.quota_exceeded',
        'assistant.busy',
        'assistant.input_invalid',
      ]) {
        reportStreamEventFailure(code);
      }
      expect(sdk.reports, isEmpty);
    });
  });

  test('başarılı akış rapor üretmez', () async {
    final e = await run(
      () => _sse(
        _ev('metin', {'metin': 'a'}) + _ev('bitti', {'sohbet_id': 's1'}),
      ),
    );
    expect(e, isNull);
    expect(sdk.reports, isEmpty);
  });
}
