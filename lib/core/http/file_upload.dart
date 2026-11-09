import 'dart:io';

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
  required String requestKey,
  String? subtaskId,
  Map<String, dynamic>? extras,
}) async {
  final form = FormData()
    ..files.add(
      MapEntry('file', await _filePart(filePath, filename, contentType)),
    );
  final r = await dio.post<Object?>(
    '/v1/work-items/${Uri.encodeComponent(workItemId)}/files',
    queryParameters: {'tag': tag, 'subtask_id': ?subtaskId},
    data: form,
    options: Options(
      contentType: 'multipart/form-data',
      // İşlem anahtarı (ADR-0027): aynı yüklemenin tekrarı aynı anahtarla gider.
      headers: {'Idempotency-Key': requestKey},
      extra: extras ?? RecordsClient.attachFileOpenapiExtras,
    ),
  );
  return r.data;
}

/// `sendChatAttachment` (`POST /v1/chats/{chatId}/attachments`) için elle kurulan multipart
/// isteği: sözleşme isteğe bağlı `body` parçasının DOSYADAN ÖNCE gelmesini ister ve sunucu türü
/// parçanın `Content-Type`'ından okur (üretilmiş istemci parça sırasını ve türünü
/// belirleyemez). `client_message_id` sorgudadır; tekrar AYNI kimlik ve aynı dosyayla gider.
/// [extras] üretilmiş `sendChatAttachmentOpenapiExtras` (kapı ve kapsam başlıkları). Dosya
/// içeriği günlüğe yazılmaz. Ham yanıt gövdesini döner.
Future<Object?> postChatAttachment(
  Dio dio, {
  required String chatId,
  required String clientMessageId,
  required String filePath,
  required String filename,
  required String contentType,
  required Map<String, dynamic> extras,
  String? body,
  String? replyToMessageId,
}) async {
  final form = FormData();
  if (body != null && body.isNotEmpty) form.fields.add(MapEntry('body', body));
  form.files.add(
    MapEntry('file', await _filePart(filePath, filename, contentType)),
  );
  final r = await dio.post<Object?>(
    '/v1/chats/${Uri.encodeComponent(chatId)}/attachments',
    queryParameters: {
      'client_message_id': clientMessageId,
      'reply_to_message_id': ?replyToMessageId,
    },
    data: form,
    options: Options(contentType: 'multipart/form-data', extra: Map.of(extras)),
  );
  return r.data;
}

/// Multipart dosya parçası. Seçimden sonra silinmiş ya da okunamayan dosya
/// `client.file_unreadable` olur (ham `FileSystemException` sızmaz, sonuç belirsiz ya da ağ
/// hatası sayılmaz): boyut okunamazsa istek gönderilmeden; içerik akışı gönderim sırasında
/// açılır (Dio `fromFile` de böyle), açılma/okuma hatası akışta [ApiError]'a çevrilir ve
/// `toApiError` onu `DioException.error`'dan aynen döner. Ağ ve TLS hataları etkilenmez.
Future<MultipartFile> _filePart(
  String path,
  String filename,
  String contentType,
) async {
  final file = File(path);
  final int length;
  try {
    length = await file.length();
  } on FileSystemException {
    throw ApiError(ClientErrorCode.fileUnreadable);
  }
  return MultipartFile.fromStream(
    () => file.openRead().handleError(
      (Object _) => throw ApiError(ClientErrorCode.fileUnreadable),
      test: (e) => e is FileSystemException,
    ),
    length,
    filename: filename,
    contentType: DioMediaType.parse(contentType),
  );
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
