import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../domain/chat.dart';
import 'messages_providers.dart';

part 'chat_shared_controller.g.dart';

/// Sohbet bilgisindeki "paylaşılanlar" listesi.
@immutable
final class ChatSharedState {
  ChatSharedState({
    required List<ChatSharedItem> items,
    this.nextCursor,
    this.kind,
    this.busy = false,
  }) : items = List.unmodifiable(items);

  final List<ChatSharedItem> items;

  /// Sonraki sayfanın imleci; null → liste tamam.
  final String? nextCursor;
  final ChatRefKind? kind;
  final bool busy;
}

/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.
@riverpod
class ChatSharedController extends _$ChatSharedController {
  final _owner = CacheOwnership();
  var _generation = 0;
  ChatRefKind? _kind;

  @override
  Future<ChatSharedState> build(String chatId) async {
    _owner.markLoaded(ref, _owner.watch(ref));
    _generation++;
    final kind = _kind;
    final page = await _repo.shared(chatId, kind: kind);
    return ChatSharedState(
      items: page.items,
      nextCursor: page.nextCursor,
      kind: kind,
    );
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Tür değişiminde eski sayfanın imleci taşınmaz; bütün türler için null.
  Future<void> setKind(ChatRefKind? kind) async {
    if (_kind == kind) return;
    _kind = kind;
    ref.invalidateSelf();
    await future;
  }

  /// Sonraki sayfayı ekler (uçuşta ya da liste tamamsa istek yok).
  Future<void> more() async {
    final v = state.value;
    final cursor = v?.nextCursor;
    if (v == null || cursor == null || v.busy || state.isLoading) return;
    final generation = _generation;
    state = AsyncData(
      ChatSharedState(
        items: v.items,
        nextCursor: cursor,
        kind: v.kind,
        busy: true,
      ),
    );
    final ChatSharedPage page;
    try {
      page = await _repo.shared(chatId, cursor: cursor, kind: v.kind);
    } on Object {
      if (ref.mounted && _owner.owns(ref) && generation == _generation) {
        state = AsyncData(v);
      }
      rethrow;
    }
    if (!ref.mounted || !_owner.owns(ref) || generation != _generation) return;
    if (page.items.isEmpty && page.nextCursor == null) {
      ref.invalidateSelf();
      return;
    }
    state = AsyncData(
      ChatSharedState(
        items: {
          for (final item in [...v.items, ...page.items]) item.refId: item,
        }.values.toList(),
        nextCursor: page.nextCursor == cursor ? null : page.nextCursor,
        kind: v.kind,
      ),
    );
  }
}

/// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
/// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).
@riverpod
Future<ChatRefCard> chatRefCard(Ref ref, String refId) {
  CacheOwnership().watch(ref);
  return ref.read(chatRepositoryProvider).refCard(refId);
}
