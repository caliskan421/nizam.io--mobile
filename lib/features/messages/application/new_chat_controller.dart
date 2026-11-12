import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
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
  final _owner = CacheOwnership();
  var _generation = 0;

  @override
  Future<ChatCandidates> build(ChatCandidatePurpose purpose) {
    _owner.markLoaded(ref, _owner.watch(ref));
    _generation++;
    _keys = const RequestKeys();
    return ref.read(chatRepositoryProvider).candidates(purpose);
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Birebir sohbeti açar (201 yeni, 200 mevcut; ikisi de "sohbeti aç").
  Future<Chat> openDirect(String accountId) async {
    final generation = _generation;
    final chat = await _repo.openDirect(accountId);
    _ensureCurrent(generation);
    ref.read(chatsControllerProvider.notifier).opened(chat);
    return chat;
  }

  Future<Chat> createGroup(GroupDraft draft) async {
    final generation = _generation;
    final (keys, key) = _keys.keyFor(_create, draft.signature);
    _keys = keys;
    try {
      Chat chat;
      try {
        chat = await _repo.createGroup(draft, requestKey: key);
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.messages);
        if (e.code != 'platform.conflict_retry') rethrow;
        _ensureCurrent(generation);
        chat = await _repo.createGroup(draft, requestKey: key);
      }
      _ensureCurrent(generation);
      _keys = _keys.clear(_create);
      ref.read(chatsControllerProvider.notifier).opened(chat);
      return chat;
    } on ApiError catch (e) {
      // Anahtar başka gövdeyle kullanılmış: yeni eylem yeni anahtarla.
      if (ref.mounted &&
          generation == _generation &&
          e.code == 'messaging.idempotency_key_reused') {
        _keys = _keys.clear(_create);
      }
      rethrow;
    }
  }

  /// Bekleyen grup kurma anahtarı (test ve tanılama).
  String? get pendingKey => _keys.pending(_create);

  void _ensureCurrent(int generation) {
    if (!ref.mounted || !_owner.owns(ref) || generation != _generation) {
      throw ApiError(ClientErrorCode.sessionEnded);
    }
  }
}
