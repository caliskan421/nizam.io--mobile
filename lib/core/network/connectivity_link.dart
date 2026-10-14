import 'package:connectivity_plus/connectivity_plus.dart';

/// Platform ağ arayüzü ipucu kaynağı. `true` = en az bir ağ arayüzü var (sunucuya
/// ulaşıldığı ANLAMINA GELMEZ); `false` = hiç arayüz yok. Paket yalnız burada bilinir;
/// testler sahte uygulama verir (gerçek platform kanalı yok).
abstract interface class ConnectivityLink {
  /// Açılıştaki arayüz durumu.
  Future<bool> hasInterface();

  /// Arayüz değişimleri.
  Stream<bool> get interfaceChanges;
}

/// `connectivity_plus` bağdaştırıcısı.
class PlusConnectivityLink implements ConnectivityLink {
  PlusConnectivityLink([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _any(List<ConnectivityResult> r) =>
      r.any((e) => e != ConnectivityResult.none);

  @override
  Future<bool> hasInterface() async =>
      _any(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get interfaceChanges =>
      _connectivity.onConnectivityChanged.map(_any);
}
