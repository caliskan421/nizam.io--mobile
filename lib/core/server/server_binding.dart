import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api/generated/clients/platform_client.dart';
import '../api/generated/operations.gen.dart';
import '../config/flavor.dart';
import '../config/generated/app_version.gen.dart';
import '../errors/api_error.dart';
import '../http/dio_factory.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../logging/log.dart';
import '../storage/secure_store.dart';
import 'semver.dart';
import 'server_address.dart';

/// Ürün kimliği (`/.well-known/nizamio-instance` `product_id`; backend provisioning sabiti).
const nizamioProductId = 'nizamio';

/// Doğrulanmış sunucunun bilgisi.
@immutable
final class ServerInfo {
  const ServerInfo({
    required this.address,
    required this.instanceId,
    required this.displayName,
    required this.brandColor,
    required this.apiVersion,
    required this.minimumMobileVersion,
    required this.serverVersion,
  });

  final ServerAddress address;
  final String instanceId;
  final String displayName;
  final String brandColor;
  final String apiVersion;
  final String minimumMobileVersion;
  final String serverVersion;
}

/// Sunucu bağı durum makinesi (K-11): bağ yok → doğrulanıyor → doğrulandı | güncelleme gerekli
/// | başarısız. Oturum katmanı yalnız [BindingVerified]'da açılır.
sealed class BindingState {
  const BindingState();
}

final class BindingUnbound extends BindingState {
  const BindingUnbound();
}

final class BindingVerifying extends BindingState {
  const BindingVerifying(this.address);
  final ServerAddress address;
}

final class BindingVerified extends BindingState {
  const BindingVerified(this.info);
  final ServerInfo info;
}

/// Sunucunun asgari mobil sürümü uygulamadan yüksek: açık "güncelleme gerekli" DURUMU
/// (ADR-0008). Giriş akışı başlamaz.
final class BindingUpdateRequired extends BindingState {
  const BindingUpdateRequired({
    required this.address,
    required this.minimumVersion,
    required this.appVersion,
  });
  final ServerAddress address;
  final String minimumVersion;
  final String appVersion;
}

/// Doğrulama başarısız (geçersiz/güvensiz adres, TLS hatası, NIZAM.IO değil, API sürümü uyumsuz,
/// ağ). [error.code] nedeni taşır; TLS hatası `client.tls_error` olarak AYRI görünür.
final class BindingFailed extends BindingState {
  const BindingFailed(this.error, {this.address});
  final ApiError error;
  final ServerAddress? address;
}

/// Sunucu bağı denetleyicisi. Doğrulama sırası (fail-closed, hiçbir adım atlanmaz):
///   1. adres yerel kurallar (prod: yalnız https) — ağ isteği YOK;
///   2. `GET /.well-known/nizamio-instance`: `product_id == nizamio`, `api_version` uyumu;
///   3. `GET /v1/instance/profile`: `api_version` uyumu, `minimum_mobile_version` ≤ uygulama.
/// Başarılı bağ (adres + instance_id) güvenli depoya yazılır. Farklı sunucuya/kuruluma
/// yeniden bağlanırken [addRebindListener] ile kaydolanlar (oturum/kapsam temizliği)
/// bağ kaydı yazılmadan ÖNCE çağrılır.
class ServerBindingController {
  ServerBindingController({
    required this.flavor,
    required this.store,
    this.appVersionOverride,
    this.adapter,
  });

  static const storeKey = 'nizamio.server.v1';

  final Flavor flavor;
  final SecureStore store;
  final List<Future<void> Function()> _rebindListeners = [];

  void addRebindListener(Future<void> Function() listener) =>
      _rebindListeners.add(listener);

  /// Test: uygulama sürümü yerine geçer.
  final String? appVersionOverride;

  /// Test: HTTP bağdaştırıcısı.
  final HttpClientAdapter? adapter;

  final ValueNotifier<BindingState> _state = ValueNotifier(
    const BindingUnbound(),
  );

  ValueListenable<BindingState> get state => _state;

  int _epoch = 0;
  BindingState get current => _state.value;

  String get _appVersion => appVersionOverride ?? appVersion;

  /// Açılış: kayıtlı bağ varsa yeniden doğrulanır (sürüm her açılışta denetlenir).
  Future<BindingState> restore() async {
    final saved = await _loadSaved();
    if (saved == null) return _state.value = const BindingUnbound();
    return verify(saved.$1);
  }

  /// Kullanıcının girdiği adresi doğrular.
  ///
  /// Eşzamanlı doğrulamalarda yalnız EN SON başlatılanın sonucu uygulanır; geç biten eski
  /// doğrulama durumu, bağ kaydını ya da oturumu değiştirmez (CX-r1-Ö-01 sınıfı).
  Future<BindingState> verify(String input) async {
    final epoch = ++_epoch;
    bool stale() => epoch != _epoch;
    final ServerAddress address;
    try {
      address = ServerAddress.parse(input, flavor);
    } on ApiError catch (e) {
      return _state.value = BindingFailed(e);
    }
    _state.value = BindingVerifying(address);
    final client = PlatformClient(
      createPublicDio(server: address, flavor: flavor, adapter: adapter),
    );
    try {
      final system = await apiCall(client.systemInfo);
      if (stale()) return _state.value;
      if (system.productId != nizamioProductId) {
        return _fail(ApiError(ClientErrorCode.serverUnrecognized), address);
      }
      if (system.apiVersion != apiVersion) {
        return _fail(ApiError(ClientErrorCode.unsupportedApiVersion), address);
      }
      final profile = await apiCall(client.instanceProfile);
      if (stale()) return _state.value;
      if (profile.apiVersion != apiVersion) {
        return _fail(ApiError(ClientErrorCode.unsupportedApiVersion), address);
      }
      final minimum = SemVer.tryParse(profile.minimumMobileVersion);
      final current = SemVer.tryParse(_appVersion);
      if (minimum == null || current == null) {
        return _fail(ApiError(ClientErrorCode.invalidResponse), address);
      }
      if (current < minimum) {
        return _state.value = BindingUpdateRequired(
          address: address,
          minimumVersion: minimum.toString(),
          appVersion: current.toString(),
        );
      }
      final info = ServerInfo(
        address: address,
        instanceId: system.instanceId,
        displayName: profile.displayName,
        brandColor: profile.brandColor,
        apiVersion: profile.apiVersion,
        minimumMobileVersion: profile.minimumMobileVersion,
        serverVersion: system.serverVersion,
      );
      final saved = await _loadSaved();
      if (stale()) return _state.value;
      if (saved != null &&
          (saved.$1 != address.toString() || saved.$2 != info.instanceId)) {
        Log.info('bağ: farklı sunucu/kurulum; yerel oturum temizleniyor');
        for (final l in _rebindListeners) {
          await l();
        }
        if (stale()) return _state.value;
      }
      await store.write(
        storeKey,
        jsonEncode({
          'origin': address.toString(),
          'instance_id': info.instanceId,
        }),
      );
      if (stale()) return _state.value;
      return _state.value = BindingVerified(info);
    } on ApiError catch (e) {
      if (stale()) return _state.value;
      // NIZAM.IO olmayan bir sunucu keşif ucunda zarfsız/404 yanıt verir.
      final unrecognized =
          e.code == ClientErrorCode.invalidResponse || e.status == 404;
      return _fail(
        unrecognized
            ? ApiError(ClientErrorCode.serverUnrecognized, status: e.status)
            : e,
        address,
      );
    } on Object {
      if (stale()) return _state.value;
      // Güvenli depo (bağ kaydı) okunamadı/yazılamadı ya da yeniden bağlanma temizliği düştü:
      // bağ doğrulanmış SAYILMAZ (fail-closed).
      return _fail(ApiError(ClientErrorCode.secureStorageError), address);
    }
  }

  BindingState _fail(ApiError e, ServerAddress address) {
    Log.info('bağ: doğrulanamadı (${e.code}) $address');
    return _state.value = BindingFailed(e, address: address);
  }

  Future<(String, String)?> _loadSaved() async {
    final raw = await store.read(storeKey);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, Object?>;
      return (m['origin']! as String, m['instance_id']! as String);
    } on Object {
      return null;
    }
  }
}
