import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/notifications/firebase_push_notifications.dart';
import 'package:nizamio/core/notifications/push_notifications.dart';

void main() {
  late _Messaging messaging;
  late FirebasePushNotifications adapter;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    messaging = _Messaging();
    adapter = FirebasePushNotifications(messaging: messaging);
  });
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('construction has no SDK side effects', () {
    expect(messaging.calls, isEmpty);
    expect(adapter.isSupported, isTrue);
  });

  for (final status in AuthorizationStatus.values) {
    test('explicit permission maps $status without fetching a token', () async {
      messaging.status = status;
      final expected = switch (status) {
        AuthorizationStatus.notDetermined => PushPermission.notDetermined,
        AuthorizationStatus.denied ||
        AuthorizationStatus.deniedPermanently => PushPermission.denied,
        AuthorizationStatus.authorized => PushPermission.authorized,
        AuthorizationStatus.provisional => PushPermission.provisional,
      };
      expect(await adapter.requestPermission(), expected);
      expect(messaging.calls, [#requestPermission]);
    });
  }

  test('Android fetches token without APNs or prompting', () async {
    expect(await adapter.getToken(), 'token');
    expect(messaging.calls, [#getToken]);
    expect(await adapter.tokenChanges.toList(), ['rotated']);
  });

  test('iOS waits for APNs readiness without retries', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(await adapter.getToken(), isNull);
    expect(messaging.calls, [#getAPNSToken]);
    messaging.apns = 'apns';
    expect(await adapter.getToken(), 'token');
    expect(messaging.calls, [#getAPNSToken, #getAPNSToken, #getToken]);
  });

  test('all message entry points keep only string data', () async {
    const remote = RemoteMessage(
      messageId: 'message',
      data: {
        'conversation_id': 'untrusted-id',
        'number': 4,
        'nested': {'route': '/admin'},
        'null': null,
      },
    );
    messaging.initial = remote;
    adapter = FirebasePushNotifications(
      messaging: messaging,
      foregroundMessages: Stream.value(remote),
      openedMessages: Stream.value(remote),
    );
    final messages = [
      await adapter.foregroundMessages.first,
      await adapter.openedMessages.first,
      (await adapter.getInitialMessage())!,
    ];
    for (final message in messages) {
      expect(message.id, 'message');
      expect(message.data, {'conversation_id': 'untrusted-id'});
    }
  });

  test('missing initial message stays null', () async {
    expect(await adapter.getInitialMessage(), isNull);
  });

  for (final platform in [
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.fuchsia,
  ]) {
    test('unsupported $platform never touches SDK', () async {
      debugDefaultTargetPlatformOverride = platform;
      expect(adapter.isSupported, isFalse);
      expect(await adapter.requestPermission(), PushPermission.denied);
      expect(await adapter.getToken(), isNull);
      expect(await adapter.getInitialMessage(), isNull);
      expect(await adapter.tokenChanges.toList(), isEmpty);
      expect(await adapter.foregroundMessages.toList(), isEmpty);
      expect(await adapter.openedMessages.toList(), isEmpty);
      expect(messaging.calls, isEmpty);
    });
  }
}

class _Messaging implements FirebaseMessaging {
  final calls = <Symbol>[];
  AuthorizationStatus status = AuthorizationStatus.authorized;
  String? apns;
  RemoteMessage? initial;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation.memberName);
    return switch (invocation.memberName) {
      #requestPermission => Future<NotificationSettings>.value(
        _Settings(status),
      ),
      #getToken => Future<String?>.value('token'),
      #getAPNSToken => Future<String?>.value(apns),
      #getInitialMessage => Future<RemoteMessage?>.value(initial),
      #onTokenRefresh => Stream<String>.value('rotated'),
      _ => throw StateError('Unexpected SDK call: ${invocation.memberName}'),
    };
  }
}

class _Settings implements NotificationSettings {
  _Settings(this.authorizationStatus);
  @override
  final AuthorizationStatus authorizationStatus;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
