import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/assignments_request.dart';
import '../../../core/api/generated/models/completion_request.dart';
import '../../../core/api/generated/models/create_work_item_request.dart';
import '../../../core/api/generated/models/create_work_item_request_priority.dart';
import '../../../core/api/generated/models/extend_request.dart';
import '../../../core/api/generated/models/transition_request.dart';
import '../../../core/api/generated/models/transition_request_to.dart';
import '../../../core/api/generated/models/transition_result.dart';
import '../../../core/api/generated/models/update_work_item_request.dart';
import '../../../core/api/generated/models/update_work_item_request_priority.dart';
import '../../../core/api/generated/models/work_item.dart';
import '../../../core/api/generated/models/work_item_dates.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/task_catalog.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';
import 'work_item_mapping.dart';

/// [WorkItemRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. DTO'lar bu katmanda
/// kalır (A1); her çağrı [apiCall] ile sarılır, eşleme hatası da `client.invalid_response`
/// olur. Kapsam başlıkları ara katmandan gelir (S3).
///
/// Bilinen açık: üretilmiş istek DTO'ları `format: date` alanlarını `DateTime.toIso8601String`
/// ile (`2026-11-01T00:00:00.000`) yazar; sunucu `YYYY-AA-GG` bekler (422
/// `work.input_invalid`). Düzeltme core/üretim katmanında (ortaklaştırma adayı).
class ApiWorkItemRepository implements WorkItemRepository {
  ApiWorkItemRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  @override
  Future<PageSlice<TaskSummary>> list([
    PageRequest page = const PageRequest(),
  ]) => apiCall(() async {
    final r = await _client.listWorkItems(
      limit: page.limit,
      cursor: page.cursor,
    );
    return PageSlice(
      items: r.items.map(_taskSummary).toList(),
      nextCursor: r.nextCursor,
    );
  });

  @override
  Future<TaskSummary> create(TaskDraft draft) {
    final body = CreateWorkItemRequest(
      title: draft.title,
      startOn: day(draft.start),
      endOn: day(draft.due),
      description: draft.description,
      priority: _createPriority(draft.priority),
      assigneeAccountId: draft.assignee,
    );
    return apiCall(
      () async => _taskSummary(await _client.createWorkItem(body: body)),
    );
  }

  @override
  Future<TaskSummary> update(String id, TaskPatch patch) {
    final body = UpdateWorkItemRequest(
      title: patch.title,
      description: patch.description,
      priority: _updatePriority(patch.priority),
      startOn: patch.start == null ? null : day(patch.start!),
      endOn: patch.due == null ? null : day(patch.due!),
      plannedEndOn: patch.plannedEnd == null ? null : day(patch.plannedEnd!),
    );
    return apiCall(
      () async =>
          _taskSummary(await _client.updateWorkItem(id: id, body: body)),
    );
  }

  @override
  Future<void> delete(String id) =>
      apiCall(() => _client.deleteWorkItem(id: id));

  @override
  Future<TaskTransition> transition(
    String id,
    TaskStatus to, {
    String? reason,
    bool? pullEndDate,
  }) {
    final body = _transitionBody(to, reason, pullEndDate);
    return apiCall(
      () async =>
          _transition(await _client.transitionWorkItem(id: id, body: body)),
    );
  }

  @override
  Future<TaskTransition> setOwnStatus(
    String id,
    TaskStatus to, {
    String? reason,
    bool? pullEndDate,
  }) {
    final body = _transitionBody(to, reason, pullEndDate);
    return apiCall(
      () async =>
          _transition(await _client.ownStatusWorkItem(id: id, body: body)),
    );
  }

  @override
  Future<void> claim(String id) => apiCall(() => _client.claimWorkItem(id: id));

  @override
  Future<void> unclaim(String id) =>
      apiCall(() => _client.unclaimWorkItem(id: id));

  @override
  Future<int> addAssignees(String id, List<String> accountIds) => apiCall(
    () async => (await _client.addAssignments(
      id: id,
      body: AssignmentsRequest(accountIds: List.of(accountIds)),
    )).added,
  );

  @override
  Future<int> removeAssignee(String id, String accountId) => apiCall(
    () async =>
        (await _client.removeAssignment(id: id, accountId: accountId)).removed,
  );

  @override
  Future<List<AssignedTask>> myTasks() => apiCall(() async {
    final r = await _client.myTasks();
    return List.unmodifiable(
      r.items.map(
        (t) => AssignedTask(
          id: t.workItemId,
          title: t.title,
          status: taskStatusFromWire(t.status),
        ),
      ),
    );
  });

  @override
  Future<TaskExtension> extend(String id, int days) => apiCall(() async {
    final r = await _client.extendWorkItem(
      id: id,
      body: ExtendRequest(days: days),
    );
    return TaskExtension(due: r.newEndOn, cascadeCount: r.cascadeCount);
  });

  @override
  Future<TaskDates> pullCompletion(String id, DateTime completedOn) => apiCall(
    () async => _taskDates(
      await _client.pullCompletion(
        id: id,
        body: CompletionRequest(completedOn: day(completedOn)),
      ),
    ),
  );

  @override
  Future<TaskDates> pullEndDate(String id) =>
      apiCall(() async => _taskDates(await _client.pullEndDate(id: id)));

  @override
  Future<TaskDates> setCompletionDate(String id, DateTime completedOn) =>
      apiCall(
        () async => _taskDates(
          await _client.setCompletionDate(
            id: id,
            body: CompletionRequest(completedOn: day(completedOn)),
          ),
        ),
      );

  static TransitionRequest _transitionBody(
    TaskStatus to,
    String? reason,
    bool? pullEndDate,
  ) => TransitionRequest(
    to: _transitionTo(to),
    reason: reason,
    pullEndDate: pullEndDate,
  );

  static TaskTransition _transition(TransitionResult r) => TaskTransition(
    workItemId: r.workItemId,
    from: taskStatusFromWire(r.from),
    to: taskStatusFromWire(r.to),
    actor: switch (r.actor.json) {
      'uye' => TransitionActor.member,
      'koordinator' => TransitionActor.coordinator,
      'koordinator_kendi_gorevi' => TransitionActor.coordinatorOwnTask,
      _ => TransitionActor.unknown,
    },
    due: r.endOn,
  );
}

TransitionRequestTo _transitionTo(TaskStatus s) =>
    TransitionRequestTo.fromJson(taskStatusToWire(s));

CreateWorkItemRequestPriority? _createPriority(TaskPriority? p) => p == null
    ? null
    : CreateWorkItemRequestPriority.fromJson(taskPriorityToWire(p));

UpdateWorkItemRequestPriority? _updatePriority(TaskPriority? p) => p == null
    ? null
    : UpdateWorkItemRequestPriority.fromJson(taskPriorityToWire(p));

TaskSummary _taskSummary(WorkItem r) => TaskSummary(
  id: r.workItemId,
  programId: r.programId,
  departmentId: r.departmentId,
  title: r.title,
  priority: taskPriorityFromWire(r.priority.json),
  status: taskStatusFromWire(r.status.json),
  assignees: List.unmodifiable(r.assigneeAccountIds),
  lateness: TaskLateness(
    isOverdue: r.isOverdue,
    daysOverdue: r.daysOverdue,
    isCompletedLate: r.isCompletedLate,
    daysLate: r.daysLate,
    isCompletedEarly: r.isCompletedEarly,
    daysEarly: r.daysEarly,
  ),
  plannedEnd: r.plannedEndOn,
  completedAt: r.completedOn,
);

TaskDates _taskDates(WorkItemDates r) => TaskDates(
  start: r.startOn,
  due: r.endOn,
  plannedEnd: r.plannedEndOn,
  completedAt: r.completedOn,
  originalCompletedAt: r.originalCompletedOn,
  submittedAt: r.submittedOn,
);
