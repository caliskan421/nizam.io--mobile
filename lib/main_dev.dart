import 'app/bootstrap.dart';
import 'core/config/flavor.dart';

/// dev flavor giriş noktası: `flutter run --flavor dev -t lib/main_dev.dart`.
Future<void> main() => bootstrap(Flavor.dev);
