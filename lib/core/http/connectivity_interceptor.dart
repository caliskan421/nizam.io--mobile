import 'package:dio/dio.dart';

import '../errors/api_error.dart';
import '../network/connectivity_monitor.dart';

/// İstek sonucunu [ConnectivityMonitor]'a bildirir (A3b girdi 2). Yalnız durum kodu ve
/// [ApiError] okunur; URL, başlık, belirteç, gövde monitöre geçmez. İsteği değiştirmez,
/// tekrar etmez.
///
/// Çevrimdışıyken (cihazda ağ arayüzü yok) son veri salt okunurdur (iPad not 47): yazma
/// istekleri (GET/HEAD dışı) gönderilmeden `client.network_error` ile reddedilir; okuma
/// istekleri geçer (bağlantı dönüşünü onlar fark eder).
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this.monitor);

  final ConnectivityMonitor monitor;

  static const _reads = {'GET', 'HEAD'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (monitor.state.value == ConnectivityState.offline &&
        !_reads.contains(options.method.toUpperCase())) {
      handler.reject(
        DioException.connectionError(
          requestOptions: options,
          reason: 'offline: write blocked',
        ),
        true,
      );
      return;
    }
    handler.next(options);
  }

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
