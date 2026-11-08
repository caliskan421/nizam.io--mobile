import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';
import 'chat_room_controller.dart';
import 'chats_controller.dart';
import 'messages_providers.dart';

part 'chat_members_controller.g.dart';

/// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
/// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
/// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
/// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
/// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
/// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.
@riverpod
class ChatMembersController extends _$ChatMembersController {
  Timer? _coalesce;

  @override
  Future<ChatMembers> build(String chatId) {
    final sub = ref.watch(chatSignalBusProvider).stream.listen(_onSignal);
    ref.onDispose(() {
      unawaited(sub.cancel());
      _coalesce?.cancel();
      _coalesce = null;
    });
    return _repo.members(chatId);
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  void _onSignal(ChatSignal s) {
    switch (s) {
      case ChatStreamOpened():
        unawaited(refresh());
      case ChatEvent(
            kind: ChatEventKind.memberChanged || ChatEventKind.chatChanged,
            :final chatId,
          )
          when chatId == this.chatId:
        _coalesce ??= Timer(ChatStreamPolicy.coalesce, () {
          _coalesce = null;
          unawaited(refresh());
        });
      case ChatEvent():
        return;
    }
  }

  /// Listeyi sessizce yeniden okur (hata yutulur: eski liste görünür kalır).
  Future<void> refresh() async {
    try {
      final members = await _repo.members(chatId);
      if (ref.mounted) state = AsyncData(members);
    } on Object {
      // Sonraki olay ya da yeniden bağlanma tazeler.
    }
  }

  /// Gruba elle üye ekler (adaylar `purpose=group&chat_id`).
  Future<void> add(Iterable<String> accountIds) async {
    final ids = accountIds.toSet().toList();
    if (ids.isEmpty) return;
    await _repo.addMembers(chatId, ids);
    await refresh();
  }

  /// Üyeyi çıkarır (kaynaktan gelen üye çıkarılamaz: 409 `member_source_managed`).
  Future<void> remove(String accountId) async {
    await _repo.removeMember(chatId, accountId);
    await refresh();
  }

  /// Gruptan ayrılır: satır listeden kalkar (sohbet ekranı kapanır).
  Future<void> leave() async {
    final me = ref.read(chatMeProvider);
    if (me == null) return;
    await _repo.removeMember(chatId, me);
    _gone();
  }

  /// Yöneticilik verir ya da alır (yalnız yönetici; hedef şirket yöneticisi ya da koordinatör).
  Future<void> setAdmin(String accountId, {required bool admin}) async {
    await _repo.setAdmin(chatId, accountId, admin: admin);
    await refresh();
  }

  /// Grup adını değiştirir; açık sohbetin başlığı ve liste satırı tazelenir.
  Future<void> rename(String name) async {
    final chat = await _repo.rename(chatId, name);
    if (!ref.mounted) return;
    if (ref.exists(chatRoomControllerProvider(chatId))) {
      ref.read(chatRoomControllerProvider(chatId).notifier).setChat(chat);
    }
    unawaited(ref.read(chatsControllerProvider.notifier).refresh());
  }

  /// Grubu siler (yönetici ya da kurucu).
  Future<void> deleteChat() async {
    await _repo.deleteChat(chatId);
    _gone();
  }

  void _gone() {
    if (!ref.mounted) return;
    ref.read(chatsControllerProvider.notifier).removed(chatId);
  }
}

/// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).
@riverpod
Future<ChatCandidates> chatAddCandidates(Ref ref, String chatId) => ref
    .read(chatRepositoryProvider)
    .candidates(ChatCandidatePurpose.group, chatId: chatId);
