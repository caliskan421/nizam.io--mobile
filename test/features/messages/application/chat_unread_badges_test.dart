import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

class _Unread extends FakeChatRepository {
  final replies = <Completer<List<ChatProgramUnread>>>[];

  @override
  Future<List<ChatProgramUnread>> unreadOverview() =>
      replies.removeAt(0).future;
}

ChatProgramUnread _program(String id, int count) => ChatProgramUnread(
  programId: id,
  name: id,
  unreadChats: count,
  mentioned: true,
);

void main() {
  test(
    'rozet yenilemede korunur; hesap değişiminde eski rozet görünmez',
    () async {
      var session = 1;
      final first = Completer<List<ChatProgramUnread>>()
        ..complete([_program('first', 7)]);
      final refresh = Completer<List<ChatProgramUnread>>();
      final next = Completer<List<ChatProgramUnread>>();
      final repo = _Unread()..replies.addAll([first, refresh, next]);
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          chatRepositoryProvider.overrideWithValue(repo),
          sessionGenerationProvider.overrideWith((ref) => session),
        ],
      );
      addTearDown(container.dispose);
      container.listen(chatUnreadBadgesProvider, (_, _) {});
      await container.read(chatUnreadSnapshotProvider.future);
      expect(
        container.read(chatUnreadBadgesProvider).value!.single.unreadChats,
        7,
      );

      container.invalidate(chatUnreadSnapshotProvider);
      final pending = container.read(chatUnreadSnapshotProvider.future);
      expect(
        container.read(chatUnreadBadgesProvider).value!.single.unreadChats,
        7,
      );
      final failed = expectLater(pending, throwsA(isA<ApiError>()));
      refresh.completeError(ApiError('client.timeout'));
      await failed;
      expect(
        container.read(chatUnreadBadgesProvider).value!.single.unreadChats,
        7,
      );

      session = 2;
      container.invalidate(sessionGenerationProvider);
      expect(container.read(chatUnreadBadgesProvider).value, isNull);
      next.complete([_program('second', 2)]);
      await container.read(chatUnreadSnapshotProvider.future);
      expect(
        container.read(chatUnreadBadgesProvider).value!.single.programId,
        'second',
      );
    },
  );
}
