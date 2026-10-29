import 'app/bootstrap.dart';
import 'core/config/flavor.dart';
import 'features/identity/identity.dart' show LoginPrefill;

/// dev flavor giriş noktası: `flutter run --flavor dev -t lib/main_dev.dart`. Yerel backend'e
/// doğrudan giriş ekranından başlamak için `--dart-define=NIZAMIO_SERVER=http://localhost:<port>`
/// (kayıtlı bağ yoksa açılışta doğrulanır).
///
/// Giriş formu yerel test hesabıyla dolu açılır (`test_integration/backend/up.sh`'e
/// `NIZAMIO_IT_ADMIN_EMAIL` / `NIZAMIO_IT_ADMIN_PASSWORD` ile kurulan atılabilir veritabanı
/// hesabı; sır değildir). Değiştirmek için `--dart-define=NIZAMIO_LOGIN_EMAIL=…` /
/// `NIZAMIO_LOGIN_PASSWORD=…`; boş e-posta ön dolguyu kapatır. prod giriş noktası bunu taşımaz.
Future<void> main() => bootstrap(
  Flavor.dev,
  devServer: const String.fromEnvironment('NIZAMIO_SERVER'),
  loginPrefill: _email.isEmpty
      ? null
      : const LoginPrefill(email: _email, password: _password),
);

const _email = String.fromEnvironment(
  'NIZAMIO_LOGIN_EMAIL',
  defaultValue: 'admin@nizam.local',
);
const _password = String.fromEnvironment(
  'NIZAMIO_LOGIN_PASSWORD',
  defaultValue: 'Pasword.123123',
);
