import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:meta/meta.dart';

import '../api/generated/error_catalog.gen.dart';
import '../api/generated/models/error_envelope.dart';
import '../api/generated/models/field_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../telemetry/api_call_scope.dart';
import '../telemetry/error_report.dart';
import '../telemetry/error_reporting.dart';
import '../telemetry/provider_unwrap.dart';
import '../telemetry/report_source.dart';

/// Alan doğrulama hatası (sunucu zarfının `fields[]` öğesi; üretilmiş DTO'dan eşlenir —
/// sınır kuralı A3). Alanlar DTO ile birebir; [message] sunucu metnidir ve kullanıcıya
/// gösterilmez (metin [code]'dan ARB ile gelir).
@immutable
final class ApiFieldError {
  const ApiFieldError({
    required this.field,
    required this.code,
    required this.message,
  });

  final String field;
  final String code;
  final String message;
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

/// Yazma isteğinin sonucu bilinmiyor mu (istemci akışları §8 "sonuç bilinmiyor"): zaman aşımı,
/// ağ kopması ya da 5xx — istek sunucuda işlenmiş olabilir. Çağıran "başarısız, yeniden oluştur"
/// demez; aynı isteği AYNI işlem anahtarıyla yeniden dener (kullanıcı eylemiyle).
bool isOutcomeUnknown(ApiError e) =>
    e.code == ClientErrorCode.timeout ||
    e.code == ClientErrorCode.networkError ||
    (e.status ?? 0) >= 500;

/// Aynı işlem anahtarı başka gövdeyle kullanılmış (`<mod>.idempotency_key_reused`, 409):
/// istemci hatasıdır; otomatik tekrar edilmez, sonraki gönderim yeni eylemdir.
bool isKeyReused(ApiError e) => e.code.endsWith('.idempotency_key_reused');

/// Nadir yarış (`platform.conflict_retry`): aynı anahtarla bir kez yeniden denenir.
const conflictRetryCode = 'platform.conflict_retry';

/// Dio hatasını [ApiError]'a çevirir. TLS hatası AYRI koddur ve asla ağ hatasına
/// indirgenmez/yutulmaz (ADR-0008, K-11).
ApiError toApiError(Object error) {
  if (error is ProviderException) {
    // Bağımlılık sarmalayıcısı: asıl hataya göre çevrilir (sarmalayıcı kendi başına geçersiz yanıt değildir).
    return toApiError(unwrapProviderException(error, StackTrace.empty).$1);
  }
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
            ApiFieldError(field: f.field, code: f.code, message: f.message),
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
///
/// Hata ApiError'a çevrilmeden ÖNCE (özgün yığın ve tür elde) güvenle sınıflandırılıp
/// raporlanır ([ErrorReporting]; onay kapalıyken hiçbir şey olmaz). Raporlananlar yalnız
/// beklenmeyen sınıflardır: geçersiz yanıt (ayrıştırma hatası, zarfsız yanıt) ve 5xx.
/// Doğrulama, yetki, yanlış parola, iptal, zaman aşımı, çevrimdışı ve TLS raporlanmaz. Özgün
/// yığın dönüştürülmüş hataya taşınır; bu yüzden üst katmanlar tekrar raporlamaz.
///
/// İşlem kimliği: çağrı süresince giden isteğin DOĞRULANMIŞ operationId'si (üretilmiş
/// `apiOperations`) [ApiCallScope] ile toplanır; kesin tek işlem yoksa (paralel istekler) `null`.
Future<T> apiCall<T>(Future<T> Function() call) async {
  final scope = ApiCallScope();
  try {
    return await ApiCallScope.run(scope, call);
  } on ApiError catch (e, st) {
    // Elle kurulmuş beklenmeyen ApiError (ör. şemaya uymayan gövde) da sınıflandırılır;
    // beklenen kodlar (doğrulama, yetki …) raporlanmaz.
    reportApiFailure(e, st, e, apiOperationId: scope.operationId);
    rethrow;
  } on DioException catch (e, st) {
    final api = toApiError(e);
    final operationId =
        ApiCallScope.ofRequest(e.requestOptions) ?? scope.operationId;
    reportApiFailure(e.error ?? e, st, api, apiOperationId: operationId);
    Error.throwWithStackTrace(api, st);
  } on Object catch (e, st) {
    final api = ApiError(ClientErrorCode.invalidResponse);
    reportApiFailure(e, st, api, apiOperationId: scope.operationId);
    Error.throwWithStackTrace(api, st);
  }
}

/// [api] BEKLENMEYEN sınıftaysa (geçersiz yanıt ya da 5xx) [cause] + [stack] ile raporlar ve
/// dönüştürülmüş [api] nesnesini aynı kökten sayar (tek rapor). Beklenen kodlar (doğrulama,
/// yetki, çakışma, iptal, zaman aşımı, çevrimdışı, TLS) raporlanmaz. Hiç fırlatmaz.
void reportApiFailure(
  Object cause,
  StackTrace stack,
  ApiError api, {
  ReportOperation? operation,
  ReportSource source = ReportSource.network,
  String? apiOperationId,
}) {
  final status = api.status;
  final ReportKind kind;
  if ((status ?? 0) >= 500) {
    kind = ReportKind.serverError; // zarfsız 502 HTML'i de sunucu hatasıdır
  } else if (api.code == ClientErrorCode.invalidResponse) {
    kind = ReportKind.invalidResponse;
  } else {
    return;
  }
  ErrorReporting.report(
    cause,
    stack,
    kind: kind,
    operation: operation,
    source: source,
    apiOperationId: apiOperationId,
    apiCode: api.code,
    status: status,
  );
  if (!identical(cause, api)) {
    ErrorReporting.markHandled(api, stack);
    ErrorReporting.markCreated(api); // bu olay için dönüştürülmüş yeni nesne
  }
}

/// Katalogda 5xx görünen ama TEKNİK arıza olmayan, beklenen iş sınırı kodları (kullanıcıya ARB
/// metniyle gösterilir): asistan tur/token sınırı ve kapasite doluluğu.
const _expectedServerCodes = {
  'assistant.limit_exceeded',
  'assistant.capacity_full',
};

/// HTTP 200 SSE akışındaki sunucu `hata` OLAYI (`AssistantFailure` kodu): kod katalogda
/// 5xx'e karşılık geliyorsa (`platform.internal`, `assistant.provider_unavailable` …) TEKNİK
/// sunucu hatasıdır ve [ReportKind.streamServerError] olarak raporlanır; reddedilen / sınır /
/// kota / yoğunluk gibi beklenen kodlar (4xx ya da katalog dışı) 0 rapor üretir. Gerçek HTTP
/// yanıtı 200 olduğundan durum SINIFI uydurulmaz. Olay iletisi/yükü rapora girmez.
void reportStreamEventFailure(
  String code, {
  ReportOperation? operation,
  ReportSource source = ReportSource.network,
  String? apiOperationId,
}) {
  final statuses = errorCatalog[code]?.statuses ?? const <int>[];
  if (!statuses.any((s) => s >= 500) || _expectedServerCodes.contains(code)) {
    return;
  }
  final api = ApiError(code);
  ErrorReporting.report(
    api,
    StackTrace.current,
    kind: ReportKind.streamServerError,
    operation: operation,
    source: source,
    apiOperationId: apiOperationId,
    apiCode: code,
  );
}

/// `client.invalid_response` üretilen yerde (ApiError `apiCall` dışında elle kurulurken)
/// kullanılır: hata raporlanmış olarak döner. `throw invalidResponseError()`. [cause]/[stack]
/// verilirse asıl hata ve özgün yığın raporlanır (ör. ayrıştırma hatası); [apiOperationId]
/// üretilmiş `apiOperations` listesindeki işlem kimliğidir (aksi halde rapora girmez).
ApiError invalidResponseError({
  Object? cause,
  StackTrace? stack,
  ReportOperation? operation,
  ReportSource source = ReportSource.network,
  String? apiOperationId,
}) {
  final e = ApiError(ClientErrorCode.invalidResponse);
  reportApiFailure(
    cause ?? e,
    stack ?? StackTrace.current,
    e,
    operation: operation,
    source: source,
    apiOperationId: apiOperationId,
  );
  // Nesne burada yeni kuruldu: ilk yakalayan katman (apiCall/controller) aynı olaydır.
  if (cause == null) ErrorReporting.markCreated(e);
  return e;
}
