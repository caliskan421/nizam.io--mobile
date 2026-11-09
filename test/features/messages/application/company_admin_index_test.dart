import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Candidates implements ChatRepository {
  int calls = 0;
  @override
  Future<ChatCandidates> candidates(
    ChatCandidatePurpose purpose, {
    String? chatId,
  }) async {
    calls++;
    expect(purpose, ChatCandidatePurpose.group);
    expect(chatId, isNull);
    return ChatCandidates(
      items: const [
        ChatCandidate(
          accountId: 'another-admin',
          name: 'Yönetici',
          role: ChatCandidateRole.companyAdmin,
        ),
        ChatCandidate(
          accountId: 'member',
          name: 'Üye',
          role: ChatCandidateRole.member,
        ),
      ],
      truncated: true,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('tek grup-adayı çağrısı gerçek admin etiketlerini self ile birleştirir ve kesikliği korur', () async {
    final repo = _Candidates();
    final c = moduleContainer(
      overrides: [chatRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(companyAdminIndexProvider, (_, _) {});
    final index = await c.read(companyAdminIndexProvider.future);
    expect(index.accountIds, {'me', 'another-admin'});
    expect(index.complete, isFalse);
    expect(repo.calls, 1);
    c.invalidate(taskCatalogControllerProvider);
    await c.read(taskCatalogControllerProvider.future);
    await c.read(companyAdminIndexProvider.future);
    expect(
      repo.calls,
      1,
      reason: 'Aynı hesap/yetki olguları için görev kataloğu yeniden okunsa da adaylar tekrar alınmaz',
    );
  });
}
