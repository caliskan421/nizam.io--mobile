import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../core/notifications/push_notifications.dart';

/// Native transport only. The caller initializes Firebase before constructing it.
/// Construction neither requests permission nor changes Firebase auto-init.
class FirebasePushNotifications implements PushNotifications {
  FirebasePushNotifications({
    required this._messaging,
    this._foregroundMessages,
    this._openedMessages,
  });

  final FirebaseMessaging _messaging;
  final Stream<RemoteMessage>? _foregroundMessages;
  final Stream<RemoteMessage>? _openedMessages;

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<PushPermission> requestPermission() async {
    if (!isSupported) return PushPermission.denied;
    final settings = await _messaging.requestPermission();
    return switch (settings.authorizationStatus) {
      AuthorizationStatus.notDetermined => PushPermission.notDetermined,
      AuthorizationStatus.denied ||
      AuthorizationStatus.deniedPermanently => PushPermission.denied,
      AuthorizationStatus.authorized => PushPermission.authorized,
      AuthorizationStatus.provisional => PushPermission.provisional,
    };
  }

  @override
  Future<String?> getToken() async {
    if (!isSupported) return null;
    // APNs registration may still be pending. A later explicit call may retry.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await _messaging.getAPNSToken() == null) {
      return null;
    }
    return _messaging.getToken();
  }

  @override
  Stream<String> get tokenChanges =>
      isSupported ? _messaging.onTokenRefresh : const Stream.empty();

  @override
  Stream<PushMessage> get foregroundMessages => isSupported
      ? (_foregroundMessages ?? FirebaseMessaging.onMessage).map(_message)
      : const Stream.empty();

  @override
  Stream<PushMessage> get openedMessages => isSupported
      ? (_openedMessages ?? FirebaseMessaging.onMessageOpenedApp).map(_message)
      : const Stream.empty();

  @override
  Future<PushMessage?> getInitialMessage() async {
    if (!isSupported) return null;
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _message(message);
  }

  static PushMessage _message(RemoteMessage message) => PushMessage(
    id: message.messageId,
    data: {
      for (final entry in message.data.entries)
        if (entry.value is String) entry.key: entry.value as String,
    },
  );
}
