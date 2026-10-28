import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import '../domain/chat_logic.dart';
import 'messages_providers.dart';

part 'chats_controller.g.dart';

/// Mesajlar kutusu ve sohbet komutları. Örnek kaynakta değişiklikler bellekte kalır (sunucuya
/// yazılmaz); liste ve sohbet ekranı aynı durumu okur.
@Riverpod(keepAlive: true)
class ChatsController extends _$ChatsController {
  var _seq = 0;

  @override
  Future<ChatInbox> build() => ref.read(chatRepositoryProvider).load();

  void _set(ChatInbox Function(ChatInbox) f) {
    final v = state.value;
    if (v != null) state = AsyncData(f(v));
  }

  void _chat(String id, Chat Function(Chat) f) => _set((v) => v.replace(id, f));

  /// Sohbet açıldı: okunmamış ayırıcısı işaretlenir, sayaç ve bahsetme sıfırlanır.
  void open(String id) => _chat(
    id,
    (c) => c.copyWith(
      unreadMarker: () => unreadMarkerOf(c),
      unread: 0,
      mention: false,
    ),
  );

  /// Bütün sohbetleri okundu sayar.
  void markAllRead() =>
      _set((v) => v.mapChats((c) => c.copyWith(unread: 0, mention: false)));

  void react(String chat, String msg, ChatReaction r) =>
      _chat(chat, (c) => c.mapMessage(msg, (m) => m.react(r)));

  void vote(String chat, String msg, int option) => _chat(
    chat,
    (c) => c.mapMessage(msg, (m) => m.copyWith(poll: m.poll?.toggle(option))),
  );

  void endPoll(String chat, String msg) => _chat(
    chat,
    (c) => c.mapMessage(msg, (m) => m.copyWith(poll: m.poll?.end())),
  );

  /// Sabitler ya da sabiti kaldırır; sonuç: mesaj artık sabit mi.
  bool togglePin(String chat, String msg) {
    final c = state.value?.chat(chat);
    if (c == null) return false;
    final pinned = c.pins.contains(msg);
    _chat(
      chat,
      (c) => c.copyWith(
        pins: pinned ? ([...c.pins]..remove(msg)) : [msg, ...c.pins],
      ),
    );
    return !pinned;
  }

  void delete(String chat, String msg) => _chat(
    chat,
    (c) => c.copyWith(
      messages: [...c.messages]..removeWhere((m) => m.id == msg),
      pins: [...c.pins]..remove(msg),
    ),
  );

  void edit(String chat, String msg, String text) => _chat(
    chat,
    (c) => c.mapMessage(msg, (m) => m.copyWith(text: text, edited: true)),
  );

  /// Mesajı gönderir (gönderiliyor: tek tik); yeni mesajın kimliği.
  String send(
    String chat, {
    required String from,
    required DateTime at,
    required String text,
    List<ChatRef> refs = const [],
    String? replyTo,
  }) {
    final id = 'n${++_seq}';
    _chat(
      chat,
      (c) => c.copyWith(
        unreadMarker: () => null,
        messages: [
          ...c.messages,
          ChatMessage(
            id: id,
            from: from,
            at: at,
            text: text,
            refs: refs,
            replyTo: replyTo,
            sent: false,
          ),
        ],
      ),
    );
    return id;
  }

  /// Sunucuya ulaştı (çift tik).
  void markSent(String chat, String msg) =>
      _chat(chat, (c) => c.mapMessage(msg, (m) => m.copyWith(sent: true)));

  /// Karşı taraf okudu (vurgulu çift tik).
  void markRead(String chat, String msg) =>
      _chat(chat, (c) => c.mapMessage(msg, (m) => m.copyWith(read: true)));

  void mute(String chat) => _chat(chat, (c) => c.copyWith(muted: true));
}
