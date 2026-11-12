import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../telemetry/error_report.dart';
import '../telemetry/error_reporting.dart';
import 'secure_store.dart';

/// flutter_secure_storage tabanlı depo. iOS: Keychain, yalnız bu cihaz ve ilk kilit
/// açıldıktan sonra (yedekle başka cihaza taşınmaz). Android: Keystore ile şifreli;
/// `android:allowBackup="false"` (AndroidManifest) belirteçlerin yedekten geri gelmesini önler.
class FlutterSecureStore implements SecureStore {
  FlutterSecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _guard(() => _storage.read(key: key));

  @override
  Future<void> write(String key, String value) =>
      _guard(() => _storage.write(key: key, value: value));

  @override
  Future<void> delete(String key) => _guard(() => _storage.delete(key: key));

  /// Keychain/Keystore arızası çağırana aynen iletilir; önce yalnız tür ve yığın
  /// raporlanır (anahtar adı, değer ve platform iletisi rapora girmez).
  Future<T> _guard<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on Object catch (e, st) {
      ErrorReporting.report(
        e,
        st,
        kind: ReportKind.storage,
        operation: ReportOperation.localStorage,
      );
      rethrow;
    }
  }
}
