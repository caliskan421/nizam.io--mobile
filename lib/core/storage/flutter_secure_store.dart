import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
