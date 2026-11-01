import 'package:dio/dio.dart';

import '../api/generated/clients/records_client.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';

/// `attachFile` (`POST /v1/work-items/{id}/files`) için elle kurulan multipart isteği — görev
/// kanıtı ve arşiv yüklemesinin TEK yolu. Üretilmiş istemci parçayı `application/octet-stream`
/// bildirir; sunucu türü parçanın `Content-Type`'ından okur ve küme dışını reddeder
/// (records `contentTypeOf`, RECORDS-K03) → üretilmiş çağrıyla her yükleme 422 olurdu.
/// Yol, yöntem ve operationId (`extras`, varsayılan [RecordsClient.attachFileOpenapiExtras])
/// aynıdır: sözleşme kapısı ve kapsam başlıkları aynen uygulanır. [contentType] çağıranın
/// izinli kümeden seçtiği türdür (`uploadContentType`). Dosya içeriği günlüğe yazılmaz.
/// Ham yanıt gövdesini döner (çözümleme [decodeJsonObject] ile).
Future<Object?> postWorkItemFile(
  Dio dio, {
  required String workItemId,
  required String tag,
  required String filePath,
  required String filename,
  required String contentType,
  String? subtaskId,
  Map<String, dynamic>? extras,
}) async {
  final form = FormData()
    ..files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(
          filePath,
          filename: filename,
          contentType: DioMediaType.parse(contentType),
        ),
      ),
    );
  final r = await dio.post<Object?>(
    '/v1/work-items/${Uri.encodeComponent(workItemId)}/files',
    queryParameters: {'tag': tag, 'subtask_id': ?subtaskId},
    data: form,
    options: Options(
      contentType: 'multipart/form-data',
      extra: extras ?? RecordsClient.attachFileOpenapiExtras,
    ),
  );
  return r.data;
}

/// JSON nesne gövdesini [fromJson] ile çözer; nesne değilse `client.invalid_response`.
T decodeJsonObject<T>(
  Object? body,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (body is! Map<String, dynamic>) {
    throw ApiError(ClientErrorCode.invalidResponse);
  }
  return fromJson(body);
}
