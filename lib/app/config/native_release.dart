import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/config/mobile_release_policy.dart';
import '../../core/config/running_release.dart';

Future<RunningRelease> readNativeRelease() async {
  final platform = kIsWeb
      ? null
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => MobileReleasePlatform.android,
          TargetPlatform.iOS => MobileReleasePlatform.ios,
          _ => null,
        };
  try {
    final info = await PackageInfo.fromPlatform().timeout(
      const Duration(seconds: 2),
    );
    return RunningRelease(
      version: info.version,
      build: int.tryParse(info.buildNumber) ?? -1,
      packageName: info.packageName,
      platform: platform,
    );
  } on Object {
    // Do not silently compare a generated version with a different installed build.
    return RunningRelease(
      version: 'invalid',
      build: -1,
      packageName: '',
      platform: platform,
    );
  }
}
