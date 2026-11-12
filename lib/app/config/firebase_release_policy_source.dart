import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../core/config/mobile_release_policy.dart';
import '../../core/preferences/app_preferences.dart';
import '../../core/telemetry/report_source.dart';
import '../../core/telemetry/unexpected_error.dart';

enum ReleasePolicyOrigin { defaults, cache, remote }

/// Explicitly injected and dormant until [fetch] is requested by composition.
/// Flags describe intent; this source never enables telemetry or messaging.
final class FirebaseReleasePolicySource implements CachedReleasePolicySource {
  FirebaseReleasePolicySource(
    this._remoteConfig, {
    AppPreferences? preferences,
    this.minimumFetchInterval = const Duration(hours: 12),
  })
    // The public named parameter intentionally hides the private field.
    // ignore: prefer_initializing_formals
    : _preferences = preferences;

  final AppPreferences? _preferences;
  final Duration minimumFetchInterval;
  Future<void>? _cacheRead;

  @override
  Future<MobileReleasePolicy> readCached() async {
    if (_hasGood) return _lastGood;
    await (_cacheRead ??= _readCached());
    if (_cacheFailed && !_hasGood) {
      throw const FormatException('Stored release policy is unavailable');
    }
    return _lastGood;
  }

  Future<void> _readCached() async {
    try {
      final saved = await _preferences?.releasePolicy();
      _cacheFailed = false;
      if (saved != null) {
        _lastGood = saved;
        _hasGood = true;
        _origin = ReleasePolicyOrigin.cache;
      }
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      _cacheFailed = true;
      // Failed disk reads must be retried after a temporary platform failure.
      _cacheRead = null;
    }
  }

  final FirebaseRemoteConfig _remoteConfig;
  MobileReleasePolicy _lastGood = const MobileReleasePolicy.disabled();
  bool _hasGood = false;
  bool _cacheFailed = false;
  Future<MobileReleasePolicy>? _inFlight;
  ReleasePolicyOrigin _origin = ReleasePolicyOrigin.defaults;

  /// SDK values after a successful fetch/activate call may still be cached;
  /// [ReleasePolicyOrigin.remote] does not assert a fresh network fetch.
  ReleasePolicyOrigin get origin => _origin;

  static const _defaults = <String, Object>{
    'android_minimum_version': '',
    'android_recommended_version': '',
    'ios_minimum_version': '',
    'ios_recommended_version': '',
    'android_minimum_build': 0,
    'android_recommended_build': 0,
    'ios_minimum_build': 0,
    'ios_recommended_build': 0,
    'native_push_enabled': false,
    'crash_reporting_enabled': false,
    'analytics_enabled': false,
  };

  @override
  Future<MobileReleasePolicy> fetch() =>
      _inFlight ??= _fetch().whenComplete(() => _inFlight = null);

  Future<MobileReleasePolicy> _fetch() async {
    if (!_hasGood) await (_cacheRead ??= _readCached());
    try {
      await _remoteConfig.ensureInitialized();
      // Load activated persisted values before network access, including on the
      // first offline launch. Never replace an in-memory good policy with cache.
      if (!_hasGood) {
        try {
          _accept(ReleasePolicyOrigin.cache);
        } on FormatException {
          // A malformed persisted candidate must not prevent remote recovery.
        }
      }
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 8),
          minimumFetchInterval: minimumFetchInterval,
        ),
      );
      await _remoteConfig.fetchAndActivate();
      _accept(ReleasePolicyOrigin.remote);
    } on Exception {
      // Unavailable SDK, transport failure or invalid candidate: retain the
      // complete last valid policy, including any mandatory update floor.
    }
    if (_cacheFailed && !_hasGood) {
      throw const FormatException('No usable release policy');
    }
    if (_hasGood) await _preferences?.setReleasePolicy(_lastGood);
    return _lastGood;
  }

  void _accept(ReleasePolicyOrigin candidateOrigin) {
    final all = _remoteConfig.getAll();
    final values = <String, Object?>{};
    for (final key in _defaults.keys) {
      final value = all[key];
      if (value == null || value.source == ValueSource.valueStatic) continue;
      final raw = value.asString();
      if (key.endsWith('_version')) {
        values[key] = raw;
      } else if (key.endsWith('_build')) {
        if (!RegExp(r'^[0-9]{1,9}$').hasMatch(raw)) {
          throw const FormatException('Invalid release build');
        }
        values[key] = int.parse(raw);
      } else {
        // Apple NSNumber defaults serialize booleans as UTF-8 "0"/"1".
        // Validate before asBool(), which would turn arbitrary text into false.
        if (raw != 'true' && raw != 'false' && raw != '0' && raw != '1') {
          throw const FormatException('Invalid release flag');
        }
        values[key] = value.asBool();
      }
    }
    if (values.isEmpty) return;
    final policy = MobileReleasePolicy.fromRemoteConfig(values);
    _lastGood = policy;
    _hasGood = true;
    _cacheFailed = false;
    _origin = candidateOrigin;
    // Persistence happens once after fetch, never concurrently for SDK cache
    // and the newer remote candidate.
  }
}
