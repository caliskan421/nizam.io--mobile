import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/native_release.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'reads installed version and build rather than generated pubspec fallback',
    () async {
      PackageInfo.setMockInitialValues(
        appName: 'Nizamio',
        packageName: 'io.nizamio.mobile',
        version: '3.4.5',
        buildNumber: '987',
        buildSignature: '',
      );
      final release = await readNativeRelease();
      expect(release.version, '3.4.5');
      expect(release.build, 987);
      expect(release.label, '3.4.5+987');
    },
  );
}
