// Mesajlaşma denetleyici testlerinin bellek içi [ChatRepository]'si: çağrıları kaydeder,
// yanıtları test kurar; akış bağlantıları testin denetlediği StreamController'lardır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

const me = 'acc-me';
const peer = 'acc-peer';

DateTime at(int minute) => DateTime(2026, 11, 9, 10, minute);

ChatMessage msg(
  int seq, {
  String? sender,
  String text = 'm',
  int revision = 0,
  String? clientId,
}) => ChatMessage(
  id: 'm$seq',
  clientId: clientId ?? 'c$seq',
  seq: seq,
  senderId: sender ?? peer,
  senderName: sender == me ? 'Ben' : 'Kadir Özbek',
  at: at(seq),
  text: text,
  revision: revision,
);

Chat chat(
  String id, {
  bool group = false,
  int unread = 0,
  String name = 'Kadir Özbek',
}) =>
    Chat(id: id, name: name, lastActivity: at(0), group: group, unread: unread);

class FakeChatRepository implements ChatRepository {
  final calls = <String>[];
  ChatInbox inbox = ChatInbox(chats: [chat('c1', unread: 2)]);
  Chat Function(String id) getChatResult = chat;

  /// Sohbet başına sunucudaki mesajlar (artan seq).
  final server = <String, List<ChatMessage>>{};
  int? peerReadSeq;

  /// Doluysa gönderim kaydı sunucuya yazıp yanıtı bu kapı açılana dek bekletir.
  Completer<void>? sendGate;

  /// Doluysa sonraki gönderim bu hatayla düşer (bir kez).
  ApiError? sendError;
  ApiError? editError;
  ApiError? openError;

  /// Sırayla verilecek akış bağlantıları; boşsa yeni bir denetleyici açılır.
  final connections = <StreamController<ChatSignal>>[];
  int connects = 0;

  final sent = <OutgoingMessage>[];
  final typings = <String>[];
  final groupKeys = <String>[];
  final List<ApiError> groupErrors = [];

  List<ChatMessage> _of(String id) => server[id] ?? const [];

  @override
  Future<ChatInbox> loadInbox() async {
    calls.add('loadInbox');
    return inbox;
  }

  @override
  Future<void> markAllRead() async => calls.add('markAllRead');

  @override
  Future<Chat> getChat(String chatId) async {
    calls.add('getChat $chatId');
    return getChatResult(chatId);
  }

  @override
  Future<ChatHistoryPage> listMessages(
    String chatId, {
    int? before,
    int? after,
    int? around,
    int? limit,
  }) async {
    final n = limit ?? 50;
    calls.add(
      'list $chatId${before == null ? '' : ' before=$before'}'
      '${after == null ? '' : ' after=$after'}'
      '${around == null ? '' : ' around=$around'}',
    );
    var all = _of(chatId);
    List<ChatMessage> page;
    if (after != null) {
      page = all.where((m) => m.seq! > after).take(n).toList();
    } else if (around != null) {
      page = all.where((m) => (m.seq! - around).abs() <= 2).toList();
    } else {
      if (before != null) all = all.where((m) => m.seq! < before).toList();
      page = all.length <= n ? all : all.sublist(all.length - n);
    }
    return ChatHistoryPage(messages: page, peerReadSeq: peerReadSeq);
  }

  @override
  Future<ChatMessage> send(String chatId, OutgoingMessage message) async {
    calls.add('send $chatId');
    sent.add(message);
    final e = sendError;
    if (e != null) {
      sendError = null;
      throw e;
    }
    final list = server.putIfAbsent(chatId, () => []);
    final existing = list.where((m) => m.clientId == message.clientId);
    if (existing.isNotEmpty) return existing.first;
    final seq = (list.lastOrNull?.seq ?? 0) + 1;
    final m = ChatMessage(
      id: 'm$seq',
      clientId: message.clientId,
      seq: seq,
      senderId: me,
      senderName: 'Ben',
      at: at(seq),
      text: message.text,
    );
    list.add(m);
    await sendGate?.future;
    return m;
  }

  @override
  Future<ChatMessage> edit(
    String chatId,
    String messageId, {
    required String text,
    required int expectedRevision,
  }) async {
    calls.add('edit $messageId rev=$expectedRevision');
    final e = editError;
    if (e != null) throw e;
    final list = server[chatId]!;
    final i = list.indexWhere((m) => m.id == messageId);
    final old = list[i];
    return list[i] = ChatMessage(
      id: old.id,
      clientId: old.clientId,
      seq: old.seq,
      senderId: old.senderId,
      senderName: old.senderName,
      at: old.at,
      text: text,
      edited: true,
      revision: old.revision + 1,
    );
  }

  @override
  Future<void> delete(String chatId, String messageId) async {
    calls.add('delete $messageId');
    server[chatId]?.removeWhere((m) => m.id == messageId);
  }

  @override
  Future<void> markRead(String chatId, String messageId) async =>
      calls.add('read $chatId $messageId');

  @override
  Future<void> typing(String chatId) async => typings.add(chatId);

  @override
  Future<ChatCandidates> candidates(ChatCandidatePurpose purpose) async {
    calls.add('candidates ${purpose.name}');
    return ChatCandidates(
      items: const [ChatCandidate(accountId: peer, name: 'Kadir Özbek')],
    );
  }

  @override
  Future<Chat> openDirect(String accountId) async {
    calls.add('openDirect $accountId');
    final e = openError;
    if (e != null) throw e;
    return chat('d-$accountId');
  }

  @override
  Future<Chat> createGroup(
    GroupDraft draft, {
    required String requestKey,
  }) async {
    groupKeys.add(requestKey);
    if (groupErrors.isNotEmpty) throw groupErrors.removeAt(0);
    return chat('g1', group: true, name: draft.name);
  }

  @override
  Stream<ChatSignal> events() {
    connects++;
    if (connections.isNotEmpty) return connections.removeAt(0).stream;
    // Bağlantısı kurulmamış akış: açık kalır, dinleyici bırakınca kapanır.
    late final StreamController<ChatSignal> idle;
    idle = StreamController<ChatSignal>(onCancel: () => idle.close());
    return idle.stream;
  }
}

/// [repo] bağlı, oturum [me] ve program `prog-1` seçili konteyner.
ProviderContainer chatContainer(
  FakeChatRepository repo, {
  Duration Function(int)? delay,
}) {
  final scope = ScopeController()..selectProgram('prog-1');
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      chatRepositoryProvider.overrideWithValue(repo),
      sessionStateProvider.overrideWithValue(
        const SessionActive(accountId: me, forcePasswordChange: false),
      ),
      scopeStateProvider.overrideWithValue(scope.current),
      chatReconnectDelayProvider.overrideWithValue(
        delay ?? (_) => Duration.zero,
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}
