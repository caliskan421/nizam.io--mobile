// NewChatController: aday listesi amaçla, birebir açma listeye ekler, grup kurma işlem anahtarı
// (aynı taslak aynı anahtar; değişen taslak yeni anahtar; conflict_retry aynı anahtarla bir kez;
// idempotency_key_reused anahtarı düşürür).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/application/new_chat_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

Matcher _code(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

void main() {
  test(
    'adaylar amaçla okunur; birebir açılan sohbet listeye eklenir',
    () async {
      final repo = FakeChatRepository();
      final c = chatContainer(repo)..listen(chatsControllerProvider, (_, _) {});
      await c.read(chatsControllerProvider.future);
      const direct = ChatCandidatePurpose.direct;
      c.listen(newChatControllerProvider(direct), (_, _) {});
      final list = await c.read(newChatControllerProvider(direct).future);
      expect(list.items.single.accountId, peer);
      expect(repo.calls, contains('candidates direct'));
      final opened = await c
          .read(newChatControllerProvider(direct).notifier)
          .openDirect(peer);
      expect(
        c.read(chatsControllerProvider).requireValue.chat(opened.id),
        isNotNull,
      );
    },
  );

  test('grup kurma: işlem anahtarı kararlılığı', () async {
    final repo = FakeChatRepository();
    final c = chatContainer(repo)..listen(chatsControllerProvider, (_, _) {});
    await c.read(chatsControllerProvider.future);
    const group = ChatCandidatePurpose.group;
    c.listen(newChatControllerProvider(group), (_, _) {});
    final ctrl = c.read(newChatControllerProvider(group).notifier);
    final draft = GroupDraft(name: 'Saha', memberIds: const [peer]);

    // Sonuç bilinmiyor: anahtar korunur, aynı taslak aynı anahtarla gider.
    repo.groupErrors.add(ApiError('client.timeout'));
    await expectLater(ctrl.createGroup(draft), _code('client.timeout'));
    await ctrl.createGroup(GroupDraft(name: 'Saha', memberIds: const [peer]));
    expect(repo.groupKeys[0], repo.groupKeys[1]);
    expect(ctrl.pendingKey, isNull, reason: 'başarıda anahtar düşer');

    // conflict_retry: aynı anahtarla tek tekrar.
    repo.groupErrors.add(ApiError('platform.conflict_retry', status: 409));
    await ctrl.createGroup(GroupDraft(name: 'Depo', memberIds: const [peer]));
    expect(repo.groupKeys[2], repo.groupKeys[3]);
    expect(repo.groupKeys[2], isNot(repo.groupKeys[1]));

    // Anahtar başka gövdeyle kullanılmış: düşer, sonraki deneme yeni anahtar.
    repo.groupErrors.add(
      ApiError('messaging.idempotency_key_reused', status: 409),
    );
    final d = GroupDraft(name: 'Ofis', memberIds: const [peer]);
    await expectLater(
      ctrl.createGroup(d),
      _code('messaging.idempotency_key_reused'),
    );
    await ctrl.createGroup(d);
    expect(repo.groupKeys[4], isNot(repo.groupKeys[5]));
    expect(repo.groupKeys.first.length, 22, reason: '128 bit base64url');
  });
}
