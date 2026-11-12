import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_release_policy.dart';

/// Installed native metadata, including Flutter build-name/build-number overrides.
final class RunningRelease {
  const RunningRelease({
    required this.version,
    required this.build,
    required this.packageName,
    required this.platform,
  });
  final String version;
  final int build;
  final String packageName;
  final MobileReleasePlatform? platform;
  String get label => '$version+$build';
}

final runningReleaseProvider = Provider<RunningRelease>(
  (ref) => const RunningRelease(
    version: 'invalid',
    build: -1,
    packageName: '',
    platform: null,
  ),
);
