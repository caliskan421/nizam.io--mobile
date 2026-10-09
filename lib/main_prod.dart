import 'app/bootstrap.dart';
import 'core/config/flavor.dart';

/// prod flavor giriş noktası: `flutter build apk --flavor prod -t lib/main_prod.dart`.
void main() => bootstrap(Flavor.prod);
