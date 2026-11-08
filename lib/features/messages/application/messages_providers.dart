import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../core/session/session_state.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';

part 'messages_providers.g.dart';

/// PORT: mesajlaşma uçlarının kaynağı (`messages_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) => throw UnimplementedError(
  'chatRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// Oturumdaki hesap (kendi mesajım ayrımı); oturum yoksa null.
@riverpod
String? chatMe(Ref ref) => switch (ref.watch(sessionStateProvider)) {
  SessionActive(:final accountId) => accountId,
  _ => null,
};

/// Anlık akışın sinyal veriyolu: bağlantı döngüsü ([ChatSyncController]) yayar; gelen kutusu
/// ve açık sohbetler dinler (her tüketici kendi okumasını birleştirir).
final class ChatSignalBus {
  final _controller = StreamController<ChatSignal>.broadcast();

  Stream<ChatSignal> get stream => _controller.stream;

  void add(ChatSignal s) {
    if (!_controller.isClosed) _controller.add(s);
  }

  Future<void> close() => _controller.close();
}

@Riverpod(keepAlive: true)
ChatSignalBus chatSignalBus(Ref ref) {
  final bus = ChatSignalBus();
  ref.onDispose(bus.close);
  return bus;
}

/// [failures] ardışık başarısızlıktan sonraki yeniden bağlanma beklemesi (testte değiştirilir).
@Riverpod(keepAlive: true)
Duration Function(int failures) chatReconnectDelay(Ref ref) {
  final random = Random.secure();
  return (failures) => reconnectDelay(failures, random);
}

/// Uygulama ön planda mı: akış yalnız ön plandayken açıktır (yaşam döngüsünü sunum katmanındaki
/// akış kapsamı yazar).
@Riverpod(keepAlive: true)
class ChatForeground extends _$ChatForeground {
  @override
  bool build() => true;

  void set(bool value) {
    if (state != value) state = value;
  }
}
