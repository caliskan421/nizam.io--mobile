import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Açık sohbetlerin paylaştığı ucuz sinyal kovası (yazıyor + okundu; [SignalBudget]).
@Riverpod(keepAlive: true)
SignalBudget chatSignalBudget(Ref ref) => SignalBudget();

/// Akışın en erken yeniden açılış anı (429 `Retry-After`; yazma bütçesi hesap başınadır). Akış
/// denetleyicisinin ömründen bağımsızdır: ön plana dönüş ve ekranın yeniden açılması da uyar.
@Riverpod(keepAlive: true)
class ChatStreamHold extends _$ChatStreamHold {
  @override
  ({String account, DateTime until})? build() => null;

  void hold(String account, DateTime until) =>
      state = (account: account, until: until);

  /// [account] için kalan bekleme; yoksa null.
  Duration? left(String? account, DateTime now) {
    final h = state;
    if (h == null || h.account != account || !h.until.isAfter(now)) {
      return null;
    }
    return h.until.difference(now);
  }
}

/// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
/// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.
@riverpod
Future<ChatInbox> chatInboxSearch(Ref ref, String query) {
  final session = ref.watch(sessionGenerationProvider);
  final program = ref.watch(scopeStateProvider.select((s) => s.programId));
  final q = query.trim();
  return ref
      .read(chatRepositoryProvider)
      .loadInbox(
        query: q.length > 100 ? q.substring(0, 100) : q,
        isCurrent: () =>
            ref.mounted &&
            ref.read(sessionGenerationProvider) == session &&
            ref.read(scopeStateProvider).programId == program,
      );
}

/// Program seçicisindeki rozetlere hazır programlar arası okunmamış/bahsetme özeti.
@riverpod
Future<List<ChatProgramUnread>> chatUnreadOverview(Ref ref) {
  ref.watch(sessionGenerationProvider);
  return ref.read(chatRepositoryProvider).unreadOverview();
}
