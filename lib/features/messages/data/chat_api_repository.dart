// HAM DIO İSTİSNASI (yalnız `events`): üretilmiş `MessagingClient.streamChatEvents` imzası
// `Future<String>`'dir — `text/event-stream` gövdesinin tamamını bekler, olayları akış sırasında
// veremez ve iptal edilemez. Akış aynı Dio (kapı/kimlik/hata halkaları) üzerinden
// `ResponseType.stream` ile okunur; kapı halkası S2 program başlığını eklesin diye üretilmiş
// `streamChatEventsOpenapiExtras` metaverisi aynen taşınır (emsal: assistant deposu). Ek gönderimi
// ve ikili indirmeler `core/http` yardımcılarıyla (parça sırası/türü, akışlı gövde) yine aynı
// metaveriyle gider. Diğer uçlar üretilmiş istemciyle çağrılır.
import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/messaging_client.dart';
import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/models/add_chat_members_request.dart';
import '../../../core/api/generated/models/chat.dart' as api;
import '../../../core/api/generated/models/chat_auto_kind.dart';
import '../../../core/api/generated/models/chat_candidate.dart' as api;
import '../../../core/api/generated/models/chat_candidate_list.dart' as api;
import '../../../core/api/generated/models/chat_candidate_role.dart' as api;
import '../../../core/api/generated/models/chat_event.dart' as api;
import '../../../core/api/generated/models/chat_history.dart' as api;
import '../../../core/api/generated/models/chat_kind.dart';
import '../../../core/api/generated/models/chat_last_message.dart';
import '../../../core/api/generated/models/chat_member_list.dart' as api;
import '../../../core/api/generated/models/chat_member_role.dart' as api;
import '../../../core/api/generated/models/chat_mention.dart' as api;
import '../../../core/api/generated/models/chat_mention_kind.dart' as api;
import '../../../core/api/generated/models/chat_message.dart' as api;
import '../../../core/api/generated/models/chat_message_quote.dart';
import '../../../core/api/generated/models/chat_message_ref_kind.dart';
import '../../../core/api/generated/models/chat_ref_list.dart';
import '../../../core/api/generated/models/chat_ref_summary.dart';
import '../../../core/api/generated/models/chat_ref_summary_kind.dart';
import '../../../core/api/generated/models/chat_role.dart';
import '../../../core/api/generated/models/chat_shared_ref_kind.dart';
import '../../../core/api/generated/models/chat_source.dart' as api;
import '../../../core/api/generated/models/chat_summary.dart';
import '../../../core/api/generated/models/create_group_chat_request.dart';
import '../../../core/api/generated/models/create_group_chat_request_source.dart';
import '../../../core/api/generated/models/create_task_from_chat_message_request.dart';
import '../../../core/api/generated/models/edit_chat_message_request.dart';
import '../../../core/api/generated/models/kind.dart';
import '../../../core/api/generated/models/kind2.dart';
import '../../../core/api/generated/models/mark_chat_read_request.dart';
import '../../../core/api/generated/models/open_direct_chat_request.dart';
import '../../../core/api/generated/models/poll.dart';
import '../../../core/api/generated/models/poll2.dart';
import '../../../core/api/generated/models/purpose.dart';
import '../../../core/api/generated/models/refs.dart';
import '../../../core/api/generated/models/send_chat_message_request.dart';
import '../../../core/api/generated/models/set_chat_reaction_request.dart';
import '../../../core/api/generated/models/set_chat_reaction_request_kind.dart';
import '../../../core/api/generated/models/update_chat_request.dart';
import '../../../core/api/generated/models/update_chat_request_source.dart';
import '../../../core/api/generated/models/vote_chat_poll_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/file_download.dart';
import '../../../core/http/file_upload.dart';
import '../../../core/http/sse.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/error_reporting.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';

part 'chat_api_mapping.dart';

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
  Future<ChatDepartments> programDepartments() async {
    final response = await apiCall(ProgramClient(_http).listProgramDepartments);
    return ChatDepartments(
      items: [
        for (final d in response.data.departments)
          ChatDepartmentOption(id: d.departmentId, name: d.displayName),
      ],
      truncated:
          response.response.headers.value('X-Result-Truncated') == 'true',
    );
  }

  @override
  Future<ChatInbox> loadInbox({
    String? query,
    bool Function()? isCurrent,
  }) async {
    void requireCurrent() {
      if (isCurrent != null && !isCurrent()) {
        throw ApiError(ClientErrorCode.sessionEnded);
      }
    }

    final client = _client;
    final chats = <Chat>[];
    final seen = <String>{};
    String? cursor;
    for (var page = 0; page < inboxMaxPages; page++) {
      requireCurrent();
      final r = await apiCall(
        () => client.listChats(
          q: query == null || query.trim().isEmpty ? null : query.trim(),
          limit: inboxPageSize,
          cursor: cursor,
        ),
      );
      requireCurrent();
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
  Future<List<ChatProgramUnread>> unreadOverview() async {
    final r = await apiCall(_client.getChatUnreadOverview);
    return List.unmodifiable([
      for (final p in r.items)
        ChatProgramUnread(
          programId: p.programId,
          name: p.programName,
          unreadChats: p.unreadChats,
          mentioned: p.mentioned,
        ),
    ]);
  }

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
              mentions: message.mentions.isEmpty
                  ? null
                  : [for (final m in message.mentions) _mentionDtoOf(m)],
              poll: message.poll == null ? null : _pollDtoOf(message.poll!),
              refs: message.refs.isEmpty
                  ? null
                  : [
                      for (final r in message.refs)
                        Refs(kind: _refKindOf(r.kind), targetId: r.targetId),
                    ],
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
  Future<ChatCandidates> candidates(
    ChatCandidatePurpose purpose, {
    String? chatId,
  }) async => _candidatesOf(
    await apiCall(
      () => _client.listChatCandidates(
        purpose: switch (purpose) {
          ChatCandidatePurpose.direct => Purpose.direct,
          ChatCandidatePurpose.group => Purpose.group,
        },
        chatId: chatId,
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
          source: draft.source == ChatSource.none
              ? null
              : _createSourceOf(draft.source),
          sourceDepartmentId: draft.sourceDepartmentId,
        ),
      ),
    ),
  );

  @override
  Future<Chat> updateSource(
    String chatId,
    ChatSource source, {
    String? departmentId,
  }) async => _chatOfDetail(
    await apiCall(
      () => _client.updateChat(
        chatId: chatId,
        body: UpdateChatRequest(
          source: _updateSourceOf(source),
          sourceDepartmentId: departmentId,
        ),
      ),
    ),
  );

  // --- Tepki, sabit, anket ---

  @override
  Future<void> setReaction(
    String chatId,
    String messageId,
    ChatReaction kind,
  ) => apiCall(
    () => _client.setChatReaction(
      chatId: chatId,
      messageId: messageId,
      body: SetChatReactionRequest(kind: _reactionKindOf(kind)),
    ),
  );

  @override
  Future<void> clearReaction(String chatId, String messageId) => apiCall(
    () => _client.deleteChatReaction(chatId: chatId, messageId: messageId),
  );

  @override
  Future<void> pin(String chatId, String messageId) => apiCall(
    () => _client.pinChatMessage(chatId: chatId, messageId: messageId),
  );

  @override
  Future<void> unpin(String chatId, String messageId) => apiCall(
    () => _client.unpinChatMessage(chatId: chatId, messageId: messageId),
  );

  @override
  Future<List<ChatMessage>> pins(String chatId) async =>
      (await pinnedPage(chatId)).items;

  @override
  Future<ChatPinsPage> pinnedPage(String chatId) async {
    final r = await apiCall(() => _client.listChatPins(chatId: chatId));
    return ChatPinsPage(
      items: [for (final m in r.items) _messageOf(m)],
      truncated: r.truncated,
    );
  }

  @override
  Future<void> vote(String chatId, String messageId, Set<int> options) =>
      apiCall(
        () => _client.voteChatPoll(
          chatId: chatId,
          messageId: messageId,
          body: VoteChatPollRequest(optionIndexes: options.toList()..sort()),
        ),
      );

  @override
  Future<void> closePoll(String chatId, String messageId) => apiCall(
    () => _client.closeChatPoll(chatId: chatId, messageId: messageId),
  );

  // --- Ek ---

  @override
  Future<ChatMessage> sendAttachment(
    String chatId,
    String clientId,
    ChatUpload file, {
    String? replyTo,
    String? caption,
  }) async {
    final http = _http;
    return _messageOf(
      await apiCall(
        () async => decodeJsonObject(
          await postChatAttachment(
            http,
            chatId: chatId,
            clientMessageId: clientId,
            filePath: file.path,
            filename: file.name,
            contentType: file.contentType,
            replyToMessageId: replyTo,
            body: caption,
            extras: MessagingClient.sendChatAttachmentOpenapiExtras,
          ),
          api.ChatMessage.fromJson,
        ),
      ),
    );
  }

  @override
  Future<Stream<List<int>>> downloadAttachment(String attachmentId) =>
      getBinaryStream(
        _http,
        path: '/v1/chat-attachments/${Uri.encodeComponent(attachmentId)}',
        extras: MessagingClient.downloadChatAttachmentOpenapiExtras,
      );

  // --- Üyeler ve grup ayarları ---

  @override
  Future<ChatMembers> members(String chatId) async =>
      _membersOf(await apiCall(() => _client.listChatMembers(chatId: chatId)));

  @override
  Future<void> addMembers(String chatId, List<String> accountIds) => apiCall(
    () => _client.addChatMembers(
      chatId: chatId,
      body: AddChatMembersRequest(accountIds: accountIds),
    ),
  );

  @override
  Future<void> removeMember(String chatId, String accountId) => apiCall(
    () => _client.removeChatMember(chatId: chatId, accountId: accountId),
  );

  @override
  Future<void> setAdmin(
    String chatId,
    String accountId, {
    required bool admin,
  }) => apiCall(
    () => admin
        ? _client.grantChatAdmin(chatId: chatId, accountId: accountId)
        : _client.revokeChatAdmin(chatId: chatId, accountId: accountId),
  );

  @override
  Future<Chat> rename(String chatId, String name) async => _chatOfDetail(
    await apiCall(
      () => _client.updateChat(
        chatId: chatId,
        body: UpdateChatRequest(name: name.trim()),
      ),
    ),
  );

  @override
  Future<void> deleteChat(String chatId) =>
      apiCall(() => _client.deleteChat(chatId: chatId));

  // --- Paylaşılanlar, mesajdan görev, arama ---

  /// Paylaşılanlar sayfa boyu.
  static const sharedPageSize = 50;

  @override
  Future<ChatSharedPage> shared(
    String chatId, {
    String? cursor,
    ChatRefKind? kind,
  }) async => _sharedOf(
    await apiCall(
      () => _client.listChatRefs(
        chatId: chatId,
        cursor: cursor,
        limit: sharedPageSize,
        kind: kind == null ? null : _refKindOf(kind),
      ),
    ),
  );

  @override
  Future<ChatRefCard> refCard(String refId) async =>
      _refCardOf(await apiCall(() => _client.getChatRefSummary(refId: refId)));

  @override
  Future<Stream<List<int>>> downloadSharedFile(String refId) => getBinaryStream(
    _http,
    path: '/v1/chat-file-refs/${Uri.encodeComponent(refId)}',
    extras: MessagingClient.downloadChatSharedFileOpenapiExtras,
  );

  @override
  Future<ChatTaskCreated> createTask(
    String chatId,
    String messageId,
    ChatTaskDraft draft, {
    required String requestKey,
  }) async {
    final r = await apiCall(
      () => _client.createTaskFromChatMessage(
        chatId: chatId,
        messageId: messageId,
        idempotencyKey: requestKey,
        body: CreateTaskFromChatMessageRequest(
          departmentId: draft.departmentId,
          startDate: draft.start,
          endDate: draft.end,
          title: draft.title,
          priority: _taskPriorityOf(draft.priority),
          assigneeAccountIds: draft.assigneeIds.isEmpty
              ? null
              : draft.assigneeIds,
        ),
      ),
    );
    return (workItemId: r.workItemId, message: _messageOf(r.message));
  }

  @override
  Future<ChatHistoryPage> search(
    String chatId,
    String query, {
    int? before,
  }) async => _historyOf(
    await apiCall(
      () => _client.listChatMessages(
        chatId: chatId,
        q: query.trim(),
        before: before,
        limit: chatSearchPageSize,
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
      if (body == null) throw invalidResponseError();
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
      } on FormatException catch (e, st) {
        _reportStream(e, st);
        throw ApiError(ClientErrorCode.invalidResponse);
      } on Object catch (e, st) {
        // Ağ/IO kopması beklenen durumdur (raporlanmaz); programlama hatası raporlanır.
        reportUnexpected(e, st, operation: ReportOperation.chatStream);
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
    } on Object catch (e, st) {
      _reportStream(e, st);
      throw ApiError(ClientErrorCode.invalidResponse);
    }
  }

  /// SSE akışı ayrıştırma arızası (olay yükü yok, yalnız tür ve yığın). Bu yol `apiCall`
  /// kullanmadığı için işlem bağlamı açıkça verilir.
  static void _reportStream(Object e, StackTrace st) => ErrorReporting.report(
    e,
    st,
    kind: ReportKind.invalidResponse,
    operation: ReportOperation.chatStream,
    apiCode: ClientErrorCode.invalidResponse,
  );
}
