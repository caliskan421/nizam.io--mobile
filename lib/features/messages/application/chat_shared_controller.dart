import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import 'messages_providers.dart';

part 'chat_shared_controller.g.dart';

/// Sohbet bilgisindeki "paylaşılanlar" listesi.
@immutable
final class ChatSharedState {
  ChatSharedState({required List<ChatSharedItem> items, this.nextCursor})
    : items = List.unmodifiable(items);

  final List<ChatSharedItem> items;

  /// Sonraki sayfanın imleci; null → liste tamam.
  final String? nextCursor;
}

/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.
@riverpod
class ChatSharedController extends _$ChatSharedController {
  @override
  Future<ChatSharedState> build(String chatId) async {
    final page = await _repo.shared(chatId);
    return ChatSharedState(items: page.items, nextCursor: page.nextCursor);
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Sonraki sayfayı ekler (uçuşta ya da liste tamamsa istek yok).
  Future<void> more() async {
    final v = state.value;
    final cursor = v?.nextCursor;
    if (v == null || cursor == null || state.isLoading) return;
    final page = await _repo.shared(chatId, cursor: cursor);
    if (!ref.mounted) return;
    if (page.items.isEmpty && page.nextCursor == null) {
      ref.invalidateSelf();
      return;
    }
    state = AsyncData(
      ChatSharedState(
        items: [...v.items, ...page.items],
        nextCursor: page.nextCursor,
      ),
    );
  }
}

/// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
/// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).
@riverpod
Future<ChatRefCard> chatRefCard(Ref ref, String refId) =>
    ref.read(chatRepositoryProvider).refCard(refId);
