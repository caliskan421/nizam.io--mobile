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
import 'sse.dart';

/// `options.extra` anahtarları.
const _opKey = 'nizamio.operation';
const _stateKey = 'nizamio.request_state';
const _departmentKey = 'nizamio.department';
const _programKey = 'nizamio.program';

/// Üretilmiş istemcinin [extras]'ına istek başına açık departman ekler: S3 isteği seçili
/// kapsamın departmanı yerine [departmentId] ile gider. Program seçili kapsamdan gelir; S3
/// dışı işlemde yok sayılır. Boş kimlik seçili departmana DÜŞMEZ: kapı `client.scope_missing`
/// ile reddeder (fail-closed). Tek kaleme ait istekte [withScope] kullanılır.
Map<String, dynamic> withDepartment(
  Map<String, dynamic>? extras,
  String departmentId,
) => {...?extras, _departmentKey: departmentId};

/// İstek başına açık KAPSAM: program VE departman birlikte sabitlenir (istemci akışları §2 —
/// tek göreve ait her istek görevin kendi `program_id` + `department_id` değeriyle). S2
/// işlemde yalnız program kullanılır (departman yok sayılır). Boş değer seçili kapsama
/// DÜŞMEZ: kapı `client.scope_missing` ile reddeder (fail-closed).
Map<String, dynamic> withScope(
  Map<String, dynamic>? extras,
  String programId,
  String departmentId,
) => {...?extras, _programKey: programId, _departmentKey: departmentId};

/// Açık değer verilmediyse null; verildiyse değeri (geçersiz/boşsa '' — reddedilir).
String? _requested(RequestOptions o, String key) {
  if (!o.extra.containsKey(key)) return null;
  final v = o.extra[key];
  return v is String ? v : '';
}

/// İsteğin başladığı andaki bağlam (CX-r2-Ö-01). Özel sınıf: çağıran `extra` ile taklit
/// edemez. Tekrar edilen istek DAİMA başladığı oturum neslinde ve başladığı kapsamla gider.
class _RequestState {
  bool retried = false;
  int? generation;
  String? accessToken;
  String? programId;
  String? departmentId;
}

_RequestState _stateOf(RequestOptions o) {
  final v = o.extra[_stateKey];
  if (v is _RequestState) return v;
  final s = _RequestState();
  o.extra[_stateKey] = s;
  return s;
}

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
/// `X-Requested-With` (her yazma), `X-Nizamio-Program` / `X-Nizamio-Department` (S2/S3;
/// kapsam istek başına [withScope] / [withDepartment] ile açıkça verilebilir).
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
      final st = _stateOf(options);
      if (!st.retried) {
        // İlk gönderim: güncel kapsam yakalanır; tekrar aynı kapsamla gider.
        // Açık değer önce; seçili kapsama YALNIZ açık değer yoksa düşülür.
        final sel = scope?.current;
        st
          ..programId =
              _requested(options, _programKey) ??
              ((sel != null && sel.hasServerProgram) ? sel.programId : null)
          ..departmentId =
              _requested(options, _departmentKey) ??
              ((sel != null && sel.hasDepartment) ? sel.departmentId : null);
      }
      final program = st.programId;
      if (program == null || program.isEmpty) {
        return handler.reject(_reject(options, ClientErrorCode.scopeMissing));
      }
      headers['X-Nizamio-Program'] = program;
      if (op.scope == ScopeClass.s3) {
        final department = st.departmentId;
        if (department == null || department.isEmpty) {
          return handler.reject(_reject(options, ClientErrorCode.scopeMissing));
        }
        headers['X-Nizamio-Department'] = department;
      }
    }
    options.extra[_opKey] = op;
    handler.next(options);
  }
}

/// 2. halka — kimlik. Bearer erişim belirteci; 401 → tek uçuş yenileme → istek YALNIZ BİR KEZ
/// tekrarlanır. Giriş/yenileme (S0) ve çıkışın 401'i yenileme tetiklemez. Multipart (FormData)
/// istek yenilemeden sonra tekrarlanmaz: `client.session_refreshed` ile döner.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.session,
    required this.instanceId,
    required this.dio,
  });

  final SessionController session;

  /// Bu Dio'nun bağlı olduğu kurulum: Bearer yalnız bu kuruluma ait çiftten alınır.
  final String instanceId;

  /// Tekrar isteği aynı zincirden geçsin diye sahibi olan Dio.
  final Dio Function() dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final op = operationOf(options);
    options.headers.remove('Authorization');
    if (op == null || !op.auth) return handler.next(options);
    final st = _stateOf(options);
    if (st.retried && st.generation != session.generation) {
      return handler.reject(_reject(options, ClientErrorCode.sessionEnded));
    }
    final token = session.accessTokenFor(instanceId);
    if (token == null) {
      return handler.reject(_reject(options, ClientErrorCode.notSignedIn));
    }
    options.headers['Authorization'] = 'Bearer $token';
    if (!st.retried) st.generation = session.generation;
    st.accessToken = token;
    handler.next(options);
  }

  /// 401 erişim belirtecinin düştüğü anlamına mı geliyor? Yenileme + tekrar YALNIZ zarf kodu
  /// `platform.unauthenticated` ise yapılır (sözleşme: erişim belirteci süresi bu kodla bildirilir).
  /// Diğer her 401 — farklı kod (ör. `identity.credentials_invalid`), gövdesiz ya da biçimsiz
  /// (`client.invalid_response`) — nedeni belirsizdir: yenileme 0, tekrar 0, hata olduğu gibi döner
  /// (aksi hâlde parola değiştirme gibi yazmalar iki kez gider).
  static bool _expiresAccess(DioException err) =>
      toApiError(err).code == 'platform.unauthenticated';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Akışlı OKUMA isteğinin (`ResponseType.stream` GET: dosya indirme) 401 gövdesi okunmamış
    // akıştır: zarf kodu görülsün diye çözülür (yenileme yalnız `platform.unauthenticated`'de;
    // GET tekrarı güvenli). Akışlı yazma (SSE `assistantChat` POST) bilinen sınır olarak
    // dokunulmadan kalır: yenileme tetiklemez.
    if (err.response?.statusCode == 401 &&
        err.requestOptions.method.toUpperCase() == 'GET') {
      err = await materializeStreamError(err);
    }
    final o = err.requestOptions;
    final op = operationOf(o);
    final st = _stateOf(o);
    if (err.response?.statusCode != 401 ||
        op == null ||
        !op.auth ||
        op.operationId == 'logout' ||
        st.retried ||
        !_expiresAccess(err)) {
      return handler.next(err);
    }
    DioException ended() => DioException(
      requestOptions: o,
      response: err.response,
      error: ApiError(ClientErrorCode.sessionEnded),
    );
    // İstek başka bir oturum neslinde başladıysa (çıkış, başka hesapla giriş, yeniden
    // bağlanma): yenileme YOK, tekrar YOK — yeni oturumun Bearer'ı eski istekle gitmez.
    if (st.generation != session.generation) return handler.next(ended());
    if (session.accessTokenFor(instanceId) == null) return handler.next(err);
    try {
      await session.refresh(failedAccessToken: st.accessToken);
    } on ApiError catch (e) {
      return handler.next(
        DioException(requestOptions: o, response: err.response, error: e),
      );
    }
    if (st.generation != session.generation) return handler.next(ended());
    // Multipart (FormData) gövde ilk gönderimde sonlandırılmıştır; aynı nesne yeniden
    // gönderilemez (dio `StateError`). Yenileme yapıldı, istek TEKRARLANMAZ: kullanıcı
    // yüklemeyi yeni gövdeyle yeniden başlatır (`client.session_refreshed`).
    if (o.data is FormData) {
      return handler.next(
        DioException(
          requestOptions: o,
          response: err.response,
          error: ApiError(ClientErrorCode.sessionRefreshed),
        ),
      );
    }
    try {
      st.retried = true;
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
