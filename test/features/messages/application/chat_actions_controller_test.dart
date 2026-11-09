// ChatActionsController: tepki ve oy iyimser; çift dokunuş tek istek, geri dönen dokunuş istek
// göndermez; hata geri alır; 409 poll_closed anketi kapatır; sabitleme şeridi yeniden okur;
// indirmeler kayda gider; mesaj başına uçuşta tek yazma, geç hata yalnız kendi katmanını geri alır.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/application/chat_actions_controller.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../fake_chat_repository.dart';

const _wait = Duration(milliseconds: 450);

class _Sink implements DownloadSink {
  final saved = <String>[];

  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    await bytes.drain<void>();
    saved.add(name);
    return '/indirilenler/$name';
  }
}

const _poll = ChatPoll(
  multi: false,
  voters: 0,
  options: [ChatPollOption('A', 0), ChatPollOption('B', 0)],
);

ChatMessage _pollMessage(ChatPoll poll) => ChatMessage(
  id: 'm2',
  clientId: 'c2',
  seq: 2,
  senderId: me,
  at: at(2),
  text: 'Hangisi?',
  poll: poll,
);

/// Sunucuda kapanmış anket (oyum B).
const _closedPoll = ChatPoll(
  multi: false,
  voters: 1,
  closed: true,
  options: [
    ChatPollOption('A', 0),
    ChatPollOption('B', 1, voters: [(accountId: me, name: 'Ben')]),
  ],
);

Future<(ProviderContainer, FakeChatRepository, _Sink)> _open() async {
  final repo = FakeChatRepository()
    ..server['c1'] = [msg(1), _pollMessage(_poll)];
  final sink = _Sink();
  final c =
      chatContainer(repo, extra: [downloadSinkProvider.overrideWithValue(sink)])
        ..listen(chatRoomControllerProvider('c1'), (_, _) {})
        ..listen(chatActionsControllerProvider('c1'), (_, _) {});
  await c.read(chatRoomControllerProvider('c1').future);
  return (c, repo, sink);
}

ChatActionsController _acts(ProviderContainer c) =>
    c.read(chatActionsControllerProvider('c1').notifier);

ChatMessage _m(ProviderContainer c, String id) =>
    c.read(chatRoomControllerProvider('c1')).requireValue.message(id)!;

void main() {
  test('tepki: iyimser; çift dokunuş son durumla tek istek', () async {
    final (c, repo, _) = await _open();
    final a = _acts(c).react('m1', ChatReaction.like);
    expect(_m(c, 'm1').reactions.single.mine, isTrue, reason: 'iyimser');
    final b = _acts(c).react('m1', ChatReaction.heart);
    await Future.wait([a, b]);
    expect(repo.calls.where((x) => x.startsWith('react')), ['react m1 heart']);
    expect(_m(c, 'm1').reactions.single.kind, ChatReaction.heart);
  });

  test('tepki: aç-kapa dokunuşu istek göndermez', () async {
    final (c, repo, _) = await _open();
    final a = _acts(c).react('m1', ChatReaction.star);
    final b = _acts(c).react('m1', ChatReaction.star);
    await Future.wait([a, b]);
    expect(repo.calls.where((x) => x.contains('react')), isEmpty);
    expect(_m(c, 'm1').reactions, isEmpty);
  });

  test('tepki: hata önceki duruma geri alır ve iletilir', () async {
    final (c, repo, _) = await _open();
    repo.writeError = ApiError('messaging.message_not_found', status: 404);
    await expectLater(
      _acts(c).react('m1', ChatReaction.like),
      throwsA(isA<ApiError>()),
    );
    expect(_m(c, 'm1').reactions, isEmpty);
  });

  test('oy: tek seçimde son seçim gider; 409 poll_closed kapatır', () async {
    final (c, repo, _) = await _open();
    final a = _acts(c).vote('m2', 0);
    final b = _acts(c).vote('m2', 1);
    expect(_m(c, 'm2').poll!.mine(me), {1});
    await Future.wait([a, b]);
    expect(repo.calls.where((x) => x.startsWith('vote')), ['vote m2 1']);
    repo.server['c1']![1] = _pollMessage(_closedPoll);
    repo.writeError = ApiError('messaging.poll_closed', status: 409);
    await expectLater(_acts(c).vote('m2', 1), throwsA(isA<ApiError>()));
    await pumpEventQueue();
    expect(_m(c, 'm2').poll!.closed, isTrue);
    expect(_m(c, 'm2').poll!.mine(me), {1}, reason: 'geri alındı');
    await _acts(c).vote('m2', 0);
    expect(
      repo.calls.last,
      isNot(startsWith('vote')),
      reason: 'kapalıya oy yok',
    );
  });

  test(
    'anketi bitir; sabitle: iyimser + şerit yeniden okunur; hata geri alır',
    () async {
      final (c, repo, _) = await _open();
      repo.server['c1']![1] = _pollMessage(_closedPoll);
      await _acts(c).closePoll('m2');
      await pumpEventQueue();
      expect(repo.calls, contains('close m2'));
      expect(_m(c, 'm2').poll!.closed, isTrue);
      repo.pinned = [repo.server['c1']!.first];
      await _acts(c).togglePin('m1');
      expect(repo.calls, containsAllInOrder(['pin m1', 'pins c1']));
      expect(_m(c, 'm1').pinned, isTrue);
      expect(
        c.read(chatRoomControllerProvider('c1')).requireValue.pins.single.id,
        'm1',
      );
      repo.writeError = ApiError('messaging.not_authorized', status: 403);
      await expectLater(_acts(c).togglePin('m1'), throwsA(isA<ApiError>()));
      expect(_m(c, 'm1').pinned, isTrue, reason: 'geri alındı');
    },
  );

  group('uçuş', flights);

  test('indirmeler kayda akar', () async {
    final (c, repo, sink) = await _open();
    final path = await _acts(c).downloadAttachment(
      const ChatAttachment(id: 'a1', fileName: 'R.pdf', sizeBytes: 3),
    );
    await _acts(c).downloadShared('ref1', 'S.pdf');
    expect(path, '/indirilenler/R.pdf');
    expect(sink.saved, ['R.pdf', 'S.pdf']);
    expect(repo.calls, containsAll(['download a1', 'sharedFile ref1']));
    await Future<void>.delayed(_wait);
  });
}

Iterable<String> _reacts(FakeChatRepository repo) =>
    repo.calls.where((x) => x.contains('react'));

void flights() {
  test('gecikmeli başarı: uçuşta tek istek, sonra son istenen durum', () async {
    final (c, repo, _) = await _open();
    final gate = repo.writeGate = Completer<void>();
    final a = _acts(c).react('m1', ChatReaction.like);
    await Future<void>.delayed(_wait);
    final taps = [
      for (final k in [
        ChatReaction.heart,
        ChatReaction.star,
        ChatReaction.check,
      ])
        _acts(c).react('m1', k),
    ];
    await Future<void>.delayed(_wait);
    expect(_reacts(repo), ['react m1 like'], reason: 'uçuş bitmeden istek yok');
    expect(_m(c, 'm1').reactions.single.kind, ChatReaction.check);
    repo.writeGate = null;
    gate.complete();
    await Future.wait([a, ...taps]);
    expect(_reacts(repo), ['react m1 like', 'react m1 check']);
    expect(repo.maxWriting, 1, reason: 'sunucuya en çok bir uçuşta istek');
    expect(_m(c, 'm1').reactions.single.kind, ChatReaction.check);
  });

  test('gecikmeli hata: kendi katmanı geri alınır', () async {
    final (c, repo, _) = await _open();
    final gate = repo.writeGate = Completer<void>();
    repo.writeError = ApiError('platform.unavailable', status: 503);
    final a = _acts(c).vote('m2', 0);
    await Future<void>.delayed(_wait);
    expect(_m(c, 'm2').poll!.mine(me), {0}, reason: 'iyimser');
    gate.complete();
    await expectLater(a, throwsA(isA<ApiError>()));
    expect(_m(c, 'm2').poll!.mine(me), isEmpty);
  });

  test(
    'ters tamamlanma: ilk isteğin geç hatası sonraki seçimi geri almaz',
    () async {
      final (c, repo, _) = await _open();
      final gate = repo.writeGate = Completer<void>();
      repo.writeError = ApiError('platform.unavailable', status: 503);
      final a = _acts(c).react('m1', ChatReaction.like);
      await Future<void>.delayed(_wait);
      final b = _acts(c).react('m1', ChatReaction.heart);
      repo.writeGate = null;
      gate.complete();
      await expectLater(a, throwsA(isA<ApiError>()));
      await b;
      expect(_reacts(repo), ['react m1 like', 'react m1 heart']);
      expect(repo.maxWriting, 1);
      expect(_m(c, 'm1').reactions.single.kind, ChatReaction.heart);
    },
  );
}
