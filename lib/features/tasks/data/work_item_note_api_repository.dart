import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/work_item_note.dart';
import '../../../core/api/generated/models/work_note_request.dart';
import '../../../core/errors/api_error.dart';
import '../domain/task_catalog.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';

/// [WorkItemNoteRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi (S3).
class ApiWorkItemNoteRepository implements WorkItemNoteRepository {
  ApiWorkItemNoteRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  @override
  Future<CountedList<TaskNote>> list(String workItemId) => apiCall(() async {
    final r = await _client.listWorkItemNotes(id: workItemId);
    return CountedList(items: r.notes.map(_taskNote).toList(), total: r.total);
  });

  @override
  Future<TaskNote> add(String workItemId, String text) => apiCall(
    () async => _taskNote(
      await _client.addWorkItemNote(
        id: workItemId,
        body: WorkNoteRequest(content: text),
      ),
    ),
  );

  @override
  Future<void> update(String workItemId, String noteId, String text) => apiCall(
    () => _client.updateWorkItemNote(
      id: workItemId,
      noteId: noteId,
      body: WorkNoteRequest(content: text),
    ),
  );

  @override
  Future<void> delete(String workItemId, String noteId) =>
      apiCall(() => _client.deleteWorkItemNote(id: workItemId, noteId: noteId));
}

TaskNote _taskNote(WorkItemNote r) => TaskNote(
  id: r.noteId,
  workItemId: r.workItemId,
  by: r.authorAccountId,
  at: r.createdAt,
  text: r.content,
  updatedAt: r.updatedAt,
);
