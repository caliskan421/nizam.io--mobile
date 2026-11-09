// Mesajlaşma deposu testlerinin HTTP bağdaştırıcısı: yol → (durum, gövde) ya da akış; görülen
// istekler kaydedilir.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nizamio/features/messages/data/chat_api_repository.dart';

class ChatHttpAdapter implements HttpClientAdapter {
  ChatHttpAdapter(this.routes);

  /// "GET /v1/chats" → (durum, gövde) ya da akış.
  final Map<String, Object> routes;
  final seen = <RequestOptions>[];

  /// İstek gövdesi akışı okunmadan hemen önce çalışır (gönderim sırasındaki yerel hata).
  void Function()? beforeBody;

  RequestOptions only(String method, String path) =>
      seen.singleWhere((o) => o.method == method && o.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    // Gerçek bağdaştırıcı gibi gövde akışı tüketilir (multipart dosyası bu sırada okunur).
    beforeBody?.call();
    await requestStream?.drain<void>();
    final r = routes['${options.method} ${options.path}'];
    if (r is Stream<Uint8List>) {
      return ResponseBody(
        r,
        200,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
    }
    final (status, body) = r is (int, Object?) ? r : (404, null);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiChatRepository, ChatHttpAdapter) chatRepo(Map<String, Object> routes) {
  final a = ChatHttpAdapter(routes);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = a;
  return (ApiChatRepository(() => dio), a);
}

/// Gönderilen JSON gövdesi.
Object? sentJson(RequestOptions o) =>
    o.data is String ? jsonDecode(o.data as String) : o.data;
