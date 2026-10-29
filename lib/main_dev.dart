import 'app/bootstrap.dart';
import 'core/config/flavor.dart';

/// dev flavor giriş noktası: `flutter run --flavor dev -t lib/main_dev.dart`. Gerçek akış
/// (sunucu → giriş → kapsam); örnek ekranlara sunucusuz geçmek için
/// `--dart-define=NIZAMIO_PROTOTYPE=true` (prototip modu).
Future<void> main() => bootstrap(
  Flavor.dev,
  prototype: const bool.fromEnvironment('NIZAMIO_PROTOTYPE'),
);
