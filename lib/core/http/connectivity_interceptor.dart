import 'package:dio/dio.dart';

import '../errors/api_error.dart';
import '../network/connectivity_monitor.dart';

/// İstek sonucunu [ConnectivityMonitor]'a bildirir (A3b girdi 2). Yalnız durum kodu ve
/// [ApiError] okunur; URL, başlık, belirteç, gövde monitöre geçmez. İsteği değiştirmez,
/// tekrar etmez.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this.monitor);

  final ConnectivityMonitor monitor;

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    monitor.reportSuccess();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    // Ağ geçidi hataları (502/503/504) sunucunun kendisinden gelmiş olmayabilir: sinyal yok.
    if (status != 502 && status != 503 && status != 504) {
      monitor.reportError(toApiError(err));
    }
    handler.next(err);
  }
}
