import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/notifications/push_notifications.dart';
import 'package:nizamio/core/notifications/push_providers.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

void main() {
  test(
    'normal açılış native push kapalı; platform izni veya token üretmez',
    () async {
      final composition = Composition.create(
        flavor: Flavor.prod,
        secureStore: MemorySecureStore(),
        preferenceStore: MemoryPreferenceStore(),
      );
      addTearDown(composition.dispose);
      final port = composition.container.read(pushNotificationsProvider);
      expect(port, same(composition.locator<PushNotifications>()));
      expect(port.isSupported, isFalse);
      expect(await port.getToken(), isNull);
    },
  );

  test('yapılandırılmış portu bağlamak kendiliğinden izin istemez', () async {
    final push = _Push();
    final composition = Composition.create(
      flavor: Flavor.dev,
      secureStore: MemorySecureStore(),
      preferenceStore: MemoryPreferenceStore(),
      pushNotifications: push,
    );
    addTearDown(composition.dispose);
    expect(composition.container.read(pushNotificationsProvider), same(push));
    expect(push.permissionRequests, 0);
    expect(push.tokenReads, 0);
  });
}

class _Push implements PushNotifications {
  int permissionRequests = 0;
  int tokenReads = 0;

  @override
  bool get isSupported => true;
  @override
  Stream<String> get tokenChanges => const Stream.empty();
  @override
  Stream<PushMessage> get foregroundMessages => const Stream.empty();
  @override
  Stream<PushMessage> get openedMessages => const Stream.empty();
  @override
  Future<PushMessage?> getInitialMessage() async => null;

  @override
  Future<PushPermission> requestPermission() async {
    permissionRequests++;
    return PushPermission.authorized;
  }

  @override
  Future<String?> getToken() async {
    tokenReads++;
    return 'test-token';
  }
}
