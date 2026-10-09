/// Derleme çeşidi (K-11). Giriş noktası belirler (`lib/main_dev.dart`, `lib/main_prod.dart`);
/// çalışma anında değiştirilemez.
enum Flavor {
  /// Yerel geliştirme: `http://localhost` (ve emülatör adresleri) serbest.
  dev,

  /// Üretim: yalnız `https://`; güven zinciri işletim sisteminin.
  prod;

  /// Düz http'ye izin var mı? Yalnız dev'de ve yalnız yerel adreslere (ServerAddress).
  bool get allowsLocalHttp => this == Flavor.dev;
}
