import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/config/saved_release_policy_source.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/storage/preference_store.dart';

void main() {
  test(
    'unresponsive read is bounded and distinguished from absent cache',
    () async {
      final prefs = AppPreferences(_BlockedStore());
      await expectLater(prefs.releasePolicy(), throwsFormatException);
    },
  );

  test(
    'timed out writes stay ordered and cannot overwrite a newer floor',
    () async {
      final store = _BlockedStore();
      final prefs = AppPreferences(store);
      final older = MobileReleasePolicy.fromRemoteConfig({
        'android_minimum_version': '0.3.0',
      });
      final newer = MobileReleasePolicy.fromRemoteConfig({
        'android_minimum_version': '0.4.0',
      });
      final first = prefs.setReleasePolicy(older);
      final second = prefs.setReleasePolicy(newer);
      await Future.wait([first, second]);
      expect(store.writes, hasLength(1));
      store.firstWrite.complete();
      await Future<void>.delayed(Duration.zero);
      expect(store.writes, hasLength(2));
      expect(
        (jsonDecode(store.values[AppPreferences.releasePolicyKey]!)
            as Map)['android_minimum_version'],
        '0.4.0',
      );
    },
  );

  test(
    'validated policy survives new process without Firebase initialization',
    () async {
      final store = MemoryPreferenceStore();
      await AppPreferences(store).setReleasePolicy(
        MobileReleasePolicy.fromRemoteConfig({
          'android_minimum_version': '0.3.0',
          'android_minimum_build': 8,
        }),
      );
      final freshProcess = SavedReleasePolicySource(AppPreferences(store));
      final policy = await freshProcess.readCached();
      expect(
        policy.evaluate(
          platform: MobileReleasePlatform.android,
          runningVersion: '0.2.0',
          runningBuild: 2,
        ),
        MobileUpdateRequirement.required,
      );
      expect((await freshProcess.fetch()).toValues(), policy.toValues());
    },
  );
  test(
    'corrupt storage is rejected, arbitrary remote fields never persisted',
    () async {
      final store = MemoryPreferenceStore();
      store.values[AppPreferences.releasePolicyKey] = '{broken';
      await expectLater(
        AppPreferences(store).releasePolicy(),
        throwsFormatException,
      );
      await AppPreferences(store).setReleasePolicy(
        MobileReleasePolicy.fromRemoteConfig({
          'android_minimum_version': '0.3.0',
          'secret': 'not-retained',
        }),
      );
      expect(
        store.values[AppPreferences.releasePolicyKey],
        isNot(contains('not-retained')),
      );
    },
  );
}

class _BlockedStore extends MemoryPreferenceStore {
  final firstWrite = Completer<void>();
  final writes = <String>[];
  @override
  Future<String?> getString(String key) => Completer<String?>().future;
  @override
  Future<void> setString(String key, String value) async {
    writes.add(value);
    if (writes.length == 1) await firstWrite.future;
    values[key] = value;
  }
}
