// MessagesController: süzgeç ve arama durumu.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/messages_controller.dart';
import 'package:nizamio/features/messages/domain/chat_logic.dart';

void main() {
  test('süzgeç; arama açılınca sorgu, kapanınca temiz', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(messagesControllerProvider.notifier)
      ..setFilter(ChatFilter.unread)
      ..toggleSearch()
      ..setQuery('trafo');
    var s = c.read(messagesControllerProvider);
    expect(
      (s.filter, s.searchOpen, s.query),
      (ChatFilter.unread, true, 'trafo'),
    );
    ctrl.toggleSearch();
    s = c.read(messagesControllerProvider);
    expect((s.filter, s.searchOpen, s.query), (ChatFilter.unread, false, ''));
  });
}
