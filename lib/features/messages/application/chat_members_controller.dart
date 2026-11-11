import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
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
  final _owner = CacheOwnership();
  var _generation = 0;
  var _scopeGeneration = 0;

  @override
  Future<ChatMembers> build(String chatId) {
    _owner.markLoaded(ref, _owner.watch(ref));
    _generation++;
    _scopeGeneration++;
    final sub = ref.watch(chatSignalBusProvider).stream.listen(_onSignal);
    ref.onDispose(() {
      unawaited(sub.cancel());
      _coalesce?.cancel();
      _coalesce = null;
    });
    return _repo.members(chatId);
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);
  bool get _active => ref.mounted && _owner.owns(ref);

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
    final generation = ++_generation;
    try {
      final members = await _repo.members(chatId);
      if (_active && generation == _generation) state = AsyncData(members);
    } on Object {
      // Sonraki olay ya da yeniden bağlanma tazeler.
    }
  }

  /// Gruba elle üye ekler (adaylar `purpose=group&chat_id`).
  Future<void> add(Iterable<String> accountIds) async {
    final generation = _generation;
    final ids = accountIds.toSet().toList();
    if (ids.isEmpty) return;
    await _repo.addMembers(chatId, ids);
    if (!_active || generation != _generation) return;
    await refresh();
  }

  /// Üyeyi çıkarır (kaynaktan gelen üye çıkarılamaz: 409 `member_source_managed`).
  Future<void> remove(String accountId) async {
    final generation = _generation;
    await _repo.removeMember(chatId, accountId);
    if (!_active || generation != _generation) return;
    await refresh();
  }

  /// Gruptan ayrılır: satır listeden kalkar (sohbet ekranı kapanır).
  Future<void> leave() async {
    final generation = _generation;
    final me = ref.read(chatMeProvider);
    if (me == null) return;
    await _repo.removeMember(chatId, me);
    if (!_active || generation != _generation) return;
    _gone();
  }

  /// Yöneticilik verir ya da alır (yalnız yönetici; hedef şirket yöneticisi ya da koordinatör).
  Future<void> setAdmin(String accountId, {required bool admin}) async {
    final generation = _generation;
    await _repo.setAdmin(chatId, accountId, admin: admin);
    if (!_active || generation != _generation) return;
    await refresh();
  }

  /// Grup adını değiştirir; açık sohbetin başlığı ve liste satırı tazelenir.
  Future<void> rename(String name) async {
    final generation = _generation;
    final chat = await _repo.rename(chatId, name);
    if (!_active || generation != _generation) return;
    if (ref.exists(chatRoomControllerProvider(chatId))) {
      ref.read(chatRoomControllerProvider(chatId).notifier).setChat(chat);
    }
    unawaited(ref.read(chatsControllerProvider.notifier).refresh());
  }

  /// Grubu siler (yönetici ya da kurucu).
  Future<void> deleteChat() async {
    final generation = _generation;
    await _repo.deleteChat(chatId);
    if (!_active || generation != _generation) return;
    _gone();
  }

  /// Kaynak üyeliğini değiştirir; sunucu sonucu grup bilgisi ve üyeleri yeniden okunur.
  Future<void> updateSource(ChatSource source, {String? departmentId}) async {
    final scopeGeneration = _scopeGeneration;
    final generation = _generation;
    final chat = await _repo.updateSource(
      chatId,
      source,
      departmentId: departmentId,
    );
    if (!_active || generation != _generation) return;
    if (ref.exists(chatRoomControllerProvider(chatId))) {
      ref.read(chatRoomControllerProvider(chatId).notifier).setChat(chat);
    }
    await refresh();
    if (_active && scopeGeneration == _scopeGeneration) {
      unawaited(ref.read(chatsControllerProvider.notifier).refresh());
    }
  }

  void _gone() {
    if (!ref.mounted) return;
    ref.read(chatsControllerProvider.notifier).removed(chatId);
  }
}

/// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).
@riverpod
Future<ChatCandidates> chatAddCandidates(Ref ref, String chatId) {
  CacheOwnership().watch(ref);
  return ref
      .read(chatRepositoryProvider)
      .candidates(ChatCandidatePurpose.group, chatId: chatId);
}
