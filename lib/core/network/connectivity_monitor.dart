import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show MissingPluginException;

import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../telemetry/report_source.dart';
import '../telemetry/unexpected_error.dart';
import 'connectivity_link.dart';

/// Sunucuya erişim durumu (A3b). "İnternet var" ölçütü sunucuya ulaşmaktır.
/// [offline]: cihazda ağ arayüzü yok (internete bağlı değil); [unreachable]: arayüz var (ya da
/// bilinmiyor) ama istek sunucuya ulaşamadı. İkisi kullanıcıya ayrı mesajla gösterilir.
enum ConnectivityState {
  online,
  offline,
  unreachable,
  unknown;

  /// Bağlantı sorunu var (şerit görünür; son veri salt okunur gösterilir).
  bool get isDown => this == offline || this == unreachable;
}

/// Ağ hatasından sonraki durum: arayüz ipucu "yok" ise internete bağlı değil, "var" ya da
/// bilinmiyorsa sunucuya ulaşılamıyor (arayüz olması internete çıkıldığını kanıtlamaz).
ConnectivityState stateAfterNetworkError({required bool? hasInterface}) =>
    hasInterface == false
    ? ConnectivityState.offline
    : ConnectivityState.unreachable;

/// Bağlantı geri geldi: sorunlu durumdan ([ConnectivityState.isDown]) sorunsuza geçiş. Sayfa ve
/// hata görünümü bu geçişte bir kez kendiliğinden yeniler (döngü yok; ürün sahibi kararı, not 47).
bool connectionRestored(ConnectivityState? before, ConnectivityState now) =>
    (before?.isDown ?? false) && !now.isDown;

/// Hata bağlantı kaynaklı mı (ağ, zaman aşımı, ağ geçidi 502–504): görünüm bağlantı tasarımıyla
/// gösterilir ve bağlantı gelince kendiliğinden yenilenir.
bool isConnectionError(ApiError e) =>
    e.code == ClientErrorCode.networkError ||
    e.code == ClientErrorCode.timeout ||
    (e.status != null && e.status! >= 502 && e.status! <= 504);

/// Bağlantı durumunu iki girdiden türetir:
/// 1. Platform arayüz olayı ([ConnectivityLink]) — yalnız İPUCU: arayüz yok → çevrimdışı;
///    arayüz var → çevrimdışıyı "bilinmiyor"a çeker, ASLA tek başına çevrimiçi demez.
/// 2. Son istek sonucu — [reportSuccess] → çevrimiçi; [reportError] ağ hatası → arayüz ipucuna
///    göre çevrimdışı ya da sunucuya ulaşılamıyor ([stateAfterNetworkError]).
///    Girdi yalnız [ApiError] kodudur (belirteç/URL/gövde taşımaz, log'a yazılmaz).
///
/// Yalnız durum yayar; hiçbir isteği tetiklemez, yeniden deneme yapmaz (CLAUDE.md).
class ConnectivityMonitor {
  ConnectivityMonitor([ConnectivityLink? link]) : _link = link;

  final ConnectivityLink? _link;
  final ValueNotifier<ConnectivityState> state = ValueNotifier(
    ConnectivityState.unknown,
  );
  StreamSubscription<bool>? _sub;
  bool _disposed = false;

  /// Son arayüz ipucu; ipucu gelmediyse null.
  bool? _interface;

  /// Arayüz ipucunu dinlemeye başlar. İdempotent. İpucu zorunlu değildir: hata olsa da durum
  /// "bilinmiyor" kalır ve istek sonucu girdisi çalışır. YALNIZ platform kanalının hiç
  /// bulunmaması ([MissingPluginException]: masaüstü, test) beklenen durumdur ve raporlanmaz;
  /// kanalın bozuk olay verisi (`TypeError`), `StateError` vb. teknik hatadır ve raporlanır.
  Future<void> start() async {
    final link = _link;
    if (link == null || _sub != null || _disposed) return;
    try {
      _sub = link.interfaceChanges.listen(_onInterface, onError: _reportLink);
      _onInterface(await link.hasInterface());
    } on Object catch (e, st) {
      _reportLink(e, st);
    }
  }

  /// Tek raporlama sahibi: kanal yokluğu hariç her hata `network` kaynağıyla raporlanır.
  static void _reportLink(Object error, StackTrace stack) => reportUnexpected(
    error,
    stack,
    source: ReportSource.network,
    expected: _isChannelAbsent,
  );

  static bool _isChannelAbsent(Object error) => error is MissingPluginException;

  void _onInterface(bool hasInterface) {
    if (_disposed) return;
    _interface = hasInterface;
    if (!hasInterface) {
      state.value = ConnectivityState.offline;
    } else if (state.value.isDown) {
      // Ağ değişti: sorun sürüyor mu bilinmez; ilk istek sonucu belirler.
      state.value = ConnectivityState.unknown;
    }
  }

  /// Sunucudan herhangi bir yanıt alındı.
  void reportSuccess() => _set(ConnectivityState.online);

  /// İstek hata ile bitti; yalnız ağ hatası bağlantı sorunu sayılır (TLS, zaman aşımı, sunucu
  /// hata zarfı vb. durumu değiştirmez; zarf varsa sunucuya ulaşılmıştır).
  void reportError(ApiError error) {
    if (error.status != null) return _set(ConnectivityState.online);
    if (error.code == ClientErrorCode.networkError) {
      _set(stateAfterNetworkError(hasInterface: _interface));
    }
  }

  void _set(ConnectivityState next) {
    if (!_disposed) state.value = next;
  }

  void dispose() {
    _disposed = true;
    try {
      unawaited(_sub?.cancel().then((_) {}, onError: _reportLink));
    } on Object catch (e, st) {
      _reportLink(e, st);
    }
    _sub = null;
    state.dispose();
  }
}
