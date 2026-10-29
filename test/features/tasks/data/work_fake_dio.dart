// work servis testlerinin ortak sahte HTTP bağdaştırıcısı (emsal: program_repository_test).
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';

/// Tek yanıtlı sahte bağdaştırıcı; istekleri ve gövdelerini kaydeder.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.body, [this.status = 200]);

  final String body;
  final int status;
  final List<RequestOptions> seen = [];

  RequestOptions get last => seen.single;

  /// Son isteğin JSON gövdesi.
  Object? get sentJson {
    final d = last.data;
    return d is String ? jsonDecode(d) : d;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// [body] yanıtını veren Dio ve bağdaştırıcı.
(Dio, FakeAdapter) fakeDio(Object body, {int status = 200}) {
  final adapter = FakeAdapter(body is String ? body : jsonEncode(body), status);
  return (
    Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter,
    adapter,
  );
}

/// Sunucu hata zarfı.
String errorEnvelope(String code) =>
    jsonEncode({'code': code, 'message': 'x', 'request_id': 'r1'});

/// [code] kodlu [ApiError] bekleyen eşleyici.
Matcher throwsApiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));
