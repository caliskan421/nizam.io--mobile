import 'dart:async';

import 'package:flutter/foundation.dart';

import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
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

  /// Arayüz ipucunu dinlemeye başlar. İdempotent; platform hatası yutulur (ipucu zorunlu
  /// değildir, istek sonucu girdisi yine çalışır).
  Future<void> start() async {
    final link = _link;
    if (link == null || _sub != null || _disposed) return;
    try {
      _sub = link.interfaceChanges.listen(_onInterface, onError: (Object _) {});
      _onInterface(await link.hasInterface());
    } on Object {
      // Platform kanalı yok/başarısız: ipucu yok, durum "bilinmiyor" kalır.
    }
  }

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
      unawaited(_sub?.cancel().then((_) {}, onError: (Object _) {}));
    } on Object {
      // Platform kanalı yok: bırakılacak bir şey kalmadı.
    }
    _sub = null;
    state.dispose();
  }
}
