import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
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
  final _owner = CacheOwnership();
  var _generation = 0;

  @override
  ChatSearchState build(String chatId) {
    _owner.markLoaded(ref, _owner.watch(ref));
    _generation++;
    return ChatSearchState();
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Yeni arama (boş sorgu sonucu temizler). Hata ekrana iletilir; eski sonuç kalmaz.
  Future<void> search(String query) async {
    final generation = ++_generation;
    final q = query.trim();
    final capped = q.length > maxQuery ? q.substring(0, maxQuery) : q;
    if (capped.isEmpty) {
      state = ChatSearchState();
      return;
    }
    state = ChatSearchState(query: capped, busy: true);
    try {
      _apply(generation, capped, const [], await _repo.search(chatId, capped));
    } on Object {
      if (ref.mounted && _owner.owns(ref) && generation == _generation) {
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
    final generation = _generation;
    state = ChatSearchState(
      query: s.query,
      results: s.results,
      hasMore: true,
      busy: true,
    );
    try {
      _apply(
        generation,
        s.query,
        s.results,
        await _repo.search(chatId, s.query, before: low),
      );
    } on Object {
      if (ref.mounted && _owner.owns(ref) && generation == _generation) {
        state = s;
      }
      rethrow;
    }
  }

  void _apply(
    int generation,
    String q,
    List<ChatMessage> before,
    ChatHistoryPage page,
  ) {
    if (!ref.mounted || !_owner.owns(ref) || generation != _generation) return;
    final unique = {for (final m in before) m.id: m};
    for (final m in page.messages) {
      unique[m.id] = m;
    }
    final results = unique.values.toList()
      ..sort((a, b) => (b.seq ?? 0).compareTo(a.seq ?? 0));
    state = ChatSearchState(
      query: q,
      results: results,
      hasMore:
          page.messages.length >= chatSearchPageSize &&
          (before.isEmpty || results.last.seq != before.last.seq),
    );
  }
}
