import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/assistant/application/assistant_controller.dart';
import 'package:nizamio/features/assistant/domain/assistant.dart';
import 'package:nizamio/features/assistant/domain/assistant_repository.dart';

import '../../connected_module_support.dart';

class _Assistant implements AssistantRepository {
  // ignore: close_sinks
  final events = StreamController<AssistantEvent>();
  final deletion = Completer<void>();
  int questions = 0;
  @override
  Stream<AssistantEvent> chat(AssistantQuestion question) {
    questions++;
    return events.stream;
  }

  @override
  Future<void> deleteConversation(String id) => deletion.future;
  @override
  Future<PageSlice<AssistantConversation>> listConversations() async =>
      PageSlice.empty();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('akış parçaları birleşir, done sohbeti kaydeder ve busy kilidi ikinci soruyu engeller', () async {
    final repository = _Assistant();
    final container = moduleContainer(
      overrides: [assistantRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(repository.events.close);
    container.listen(assistantChatProvider, (_, _) {});
    final controller = container.read(assistantChatProvider.notifier);
    controller.send('Soru');
    controller.send('İkinci');
    repository.events.add(const AssistantTextChunk('Mer'));
    repository.events.add(const AssistantTextChunk('haba'));
    repository.events.add(const AssistantDone('conversation'));
    await Future<void>.delayed(Duration.zero);
    final state = container.read(assistantChatProvider);
    expect(repository.questions, 1);
    expect(state.messages.last.content, 'Merhaba');
    expect(state.conversationId, 'conversation');
    expect(state.busy, isFalse);
  });
  test('scope değişince stream iptal edilir, eski akış ve silme yanıtı yeni sohbeti değiştirmez', () async {
    final repository = _Assistant();
    final container = moduleContainer(
      overrides: [assistantRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(repository.events.close);
    container.listen(assistantChatProvider, (_, _) {});
    final controller = container.read(assistantChatProvider.notifier);
    final deletion = controller.delete('old');
    controller.send('Kilitli');
    expect(repository.questions, 0);
    container.read(scopeControllerProvider).selectProgram('other');
    await container.pump();
    repository.deletion.complete();
    await deletion;
    expect(container.read(assistantChatProvider).conversationId, isNull);
    controller.send('Yeni');
    container.read(scopeControllerProvider).selectProgram('third');
    await container.pump();
    expect(repository.events.hasListener, isFalse);
    expect(container.read(assistantChatProvider).messages, isEmpty);
  });
}
