// DTO → domain eşlemesi ([ApiChatRepository] kütüphanesinin parçası; A2: üretilmiş tipler yalnız
// özel bildirimlerde; zamanlar yerel saat).
part of 'chat_api_repository.dart';

/// Liste satırı (`ChatSummary`) → [Chat].
Chat _chatOfSummary(ChatSummary s) => Chat(
  id: s.chatId,
  name: _name(s.kind, s.name, s.counterpartName),
  lastActivity: (s.lastMessageAt ?? s.createdAt).toLocal(),
  group: s.kind == ChatKind.group,
  general: s.autoKind == ChatAutoKind.general,
  source: _sourceOf(s.source),
  sourceDepartmentId: s.sourceDepartmentId,
  counterpartId: s.counterpartAccountId,
  unread: s.unreadCount,
  mention: s.mentioned,
  last: _preview(s.lastMessage),
  lastSeq: s.lastSeq,
  role: _role(s.role),
  peerOnline: s.peerOnline,
  peerLastSeen: s.peerLastSeenAt?.toLocal(),
);

/// Sohbet bilgisi (`Chat`; çağıranın rolü dahil) → [Chat]. Okunmamış sayısı ve son mesaj liste
/// satırından gelir (burada boş).
Chat _chatOfDetail(api.Chat c) => Chat(
  id: c.chatId,
  name: _name(c.kind, c.name, c.counterpartName),
  lastActivity: (c.lastMessageAt ?? c.createdAt).toLocal(),
  group: c.kind == ChatKind.group,
  general: c.autoKind == ChatAutoKind.general,
  source: _sourceOf(c.source),
  sourceDepartmentId: c.sourceDepartmentId,
  counterpartId: c.counterpartAccountId,
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

/// Sunucu mesajı → [ChatMessage] (gönderim durumu `sent`). Bilinmeyen tepki/referans/bahsetme
/// türü atlanır (yeni sunucu değeri istemciyi kırmaz).
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
        contentType: a.contentType,
      ),
  ],
  mentions: [for (final x in m.mentions) ?_mentionOf(x)],
  refs: [
    for (final r in m.refs)
      if (_messageRefKind(r.kind) case final k?)
        ChatMessageRef(refId: r.refId, kind: k, targetId: r.targetId),
  ],
  taskIds: List.unmodifiable(m.taskIds),
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

/// Tepki → istek türü.
SetChatReactionRequestKind _reactionKindOf(ChatReaction r) => switch (r) {
  ChatReaction.like => SetChatReactionRequestKind.like,
  ChatReaction.heart => SetChatReactionRequestKind.heart,
  ChatReaction.check => SetChatReactionRequestKind.check,
  ChatReaction.star => SetChatReactionRequestKind.star,
};

ChatMention? _mentionOf(api.ChatMention m) => switch (m.kind) {
  api.ChatMentionKind.all => const ChatMention.all(),
  api.ChatMentionKind.account when m.targetId != null => ChatMention.account(
    m.targetId!,
  ),
  api.ChatMentionKind.department when m.targetId != null =>
    ChatMention.department(m.targetId!),
  _ => null,
};

/// Bahsetme → istek öğesi.
api.ChatMention _mentionDtoOf(ChatMention m) => api.ChatMention(
  kind: switch (m.kind) {
    ChatMentionKind.account => api.ChatMentionKind.account,
    ChatMentionKind.department => api.ChatMentionKind.department,
    ChatMentionKind.all => api.ChatMentionKind.all,
  },
  targetId: m.targetId,
);

/// Anket taslağı → istek alanı.
Poll _pollDtoOf(PollDraft p) => Poll(
  options: [for (final o in p.options) o.trim()],
  multi: p.multi,
  closesAt: p.closesAt?.toUtc(),
);

ChatSource _sourceOf(api.ChatSource s) => switch (s) {
  api.ChatSource.none => ChatSource.none,
  api.ChatSource.department => ChatSource.department,
  api.ChatSource.program => ChatSource.program,
  api.ChatSource.$unknown => ChatSource.none,
};

CreateGroupChatRequestSource _createSourceOf(ChatSource s) => switch (s) {
  ChatSource.none => CreateGroupChatRequestSource.none,
  ChatSource.department => CreateGroupChatRequestSource.department,
  ChatSource.program => CreateGroupChatRequestSource.program,
};

UpdateChatRequestSource _updateSourceOf(ChatSource s) => switch (s) {
  ChatSource.none => UpdateChatRequestSource.none,
  ChatSource.department => UpdateChatRequestSource.department,
  ChatSource.program => UpdateChatRequestSource.program,
};

Kind _refKindOf(ChatRefKind k) => switch (k) {
  ChatRefKind.task => Kind.task,
  ChatRefKind.department => Kind.department,
  ChatRefKind.file => Kind.file,
};

ChatRefKind? _messageRefKind(ChatMessageRefKind k) => switch (k) {
  ChatMessageRefKind.task => ChatRefKind.task,
  ChatMessageRefKind.department => ChatRefKind.department,
  ChatMessageRefKind.file => ChatRefKind.file,
  ChatMessageRefKind.$unknown => null,
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
          voters: [
            for (final v in r.voters)
              (accountId: v.accountId, name: v.fullName ?? ''),
          ],
        ),
    ],
  );
}

/// Geçmiş sayfası → [ChatHistoryPage] (artan `seq`; arama sayfası da artan döner).
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

/// Üye listesi; tanımsız rol `member` sayılır (yetki kararı sunucuda).
ChatMembers _membersOf(api.ChatMemberList l) => ChatMembers(
  items: [
    for (final m in l.items)
      ChatMember(
        accountId: m.accountId,
        name: m.fullName,
        role: switch (m.role) {
          api.ChatMemberRole.admin => ChatMemberRole.admin,
          api.ChatMemberRole.founder => ChatMemberRole.founder,
          api.ChatMemberRole.member ||
          api.ChatMemberRole.$unknown => ChatMemberRole.member,
        },
        fromSource: m.fromSource,
      ),
  ],
  truncated: l.truncated,
);

/// Paylaşılanlar sayfası; bilinmeyen tür atlanır, boş imleç son sayfa.
ChatSharedPage _sharedOf(ChatRefList l) => ChatSharedPage(
  items: [
    for (final r in l.items)
      if (switch (r.kind) {
            ChatSharedRefKind.task => ChatRefKind.task,
            ChatSharedRefKind.department => ChatRefKind.department,
            ChatSharedRefKind.file => ChatRefKind.file,
            ChatSharedRefKind.$unknown => null,
          }
          case final k?)
        ChatSharedItem(
          refId: r.refId,
          kind: k,
          targetId: r.targetId,
          messageId: r.messageId,
          senderId: r.senderAccountId,
          at: r.createdAt.toLocal(),
        ),
  ],
  nextCursor: (l.nextCursor?.isEmpty ?? true) ? null : l.nextCursor,
);

/// Referans kartı; tanımsız tür "artık yok" kartıdır.
ChatRefCard _refCardOf(ChatRefSummary s) {
  final kind = switch (s.kind) {
    ChatRefSummaryKind.task => ChatRefKind.task,
    ChatRefSummaryKind.department => ChatRefKind.department,
    ChatRefSummaryKind.file || ChatRefSummaryKind.$unknown => ChatRefKind.file,
  };
  if (!s.available || s.kind == ChatRefSummaryKind.$unknown) {
    return ChatRefCard(refId: s.refId, kind: kind, available: false);
  }
  final task = s.task;
  final file = s.file;
  return ChatRefCard(
    refId: s.refId,
    kind: kind,
    available: true,
    title: task?.title ?? s.department?.name ?? file?.name,
    department: task?.departmentName,
    start: task?.startOn,
    end: task?.endOn,
    sizeBytes: file?.sizeBytes,
  );
}

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

/// Mesajdan görevin önceliği → sunucu değeri.
String? _taskPriorityOf(ChatTaskPriority? p) => switch (p) {
  ChatTaskPriority.low => 'dusuk',
  ChatTaskPriority.medium => 'orta',
  ChatTaskPriority.high => 'yuksek',
  ChatTaskPriority.urgent => 'acil',
  null => null,
};
