import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';

// `text/event-stream` (SSE) yanıtları için çekirdek yardımcılar. Üretilmiş istemci SSE ucunu
// (`assistantChat`) tek seferlik `Future<String>` olarak verir; akış ham Dio ile
// `ResponseType.stream` okunur. Feature katmanı `dart:convert` alamaz (sınır kuralı D2), bu
// yüzden UTF-8 çözme, olay çerçeveleme ve JSON çözme burada yapılır.

/// Tek SSE olayı: `event:` adı ve `data:` satırlarının (`\n` ile birleşik) metni.
@immutable
final class SseEvent {
  const SseEvent(this.event, this.data);

  /// `event:` alanı; yoksa SSE varsayılanı `message`.
  final String event;
  final String data;

  @override
  bool operator ==(Object other) =>
      other is SseEvent && other.event == event && other.data == data;

  @override
  int get hashCode => Object.hash(event, data);

  /// Gövde gizli olabilir; yalnız olay adı yazılır.
  @override
  String toString() => 'SseEvent($event)';
}

/// Bayt akışını SSE olaylarına çevirir (WHATWG SSE çerçevelemesi: boş satır olayı bitirir,
/// `:` ile başlayan satır yorumdur, `id`/`retry` yok sayılır, CRLF/LF/CR satır sonu).
/// Parçalar herhangi bir baytta (çok baytlı UTF-8 karakterin ortasında bile) bölünebilir.
/// Akış sonunda bitmemiş (boş satırla kapanmamış) olay atılır. Geçersiz UTF-8 →
/// `FormatException`.
Stream<SseEvent> decodeSse(Stream<List<int>> bytes) async* {
  String? event;
  final data = <String>[];
  await for (final line
      in bytes
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
    if (line.isEmpty) {
      if (data.isNotEmpty) {
        yield SseEvent(event ?? 'message', data.join('\n'));
      }
      event = null;
      data.clear();
      continue;
    }
    if (line.startsWith(':')) continue;
    final colon = line.indexOf(':');
    final field = colon < 0 ? line : line.substring(0, colon);
    var value = colon < 0 ? '' : line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);
    switch (field) {
      case 'event':
        event = value;
      case 'data':
        data.add(value);
    }
  }
}

/// SSE `data:` metnini JSON nesnesine çözer; nesne değilse ya da çözülemezse
/// `client.invalid_response` [ApiError] fırlatır.
Map<String, Object?> sseJsonObject(String data) {
  final Object? decoded;
  try {
    decoded = jsonDecode(data);
  } on FormatException {
    throw ApiError(ClientErrorCode.invalidResponse);
  }
  if (decoded is Map<String, Object?>) return decoded;
  throw ApiError(ClientErrorCode.invalidResponse);
}

/// `ResponseType.stream` isteğinin hatasını [ApiError]'a çevirir. Akış isteğinde 2xx dışı
/// yanıtın gövdesi okunmamış bir [ResponseBody]'dir; hata halkası onu zarf olarak çözemez ve
/// `client.invalid_response` yazar. Burada gövde okunur, JSON zarfı çözülür ve normal
/// [toApiError] kuralıyla (kod, durum, `request_id`, `fields[]`, `Retry-After`) eşlenir.
/// Gövdesi akış olmayan hata (kapı reddi, ağ, TLS, zaman aşımı) [toApiError]'a gider.
Future<ApiError> streamApiError(Object error) async {
  if (error is! DioException) return toApiError(error);
  return toApiError(await materializeStreamError(error));
}

/// Akış isteğinin hatasında okunmamış [ResponseBody] gövdeyi JSON'a çözer ve gövdesi çözülmüş
/// bir `badResponse` hatası döner (hata halkaları ve [toApiError] zarfı okuyabilsin; ör. kimlik
/// halkası 401 `platform.unauthenticated` kodunu görür). Gövdesi akış olmayan hata aynen döner.
Future<DioException> materializeStreamError(DioException error) async {
  final response = error.response;
  final body = response?.data;
  if (response == null || body is! ResponseBody) return error;
  Object? decoded;
  try {
    final text = await utf8.decodeStream(body.stream);
    decoded = text.isEmpty ? null : jsonDecode(text);
  } on Object {
    decoded = null;
  }
  return DioException(
    requestOptions: error.requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: error.requestOptions,
      statusCode: response.statusCode,
      headers: response.headers,
      data: decoded,
    ),
  );
}
