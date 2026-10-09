import 'package:dio/dio.dart';

import '../api/api_meta.dart';
import '../api/generated/operations.gen.dart';
import '../config/flavor.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../logging/log.dart';
import '../scope/scope_controller.dart';
import '../server/server_address.dart';
import '../session/session_controller.dart';

/// `options.extra` anahtarları.
const _opKey = 'nizamio.operation';
const _retriedKey = 'nizamio.retried';
const _tokenKey = 'nizamio.access_token';

/// Üretilmiş istemcinin `@Extras` ile taşıdığı operationId.
String? _operationId(RequestOptions o) {
  final openapi = o.extra['openapi'];
  if (openapi is Map) {
    final id = openapi['operationId'];
    if (id is String) return id;
  }
  return null;
}

ApiOperation? operationOf(RequestOptions o) => o.extra[_opKey] as ApiOperation?;

DioException _reject(RequestOptions o, String code) => DioException(
  requestOptions: o,
  error: ApiError(code),
  type: DioExceptionType.cancel,
);

/// 1. halka — sözleşme kapısı. Spec'te olmayan, yanlış yönteme/adrese giden ya da kapsamı
/// eksik istek ağa ÇIKMAZ. Başlıklar: `X-Nizamio-Client: mobile` (her istek),
/// `X-Requested-With` (her yazma), `X-Nizamio-Program` / `X-Nizamio-Department` (S2/S3).
class ApiGuardInterceptor extends Interceptor {
  ApiGuardInterceptor({
    required this.server,
    required this.flavor,
    required this.scope,
    this.operations = apiOperations,
  });

  /// Spec'ten üretilen harita (testte sentetik S3 işlemi için değiştirilebilir).
  final Map<String, ApiOperation> operations;
  final ServerAddress server;
  final Flavor flavor;
  final ScopeController? scope;

  late final List<(RegExp, ApiOperation)> _templates = [
    for (final op in operations.values) (_templateRegExp(op.path), op),
  ];

  ApiOperation? _resolve(String method, String path) {
    ApiOperation? found;
    for (final (re, op) in _templates) {
      if (op.method == method && re.hasMatch(path)) {
        if (found != null) return null; // belirsiz eşleşme: fail-closed
        found = op;
      }
    }
    return found;
  }

  /// `/v1/departments/{id}/members` → `^/v1/departments/[^/]+/members$`.
  static RegExp _templateRegExp(String template) {
    final parts = template.split(RegExp(r'\{[^/{}]+\}')).map(RegExp.escape);
    return RegExp('^${parts.join('[^/]+')}\$');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // İşlem, çağıranın verdiği metaveriden DEĞİL gerçek yöntem + yoldan bulunur; taşınan
    // operationId bununla birebir aynı olmalıdır (CX-Ö-02: başka işlemin extras'ı ile kapsam
    // sınıfı düşürülemez).
    final id = _operationId(options);
    final op = _resolve(options.method.toUpperCase(), options.uri.path);
    if (op == null || id != op.operationId) {
      return handler.reject(_reject(options, ClientErrorCode.unknownOperation));
    }
    // Sunucu bağının dışına (başka host/şema) istek yok; prod'da düz http hiç yok.
    final uri = options.uri;
    if (!server.owns(uri) ||
        (uri.scheme != 'https' && !flavor.allowsLocalHttp)) {
      return handler.reject(_reject(options, ClientErrorCode.insecureServer));
    }
    final headers = options.headers
      ..remove('X-Nizamio-Program')
      ..remove('X-Nizamio-Department')
      ..['X-Nizamio-Client'] = 'mobile';
    if (op.method != 'GET' || op.csrf) {
      headers['X-Requested-With'] = 'XMLHttpRequest';
    }
    if (op.scope == ScopeClass.s2 || op.scope == ScopeClass.s3) {
      final sel = scope?.current;
      if (sel == null || !sel.hasProgram) {
        return handler.reject(_reject(options, ClientErrorCode.scopeMissing));
      }
      headers['X-Nizamio-Program'] = sel.programId;
      if (op.scope == ScopeClass.s3) {
        if (!sel.hasDepartment) {
          return handler.reject(_reject(options, ClientErrorCode.scopeMissing));
        }
        headers['X-Nizamio-Department'] = sel.departmentId;
      }
    }
    options.extra[_opKey] = op;
    handler.next(options);
  }
}

/// 2. halka — kimlik. Bearer erişim belirteci; 401 → tek uçuş yenileme → istek YALNIZ BİR KEZ
/// tekrarlanır. Giriş/yenileme (S0) ve çıkışın 401'i yenileme tetiklemez.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.session, required this.dio});

  final SessionController session;

  /// Tekrar isteği aynı zincirden geçsin diye sahibi olan Dio.
  final Dio Function() dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final op = operationOf(options);
    options.headers.remove('Authorization');
    if (op == null || !op.auth) return handler.next(options);
    final token = session.accessToken;
    if (token == null) {
      return handler.reject(_reject(options, ClientErrorCode.notSignedIn));
    }
    options.headers['Authorization'] = 'Bearer $token';
    options.extra[_tokenKey] = token;
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final o = err.requestOptions;
    final op = operationOf(o);
    if (err.response?.statusCode != 401 ||
        op == null ||
        !op.auth ||
        op.operationId == 'logout' ||
        o.extra[_retriedKey] == true) {
      return handler.next(err);
    }
    try {
      await session.refresh(failedAccessToken: o.extra[_tokenKey] as String?);
    } on ApiError catch (e) {
      return handler.next(
        DioException(requestOptions: o, response: err.response, error: e),
      );
    }
    try {
      o.extra[_retriedKey] = true;
      final response = await dio().fetch<Object?>(o);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}

/// Son halka — her hata `DioException.error` içinde [ApiError] taşır; günlüğe yalnız yöntem,
/// yol, durum ve istek kimliği yazılır (başlık/gövde asla).
class ErrorLogInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final o = response.requestOptions;
    Log.info('${o.method} ${o.path} → ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = toApiError(err);
    final o = err.requestOptions;
    Log.info(
      '${o.method} ${o.path} → ${err.response?.statusCode ?? '-'} ${apiError.code}'
      '${apiError.requestId == null ? '' : ' request_id=${apiError.requestId}'}',
    );
    handler.next(
      DioException(
        requestOptions: o,
        response: err.response,
        type: err.type,
        error: apiError,
      ),
    );
  }
}
