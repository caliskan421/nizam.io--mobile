import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/firebase_release_policy_source.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';

void main() {
  test(
    'construction is dormant; fetch loads cache before SDK defaults',
    () async {
      final sdk = _RemoteConfigFake()..cached = _required;
      final source = FirebaseReleasePolicySource(sdk);
      expect(sdk.calls, isEmpty);
      await source.fetch();
      expect(sdk.calls, [
        'initialize',
        'read',
        'defaults',
        'settings',
        'fetch',
        'read',
      ]);
      expect(source.origin, ReleasePolicyOrigin.remote);
      expect(sdk.settingsUsed!.fetchTimeout, const Duration(seconds: 8));
      expect(sdk.settingsUsed!.minimumFetchInterval, const Duration(hours: 12));
    },
  );

  test('first offline fetch retains activated mandatory policy', () async {
    final sdk = _RemoteConfigFake()
      ..cached = _required
      ..offline = true;
    final source = FirebaseReleasePolicySource(sdk);
    expect(
      _requirement(await source.fetch()),
      MobileUpdateRequirement.required,
    );
    expect(source.origin, ReleasePolicyOrigin.cache);
  });

  test(
    'invalid remote values cannot replace last valid mandatory policy',
    () async {
      final sdk = _RemoteConfigFake()..remote = _required;
      final source = FirebaseReleasePolicySource(sdk);
      final good = await source.fetch();
      for (final invalid in ['garbage', '-1', '1.5', '99999999999999999999']) {
        sdk.remote = {..._required, 'android_minimum_build': invalid};
        expect(await source.fetch(), same(good));
      }
      sdk.remote = {..._required, 'analytics_enabled': 'yes'};
      expect(await source.fetch(), same(good));
      sdk.remote = {..._required, 'android_minimum_version': 'broken'};
      expect(await source.fetch(), same(good));
      sdk.offline = true;
      expect(await source.fetch(), same(good));
    },
  );

  test(
    'malformed cache can recover from remote and unknown keys are ignored',
    () async {
      final sdk = _RemoteConfigFake()
        ..cached = {'analytics_enabled': 'yes'}
        ..remote = {
          ..._required,
          'unknown_key': 'anything',
          'analytics_enabled': 'true',
        };
      final source = FirebaseReleasePolicySource(sdk);
      final policy = await source.fetch();
      expect(_requirement(policy), MobileUpdateRequirement.required);
      expect(policy.analyticsEnabled, isTrue);
    },
  );

  test('missing offline cache gives safe disabled policy', () async {
    final source = FirebaseReleasePolicySource(
      _RemoteConfigFake()..offline = true,
    );
    final policy = await source.fetch();
    expect(_requirement(policy), MobileUpdateRequirement.none);
    expect(policy.nativePushEnabled, isFalse);
    expect(policy.crashReportingEnabled, isFalse);
    expect(policy.analyticsEnabled, isFalse);
    expect(source.origin, ReleasePolicyOrigin.defaults);
  });
}

const _required = {'android_minimum_version': '2.0.0'};

MobileUpdateRequirement _requirement(MobileReleasePolicy policy) =>
    policy.evaluate(
      platform: MobileReleasePlatform.android,
      runningVersion: '1.0.0',
      runningBuild: 1,
    );

class _RemoteConfigFake implements FirebaseRemoteConfig {
  final calls = <String>[];
  Map<String, String> cached = {};
  Map<String, String>? remote;
  bool offline = false;
  RemoteConfigSettings? settingsUsed;

  @override
  Future<void> ensureInitialized() async => calls.add('initialize');

  @override
  Map<String, RemoteConfigValue> getAll() {
    calls.add('read');
    return cached.map(
      (key, value) => MapEntry(
        key,
        RemoteConfigValue(utf8.encode(value), ValueSource.valueRemote),
      ),
    );
  }

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    calls.add('defaults');
  }

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {
    calls.add('settings');
    settingsUsed = settings;
  }

  @override
  Future<bool> fetchAndActivate() async {
    calls.add('fetch');
    if (offline) throw Exception('offline');
    cached = remote ?? cached;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
