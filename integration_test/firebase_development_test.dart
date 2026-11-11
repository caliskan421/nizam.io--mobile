import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
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
    // SDK kullanıma hazır; gerçek parametreler farklı olabilir. Kararın UI'ı
    // kilitlemesi ve telemetry/push açması bu bağlantı testinin kapsamında değil.
    expect(policy, isNotNull);
  });
}
