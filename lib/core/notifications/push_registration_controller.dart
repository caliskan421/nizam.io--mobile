import 'dart:async';

import '../telemetry/report_source.dart';
import '../telemetry/unexpected_error.dart';
import 'push_notifications.dart';

enum PushPlatform { android, ios }

final class PushOwner {
  const PushOwner({
    required this.instanceId,
    required this.userId,
    required this.sessionId,
  });

  final String instanceId;
  final String userId;
  final String sessionId;

  @override
  bool operator ==(Object other) =>
      other is PushOwner &&
      instanceId == other.instanceId &&
      userId == other.userId &&
      sessionId == other.sessionId;

  @override
  int get hashCode => Object.hash(instanceId, userId, sessionId);
}

final class PushRegistration {
  const PushRegistration({
    required this.owner,
    required this.token,
    required this.platform,
  });

  final PushOwner owner;
  final String token;
  final PushPlatform platform;
}

/// Implement only when an authoritative backend contract exists.
abstract interface class NativePushRegistrationRepository {
  Future<String> register(PushRegistration registration);
  Future<void> unregister(PushRegistration registration, String registrationId);
}

final class PushRegistrationState {
  const PushRegistrationState({
    this.owner,
    this.permission = PushPermission.notDetermined,
    this.isRegistered = false,
    this.error,
  });

  final PushOwner? owner;
  final PushPermission permission;
  final bool isRegistered;
  final Object? error;
}

/// Explicit opt-in lifecycle; construction never prompts for permission.
///
/// Call disable before invalidating the session's credentials, so the repository
/// can delete its registration using the captured owner. Failed deletions remain
/// queued for a later operation; this cannot guarantee remote deletion offline.
final class PushRegistrationController {
  PushRegistrationController({
    required PushNotifications notifications,
    required this._repository,
    required this._platform,
  }) : _notifications = notifications {
    _subscription = notifications.tokenChanges.listen(
      (token) {
        if (_owner == null || !_permitted || _disposed) return;
        _tokenRevision++;
        _token = token;
        unawaited(_enqueue(_reconcile).catchError((Object _) {}));
      },
      onError: (Object error, StackTrace st) {
        reportUnexpected(error, st, source: ReportSource.push);
        _publish(error: error);
      },
    );
  }

  final PushNotifications _notifications;
  final NativePushRegistrationRepository _repository;
  final PushPlatform _platform;
  final _states = StreamController<PushRegistrationState>.broadcast();
  late final StreamSubscription<String> _subscription;
  Future<void> _tail = Future.value();
  final List<({PushRegistration registration, String id})> _pending = [];
  ({PushRegistration registration, String id})? _active;
  PushOwner? _owner;
  String? _token;
  int _revision = 0;
  int _tokenRevision = 0;
  bool _disposed = false;
  PushPermission _permission = PushPermission.notDetermined;
  PushRegistrationState _state = const PushRegistrationState();

  PushRegistrationState get state => _state;
  Stream<PushRegistrationState> get states => _states.stream;
  bool get _permitted =>
      _permission == PushPermission.authorized ||
      _permission == PushPermission.provisional;

  Future<void> enable(PushOwner owner) {
    if (_disposed) return Future.error(StateError('Controller disposed'));
    final revision = ++_revision;
    _owner = owner;
    _token = null;
    _permission = PushPermission.notDetermined;
    _retireActive();
    _publish();
    return _enqueue(() async {
      await _cleanup();
      if (!_current(revision)) return;
      if (!_notifications.isSupported) {
        _permission = PushPermission.denied;
        _publish();
        return;
      }
      final permission = await _notifications.requestPermission();
      if (!_current(revision)) return;
      _permission = permission;
      _publish();
      if (!_permitted) return;
      final tokenRevision = _tokenRevision;
      final token = await _notifications.getToken();
      if (!_current(revision)) return;
      if (tokenRevision == _tokenRevision) _token = token;
      await _reconcile();
    });
  }

  Future<void> disable() {
    if (_disposed) return Future.error(StateError('Controller disposed'));
    _clearOwner();
    return _enqueue(_cleanup);
  }

  void _clearOwner() {
    _revision++;
    _owner = null;
    _token = null;
    _permission = PushPermission.notDetermined;
    _retireActive();
    _publish();
  }

  bool _current(int revision) => !_disposed && revision == _revision;

  void _retireActive() {
    final active = _active;
    if (active != null) _pending.add(active);
    _active = null;
  }

  Future<void> _cleanup() async {
    while (_pending.isNotEmpty) {
      final item = _pending.first;
      await _repository.unregister(item.registration, item.id);
      _pending.removeAt(0);
    }
  }

  Future<void> _reconcile() async {
    final owner = _owner;
    final token = _token;
    if (_disposed || owner == null || !_permitted) return;
    if (_active?.registration.token == token &&
        _active?.registration.owner == owner) {
      return;
    }
    _retireActive();
    _publish();
    await _cleanup();
    if (token == null || token.isEmpty) return;
    final revision = _revision;
    if (_disposed || owner != _owner || token != _token) return;
    final registration = PushRegistration(
      owner: owner,
      token: token,
      platform: _platform,
    );
    final id = await _repository.register(registration);
    final result = (registration: registration, id: id);
    if (!_current(revision) || owner != _owner || token != _token) {
      _pending.add(result);
      await _cleanup();
      return;
    }
    _active = result;
    _publish();
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _tail.then((_) => operation()).catchError((
      Object error,
      StackTrace st,
    ) {
      reportUnexpected(error, st, source: ReportSource.push);
      _publish(error: error);
      Error.throwWithStackTrace(error, st);
    });
    _tail = result.catchError((Object _) {});
    return result;
  }

  void _publish({Object? error}) {
    _state = PushRegistrationState(
      owner: _owner,
      permission: _permission,
      isRegistered: _active != null,
      error: error,
    );
    if (!_states.isClosed) _states.add(_state);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _clearOwner();
    _disposed = true;
    await _subscription.cancel();
    try {
      await _enqueue(_cleanup);
    } finally {
      await _states.close();
    }
  }
}
