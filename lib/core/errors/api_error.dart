import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../api/generated/error_catalog.gen.dart';
import '../api/generated/models/error_envelope.dart';
import '../api/generated/models/field_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';

/// Alan doğrulama hatası (sunucu zarfının `fields[]` öğesi; üretilmiş DTO'dan eşlenir —
/// sınır kuralı A3). Sunucunun `message` metni taşınmaz: metin `code`'dan ARB ile gelir.
@immutable
final class ApiFieldError {
  const ApiFieldError({required this.field, required this.code});

  final String field;
  final String code;
}

/// Uygulamanın tek hata biçimi (F14 kapsam 6–7): `{code, messageKey, requestId, fields[]}`.
/// Sunucunun `message` alanı kullanıcıya gösterilmez; metin `code`'dan ARB ile gelir.
class ApiError implements Exception {
  ApiError(
    this.code, {
    this.requestId,
    this.fields = const [],
    this.status,
    this.retryAfter,
  });

  /// Kararlı kod: sunucu kataloğu (`identity.credentials_invalid`) ya da `client.*`.
  final String code;
  final String? requestId;
  final List<ApiFieldError> fields;
  final int? status;

  /// 429 yanıtının `Retry-After` süresi. Otomatik yeniden deneme yapılmaz; çağıran karar verir.
  final Duration? retryAfter;

  /// i18n anahtarı (katalogdaki `message_key`; istemci kodlarında `errors.<kod>`).
  String get messageKey => errorCatalog[code]?.messageKey ?? 'errors.$code';

  /// Kod sunucu kataloğunda mı (yeni etiketin bilinmeyen kodu → false; metin genel metne düşer).
  bool get isKnown =>
      errorCatalog.containsKey(code) || ClientErrorCode.all.contains(code);

  /// Gizli veri taşımaz (belirteç, gövde, iç istisna yoktur).
  @override
  String toString() =>
      'ApiError($code${status == null ? '' : ', $status'}${requestId == null ? '' : ', request_id=$requestId'})';
}

/// Dio hatasını [ApiError]'a çevirir. TLS hatası AYRI koddur ve asla ağ hatasına
/// indirgenmez/yutulmaz (ADR-0008, K-11).
ApiError toApiError(Object error) {
  if (error is ApiError) return error;
  if (error is! DioException) return ApiError(ClientErrorCode.invalidResponse);
  final inner = error.error;
  if (inner is ApiError) return inner;
  if (error.type == DioExceptionType.badCertificate ||
      inner is HandshakeException ||
      inner is TlsException ||
      inner is CertificateException) {
    return ApiError(ClientErrorCode.tlsError);
  }
  // 2xx yanıt geldi ama dio beklenen tipe dönüştüremedi (ör. nesne yerine liste): geçersiz yanıt.
  if (error.type == DioExceptionType.unknown &&
      (error.response != null ||
          inner is TypeError ||
          inner is FormatException)) {
    return ApiError(
      ClientErrorCode.invalidResponse,
      status: error.response?.statusCode,
    );
  }
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return ApiError(ClientErrorCode.timeout);
    case DioExceptionType.badResponse:
      return _fromResponse(error.response);
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
    case DioExceptionType.badCertificate:
      return ApiError(ClientErrorCode.networkError);
  }
}

ApiError _fromResponse(Response<Object?>? response) {
  final status = response?.statusCode;
  final data = response?.data;
  Duration? retryAfter;
  final ra = int.tryParse(response?.headers.value('retry-after') ?? '');
  if (ra != null && ra >= 0) retryAfter = Duration(seconds: ra);
  if (data is Map<String, Object?>) {
    try {
      final env = ErrorEnvelope.fromJson(data);
      return ApiError(
        env.code,
        requestId: env.requestId,
        fields: [
          for (final f in env.fields ?? const <FieldError>[])
            ApiFieldError(field: f.field, code: f.code),
        ],
        status: status,
        retryAfter: retryAfter,
      );
    } on Object {
      // Zarf biçiminde değil → aşağıda invalid_response.
    }
  }
  return ApiError(
    ClientErrorCode.invalidResponse,
    status: status,
    requestId: response?.headers.value('x-request-id'),
  );
}

/// Üretilmiş istemci çağrısını sarar: her hata [ApiError] olarak fırlatılır. 2xx gövdesi
/// üretilmiş DTO'ya ayrıştırılamazsa (TypeError, FormatException, CheckedFromJsonException …)
/// `client.invalid_response` olur — ayrıştırma hatası hiçbir zaman ham sızmaz (CX-Ö-01).
Future<T> apiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on ApiError {
    rethrow;
  } on DioException catch (e) {
    throw toApiError(e);
  } on Object {
    throw ApiError(ClientErrorCode.invalidResponse);
  }
}
