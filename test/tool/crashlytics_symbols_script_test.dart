// ios/scripts/upload_crashlytics_symbols.sh: simülatör, Debug ve yapılandırmasız (prod)
// derlemelerde ATLAR; yalnız gerçek cihaz Release/Profile + plist + dSYM varken Crashlytics
// `run` betiğini çağırır. Betik gerçek `sh` ile, sahte ortam dizinleriyle koşulur.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tmp;
  late String marker;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('crashlytics_script_');
    marker = '${tmp.path}/run_called';
    // BUILD_DIR=<tmp>/Build/Products → run: <tmp>/SourcePackages/checkouts/…/Crashlytics/run
    final run = File(
      '${tmp.path}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run',
    )..createSync(recursive: true);
    run.writeAsStringSync('#!/bin/sh\necho called > "$marker"\n');
    Process.runSync('chmod', ['+x', run.path]);
    Directory('${tmp.path}/dSYMs/Runner.app.dSYM').createSync(recursive: true);
    Directory('${tmp.path}/out/Runner.app').createSync(recursive: true);
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  ProcessResult runScript({
    required String platform,
    required String configuration,
    bool plist = true,
  }) {
    if (plist) {
      File('${tmp.path}/out/Runner.app/GoogleService-Info.plist')
          .writeAsStringSync('x');
    }
    return Process.runSync(
      '/bin/sh',
      ['${Directory.current.path}/ios/scripts/upload_crashlytics_symbols.sh'],
      environment: {
        'PLATFORM_NAME': platform,
        'EFFECTIVE_PLATFORM_NAME': platform == 'iphonesimulator'
            ? '-iphonesimulator'
            : '-iphoneos',
        'CONFIGURATION': configuration,
        'TARGET_BUILD_DIR': '${tmp.path}/out',
        'UNLOCALIZED_RESOURCES_FOLDER_PATH': 'Runner.app',
        'BUILD_DIR': '${tmp.path}/Build/Products',
        'DWARF_DSYM_FOLDER_PATH': '${tmp.path}/dSYMs',
        'DWARF_DSYM_FILE_NAME': 'Runner.app.dSYM',
      },
    );
  }

  test('gerçek cihaz Release + plist + dSYM: Crashlytics run çağrılır', () {
    final r = runScript(platform: 'iphoneos', configuration: 'Release-dev');
    expect(r.exitCode, 0, reason: '${r.stdout}${r.stderr}');
    expect(File(marker).existsSync(), isTrue);
  });

  test('simülatör Release: AÇIKÇA atlanır', () {
    final r = runScript(
      platform: 'iphonesimulator',
      configuration: 'Release-dev',
    );
    expect(r.exitCode, 0);
    expect(r.stdout, contains('simülatör'));
    expect(File(marker).existsSync(), isFalse);
  });

  test('Debug atlanır; yapılandırmasız (prod) atlanır', () {
    expect(
      runScript(platform: 'iphoneos', configuration: 'Debug-dev').exitCode,
      0,
    );
    expect(File(marker).existsSync(), isFalse);
    File('${tmp.path}/out/Runner.app/GoogleService-Info.plist').deleteSync();
    final r = runScript(
      platform: 'iphoneos',
      configuration: 'Release-prod',
      plist: false,
    );
    expect(r.exitCode, 0);
    expect(r.stdout, contains('yapılandırması yok'));
    expect(File(marker).existsSync(), isFalse);
  });
}
