/// Platform-neutral access to native notification delivery.
abstract interface class PushNotifications {
  bool get isSupported;
  Future<PushPermission> requestPermission();
  Future<String?> getToken();
  Stream<String> get tokenChanges;
  Stream<PushMessage> get foregroundMessages;
  Stream<PushMessage> get openedMessages;
  Future<PushMessage?> getInitialMessage();
}

enum PushPermission { notDetermined, denied, authorized, provisional }

final class PushMessage {
  PushMessage({this.id, Map<String, String> data = const {}})
    : data = Map.unmodifiable(data);

  final String? id;
  final Map<String, String> data;
}

final class DisabledPushNotifications implements PushNotifications {
  const DisabledPushNotifications();

  @override
  bool get isSupported => false;
  @override
  Future<PushPermission> requestPermission() async => PushPermission.denied;
  @override
  Future<String?> getToken() async => null;
  @override
  Stream<String> get tokenChanges => const Stream.empty();
  @override
  Stream<PushMessage> get foregroundMessages => const Stream.empty();
  @override
  Stream<PushMessage> get openedMessages => const Stream.empty();
  @override
  Future<PushMessage?> getInitialMessage() async => null;
}
