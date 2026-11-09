// Mesajlaşma denetleyici testlerinin bellek içi [ChatRepository]'si: çağrıları kaydeder,
// yanıtları test kurar; akış bağlantıları testin denetlediği StreamController'lardır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
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

  /// Doluysa sıradaki `loadInbox` çağrıları sırayla bu tamamlayıcıların yanıtını bekler
  /// (FIFO; yanıt sırası testte elle belirlenir).
  final inboxReplies = <Completer<ChatInbox>>[];
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

  /// Doluysa sonraki tepki/oy/sabit/üye yazması bu hatayla düşer (bir kez).
  ApiError? writeError;

  /// Doluysa yazmalar (çağrı anında okunur) bu kapı açılana dek bekler.
  Completer<void>? writeGate;

  /// Aynı anda uçuşta olan en çok yazma sayısı.
  int maxWriting = 0;
  var _writing = 0;

  /// Doluysa geçmiş okumaları (sayfa çağrı anında kesilir) bu kapı açılana dek bekler.
  Completer<void>? listGate;

  /// Sabit şeridi (sunucu sırası).
  List<ChatMessage> pinned = [];
  ChatMembers memberList = ChatMembers(
    items: const [
      ChatMember(accountId: me, name: 'Ben', role: ChatMemberRole.admin),
      ChatMember(
        accountId: peer,
        name: 'Kadir Özbek',
        role: ChatMemberRole.member,
      ),
    ],
  );

  /// Paylaşılanlar sayfaları (imleç → sayfa; null ilk sayfa).
  final sharedPages = <String?, ChatSharedPage>{};
  final taskKeys = <String>[];
  final List<ApiError> taskErrors = [];
  final uploads = <(String, ChatUpload)>[];

  /// Arama sonuçları (artan seq; `before` süzer).
  List<ChatMessage> searchHits = [];

  Future<void> _write(String call) async {
    calls.add(call);
    final e = writeError;
    writeError = null;
    final gate = writeGate;
    if (++_writing > maxWriting) maxWriting = _writing;
    try {
      if (gate != null) await gate.future;
      if (e != null) throw e;
    } finally {
      _writing--;
    }
  }

  List<ChatMessage> _of(String id) => server[id] ?? const [];

  @override
  Future<ChatInbox> loadInbox() async {
    calls.add('loadInbox');
    if (inboxReplies.isNotEmpty) return inboxReplies.removeAt(0).future;
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
    final read = ChatHistoryPage(messages: page, peerReadSeq: peerReadSeq);
    final gate = listGate;
    if (gate != null) await gate.future;
    return read;
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
    // §10.2: bayat sürüm ve farklı gövde 409; gövde zaten istenen metinse 200.
    if (old.text == text) return old;
    if (expectedRevision != old.revision) {
      throw ApiError('messaging.edit_conflict', status: 409);
    }
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
  Future<ChatCandidates> candidates(
    ChatCandidatePurpose purpose, {
    String? chatId,
  }) async {
    calls.add('candidates ${purpose.name}${chatId == null ? '' : ' $chatId'}');
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
  Future<void> setReaction(
    String chatId,
    String messageId,
    ChatReaction kind,
  ) async => _write('react $messageId ${kind.name}');

  @override
  Future<void> clearReaction(String chatId, String messageId) async =>
      _write('unreact $messageId');

  @override
  Future<void> pin(String chatId, String messageId) async =>
      _write('pin $messageId');

  @override
  Future<void> unpin(String chatId, String messageId) async =>
      _write('unpin $messageId');

  @override
  Future<List<ChatMessage>> pins(String chatId) async {
    calls.add('pins $chatId');
    return pinned;
  }

  @override
  Future<void> vote(String chatId, String messageId, Set<int> options) async =>
      _write('vote $messageId ${(options.toList()..sort()).join(',')}');

  @override
  Future<void> closePoll(String chatId, String messageId) async =>
      _write('close $messageId');

  @override
  Future<ChatMessage> sendAttachment(
    String chatId,
    String clientId,
    ChatUpload file, {
    String? replyTo,
  }) async {
    uploads.add((clientId, file));
    await _write('attach $chatId');
    final list = server.putIfAbsent(chatId, () => []);
    final seq = (list.lastOrNull?.seq ?? 0) + 1;
    final m = ChatMessage(
      id: 'm$seq',
      clientId: clientId,
      seq: seq,
      senderId: me,
      at: at(seq),
      text: '',
      attachments: [
        ChatAttachment(id: 'a$seq', fileName: file.name, sizeBytes: 1),
      ],
    );
    list.add(m);
    return m;
  }

  @override
  Future<Stream<List<int>>> downloadAttachment(String attachmentId) async {
    calls.add('download $attachmentId');
    return Stream.value(const [1, 2, 3]);
  }

  @override
  Future<ChatMembers> members(String chatId) async {
    calls.add('members $chatId');
    return memberList;
  }

  @override
  Future<void> addMembers(String chatId, List<String> accountIds) async =>
      _write('add ${accountIds.join(',')}');

  @override
  Future<void> removeMember(String chatId, String accountId) async =>
      _write('remove $accountId');

  @override
  Future<void> setAdmin(
    String chatId,
    String accountId, {
    required bool admin,
  }) async => _write('admin $accountId $admin');

  @override
  Future<Chat> rename(String chatId, String name) async {
    await _write('rename $name');
    return chat(chatId, group: true, name: name);
  }

  @override
  Future<void> deleteChat(String chatId) async => _write('deleteChat $chatId');

  @override
  Future<ChatSharedPage> shared(String chatId, {String? cursor}) async {
    calls.add('shared ${cursor ?? '-'}');
    return sharedPages[cursor] ?? ChatSharedPage(items: const []);
  }

  @override
  Future<ChatRefCard> refCard(String refId) async {
    calls.add('card $refId');
    return ChatRefCard(
      refId: refId,
      kind: ChatRefKind.file,
      available: true,
      title: 'Rapor.pdf',
      sizeBytes: 2400000,
    );
  }

  @override
  Future<Stream<List<int>>> downloadSharedFile(String refId) async {
    calls.add('sharedFile $refId');
    return Stream.value(const [1]);
  }

  @override
  Future<ChatTaskCreated> createTask(
    String chatId,
    String messageId,
    ChatTaskDraft draft, {
    required String requestKey,
  }) async {
    taskKeys.add(requestKey);
    if (taskErrors.isNotEmpty) throw taskErrors.removeAt(0);
    final old = server[chatId]!.firstWhere((m) => m.id == messageId);
    return (
      workItemId: 'w1',
      message: ChatMessage(
        id: old.id,
        clientId: old.clientId,
        seq: old.seq,
        senderId: old.senderId,
        at: old.at,
        text: old.text,
        taskIds: const ['w1'],
      ),
    );
  }

  @override
  Future<ChatHistoryPage> search(
    String chatId,
    String query, {
    int? before,
  }) async {
    calls.add('search $query${before == null ? '' : ' before=$before'}');
    final hits = [
      for (final m in searchHits)
        if (before == null || m.seq! < before) m,
    ];
    final page = hits.length <= chatSearchPageSize
        ? hits
        : hits.sublist(hits.length - chatSearchPageSize);
    return ChatHistoryPage(messages: page);
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
  List<Override> extra = const [],
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
      ...extra,
    ],
  );
  addTearDown(c.dispose);
  return c;
}
