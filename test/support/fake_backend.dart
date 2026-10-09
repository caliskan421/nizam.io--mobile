// Sahte HTTP bağdaştırıcısı: istekleri kaydeder, yanıtı test işleyicisinden üretir.
// Ağa hiç çıkmaz; "istek gönderilmedi" iddiaları [requests] sayısıyla kanıtlanır.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class Seen {
  Seen(this.method, this.path, this.headers, this.body, {this.host = ''});
  final String method;
  final String host;
  final String path;
  final Map<String, Object?> headers;
  final Object? body;

  String? header(String name) {
    for (final e in headers.entries) {
      if (e.key.toLowerCase() == name.toLowerCase()) return e.value?.toString();
    }
    return null;
  }
}

typedef FakeHandler = FutureOr<ResponseBody> Function(Seen req);

ResponseBody jsonResponse(
  int status,
  Object? body, {
  Map<String, List<String>>? headers,
}) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...?headers,
  },
);

ResponseBody envelope(
  int status,
  String code, {
  Map<String, List<String>>? headers,
}) => jsonResponse(status, {
  'code': code,
  'message': 'sunucu iletisi (gösterilmez)',
  'request_id': 'req-$code',
}, headers: headers);

class FakeBackend implements HttpClientAdapter {
  FakeBackend(this.handler);

  FakeHandler handler;
  final List<Seen> requests = [];

  int count(String method, String path) =>
      requests.where((r) => r.method == method && r.path == path).length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? body;
    if (requestStream != null) {
      final bytes = await requestStream.expand((c) => c).toList();
      final text = utf8.decode(bytes);
      body = text.isEmpty ? null : jsonDecode(text);
    }
    final seen = Seen(
      options.method,
      options.uri.path,
      Map.of(options.headers),
      body,
      host: options.uri.host,
    );
    requests.add(seen);
    return handler(seen);
  }

  @override
  void close({bool force = false}) {}
}

/// Geçerli keşif + profil yanıtları.
ResponseBody discoveryHandler(
  Seen r, {
  String minimum = '0.0.0',
  String api = 'v1',
}) {
  switch (r.path) {
    case '/.well-known/nizamio-instance':
      return jsonResponse(200, {
        'product_id': 'nizamio',
        'instance_id': 'inst-1',
        'company_display_name': 'Test',
        'server_version': '0.0.0-test',
        'api_version': api,
        'minimum_mobile_version': '0.0.0',
        'capabilities': null,
      });
    case '/v1/instance/profile':
      return jsonResponse(200, {
        'display_name': 'Test',
        'brand_color': '#1F4E79',
        'timezone': 'Europe/Istanbul',
        'api_version': api,
        'minimum_mobile_version': minimum,
      });
  }
  return envelope(404, 'platform.not_found');
}

/// Sunucunun yanıtını kaybetmesi: istek işlendi, istemci zaman aşımı gördü.
Never timeout(RequestOptions? o) => throw DioException(
  requestOptions: o ?? RequestOptions(),
  type: DioExceptionType.receiveTimeout,
);
