import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/config/release_policy_provider.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

void main() {
  test('kapalı varsayılan backend asgari sürümünü gevşetmez', () async {
    final composition = Composition.create(
      flavor: Flavor.prod,
      secureStore: MemorySecureStore(),
      preferenceStore: MemoryPreferenceStore(),
    );
    addTearDown(composition.dispose);
    final source = composition.container.read(releasePolicySourceProvider);
    expect(source, same(composition.locator<ReleasePolicySource>()));
    final policy = await source.fetch();
    expect(policy.analyticsEnabled, isFalse);
    expect(
      policy.evaluate(
        platform: MobileReleasePlatform.android,
        runningVersion: '0.2.0',
        runningBuild: 2,
        backendMinimumVersion: '0.3.0',
      ),
      MobileUpdateRequirement.required,
    );
  });

  test('kaynak bağlamak açılışta Firebase isteği başlatmaz', () async {
    final source = _Source();
    final composition = Composition.create(
      flavor: Flavor.dev,
      secureStore: MemorySecureStore(),
      preferenceStore: MemoryPreferenceStore(),
      releasePolicySource: source,
    );
    addTearDown(composition.dispose);
    expect(
      composition.container.read(releasePolicySourceProvider),
      same(source),
    );
    expect(source.fetches, 0);
  });
}

class _Source implements ReleasePolicySource {
  int fetches = 0;

  @override
  Future<MobileReleasePolicy> fetch() async {
    fetches++;
    return const MobileReleasePolicy.disabled();
  }
}
