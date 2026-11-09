import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../domain/chat.dart';
import 'chats_controller.dart';
import 'messages_providers.dart';

part 'new_chat_controller.g.dart';

/// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
/// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
/// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.
@riverpod
class NewChatController extends _$NewChatController {
  static const _create = 'createGroup';

  var _keys = const RequestKeys();

  @override
  Future<ChatCandidates> build(ChatCandidatePurpose purpose) =>
      ref.read(chatRepositoryProvider).candidates(purpose);

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Birebir sohbeti açar (201 yeni, 200 mevcut; ikisi de "sohbeti aç").
  Future<Chat> openDirect(String accountId) async {
    final chat = await _repo.openDirect(accountId);
    ref.read(chatsControllerProvider.notifier).opened(chat);
    return chat;
  }

  Future<Chat> createGroup(GroupDraft draft) async {
    final (keys, key) = _keys.keyFor(_create, draft.signature);
    _keys = keys;
    try {
      Chat chat;
      try {
        chat = await _repo.createGroup(draft, requestKey: key);
      } on ApiError catch (e) {
        if (e.code != 'platform.conflict_retry') rethrow;
        chat = await _repo.createGroup(draft, requestKey: key);
      }
      _keys = _keys.clear(_create);
      ref.read(chatsControllerProvider.notifier).opened(chat);
      return chat;
    } on ApiError catch (e) {
      // Anahtar başka gövdeyle kullanılmış: yeni eylem yeni anahtarla.
      if (e.code == 'messaging.idempotency_key_reused') {
        _keys = _keys.clear(_create);
      }
      rethrow;
    }
  }

  /// Bekleyen grup kurma anahtarı (test ve tanılama).
  String? get pendingKey => _keys.pending(_create);
}
