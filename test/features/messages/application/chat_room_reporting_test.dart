// ChatRoomController gönderim sınırı: ApiError dışı beklenmeyen hata (ör. DTO→domain eşleme
// TypeError'ı) arayüze sızmadan raporlanır; beklenen ApiError raporlanmaz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../../../support/fake_error_reporter.dart';
import '../fake_chat_repository.dart';

class _MappingBugRepository extends FakeChatRepository {
  @override
  Future<ChatMessage> send(String chatId, OutgoingMessage message) =>
      Future<ChatMessage>.error(TypeError());
}

Future<(ProviderContainer, FakeChatRepository)> _open(
  FakeChatRepository repo,
) async {
  repo
    ..server['c1'] = [msg(1)]
    ..getChatResult = chat;
  final c = chatContainer(repo);
  c
    ..listen(chatsControllerProvider, (_, _) {})
    ..listen(chatRoomControllerProvider('c1'), (_, _) {});
  await c.read(chatsControllerProvider.future);
  await c.read(chatRoomControllerProvider('c1').future);
  await pumpEventQueue();
  return (c, repo);
}

void main() {
  late FakeErrorReporter sdk;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk);
    ErrorReporting.setEnabled(true);
  });
  tearDown(ErrorReporting.reset);

  test(
    'eşleme TypeError: chat_send bağlamıyla raporlanır ve yeniden fırlar',
    () async {
      final (c, _) = await _open(_MappingBugRepository());
      final ctrl = c.read(chatRoomControllerProvider('c1').notifier);
      await expectLater(ctrl.send('merhaba'), throwsA(isA<TypeError>()));
      final r = sdk.reports.single;
      expect(r.operation, ReportOperation.chatSend);
      expect(r.errorType, ReportErrorType.typeError);
      expect(wireOf(r), isNot(contains('merhaba')));
    },
  );

  test('beklenen ApiError (yetki/zaman aşımı) raporlanmaz', () async {
    final (c, repo) = await _open(FakeChatRepository());
    final ctrl = c.read(chatRoomControllerProvider('c1').notifier);
    repo.sendError = ApiError('client.timeout');
    expect(await ctrl.send('a'), ChatSendOutcome.failed);
    repo.sendError = ApiError('messaging.not_authorized', status: 403);
    await ctrl.send('b');
    expect(sdk.reports, isEmpty);
  });
}
