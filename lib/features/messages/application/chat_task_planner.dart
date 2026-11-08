import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import 'chat_room_controller.dart';
import 'messages_providers.dart';

/// tasks'ın [ChatTaskPlanner] portunun gerçekleştirmesi ("mesajdan görev" kipindeki yeni görev
/// formu; §10.9). Yanıttaki güncel mesaj (`task_ids`) açık sohbete yerleştirilir.
class MessagesTaskPlanner implements ChatTaskPlanner {
  MessagesTaskPlanner(this._ref);

  final Ref _ref;

  @override
  Future<String> convertMessage(
    ChatTaskSource source,
    NoteTaskPlan plan, {
    required String requestKey,
  }) async {
    final r = await _ref
        .read(chatRepositoryProvider)
        .createTask(
          source.chatId,
          source.messageId,
          ChatTaskDraft(
            departmentId: plan.departmentId,
            start: plan.start,
            end: plan.end,
            title: plan.title.isEmpty ? null : plan.title,
            priority: switch (plan.priority) {
              TaskPriority.low => ChatTaskPriority.low,
              TaskPriority.medium => ChatTaskPriority.medium,
              TaskPriority.high => ChatTaskPriority.high,
              TaskPriority.urgent => ChatTaskPriority.urgent,
              TaskPriority.unknown => null,
            },
            assigneeIds: plan.assigneeIds,
          ),
          requestKey: requestKey,
        );
    final room = chatRoomControllerProvider(source.chatId);
    if (_ref.exists(room)) _ref.read(room.notifier).apply(r.message);
    return r.workItemId;
  }
}
