import 'package:dio/dio.dart';

import '../config/flavor.dart';
import '../scope/scope_controller.dart';
import '../server/server_address.dart';
import '../session/session_controller.dart';
import 'interceptors.dart';

/// Ortak taban ayarları. Yönlendirme izlenmez (https → http yönlendirmesiyle parola sızmaz;
/// 3xx geçersiz yanıttır). TLS: platform güven zinciri; `badCertificateCallback` YOK
/// (sınır kuralı S2) — sertifika hatası `client.tls_error` olarak yüzeye çıkar.
BaseOptions baseOptions(ServerAddress server) => BaseOptions(
  baseUrl: server.origin.toString(),
  connectTimeout: const Duration(seconds: 10),
  sendTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
  followRedirects: false,
  maxRedirects: 0,
  validateStatus: (s) => s != null && s >= 200 && s < 300,
  responseType: ResponseType.json,
  contentType: Headers.jsonContentType,
);

/// Kimliksiz (S0) ve yenileme çağrıları için: kapı + hata halkası, kimlik halkası yok.
Dio createPublicDio({
  required ServerAddress server,
  required Flavor flavor,
  HttpClientAdapter? adapter,
}) {
  final dio = Dio(baseOptions(server));
  if (adapter != null) dio.httpClientAdapter = adapter;
  dio.interceptors.addAll([
    ApiGuardInterceptor(server: server, flavor: flavor, scope: null),
    ErrorLogInterceptor(),
  ]);
  return dio;
}

/// Uygulama API'si: kapı → kimlik (Bearer, 401 → tek yenileme → bir tekrar) → hata/günlük.
Dio createApiDio({
  required ServerAddress server,
  required Flavor flavor,
  required SessionController session,
  required String instanceId,
  required ScopeController scope,
  HttpClientAdapter? adapter,
}) {
  final dio = Dio(baseOptions(server));
  if (adapter != null) dio.httpClientAdapter = adapter;
  dio.interceptors.addAll([
    ApiGuardInterceptor(server: server, flavor: flavor, scope: scope),
    AuthInterceptor(session: session, instanceId: instanceId, dio: () => dio),
    ErrorLogInterceptor(),
  ]);
  return dio;
}
