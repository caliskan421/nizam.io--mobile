import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/firebase_release_policy_source.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';

void main() {
  test(
    'native Apple boolean defaults preserve remote release recommendations',
    () async {
      final sdk = _RemoteConfigFake()
        ..defaultKeys = {
          'native_push_enabled',
          'crash_reporting_enabled',
          'analytics_enabled',
        }
        ..remote = {
          'ios_recommended_version': '0.2.2',
          'native_push_enabled': '0',
          'crash_reporting_enabled': '0',
          'analytics_enabled': '0',
        };
      final source = FirebaseReleasePolicySource(sdk);
      final policy = await source.fetch();
      expect(policy.toValues()['ios_recommended_version'], '0.2.2');
      expect(
        policy.evaluate(
          platform: MobileReleasePlatform.ios,
          runningVersion: '0.2.1',
          runningBuild: 3,
        ),
        MobileUpdateRequirement.optional,
      );
      expect(policy.nativePushEnabled, isFalse);
      expect(policy.crashReportingEnabled, isFalse);
      expect(policy.analyticsEnabled, isFalse);
    },
  );

  test(
    'mixed boolean representations roundtrip; arbitrary yes is still rejected',
    () async {
      for (final candidate in [
        {
          'native_push_enabled': '1',
          'crash_reporting_enabled': 'true',
          'analytics_enabled': '0',
        },
        {
          'native_push_enabled': 'true',
          'crash_reporting_enabled': '1',
          'analytics_enabled': 'false',
        },
      ]) {
        final sdk = _RemoteConfigFake()..remote = {..._required, ...candidate};
        final source = FirebaseReleasePolicySource(sdk);
        final good = await source.fetch();
        expect(good.nativePushEnabled, isTrue);
        expect(good.crashReportingEnabled, isTrue);
        expect(good.analyticsEnabled, isFalse);
        sdk.remote = {..._required, ...candidate, 'analytics_enabled': 'yes'};
        expect(await source.fetch(), same(good));
      }
    },
  );

  test(
    'custom debug fetch interval is applied; default remains twelve hours',
    () async {
      final sdk = _RemoteConfigFake();
      await FirebaseReleasePolicySource(
        sdk,
        minimumFetchInterval: const Duration(seconds: 30),
      ).fetch();
      expect(
        sdk.settingsUsed!.minimumFetchInterval,
        const Duration(seconds: 30),
      );
      await FirebaseReleasePolicySource(sdk).fetch();
      expect(sdk.settingsUsed!.minimumFetchInterval, const Duration(hours: 12));
    },
  );

  test(
    'temporary disk failure recovers on retry while Remote Config is offline',
    () async {
      final store = MemoryPreferenceStore();
      await AppPreferences(store)
          .setReleasePolicy(MobileReleasePolicy.fromRemoteConfig(_required));
      store.failAll = true;
      final source = FirebaseReleasePolicySource(
        _RemoteConfigFake()..offline = true,
        preferences: AppPreferences(store),
      );
      await expectLater(source.readCached(), throwsFormatException);
      store.failAll = false;
      expect(
        _requirement(await source.readCached()),
        MobileUpdateRequirement.required,
      );
      expect(
        _requirement(await source.fetch()),
        MobileUpdateRequirement.required,
      );
    },
  );

  test('readCached returns latest accepted remote floor, never first empty snapshot', () async {
    final sdk = _RemoteConfigFake()..remote = _required;
    final source = FirebaseReleasePolicySource(sdk);
    expect(
      _requirement(await source.readCached()),
      MobileUpdateRequirement.none,
    );
    await source.fetch();
    expect(
      _requirement(await source.readCached()),
      MobileUpdateRequirement.required,
    );
  });

  test('stored floor is emitted without waiting for network', () async {
    final store = MemoryPreferenceStore();
    await AppPreferences(store)
        .setReleasePolicy(MobileReleasePolicy.fromRemoteConfig(_required));
    final network = Completer<void>();
    final sdk = _RemoteConfigFake()..blocked = network.future;
    final source = FirebaseReleasePolicySource(
      sdk,
      preferences: AppPreferences(store),
    );
    final fetch = source.fetch();
    expect(
      _requirement(await source.readCached()),
      MobileUpdateRequirement.required,
    );
    network.complete();
    await fetch;
  });

  test('unreadable stored policy cannot silently lift gate; valid remote can recover', () async {
    final store = MemoryPreferenceStore();
    store.values[AppPreferences.releasePolicyKey] = '{broken';
    final sdk = _RemoteConfigFake()..offline = true;
    final source = FirebaseReleasePolicySource(
      sdk,
      preferences: AppPreferences(store),
    );
    await expectLater(source.readCached(), throwsFormatException);
    await expectLater(source.fetch(), throwsFormatException);
    sdk.offline = false;
    sdk.remote = _required;
    expect(
      _requirement(await source.fetch()),
      MobileUpdateRequirement.required,
    );
    expect(
      _requirement(await source.readCached()),
      MobileUpdateRequirement.required,
    );
  });

  test(
    'bad publication cannot destroy last valid policy across launches',
    () async {
      final store = MemoryPreferenceStore();
      final sdk = _RemoteConfigFake()..remote = _required;
      await FirebaseReleasePolicySource(
        sdk,
        preferences: AppPreferences(store),
      ).fetch();
      sdk.cached = {'android_minimum_version': 'broken'};
      sdk.offline = true;
      final fresh = FirebaseReleasePolicySource(
        sdk,
        preferences: AppPreferences(store),
      );
      expect(
        _requirement(await fresh.readCached()),
        MobileUpdateRequirement.required,
      );
      expect(sdk.calls.where((call) => call == 'fetch').length, 1);
      expect(
        _requirement(await fresh.fetch()),
        MobileUpdateRequirement.required,
      );
    },
  );

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
  Set<String> defaultKeys = {};
  Map<String, String>? remote;
  bool offline = false;
  Future<void>? blocked;
  RemoteConfigSettings? settingsUsed;

  @override
  Future<void> ensureInitialized() async => calls.add('initialize');

  @override
  Map<String, RemoteConfigValue> getAll() {
    calls.add('read');
    return cached.map(
      (key, value) => MapEntry(
        key,
        RemoteConfigValue(
          utf8.encode(value),
          defaultKeys.contains(key)
              ? ValueSource.valueDefault
              : ValueSource.valueRemote,
        ),
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
    await blocked;
    if (offline) throw Exception('offline');
    cached = remote ?? cached;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
