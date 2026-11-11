// Real HTTP scenario for messaging ports, independent of widgets and fake repositories.
// Uses the standard NIZAMIO_IT_* configuration; resources belong only to this scenario.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/request_key.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import 'support/messaging_fixture.dart';

Matcher _error(String code) =>
    throwsA(isA<ApiError>().having((error) => error.code, 'code', code));

void main() {
  test(
    'source, refs, search, poll and attachment survive real API round trips',
    () async {
      final fixture = await MessagingFixture.create();
      final repo = fixture.messages;

      // The same request key returns the same group; it does not create another chat.
      final draft = GroupDraft(
        name: 'Infrastructure scenario',
        memberIds: const [],
        source: ChatSource.program,
      );
      final groupKey = newRequestKey();
      final group = await repo.createGroup(draft, requestKey: groupKey);
      expect(group.source, ChatSource.program);
      final replayedGroup = await repo.createGroup(draft, requestKey: groupKey);
      expect(replayedGroup.id, group.id);
      expect(fixture.proxy.count('POST', '/v1/chats/groups'), 2);
      expect(
        (await repo.loadInbox()).chats.where((chat) => chat.id == group.id),
        hasLength(1),
      );

      final changedSource = await repo.updateSource(
        group.id,
        ChatSource.department,
        departmentId: fixture.departmentId,
      );
      expect(changedSource.source, ChatSource.department);
      expect(changedSource.sourceDepartmentId, fixture.departmentId);
      final clearedSource = await repo.updateSource(group.id, ChatSource.none);
      expect(clearedSource.source, ChatSource.none);
      expect(clearedSource.sourceDepartmentId, isNull);

      final baseline = await repo.send(
        group.id,
        OutgoingMessage(clientId: newRequestKey(), text: 'Before subscription'),
      );

      // Subscribe first, then read content over HTTP after the content-free SSE signal.
      final liveRepo = await fixture.streamRepository();
      final events = StreamIterator(liveRepo.events());
      addTearDown(events.cancel);
      expect(
        await events.moveNext().timeout(const Duration(seconds: 10)),
        isTrue,
      );
      expect(events.current, isA<ChatStreamOpened>());

      final messageKey = newRequestKey();
      final outgoing = OutgoingMessage(
        clientId: messageKey,
        text: 'SearchableUniquePayload',
        refs: [
          ChatRefDraft(
            kind: ChatRefKind.department,
            targetId: fixture.departmentId,
          ),
        ],
        mentions: [ChatMention.department(fixture.departmentId)],
      );
      final original = await repo.send(group.id, outgoing);
      final createdSignal = await (() async {
        while (await events.moveNext()) {
          final event = events.current;
          if (event is ChatEvent &&
              event.kind == ChatEventKind.messageCreated &&
              event.chatId == group.id) {
            return event;
          }
        }
        throw StateError('SSE closed before message.created');
      })().timeout(const Duration(seconds: 10));
      expect(createdSignal.messageId, original.id);
      // ChatEvent carries identifiers only; visible content comes from authorized HTTP.
      final reconciled = await liveRepo.listMessages(
        group.id,
        after: baseline.seq,
      );
      expect(reconciled.messages.single.id, original.id);
      expect(reconciled.messages.single.text, outgoing.text);
      await events.cancel();
      final repeated = await repo.send(group.id, outgoing);
      expect(repeated.id, original.id);
      expect(repeated.seq, original.seq);
      expect(repeated.refs.single.refId, original.refs.single.refId);
      expect(repeated.refs.single.targetId, fixture.departmentId);
      expect(repeated.mentions.single.kind, ChatMentionKind.department);
      await expectLater(
        repo.send(
          group.id,
          OutgoingMessage(clientId: messageKey, text: 'Changed payload'),
        ),
        _error('messaging.idempotency_key_reused'),
      );

      // A later message hides the matched text from the last-message preview.
      await repo.send(
        group.id,
        OutgoingMessage(
          clientId: newRequestKey(),
          text: 'Unrelated latest text',
        ),
      );
      final inbox = await repo.loadInbox(query: 'SearchableUniquePayload');
      expect(inbox.chats.map((chat) => chat.id), contains(group.id));
      final matching = await repo.search(group.id, 'SearchableUniquePayload');
      expect(matching.messages.map((message) => message.id), [original.id]);
      final shared = await repo.shared(group.id, kind: ChatRefKind.department);
      expect(shared.items.single.refId, original.refs.single.refId);
      expect(
        (await repo.shared(group.id, kind: ChatRefKind.file)).items,
        isEmpty,
      );
      final card = await repo.refCard(original.refs.single.refId);
      expect(card.available, isTrue);
      expect(card.kind, ChatRefKind.department);

      final closesAt = DateTime.now().toUtc().add(const Duration(hours: 2));
      final poll = await repo.send(
        group.id,
        OutgoingMessage(
          clientId: newRequestKey(),
          text: 'Decision?',
          poll: PollDraft(options: const ['A', 'B'], closesAt: closesAt),
        ),
      );
      expect(
        poll.poll!.closesAt!.toUtc().difference(closesAt).inMilliseconds.abs(),
        lessThan(1000),
      );
      await repo.vote(group.id, poll.id, {0});
      final pollPage = await repo.listMessages(group.id, around: poll.seq);
      expect(
        pollPage.messages.firstWhere((m) => m.id == poll.id).poll!.voters,
        1,
      );
      await repo.closePoll(group.id, poll.id);
      await expectLater(
        repo.vote(group.id, poll.id, {1}),
        _error('messaging.poll_closed'),
      );

      final directory = await Directory.systemTemp.createTemp(
        'nizamio-message-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/scenario.pdf');
      final bytes = '%PDF-1.4\nSynthetic messaging fixture\n%%EOF\n'.codeUnits;
      await file.writeAsBytes(bytes);
      final attachmentKey = newRequestKey();
      final upload = ChatUpload(
        path: file.path,
        name: 'scenario.pdf',
        sizeBytes: bytes.length,
        contentType: 'application/pdf',
      );
      final attachment = await repo.sendAttachment(
        group.id,
        attachmentKey,
        upload,
        replyTo: original.id,
        caption: 'Attachment caption',
      );
      expect(attachment.text, 'Attachment caption');
      expect(attachment.replyTo!.messageId, original.id);
      final attachmentReplay = await repo.sendAttachment(
        group.id,
        attachmentKey,
        upload,
        replyTo: original.id,
        caption: 'Attachment caption',
      );
      expect(attachmentReplay.id, attachment.id);
      final downloaded = await repo.downloadAttachment(
        attachment.attachments.single.id,
      );
      expect(await downloaded.expand((chunk) => chunk).toList(), bytes);

      final overview = await repo.unreadOverview();
      final thisProgram = overview.singleWhere(
        (p) => p.programId == fixture.programId,
      );
      expect(
        thisProgram.unreadChats,
        0,
        reason: 'own messages do not count as unread',
      );
      expect(thisProgram.mentioned, isFalse);
      final history = await repo.listMessages(group.id);
      expect(
        history.messages.where((m) => m.clientId == messageKey),
        hasLength(1),
      );
      expect(
        history.messages.where((m) => m.clientId == attachmentKey),
        hasLength(1),
      );
    },
  );
}
