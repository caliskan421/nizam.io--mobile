import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/admin_user_tasks.dart';

final adminUserTaskPanelProvider = NotifierProvider.autoDispose
    .family<UserTaskPanelController, UserTaskPanelState, String>(
      UserTaskPanelController.new,
    );

class UserTaskPanelController extends Notifier<UserTaskPanelState> {
  UserTaskPanelController(this.accountId);
  final String accountId;
  @override
  UserTaskPanelState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return const UserTaskPanelState();
  }

  void toggleStatus(UserTaskStatus status) => state = state.copyWith(
    statuses: Set.unmodifiable(
      state.statuses.contains(status)
          ? (Set<UserTaskStatus>.of(state.statuses)..remove(status))
          : {...state.statuses, status},
    ),
  );
  void togglePriority(TaskPriority priority) => state = state.copyWith(
    priorities: Set.unmodifiable(
      state.priorities.contains(priority)
          ? (Set<TaskPriority>.of(state.priorities)..remove(priority))
          : {...state.priorities, priority},
    ),
  );
  void show(UserTaskView view) => state = state.copyWith(view: view);
  void resetStatuses() =>
      state = state.copyWith(statuses: const {UserTaskStatus.open});
  void clear() => state = UserTaskPanelState(view: state.view);
}
