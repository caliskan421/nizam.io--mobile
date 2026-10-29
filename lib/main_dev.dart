import 'app/bootstrap.dart';
import 'core/config/flavor.dart';

/// dev flavor giriş noktası: `flutter run --flavor dev -t lib/main_dev.dart`. Yerel backend'e
/// doğrudan giriş ekranından başlamak için `--dart-define=NIZAMIO_SERVER=http://localhost:<port>`
/// (kayıtlı bağ yoksa açılışta doğrulanır).
Future<void> main() => bootstrap(
  Flavor.dev,
  devServer: const String.fromEnvironment('NIZAMIO_SERVER'),
);
