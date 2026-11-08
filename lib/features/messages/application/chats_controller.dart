import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';
import 'messages_providers.dart';

part 'chats_controller.g.dart';

/// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
/// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
/// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz.
@Riverpod(keepAlive: true)
class ChatsController extends _$ChatsController {
  Timer? _coalesce;

  @override
  Future<ChatInbox> build() {
    ref
      ..watch(chatMeProvider)
      ..watch(scopeStateProvider.select((s) => s.programId));
    final sub = ref.watch(chatSignalBusProvider).stream.listen(_onSignal);
    ref.onDispose(() {
      unawaited(sub.cancel());
      _coalesce?.cancel();
      _coalesce = null;
    });
    return ref.read(chatRepositoryProvider).loadInbox();
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  void _set(ChatInbox Function(ChatInbox) f) {
    final v = state.value;
    if (v != null) state = AsyncData(f(v));
  }

  void _onSignal(ChatSignal s) {
    switch (s) {
      case ChatStreamOpened():
        _coalesce?.cancel();
        _coalesce = null;
        unawaited(refresh());
      case ChatEvent(kind: ChatEventKind.typing):
        return;
      case ChatEvent():
        _coalesce ??= Timer(ChatStreamPolicy.coalesce, () {
          _coalesce = null;
          unawaited(refresh());
        });
    }
  }

  /// Listeyi sessizce yeniden okur (hata yutulur: eski liste görünür kalır).
  Future<void> refresh() async {
    if (state.value == null) return;
    try {
      final inbox = await _repo.loadInbox();
      if (ref.mounted) state = AsyncData(inbox);
    } on Object {
      // Ağ/sunucu hatası: sonraki olay ya da yeniden bağlanma tazeler.
    }
  }

  /// Bütün sohbetleri sunucuda okundu sayar; başarıda yerel sayaçlar sıfırlanır.
  Future<void> markAllRead() async {
    await _repo.markAllRead();
    if (!ref.mounted) return;
    _set((v) => v.mapChats((c) => c.copyWith(unread: 0, mention: false)));
  }

  /// Sohbet açık ve okundu imleci ilerledi: satırın sayacı ve bahsetmesi düşer.
  void markedRead(String chatId) => _set(
    (v) => v.replace(chatId, (c) => c.copyWith(unread: 0, mention: false)),
  );

  /// Yeni açılan (ya da kurulan) sohbet listede yoksa başa eklenir.
  void opened(Chat chat) => _set((v) => v.withChat(chat));

  /// Gruptan ayrıldım ya da grup silindi: satır listeden kalkar.
  void removed(String chatId) => _set(
    (v) => ChatInbox(
      chats: [
        for (final c in v.chats)
          if (c.id != chatId) c,
      ],
      truncated: v.truncated,
    ),
  );
}
