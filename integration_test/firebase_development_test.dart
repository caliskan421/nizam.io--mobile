import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nizamio/app/config/firebase_release_policy_source.dart';
import 'package:nizamio/app/config/firebase_services.dart';
import 'package:nizamio/core/config/flavor.dart';

/// Gerçek native yapılandırma ve Remote Config bağlantısı; APNs veya FCM tokenı
/// istemez, bildirim izni açmaz, backend'e veya oturum deposuna erişmez.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dev Firebase yapılandırması ve Remote Config okunabilir', (
    tester,
  ) async {
    final services = await initializeFirebaseServices(
      Flavor.dev,
      timeout: const Duration(seconds: 10),
    );
    expect(services, isNotNull);
    final app = Firebase.app();
    expect(app.options.projectId, 'nizamio-mobile');
    expect(FirebaseMessaging.instance.isAutoInitEnabled, isFalse);

    final policy = await services!.releasePolicySource.fetch();
    expect(
      FirebaseRemoteConfig.instance.lastFetchStatus,
      RemoteConfigFetchStatus.success,
    );
    final sdk = FirebaseRemoteConfig.instance;
    // Compare actual native payloads with the accepted policy, not a hardcoded
    // console publication. These allowlisted values contain no user data.
    final values = policy.toValues();
    // Even an all-default publication must be accepted, not silently discarded
    // as an invalid candidate and replaced by the disabled fallback.
    final source = services.releasePolicySource as FirebaseReleasePolicySource;
    expect(source.origin, ReleasePolicyOrigin.remote);
    expect(
      values['ios_recommended_version'],
      sdk.getString('ios_recommended_version'),
    );
    expect(
      sdk.settings.minimumFetchInterval,
      kDebugMode ? const Duration(seconds: 30) : const Duration(hours: 12),
    );
    for (final key in const [
      'native_push_enabled',
      'crash_reporting_enabled',
      'analytics_enabled',
    ]) {
      final native = sdk.getAll()[key];
      expect(native, isNotNull);
      expect(values[key], native!.asBool(), reason: 'Native $key roundtrip');
      if (native.source == ValueSource.valueDefault) {
        debugPrint(
          'Firebase native default $key: ${native.asString()} (${native.source.name})',
        );
        expect(values[key], isFalse);
      }
    }
  });
}
