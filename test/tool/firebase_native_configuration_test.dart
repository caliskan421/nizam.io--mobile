import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('flavor ayarları Flutter CLI/test giriş noktasını geçersiz kılamaz', () {
    final files = Directory('ios/Flutter').listSync().whereType<File>().where(
      (file) =>
          RegExp(r'/(Debug|Profile|Release)-(dev|prod)\.xcconfig$')
              .hasMatch(file.path),
    );
    expect(files, isNotEmpty);
    for (final file in files) {
      expect(
        RegExp(
          r'^\s*FLUTTER_TARGET\s*=',
          multiLine: true,
        ).hasMatch(file.readAsStringSync()),
        isFalse,
        reason:
            '${file.path}: Generated.xcconfig test listener hedefi korunmalı',
      );
    }
  });

  test(
    'iOS flavor kopyası eski dev dosyasını prod ve hata yollarında kaldırır',
    () async {
      final fixture = await Directory.systemTemp.createTemp(
        'nizam-firebase-copy-',
      );
      addTearDown(() => fixture.delete(recursive: true));
      final source = Directory('${fixture.path}/ios');
      final dev = File('${source.path}/Firebase/dev/GoogleService-Info.plist');
      await dev.parent.create(recursive: true);
      await dev.writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict><key>BUNDLE_ID</key><string>test.dev</string></dict></plist>
''');
      final destination = File(
        '${fixture.path}/build/Runner.app/GoogleService-Info.plist',
      );
      Future<ProcessResult> copy(String configuration, String bundle) =>
          Process.run(
            '/bin/sh',
            [File('ios/scripts/copy_firebase_config.sh').absolute.path],
            environment: {
              'SRCROOT': source.path,
              'TARGET_BUILD_DIR': '${fixture.path}/build',
              'UNLOCALIZED_RESOURCES_FOLDER_PATH': 'Runner.app',
              'CONFIGURATION': configuration,
              'PRODUCT_BUNDLE_IDENTIFIER': bundle,
            },
          );

      expect((await copy('Debug-dev', 'test.dev')).exitCode, 0);
      expect(await destination.readAsString(), await dev.readAsString());
      expect((await copy('Debug-prod', 'test.prod')).exitCode, 0);
      expect(destination.existsSync(), isFalse);

      await copy('Debug-dev', 'test.dev');
      expect((await copy('Debug-dev', 'wrong.owner')).exitCode, isNot(0));
      expect(destination.existsSync(), isFalse);
      await dev.delete();
      expect((await copy('Debug-dev', 'test.dev')).exitCode, isNot(0));
      expect((await copy('Unknown', 'test.dev')).exitCode, isNot(0));
    },
    skip: !Platform.isMacOS,
  );
}
