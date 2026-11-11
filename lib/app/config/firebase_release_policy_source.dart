import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../core/config/mobile_release_policy.dart';

enum ReleasePolicyOrigin { defaults, cache, remote }

/// Explicitly injected and dormant until [fetch] is requested by composition.
/// Flags describe intent; this source never enables telemetry or messaging.
final class FirebaseReleasePolicySource implements ReleasePolicySource {
  FirebaseReleasePolicySource(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;
  MobileReleasePolicy _lastGood = const MobileReleasePolicy.disabled();
  bool _hasGood = false;
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
  Future<MobileReleasePolicy> fetch() async {
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
          minimumFetchInterval: const Duration(hours: 12),
        ),
      );
      await _remoteConfig.fetchAndActivate();
      _accept(ReleasePolicyOrigin.remote);
    } on Exception {
      // Unavailable SDK, transport failure or invalid candidate: retain the
      // complete last valid policy, including any mandatory update floor.
    }
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
        if (raw != 'true' && raw != 'false') {
          throw const FormatException('Invalid release flag');
        }
        values[key] = raw == 'true';
      }
    }
    if (values.isEmpty) return;
    final policy = MobileReleasePolicy.fromRemoteConfig(values);
    _lastGood = policy;
    _hasGood = true;
    _origin = candidateOrigin;
  }
}
