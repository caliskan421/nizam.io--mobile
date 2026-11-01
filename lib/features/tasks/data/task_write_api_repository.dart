import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/create_subtask_request.dart';
import '../../../core/api/generated/models/transition_request.dart';
import '../../../core/api/generated/models/transition_request_to.dart';
import '../../../core/api/generated/models/update_subtask_request.dart';
import '../../../core/api/generated/models/work_note_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';
import 'work_item_mapping.dart';

/// [TaskWriteRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. Her istek görevin
/// KENDİ departmanıyla gider ([withDepartment]; seçili kapsamın departmanı değil). Departmanı
/// olmayan görev kapıda reddedilir (boş kimlik seçili departmana düşmez). Yanıt gövdeleri
/// okunmaz: çağıran başarıdan sonra kaynağı yeniden okur (istemci akışları §8).
class ApiTaskWriteRepository implements TaskWriteRepository {
  ApiTaskWriteRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  @override
  Future<void> changeStatus(
    TaskItem task,
    StatusEndpoint via,
    TaskStatus to, {
    String? reason,
    bool closeSubtasks = false,
  }) {
    final body = TransitionRequest(
      to: TransitionRequestTo.fromJson(taskStatusToWire(to)),
      reason: reason,
      closeSubtasks: closeSubtasks ? true : null,
    );
    return apiCall(
      () => switch (via) {
        StatusEndpoint.transition => _client.transitionWorkItem(
          id: task.id,
          body: body,
          extras: withDepartment(
            WorkClient.transitionWorkItemOpenapiExtras,
            _dept(task),
          ),
        ),
        StatusEndpoint.ownStatus => _client.ownStatusWorkItem(
          id: task.id,
          body: body,
          extras: withDepartment(
            WorkClient.ownStatusWorkItemOpenapiExtras,
            _dept(task),
          ),
        ),
      },
    );
  }

  @override
  Future<void> addNote(TaskItem task, String text) => apiCall(
    () => _client.addWorkItemNote(
      id: task.id,
      body: WorkNoteRequest(content: text),
      extras: withDepartment(
        WorkClient.addWorkItemNoteOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> updateNote(TaskItem task, String noteId, String text) => apiCall(
    () => _client.updateWorkItemNote(
      id: task.id,
      noteId: noteId,
      body: WorkNoteRequest(content: text),
      extras: withDepartment(
        WorkClient.updateWorkItemNoteOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> deleteNote(TaskItem task, String noteId) => apiCall(
    () => _client.deleteWorkItemNote(
      id: task.id,
      noteId: noteId,
      extras: withDepartment(
        WorkClient.deleteWorkItemNoteOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> createSubtask(TaskItem task, String title) => apiCall(
    () => _client.createWorkItemSubtask(
      id: task.id,
      body: CreateSubtaskRequest(title: title),
      extras: withDepartment(
        WorkClient.createWorkItemSubtaskOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> updateSubtask(
    TaskItem task,
    String subtaskId,
    SubtaskPatch patch,
  ) {
    final dates = patch.dates;
    final body = UpdateSubtaskRequest(
      title: patch.title,
      // Boş dize atamayı / tarihleri kaldırır (sunucu sözleşmesi).
      assigneeAccountId: patch.assignee == null
          ? null
          : patch.assignee!.id ?? '',
      startOn: dates == null ? null : _day(dates.start),
      endOn: dates == null ? null : _day(dates.end),
      done: patch.done,
    );
    return apiCall(
      () => _client.updateWorkItemSubtask(
        id: task.id,
        subtaskId: subtaskId,
        body: body,
        extras: withDepartment(
          WorkClient.updateWorkItemSubtaskOpenapiExtras,
          _dept(task),
        ),
      ),
    );
  }

  @override
  Future<void> deleteSubtask(TaskItem task, String subtaskId) => apiCall(
    () => _client.deleteWorkItemSubtask(
      id: task.id,
      subtaskId: subtaskId,
      extras: withDepartment(
        WorkClient.deleteWorkItemSubtaskOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  /// Görevin departmanı; yoksa '' (kapı `client.scope_missing` ile reddeder).
  static String _dept(TaskItem task) => task.departmentId ?? '';

  /// `YYYY-AA-GG`; null → '' (kaldır).
  static String _day(DateTime? d) {
    if (d == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';
  }
}
