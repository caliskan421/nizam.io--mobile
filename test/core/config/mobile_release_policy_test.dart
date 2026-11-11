import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';

void main() {
  MobileUpdateRequirement decide(
    MobileReleasePolicy policy, {
    String version = '1.9.0',
    int build = 3,
    String? backend,
    MobileReleasePlatform platform = MobileReleasePlatform.android,
  }) => policy.evaluate(
    platform: platform,
    runningVersion: version,
    runningBuild: build,
    backendMinimumVersion: backend,
  );

  test('disabled defaults collect nothing and still enforce backend', () async {
    final policy = await const DisabledReleasePolicySource().fetch();
    expect(policy.nativePushEnabled, isFalse);
    expect(policy.analyticsEnabled, isFalse);
    expect(policy.crashReportingEnabled, isFalse);
    expect(decide(policy), MobileUpdateRequirement.none);
    expect(decide(policy, backend: '1.10.0'), MobileUpdateRequirement.required);
  });

  test('numeric ordering, platforms and recommendation precedence', () {
    final policy = MobileReleasePolicy.fromRemoteConfig({
      'android_minimum_version': '1.8.0',
      'android_recommended_version': '1.10.0',
      'ios_minimum_version': '2.0.0',
    });
    expect(decide(policy), MobileUpdateRequirement.optional);
    expect(decide(policy, version: '1.7.0'), MobileUpdateRequirement.required);
    expect(decide(policy, version: '1.10.0'), MobileUpdateRequirement.none);
    expect(
      decide(policy, platform: MobileReleasePlatform.ios),
      MobileUpdateRequirement.required,
    );
    expect(decide(policy, backend: '2.0.0'), MobileUpdateRequirement.required);
  });

  test('build floors only apply at their version', () {
    final policy = MobileReleasePolicy.fromRemoteConfig({
      'android_minimum_version': '1.9.0',
      'android_minimum_build': 4,
      'android_recommended_version': '1.9.0',
      'android_recommended_build': 8,
    });
    expect(decide(policy), MobileUpdateRequirement.required);
    expect(decide(policy, build: 4), MobileUpdateRequirement.optional);
    expect(decide(policy, build: 8), MobileUpdateRequirement.none);
    expect(
      decide(policy, version: '1.9.1', build: 0),
      MobileUpdateRequirement.none,
    );
  });

  test('invalid runtime or backend is explicitly incompatible', () {
    const policy = MobileReleasePolicy.disabled();
    for (final version in [
      '',
      'v1.2.3',
      '1.2',
      '1.2.3+4',
      '999999999999.0.0',
    ]) {
      expect(
        decide(policy, version: version),
        MobileUpdateRequirement.incompatible,
      );
      expect(
        decide(policy, backend: version),
        MobileUpdateRequirement.incompatible,
      );
    }
    expect(decide(policy, build: -1), MobileUpdateRequirement.incompatible);
  });

  test(
    'malformed candidates reject atomically, including lower recommendations',
    () {
      for (final candidate in <Map<String, Object?>>[
        {'android_minimum_version': '1.2.3-beta'},
        {'ios_minimum_version': 123},
        {'android_minimum_version': '99999999999999999.2.3'},
        {'android_minimum_build': 4},
        {'android_minimum_build': -1},
        {'android_minimum_build': '4'},
        {'android_minimum_build': 4.0},
        {
          'android_minimum_version': '2.0.0',
          'android_recommended_version': '1.9.0',
        },
        {
          'android_minimum_version': '2.0.0',
          'android_minimum_build': 5,
          'android_recommended_version': '2.0.0',
          'android_recommended_build': 4,
        },
        {'native_push_enabled': 'true'},
        {'analytics_enabled': 1},
        {'crash_reporting_enabled': 'false'},
      ]) {
        expect(
          () => MobileReleasePolicy.fromRemoteConfig(candidate),
          throwsFormatException,
          reason: '$candidate',
        );
      }
    },
  );

  test('strict booleans and empty version defaults are supported', () {
    final policy = MobileReleasePolicy.fromRemoteConfig({
      'android_minimum_version': '',
      'android_minimum_build': 0,
      'native_push_enabled': true,
      'crash_reporting_enabled': true,
      'analytics_enabled': false,
    });
    expect(policy.nativePushEnabled, isTrue);
    expect(policy.crashReportingEnabled, isTrue);
    expect(policy.analyticsEnabled, isFalse);
    expect(decide(policy), MobileUpdateRequirement.none);
  });
}
