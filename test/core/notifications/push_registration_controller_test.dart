import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/notifications/push_notifications.dart';
import 'package:nizamio/core/notifications/push_registration_controller.dart';

void main() {
  const owner = PushOwner(instanceId: 'server', userId: 'user', sessionId: 's');
  late FakePush push;
  late FakeRepository repository;
  late PushRegistrationController controller;

  setUp(() {
    push = FakePush();
    repository = FakeRepository();
    controller = PushRegistrationController(
      notifications: push,
      repository: repository,
      platform: PushPlatform.android,
    );
  });

  tearDown(() async {
    repository.failure = false;
    await controller.dispose();
    await push.tokens.close();
  });

  test(
    'construction does not prompt; denied permission never registers',
    () async {
      expect(push.prompts, 0);
      push.permission = PushPermission.denied;
      await controller.enable(owner);
      expect(push.prompts, 1);
      expect(repository.registered, isEmpty);
      expect(controller.state.permission, PushPermission.denied);
    },
  );

  test('refresh retires previous token and logout clears ownership', () async {
    await controller.enable(owner);
    push.tokens.add('new');
    await pumpEventQueue();
    expect(repository.registered.map((r) => r.token), ['initial', 'new']);
    expect(repository.deleted, ['id-1']);
    final logout = controller.disable();
    expect(controller.state.owner, isNull);
    expect(controller.state.isRegistered, isFalse);
    await logout;
    expect(repository.deleted, ['id-1', 'id-2']);
    push.tokens.add('after-logout');
    await pumpEventQueue();
    expect(repository.registered, hasLength(2));
  });

  test(
    'logout deletes a registration completing after ownership clears',
    () async {
      repository.gate = Completer<String>();
      final enabling = controller.enable(owner);
      await pumpEventQueue();
      final disabling = controller.disable();
      expect(controller.state.owner, isNull);
      repository.gate!.complete('late');
      await Future.wait([enabling, disabling]);
      expect(repository.deleted, ['late']);
      expect(controller.state.isRegistered, isFalse);
    },
  );

  test(
    'owner transition cannot bind old in-flight result to new owner',
    () async {
      repository.gate = Completer<String>();
      final first = controller.enable(owner);
      await pumpEventQueue();
      const next = PushOwner(
        instanceId: 'other',
        userId: 'user',
        sessionId: 's2',
      );
      final second = controller.enable(next);
      repository.gate!.complete('old');
      repository.gate = null;
      await Future.wait([first, second]);
      expect(repository.deleted, ['old']);
      expect(repository.registered.last.owner, next);
      expect(controller.state.owner, next);
      expect(controller.state.isRegistered, isTrue);
    },
  );

  test('registration failure reaches caller and observable state', () async {
    repository.failure = true;
    await expectLater(controller.enable(owner), throwsStateError);
    expect(controller.state.error, isA<StateError>());
    expect(controller.state.isRegistered, isFalse);
  });

  test(
    'token churn deletes stale in-flight token before registering latest',
    () async {
      repository.gate = Completer<String>();
      final enabling = controller.enable(owner);
      await pumpEventQueue();
      push.tokens.add('middle');
      push.tokens.add('latest');
      await pumpEventQueue();
      repository.gate!.complete('stale');
      repository.gate = null;
      await enabling;
      await pumpEventQueue();
      expect(repository.deleted, ['stale']);
      expect(repository.registered.map((r) => r.token), ['initial', 'latest']);
      expect(controller.state.isRegistered, isTrue);
    },
  );

  test(
    'dispose waits for late registration cleanup and rejects reuse',
    () async {
      repository.gate = Completer<String>();
      final enabling = controller.enable(owner);
      await pumpEventQueue();
      final disposing = controller.dispose();
      expect(controller.state.owner, isNull);
      repository.gate!.complete('late-dispose');
      await Future.wait([enabling, disposing]);
      expect(repository.deleted, ['late-dispose']);
      await expectLater(controller.enable(owner), throwsStateError);
    },
  );

  test('failed deletion is retried without rebinding ownership', () async {
    await controller.enable(owner);
    repository.failure = true;
    await expectLater(controller.disable(), throwsStateError);
    expect(controller.state.owner, isNull);
    repository.failure = false;
    await controller.disable();
    expect(repository.deleted, ['id-1']);
  });

  test('disabled adapter and defensive message data are safe', () async {
    const disabled = DisabledPushNotifications();
    expect(disabled.isSupported, isFalse);
    expect(await disabled.requestPermission(), PushPermission.denied);
    expect(await disabled.getToken(), isNull);
    expect(await disabled.getInitialMessage(), isNull);
    expect(await disabled.tokenChanges.toList(), isEmpty);
    expect(await disabled.foregroundMessages.toList(), isEmpty);
    expect(await disabled.openedMessages.toList(), isEmpty);
    final data = {'key': 'value'};
    final message = PushMessage(data: data);
    data.clear();
    expect(message.data, {'key': 'value'});
    expect(message.data.clear, throwsUnsupportedError);
  });
}

final class FakePush implements PushNotifications {
  // Closed by tearDown, after the controller cancels its subscription.
  // ignore: close_sinks
  final tokens = StreamController<String>.broadcast();
  PushPermission permission = PushPermission.authorized;
  int prompts = 0;
  @override
  bool get isSupported => true;
  @override
  Stream<String> get tokenChanges => tokens.stream;
  @override
  Future<PushPermission> requestPermission() async {
    prompts++;
    return permission;
  }

  @override
  Future<String?> getToken() async => 'initial';
  @override
  Stream<PushMessage> get foregroundMessages => const Stream.empty();
  @override
  Stream<PushMessage> get openedMessages => const Stream.empty();
  @override
  Future<PushMessage?> getInitialMessage() async => null;
}

final class FakeRepository implements NativePushRegistrationRepository {
  final registered = <PushRegistration>[];
  final deleted = <String>[];
  Completer<String>? gate;
  bool failure = false;
  @override
  Future<String> register(PushRegistration registration) async {
    if (failure) throw StateError('register failed');
    registered.add(registration);
    return gate?.future ?? 'id-${registered.length}';
  }

  @override
  Future<void> unregister(PushRegistration registration, String id) async {
    if (failure) throw StateError('unregister failed');
    deleted.add(id);
  }
}
