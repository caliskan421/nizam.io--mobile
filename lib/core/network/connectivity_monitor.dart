import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show MissingPluginException;

import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../telemetry/report_source.dart';
import '../telemetry/unexpected_error.dart';
import 'connectivity_link.dart';

/// Sunucuya erişim durumu (A3b). "İnternet var" ölçütü sunucuya ulaşmaktır.
enum ConnectivityState { online, offline, unknown }

/// Bağlantı durumunu iki girdiden türetir:
/// 1. Platform arayüz olayı ([ConnectivityLink]) — yalnız İPUCU: arayüz yok → çevrimdışı;
///    arayüz var → çevrimdışıyı "bilinmiyor"a çeker, ASLA tek başına çevrimiçi demez.
/// 2. Son istek sonucu — [reportSuccess] → çevrimiçi; [reportError] ağ hatası → çevrimdışı.
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
    if (!hasInterface) {
      state.value = ConnectivityState.offline;
    } else if (state.value == ConnectivityState.offline) {
      state.value = ConnectivityState.unknown;
    }
  }

  /// Sunucudan herhangi bir yanıt alındı.
  void reportSuccess() => _set(ConnectivityState.online);

  /// İstek hata ile bitti; yalnız ağ hatası çevrimdışı sayılır (TLS, zaman aşımı, sunucu
  /// hata zarfı vb. durumu değiştirmez; zarf varsa sunucuya ulaşılmıştır).
  void reportError(ApiError error) {
    if (error.status != null) return _set(ConnectivityState.online);
    if (error.code == ClientErrorCode.networkError) {
      _set(ConnectivityState.offline);
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
