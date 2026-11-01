import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../api/generated/clients/records_client.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import 'sse.dart';

/// `downloadFile` (`GET /v1/files/{id}/download`) için AKIŞLI indirme: yanıt
/// `ResponseType.stream` ile okunur ve gövde parça parça döner — dosya belleğe toplanmaz
/// (çağıran akışı doğrudan diske yazar). Yol, yöntem ve operationId (`extras`, varsayılan
/// [RecordsClient.downloadFileOpenapiExtras]) üretilmiş istemciyle aynıdır: sözleşme kapısı,
/// kapsam başlıkları ve kimlik halkası (401 → yenileme → tek tekrar) aynen uygulanır.
///
/// Hata: 2xx dışı yanıtın akış gövdesi zarf olarak çözülür ([streamApiError]; kod, durum,
/// `request_id`). Akış sırasında kopan bağlantı `client.network_error` olur. Dosya içeriği
/// günlüğe yazılmaz.
Future<Stream<List<int>>> getFileStream(
  Dio dio, {
  required String fileId,
  Map<String, dynamic>? extras,
}) async {
  final Response<ResponseBody> r;
  try {
    r = await dio.get<ResponseBody>(
      '/v1/files/${Uri.encodeComponent(fileId)}/download',
      options: Options(
        responseType: ResponseType.stream,
        extra: extras ?? RecordsClient.downloadFileOpenapiExtras,
      ),
    );
  } on DioException catch (e) {
    throw await streamApiError(e);
  }
  final body = r.data;
  if (body == null) throw ApiError(ClientErrorCode.invalidResponse);
  return body.stream.transform(
    StreamTransformer<Uint8List, List<int>>.fromHandlers(
      handleError: (_, _, sink) =>
          sink.addError(ApiError(ClientErrorCode.networkError)),
    ),
  );
}
