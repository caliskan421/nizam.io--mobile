import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/collaboration_client.dart';
import '../../../core/api/generated/models/filter.dart';
import '../../../core/api/generated/models/message.dart';
import '../../../core/api/generated/models/recipient_group.dart';
import '../../../core/api/generated/models/send_message_request.dart';
import '../../../core/api/generated/models/sent_message.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/chat.dart';
import '../domain/mailbox.dart';
import '../domain/message_repository.dart';

/// Mesaj uçlarına (`collaboration` etiketinin mesaj yarısı) üretilmiş istemciyle erişim.
/// Üretilmiş DTO'lar bu katmanda kalır; dışarıya domain varlıkları döner (sınır kuralı A1).
/// Bütün hatalar [ApiError] olarak fırlar.
class ApiMessageRepository implements MessageRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (`X-Nizamio-Program` ara katmandan).
  ApiMessageRepository(Dio dio) : _client = CollaborationClient(dio);

  final CollaborationClient _client;

  @override
  Future<PageSlice<MailboxMessage>> list(
    MessageBox box, {
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _client.listMessages(
        filter: switch (box) {
          MessageBox.inbox => Filter.inbox,
          MessageBox.sent => Filter.sent,
        },
        limit: page.limit,
        cursor: page.cursor,
      ),
    );
    return PageSlice(
      items: [for (final m in r.items) _message(m, box)],
      // Sözleşme: `next_cursor` zorunlu; boş dize son sayfadır.
      nextCursor: r.nextCursor.isEmpty ? null : r.nextCursor,
    );
  }

  @override
  Future<int> unreadCount() async =>
      (await apiCall(_client.countUnreadMessages)).count;

  @override
  Future<List<MessageRecipientGroup>> recipients() async {
    final r = await apiCall(_client.listMessageRecipients);
    return [for (final g in r.groups) _group(g)];
  }

  @override
  Future<MessageReceipt> send({
    required String receiverAccountId,
    required String subject,
    required String content,
  }) async => _receipt(
    await apiCall(
      () => _client.sendMessage(
        body: SendMessageRequest(
          receiverAccountId: receiverAccountId,
          subject: subject,
          content: content,
        ),
      ),
    ),
  );

  @override
  Future<void> markRead(String id) =>
      apiCall(() => _client.markMessageRead(id: id));

  @override
  Future<void> delete(String id) =>
      apiCall(() => _client.deleteMessage(id: id));

  static MailboxMessage _message(Message m, MessageBox box) => MailboxMessage(
    message: ChatMessage(
      id: m.messageId,
      from: m.senderAccountId,
      to: m.receiverAccountId,
      at: m.createdAt,
      text: m.content,
      read: m.isRead,
      readAt: m.readAt,
    ),
    box: box,
    subject: m.subject,
    programId: m.programId,
    senderName: m.senderName,
    receiverName: m.receiverName,
  );

  static MessageRecipientGroup _group(RecipientGroup g) =>
      MessageRecipientGroup(
        kind: enumFromWire(
          RecipientGroupKind.values,
          g.key,
          RecipientGroupKind.unknown,
        ),
        recipients: [
          for (final p in g.recipients)
            MessageRecipient(accountId: p.accountId, fullName: p.fullName),
        ],
        truncated: g.truncated,
      );

  static MessageReceipt _receipt(SentMessage r) => MessageReceipt(
    id: r.messageId,
    programId: r.programId,
    receiverAccountId: r.receiverAccountId,
    subject: r.subject,
    createdAt: r.createdAt,
  );
}
