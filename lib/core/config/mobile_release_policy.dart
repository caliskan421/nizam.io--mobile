import '../server/semver.dart';

enum MobileReleasePlatform { android, ios }

enum MobileUpdateRequirement { none, optional, required, incompatible }

/// Remote policy supplements, and can never relax, the server's minimum.
final class MobileReleasePolicy {
  const MobileReleasePolicy.disabled()
    : _android = const _PlatformPolicy(),
      _ios = const _PlatformPolicy(),
      nativePushEnabled = false,
      crashReportingEnabled = false,
      analyticsEnabled = false;

  const MobileReleasePolicy._(
    this._android,
    this._ios,
    this.nativePushEnabled,
    this.crashReportingEnabled,
    this.analyticsEnabled,
  );

  /// Reject the entire invalid candidate so callers can retain a usable policy.
  factory MobileReleasePolicy.fromRemoteConfig(Map<String, Object?> values) =>
      MobileReleasePolicy._(
        _PlatformPolicy.parse(values, 'android'),
        _PlatformPolicy.parse(values, 'ios'),
        _boolean(values, 'native_push_enabled'),
        _boolean(values, 'crash_reporting_enabled'),
        _boolean(values, 'analytics_enabled'),
      );

  final _PlatformPolicy _android;
  final _PlatformPolicy _ios;
  final bool nativePushEnabled;
  final bool crashReportingEnabled;
  final bool analyticsEnabled;

  Map<String, Object> toValues() => {
    ..._android.toValues('android'),
    ..._ios.toValues('ios'),
    'native_push_enabled': nativePushEnabled,
    'crash_reporting_enabled': crashReportingEnabled,
    'analytics_enabled': analyticsEnabled,
  };

  MobileUpdateRequirement evaluate({
    required MobileReleasePlatform platform,
    required String runningVersion,
    required int runningBuild,
    String? backendMinimumVersion,
  }) {
    final running = _version(runningVersion);
    final backend = backendMinimumVersion == null
        ? null
        : _version(backendMinimumVersion);
    if (running == null ||
        runningBuild < 0 ||
        (backendMinimumVersion != null && backend == null)) {
      return MobileUpdateRequirement.incompatible;
    }
    final policy = platform == MobileReleasePlatform.android ? _android : _ios;
    if ((backend != null && running.compareTo(backend) < 0) ||
        policy.minimum.isAbove(running, runningBuild)) {
      return MobileUpdateRequirement.required;
    }
    if (policy.recommended.isAbove(running, runningBuild)) {
      return MobileUpdateRequirement.optional;
    }
    return MobileUpdateRequirement.none;
  }
}

abstract interface class CachedReleasePolicySource
    implements ReleasePolicySource {
  Future<MobileReleasePolicy> readCached();
}

abstract interface class ReleasePolicySource {
  Future<MobileReleasePolicy> fetch();
}

final class DisabledReleasePolicySource implements ReleasePolicySource {
  const DisabledReleasePolicySource();

  @override
  Future<MobileReleasePolicy> fetch() async =>
      const MobileReleasePolicy.disabled();
}

final class _PlatformPolicy {
  const _PlatformPolicy({
    this.minimum = const _ReleaseFloor(),
    this.recommended = const _ReleaseFloor(),
  });

  factory _PlatformPolicy.parse(Map<String, Object?> values, String platform) {
    final minimum = _ReleaseFloor.parse(values, '${platform}_minimum');
    final recommended = _ReleaseFloor.parse(values, '${platform}_recommended');
    // An omitted recommendation is fine; an explicit lower one is a mistake.
    if (recommended.version != null &&
        minimum.version != null &&
        recommended.compareTo(minimum) < 0) {
      throw FormatException('$platform recommendation is below minimum');
    }
    return _PlatformPolicy(minimum: minimum, recommended: recommended);
  }

  Map<String, Object> toValues(String platform) => {
    '${platform}_minimum_version': minimum.version?.toString() ?? '',
    '${platform}_minimum_build': minimum.build,
    '${platform}_recommended_version': recommended.version?.toString() ?? '',
    '${platform}_recommended_build': recommended.build,
  };

  final _ReleaseFloor minimum;
  final _ReleaseFloor recommended;
}

final class _ReleaseFloor {
  const _ReleaseFloor({this.version, this.build = 0});

  factory _ReleaseFloor.parse(Map<String, Object?> values, String prefix) {
    final rawVersion = values['${prefix}_version'];
    final rawBuild = values['${prefix}_build'];
    // Empty Remote Config version defaults mean no floor. A build alone has no
    // version to qualify and is rejected instead of applying across releases.
    final unset = rawVersion == null || rawVersion == '';
    final version = rawVersion is String ? _version(rawVersion) : null;
    if (!unset && version == null) {
      throw FormatException('Invalid ${prefix}_version');
    }
    final build = rawBuild ?? 0;
    if (build is! int || build < 0 || (unset && build != 0)) {
      throw FormatException('Invalid ${prefix}_build');
    }
    return _ReleaseFloor(version: version, build: build);
  }

  final SemVer? version;
  final int build;

  bool isAbove(SemVer running, int runningBuild) =>
      version != null &&
      (version!.compareTo(running) > 0 ||
          (version!.compareTo(running) == 0 && build > runningBuild));

  int compareTo(_ReleaseFloor other) {
    final comparison = version!.compareTo(other.version!);
    return comparison == 0 ? build.compareTo(other.build) : comparison;
  }
}

// Bound each component before delegating to SemVer's int.parse.
SemVer? _version(String value) =>
    RegExp(r'^[0-9]{1,9}\.[0-9]{1,9}\.[0-9]{1,9}$').hasMatch(value)
    ? SemVer.tryParse(value)
    : null;

bool _boolean(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value == null) return false;
  if (value is bool) return value;
  throw FormatException('Invalid $key');
}
