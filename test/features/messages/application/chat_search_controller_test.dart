// ChatSearchController: sorgu kırpılır (en çok 100), sonuç en yeniden eskiye; dolu sayfa sonrası
// `before=<en küçük seq>`; boş sorgu temizler; hata eski sonucu bırakmaz.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/application/chat_search_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

void main() {
  test('arama sayfaları ve temizleme', () async {
    final repo = FakeChatRepository()
      ..searchHits = [for (var s = 1; s <= chatSearchPageSize + 5; s++) msg(s)];
    final c = chatContainer(repo)
      ..listen(chatSearchControllerProvider('c1'), (_, _) {});
    final ctl = c.read(chatSearchControllerProvider('c1').notifier);
    await ctl.search('  trafo ${'x' * 120}');
    var s = c.read(chatSearchControllerProvider('c1'));
    expect(s.query.length, ChatSearchController.maxQuery);
    expect(
      s.results.first.seq,
      chatSearchPageSize + 5,
      reason: 'en yeni başta',
    );
    expect(s.hasMore, isTrue);
    await ctl.more();
    s = c.read(chatSearchControllerProvider('c1'));
    expect(repo.calls.last, endsWith('before=6'));
    expect(s.results, hasLength(chatSearchPageSize + 5));
    expect(s.hasMore, isFalse);
    await ctl.more();
    expect(repo.calls.where((x) => x.startsWith('search')), hasLength(2));
    await ctl.search(' ');
    expect(c.read(chatSearchControllerProvider('c1')).results, isEmpty);
  });

  test('hata: sonuç boş kalır ve iletilir', () async {
    final repo = _Failing();
    final c = chatContainer(repo)
      ..listen(chatSearchControllerProvider('c1'), (_, _) {});
    await expectLater(
      c.read(chatSearchControllerProvider('c1').notifier).search('a'),
      throwsA(isA<ApiError>()),
    );
    final s = c.read(chatSearchControllerProvider('c1'));
    expect((s.query, s.results.length, s.busy), ('a', 0, false));
  });
}

class _Failing extends FakeChatRepository {
  @override
  Future<ChatHistoryPage> search(String chatId, String query, {int? before}) =>
      Future.error(ApiError('messaging.invalid_cursor', status: 422));
}
