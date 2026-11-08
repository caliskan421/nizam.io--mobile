// HAM DIO İSTİSNASI (yalnız `events`): üretilmiş `MessagingClient.streamChatEvents` imzası
// `Future<String>`'dir — `text/event-stream` gövdesinin tamamını bekler, olayları akış sırasında
// veremez ve iptal edilemez. Akış aynı Dio (kapı/kimlik/hata halkaları) üzerinden
// `ResponseType.stream` ile okunur; kapı halkası S2 program başlığını eklesin diye üretilmiş
// `streamChatEventsOpenapiExtras` metaverisi aynen taşınır (emsal: assistant deposu). Diğer uçlar
// üretilmiş istemciyle çağrılır.
import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/messaging_client.dart';
import '../../../core/api/generated/models/chat.dart' as api;
import '../../../core/api/generated/models/chat_auto_kind.dart';
import '../../../core/api/generated/models/chat_candidate.dart' as api;
import '../../../core/api/generated/models/chat_candidate_list.dart' as api;
import '../../../core/api/generated/models/chat_candidate_role.dart' as api;
import '../../../core/api/generated/models/chat_event.dart' as api;
import '../../../core/api/generated/models/chat_history.dart' as api;
import '../../../core/api/generated/models/chat_kind.dart';
import '../../../core/api/generated/models/chat_last_message.dart';
import '../../../core/api/generated/models/chat_message.dart' as api;
import '../../../core/api/generated/models/chat_message_quote.dart';
import '../../../core/api/generated/models/chat_role.dart';
import '../../../core/api/generated/models/chat_summary.dart';
import '../../../core/api/generated/models/create_group_chat_request.dart';
import '../../../core/api/generated/models/edit_chat_message_request.dart';
import '../../../core/api/generated/models/kind2.dart';
import '../../../core/api/generated/models/mark_chat_read_request.dart';
import '../../../core/api/generated/models/open_direct_chat_request.dart';
import '../../../core/api/generated/models/poll2.dart';
import '../../../core/api/generated/models/purpose.dart';
import '../../../core/api/generated/models/send_chat_message_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/sse.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';

/// [ChatRepository]'nin `/v1/chats*` uçlarıyla gerçekleştirmesi (S2; program başlığını ara
/// katman ekler). DTO'lar bu katmanda kalır (A1/A2); hatalar [ApiError]. Otomatik yeniden deneme
/// yoktur (A3): gönderimin tekrarı kullanıcı eylemidir ve AYNI `client_message_id` ile gider.
class ApiChatRepository implements ChatRepository {
  /// [dio]: doğrulanmış bağın güncel API istemcisi; bağ yoksa null →
  /// `client.server_not_verified`. İstek anında okunur (bağ değişebilir).
  ApiChatRepository(this._dio);

  final Dio? Function() _dio;

  /// Sözleşmedeki akış yolu (üretilmiş istemcideki `@GET` ile aynı).
  static const streamPath = '/v1/chats/stream';

  /// Liste sayfa boyu (sunucu tavanı) ve birleştirilen en çok sayfa.
  static const inboxPageSize = 200;
  static const inboxMaxPages = 5;

  Dio get _http {
    final d = _dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return d;
  }

  MessagingClient get _client => MessagingClient(_http);

  @override
  Future<ChatInbox> loadInbox() async {
    final client = _client;
    final chats = <Chat>[];
    final seen = <String>{};
    String? cursor;
    for (var page = 0; page < inboxMaxPages; page++) {
      final r = await apiCall(
        () => client.listChats(limit: inboxPageSize, cursor: cursor),
      );
      chats.addAll(r.items.map(_chatOfSummary));
      cursor = r.nextCursor;
      if (cursor.isEmpty) return ChatInbox(chats: chats);
      if (!seen.add(cursor)) break;
    }
    return ChatInbox(chats: chats, truncated: true);
  }

  @override
  Future<void> markAllRead() => apiCall(_client.markAllChatsRead);

  @override
  Future<Chat> getChat(String chatId) async =>
      _chatOfDetail(await apiCall(() => _client.getChat(chatId: chatId)));

  @override
  Future<ChatHistoryPage> listMessages(
    String chatId, {
    int? before,
    int? after,
    int? around,
    int? limit,
  }) async => _historyOf(
    await apiCall(
      () => _client.listChatMessages(
        chatId: chatId,
        before: before,
        after: after,
        around: around,
        limit: limit,
      ),
    ),
  );

  @override
  Future<ChatMessage> send(String chatId, OutgoingMessage message) async =>
      _messageOf(
        await apiCall(
          () => _client.sendChatMessage(
            chatId: chatId,
            body: SendChatMessageRequest(
              clientMessageId: message.clientId,
              body: message.text,
              replyToMessageId: message.replyTo,
            ),
          ),
        ),
      );

  @override
  Future<ChatMessage> edit(
    String chatId,
    String messageId, {
    required String text,
    required int expectedRevision,
  }) async => _messageOf(
    await apiCall(
      () => _client.editChatMessage(
        chatId: chatId,
        messageId: messageId,
        body: EditChatMessageRequest(
          body: text,
          expectedRevision: expectedRevision,
        ),
      ),
    ),
  );

  @override
  Future<void> delete(String chatId, String messageId) => apiCall(
    () => _client.deleteChatMessage(chatId: chatId, messageId: messageId),
  );

  @override
  Future<void> markRead(String chatId, String messageId) => apiCall(
    () => _client.markChatRead(
      chatId: chatId,
      body: MarkChatReadRequest(messageId: messageId),
    ),
  );

  @override
  Future<void> typing(String chatId) =>
      apiCall(() => _client.sendChatTyping(chatId: chatId));

  @override
  Future<ChatCandidates> candidates(ChatCandidatePurpose purpose) async =>
      _candidatesOf(
        await apiCall(
          () => _client.listChatCandidates(
            purpose: switch (purpose) {
              ChatCandidatePurpose.direct => Purpose.direct,
              ChatCandidatePurpose.group => Purpose.group,
            },
          ),
        ),
      );

  @override
  Future<Chat> openDirect(String accountId) async => _chatOfDetail(
    await apiCall(
      () => _client.openDirectChat(
        body: OpenDirectChatRequest(accountId: accountId),
      ),
    ),
  );

  @override
  Future<Chat> createGroup(
    GroupDraft draft, {
    required String requestKey,
  }) async => _chatOfDetail(
    await apiCall(
      () => _client.createGroupChat(
        idempotencyKey: requestKey,
        body: CreateGroupChatRequest(
          name: draft.name.trim(),
          memberAccountIds: draft.memberIds,
        ),
      ),
    ),
  );

  @override
  Stream<ChatSignal> events() async* {
    final cancel = CancelToken();
    try {
      final Response<ResponseBody> response;
      try {
        response = await _http.get<ResponseBody>(
          streamPath,
          cancelToken: cancel,
          options: Options(
            responseType: ResponseType.stream,
            receiveTimeout: ChatStreamPolicy.idleTimeout,
            headers: {Headers.acceptHeader: 'text/event-stream'},
            // Kapı halkası `extra`'ya yazar; sabit harita kopyalanır.
            extra: Map.of(MessagingClient.streamChatEventsOpenapiExtras),
          ),
        );
      } on Object catch (e) {
        throw await streamApiError(e);
      }
      final body = response.data;
      if (body == null) throw ApiError(ClientErrorCode.invalidResponse);
      yield const ChatStreamOpened();
      try {
        await for (final raw in decodeSse(body.stream)) {
          final kind = _eventKindOf(raw.event);
          if (kind == null) continue;
          yield _event(kind, raw.data);
        }
      } on ApiError {
        rethrow;
      } on DioException catch (e) {
        throw toApiError(e);
      } on FormatException {
        throw ApiError(ClientErrorCode.invalidResponse);
      } on Object {
        throw ApiError(ClientErrorCode.networkError);
      }
    } finally {
      // Dinleyici bıraktıysa ya da akış bittiyse bağlantı kapatılır.
      cancel.cancel();
    }
  }

  /// Olay yükü; şemaya uymayan yük (eksik/yanlış tipli alan) `client.invalid_response`.
  static ChatEvent _event(ChatEventKind kind, String data) {
    final json = sseJsonObject(data);
    try {
      return _eventOf(kind, api.ChatEvent.fromJson(json));
    } on Object {
      throw ApiError(ClientErrorCode.invalidResponse);
    }
  }
}

// --- DTO → domain eşlemesi (A1/A2: üretilmiş tipler yalnız bu dosyada; zamanlar yerel saat) ---

/// Liste satırı (`ChatSummary`) → [Chat].
Chat _chatOfSummary(ChatSummary s) => Chat(
  id: s.chatId,
  name: _name(s.kind, s.name, s.counterpartName),
  lastActivity: (s.lastMessageAt ?? s.createdAt).toLocal(),
  group: s.kind == ChatKind.group,
  general: s.autoKind == ChatAutoKind.general,
  counterpartId: s.counterpartAccountId,
  unread: s.unreadCount,
  mention: s.mentioned,
  last: _preview(s.lastMessage),
  lastSeq: s.lastSeq,
  role: _role(s.role),
  peerOnline: s.peerOnline,
  peerLastSeen: s.peerLastSeenAt?.toLocal(),
);

/// Sohbet bilgisi (`Chat`; çağıranın rolü dahil) → [Chat]. Okunmamış sayısı ve son mesaj
/// [row]'dan (liste satırı) korunur; yoksa boş.
Chat _chatOfDetail(api.Chat c, {Chat? row}) => Chat(
  id: c.chatId,
  name: _name(c.kind, c.name, c.counterpartName),
  lastActivity: (c.lastMessageAt ?? c.createdAt).toLocal(),
  group: c.kind == ChatKind.group,
  general: c.autoKind == ChatAutoKind.general,
  counterpartId: c.counterpartAccountId,
  unread: row?.unread ?? 0,
  mention: row?.mention ?? false,
  last: row?.last,
  lastSeq: c.lastSeq,
  role: _role(c.role),
  peerOnline: c.peerOnline,
  peerLastSeen: c.peerLastSeenAt?.toLocal(),
);

String _name(ChatKind kind, String? name, String? counterpart) =>
    (kind == ChatKind.direct ? counterpart ?? name : name ?? counterpart) ?? '';

ChatMemberRole? _role(ChatRole? r) => switch (r) {
  ChatRole.admin => ChatMemberRole.admin,
  ChatRole.founder => ChatMemberRole.founder,
  ChatRole.member => ChatMemberRole.member,
  ChatRole.$unknown || null => null,
};

ChatPreview? _preview(ChatLastMessage? m) => m == null
    ? null
    : ChatPreview(
        senderId: m.senderAccountId,
        senderName: m.senderName,
        at: m.createdAt.toLocal(),
        text: m.deleted ? null : m.body,
        deleted: m.deleted,
      );

/// Sunucu mesajı → [ChatMessage] (gönderim durumu `sent`).
ChatMessage _messageOf(api.ChatMessage m) => ChatMessage(
  id: m.messageId,
  clientId: m.clientMessageId,
  seq: m.seq,
  senderId: m.senderAccountId,
  senderName: m.senderName,
  at: m.createdAt.toLocal(),
  text: m.body,
  edited: m.edited,
  revision: m.editRevision,
  replyTo: _quote(m.replyTo, m.replyToMessageId),
  reactions: [
    for (final r in m.reactions)
      if (_reaction(r.kind) case final k?)
        ChatReactionCount(k, r.count, mine: r.mine),
  ],
  pinnedAt: m.pinnedAt?.toLocal(),
  poll: _poll(m.poll),
  attachments: [
    for (final a in m.attachments)
      ChatAttachment(
        id: a.attachmentId,
        fileName: a.fileName,
        sizeBytes: a.sizeBytes,
      ),
  ],
);

ChatQuote? _quote(ChatMessageQuote? q, String? replyToId) {
  if (q != null) {
    return ChatQuote(
      messageId: q.messageId,
      senderId: q.senderAccountId,
      senderName: q.senderName,
      text: q.body,
      deleted: q.deleted,
    );
  }
  // Alıntı gövdesi gelmediyse yalnız kimlik (yanıtlanan mesaj pencerede aranır).
  return replyToId == null ? null : ChatQuote(messageId: replyToId);
}

ChatReaction? _reaction(Kind2 k) => switch (k) {
  Kind2.like => ChatReaction.like,
  Kind2.heart => ChatReaction.heart,
  Kind2.check => ChatReaction.check,
  Kind2.star => ChatReaction.star,
  Kind2.$unknown => null,
};

ChatPoll? _poll(Poll2? p) {
  if (p == null) return null;
  final results = [...p.results]
    ..sort((a, b) => a.optionIndex.compareTo(b.optionIndex));
  return ChatPoll(
    multi: p.multi,
    closesAt: p.closesAt?.toLocal(),
    closed: p.closedAt != null,
    voters: {
      for (final r in results)
        for (final v in r.voters) v.accountId,
    }.length,
    options: [
      for (final r in results)
        ChatPollOption(
          r.label,
          r.count,
          voterIds: {for (final v in r.voters) v.accountId},
        ),
    ],
  );
}

/// Geçmiş sayfası → [ChatHistoryPage] (sunucu sayfayı artan sırada verir; yine de sıralanır).
ChatHistoryPage _historyOf(api.ChatHistory h) => ChatHistoryPage(
  messages: h.items.map(_messageOf).toList()
    ..sort((a, b) => a.seq!.compareTo(b.seq!)),
  peerReadSeq: h.peerReadSeq,
);

ChatCandidates _candidatesOf(api.ChatCandidateList l) => ChatCandidates(
  items: [
    for (final c in l.items)
      ChatCandidate(
        accountId: c.accountId,
        name: c.fullName,
        role: _candidateRole(c),
      ),
  ],
  truncated: l.truncated,
);

ChatCandidateRole? _candidateRole(api.ChatCandidate c) => switch (c.role) {
  api.ChatCandidateRole.companyAdmin => ChatCandidateRole.companyAdmin,
  api.ChatCandidateRole.coordinator => ChatCandidateRole.coordinator,
  api.ChatCandidateRole.member => ChatCandidateRole.member,
  api.ChatCandidateRole.$unknown => null,
};

/// SSE olay adı → tür; bilinmeyen olay `null` (yok sayılır, yeni sunucu olayı istemciyi kırmaz).
ChatEventKind? _eventKindOf(String name) => switch (name) {
  'message.created' => ChatEventKind.messageCreated,
  'message.updated' => ChatEventKind.messageUpdated,
  'message.deleted' => ChatEventKind.messageDeleted,
  'read.updated' => ChatEventKind.readUpdated,
  'member.changed' => ChatEventKind.memberChanged,
  'chat.changed' => ChatEventKind.chatChanged,
  'typing' => ChatEventKind.typing,
  _ => null,
};

ChatEvent _eventOf(ChatEventKind kind, api.ChatEvent e) => ChatEvent(
  kind: kind,
  chatId: e.chatId,
  actorId: e.actorAccountId,
  messageId: e.messageId,
  affected: List.unmodifiable(e.affectedAccountIds),
);
