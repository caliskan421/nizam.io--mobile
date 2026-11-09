// Sohbet ek kuralları: bahsetme sorgusu/uygulama/gönderilecekler (metinde kalanlar, tekil, tavan),
// iyimser tepki sayımı, anket oy kümesi (tek/çoklu), iyimser oy ve kapanma, anket taslağı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

void main() {
  test('bahsetme: son @sorgu, uygulama ve metinde kalan seçimler', () {
    expect(mentionQuery('merhaba @Ka'), 'Ka');
    expect(mentionQuery('@'), '');
    expect(mentionQuery('e-posta a@b'), isNull, reason: 'kelime içi @');
    expect(mentionQuery('@Kadir Ö'), isNull, reason: 'boşluk sorguyu bitirir');
    expect(applyMention('selam @Ka', 'Kadir Özbek'), 'selam @Kadir Özbek ');
    final picks = <MentionPick>[
      (label: 'Kadir Özbek', mention: const ChatMention.account('k')),
      (label: 'Reha Koçak', mention: const ChatMention.account('r')),
      (label: 'Kadir Özbek', mention: const ChatMention.account('k')),
      (label: 'herkes', mention: const ChatMention.all()),
    ];
    expect(mentionsIn('@Kadir Özbek ve @herkes', picks), [
      const ChatMention.account('k'),
      const ChatMention.all(),
    ]);
    final many = [
      for (var i = 0; i < 30; i++)
        (label: 'k$i', mention: ChatMention.account('$i')),
    ];
    expect(
      mentionsIn([for (var i = 0; i < 30; i++) '@k$i'].join(' '), many),
      hasLength(chatMaxMentions),
    );
  });

  test('tepki: benim tepkim yer değiştirir, sayılar iyimser', () {
    const start = [
      ChatReactionCount(ChatReaction.like, 2, mine: true),
      ChatReactionCount(ChatReaction.heart, 1),
    ];
    final swapped = withMyReaction(start, ChatReaction.heart);
    expect(
      [for (final r in swapped) (r.kind, r.count, r.mine)],
      [(ChatReaction.like, 1, false), (ChatReaction.heart, 2, true)],
    );
    final removed = withMyReaction(swapped, null);
    expect(
      [for (final r in removed) (r.kind, r.count, r.mine)],
      [(ChatReaction.like, 1, false), (ChatReaction.heart, 1, false)],
    );
  });

  test('anket: tek/çoklu oy kümesi, iyimser oy, kapanma', () {
    const me = (accountId: 'me', name: 'Ben');
    const single = ChatPoll(
      multi: false,
      voters: 1,
      options: [
        ChatPollOption('A', 1, voters: [me]),
        ChatPollOption('B', 0),
      ],
    );
    expect(single.mine('me'), {0});
    expect(single.toggled({0}, 0), <int>{}, reason: 'aynı seçenek geri çeker');
    expect(single.toggled({0}, 1), {1});
    const multi = ChatPoll(multi: true, voters: 0, options: []);
    expect(multi.toggled({0}, 1), {0, 1});
    expect(multi.toggled({0, 1}, 0), {1});
    final moved = single.withVotes(me, {1});
    expect([for (final o in moved.options) o.count], [0, 1]);
    expect(moved.options[1].votedBy('me'), isTrue);
    expect(moved.voters, 1);
    expect(single.isClosed(DateTime(2026)), isFalse);
    expect(single.asClosed().isClosed(DateTime(2026)), isTrue);
    final due = ChatPoll(
      multi: false,
      voters: 0,
      options: const [],
      closesAt: DateTime(2026, 1, 1),
    );
    expect(due.isClosed(DateTime(2026, 1, 2)), isTrue, reason: 'son tarih');
  });

  test('anket taslağı: 2–10 tekil, boş seçenek sayılmaz', () {
    expect(PollDraft.valid(['A', ' ', 'B']), isTrue);
    expect(PollDraft.valid(['A']), isFalse);
    expect(PollDraft.valid(['A', 'A ']), isFalse);
    expect(PollDraft.valid([for (var i = 0; i < 11; i++) '$i']), isFalse);
  });
}
