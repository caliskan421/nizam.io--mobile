import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/telemetry/report_source.dart';
import '../../core/telemetry/unexpected_error.dart';

/// Riverpod 3 `ProviderObserver`: sağlayıcının build/future/stream hatası ya da bir notifier'ın
/// `AsyncError` durumuna geçmesi (`providerDidFail`) BEKLENMEYEN sınıftaysa tek rapor üretir
/// (uygulamada Riverpod mutasyonu kullanılmaz; `mutationError` bu yüzden ele alınmaz).
///
/// - Dinamik sağlayıcı adı, `family` argümanı, `Provider.toString` ve durum anlık görüntüsü
///   HİÇ okunmaz; yalnız `error` ve `stackTrace` kullanılır. Kaynak sabit
///   [ReportSource.provider]'dır (hangi sağlayıcı olduğu bilinmez, uydurulmaz).
/// - Beklenen hatalar (`ApiError` doğrulama/yetki/çevrimdışı, iptal, zaman aşımı) süzülür.
/// - Aynı kök hata nesnesi `catch` sınırında ya da `apiCall`'da zaten raporlandıysa tekrar
///   raporlanmaz (`ErrorReporting.alreadyHandled`). Bu yüzden `catch` sınırındaki rapor
///   (özgün yığın, işlem bağlamı) önceliklidir; gözlemci yalnız kaçanları yakalar.
/// - Bağ: `ProviderContainer(observers: …)` (app/di/composition.dart). Rıza kapalıyken
///   `ErrorReporting` hiçbir şey göndermez; gözlemcinin kendi durumu/ömrü yoktur.
final class ErrorReportingProviderObserver extends ProviderObserver {
  const ErrorReportingProviderObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) => reportUnexpected(error, stackTrace, source: ReportSource.provider);
}
