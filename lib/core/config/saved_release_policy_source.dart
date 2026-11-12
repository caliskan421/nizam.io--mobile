import '../preferences/app_preferences.dart';
import 'mobile_release_policy.dart';

/// Firebase initialization failure cannot clear a previously accepted floor.
final class SavedReleasePolicySource implements CachedReleasePolicySource {
  SavedReleasePolicySource(this._preferences);
  final AppPreferences _preferences;
  @override
  Future<MobileReleasePolicy> readCached() async =>
      await _preferences.releasePolicy() ??
      const MobileReleasePolicy.disabled();
  @override
  Future<MobileReleasePolicy> fetch() => readCached();
}
