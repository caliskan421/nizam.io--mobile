import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import 'messages_providers.dart';

part 'chat_search_controller.g.dart';

/// Sohbet içi arama sonucu: [results] en yeniden eskiye.
@immutable
final class ChatSearchState {
  ChatSearchState({
    this.query = '',
    List<ChatMessage> results = const [],
    this.hasMore = false,
    this.busy = false,
  }) : results = List.unmodifiable(results);

  final String query;
  final List<ChatMessage> results;
  final bool hasMore;
  final bool busy;
}

/// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
/// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
/// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).
@riverpod
class ChatSearchController extends _$ChatSearchController {
  static const maxQuery = 100;

  @override
  ChatSearchState build(String chatId) => ChatSearchState();

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Yeni arama (boş sorgu sonucu temizler). Hata ekrana iletilir; eski sonuç kalmaz.
  Future<void> search(String query) async {
    final q = query.trim();
    final capped = q.length > maxQuery ? q.substring(0, maxQuery) : q;
    if (capped.isEmpty) {
      state = ChatSearchState();
      return;
    }
    state = ChatSearchState(query: capped, busy: true);
    try {
      _apply(capped, const [], await _repo.search(chatId, capped));
    } on Object {
      if (ref.mounted && state.query == capped) {
        state = ChatSearchState(query: capped);
      }
      rethrow;
    }
  }

  /// Daha eski sonuçlar.
  Future<void> more() async {
    final s = state;
    final low = s.results.lastOrNull?.seq;
    if (!s.hasMore || s.busy || low == null) return;
    state = ChatSearchState(
      query: s.query,
      results: s.results,
      hasMore: true,
      busy: true,
    );
    try {
      _apply(
        s.query,
        s.results,
        await _repo.search(chatId, s.query, before: low),
      );
    } on Object {
      if (ref.mounted) state = s;
      rethrow;
    }
  }

  void _apply(String q, List<ChatMessage> before, ChatHistoryPage page) {
    if (!ref.mounted || state.query != q) return;
    state = ChatSearchState(
      query: q,
      results: [...before, ...page.messages.reversed],
      hasMore: page.messages.length >= chatSearchPageSize,
    );
  }
}
