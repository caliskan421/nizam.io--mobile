import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/assistant.dart';
import '../domain/assistant_repository.dart';

final assistantRepositoryProvider = Provider<AssistantRepository>(
  (ref) => throw UnimplementedError(),
);
final assistantConversationsProvider = FutureProvider((ref) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref.watch(assistantRepositoryProvider).listConversations();
});
final assistantChatProvider =
    NotifierProvider.autoDispose<AssistantController, AssistantChatState>(
      AssistantController.new,
    );

class AssistantChatState {
  const AssistantChatState({
    this.conversationId,
    this.messages = const [],
    this.answer = '',
    this.busy = false,
    this.error,
    this.disabled = false,
    this.sources = const [],
  });
  final String? conversationId;
  final List<AssistantMessage> messages;
  final String answer;
  final bool busy;
  final ApiError? error;
  final bool disabled;
  final List<String> sources;
}

class AssistantController extends Notifier<AssistantChatState> {
  StreamSubscription<AssistantEvent>? _subscription;
  int _epoch = 0;

  @override
  AssistantChatState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch++;
    unawaited(_subscription?.cancel());
    _subscription = null;
    ref.onDispose(() {
      _epoch++;
      unawaited(_subscription?.cancel());
    });
    return const AssistantChatState();
  }

  Future<void> open(String? id) async {
    if (state.busy) return;
    final epoch = ++_epoch;
    state = const AssistantChatState(busy: true);
    if (id == null) {
      state = const AssistantChatState();
      return;
    }
    try {
      final detail = await ref
          .read(assistantRepositoryProvider)
          .getConversation(id);
      if (ref.mounted && epoch == _epoch) {
        state = AssistantChatState(
          conversationId: id,
          messages: detail.messages,
        );
      }
    } on Object catch (e, st) {
      _error(e, st, epoch);
    }
  }

  Future<void> delete(String id) async {
    if (state.busy) return;
    final epoch = ++_epoch;
    state = AssistantChatState(
      conversationId: state.conversationId,
      messages: state.messages,
      busy: true,
    );
    try {
      await ref.read(assistantRepositoryProvider).deleteConversation(id);
      if (!ref.mounted || epoch != _epoch) return;
      state = const AssistantChatState();
      ref.invalidate(assistantConversationsProvider);
    } on Object catch (e, st) {
      _error(e, st, epoch);
    }
  }

  void send(String text) {
    text = text.trim();
    if (state.busy || text.isEmpty || state.disabled) return;
    final epoch = ++_epoch;
    final id = state.conversationId;
    final messages = [
      ...state.messages,
      AssistantMessage(
        order: state.messages.length,
        role: AssistantMessageRole.user,
        content: text,
        createdAt: DateTime.now(),
      ),
    ];
    state = AssistantChatState(
      conversationId: id,
      messages: messages,
      busy: true,
    );
    var answer = '';
    var sources = <String>[];
    var terminal = false;
    _subscription = ref
        .read(assistantRepositoryProvider)
        .chat(AssistantQuestion(text: text, conversationId: id))
        .listen(
          (event) {
            if (!ref.mounted || epoch != _epoch) return;
            switch (event) {
              case AssistantTextChunk(:final text):
                answer += text;
              case AssistantSources(:final tools):
                sources = tools;
              case AssistantDone(:final conversationId):
                terminal = true;
                state = AssistantChatState(
                  conversationId: conversationId,
                  messages: [
                    ...messages,
                    AssistantMessage(
                      order: messages.length,
                      role: AssistantMessageRole.assistant,
                      content: answer,
                      createdAt: DateTime.now(),
                    ),
                  ],
                  sources: sources,
                );
                ref.invalidate(assistantConversationsProvider);
                return;
              case AssistantFailure(:final code):
                terminal = true;
                _error(ApiError(code), StackTrace.current, epoch);
                return;
              default:
                break;
            }
            state = AssistantChatState(
              conversationId: id,
              messages: messages,
              answer: answer,
              busy: true,
              sources: sources,
            );
          },
          onError: (Object error, StackTrace st) {
            terminal = true;
            _error(error, st, epoch);
          },
          onDone: () {
            if (!terminal) {
              _error(
                ApiError('client.network_error'),
                StackTrace.current,
                epoch,
              );
            }
          },
        );
  }

  Future<void> stop() async {
    final epoch = ++_epoch;
    await _subscription?.cancel();
    if (!ref.mounted || epoch != _epoch) return;
    state = AssistantChatState(
      conversationId: state.conversationId,
      messages: state.messages,
      answer: state.answer,
      error: ApiError('client.outcome_unknown'),
    );
    ref.invalidate(assistantConversationsProvider);
  }

  /// Beklenmeyen hata (eşleme TypeError'ı, akış dinleyici hatası) çevrilmeden ÖNCE raporlanır;
  /// bayat (`epoch` eskimiş) sonuçta da hata kaybolmaz. Soru ve yanıt metni rapora girmez.
  void _error(Object error, StackTrace st, int epoch) {
    // Koşulsuz: AssistantDisabled beklenen sonuçtur (ExpectedFailure) ve rapor üretmez.
    final reported = toReportedApiError(
      error,
      st,
      source: ReportSource.assistant,
      operation: ReportOperation.assistantChat,
    );
    final ApiError? api = error is AssistantDisabled ? null : reported;
    if (!ref.mounted || epoch != _epoch) return;
    state = AssistantChatState(
      conversationId: state.conversationId,
      messages: state.messages,
      answer: state.answer,
      error: api,
      disabled: error is AssistantDisabled,
    );
  }
}
