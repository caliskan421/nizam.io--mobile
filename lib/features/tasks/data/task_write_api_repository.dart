import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/assignments_request.dart';
import '../../../core/api/generated/models/create_subtask_request.dart';
import '../../../core/api/generated/models/create_work_item_request.dart';
import '../../../core/api/generated/models/create_work_item_request_priority.dart';
import '../../../core/api/generated/models/date_change_request_create.dart';
import '../../../core/api/generated/models/rename_file_request.dart';
import '../../../core/api/generated/models/review_request.dart';
import '../../../core/api/generated/models/review_request_decision.dart';
import '../../../core/api/generated/models/roster_member.dart';
import '../../../core/api/generated/models/roster_member_status.dart';
import '../../../core/api/generated/models/transition_request.dart';
import '../../../core/api/generated/models/transition_request_to.dart';
import '../../../core/api/generated/models/update_subtask_request.dart';
import '../../../core/api/generated/models/update_work_item_request.dart';
import '../../../core/api/generated/models/update_work_item_request_priority.dart';
import '../../../core/api/generated/models/work_note_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/file_download.dart';
import '../../../core/http/file_upload.dart';
import '../../../core/http/interceptors.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';
import 'work_item_mapping.dart';

/// [TaskWriteRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. Her istek görevin
/// KENDİ programı ve departmanıyla gider ([withScope]; seçili kapsam değil). Programı ya da
/// departmanı olmayan görev kapıda reddedilir (boş kimlik seçili kapsama düşmez). Yanıt gövdeleri
/// okunmaz (yalnız yeni görevin kimliği): çağıran başarıdan sonra kaynağı yeniden okur
/// (istemci akışları §8).
///
/// Dosya yükleme üretilmiş `attachFile` ile DEĞİL ortak elle multipart yardımcısıyla gider
/// ([postWorkItemFile]; arşiv yüklemesiyle aynı yol — parça türü bildirilir).
class ApiTaskWriteRepository implements TaskWriteRepository {
  ApiTaskWriteRepository(Dio dio)
    : _dio = dio,
      _client = WorkClient(dio),
      _records = RecordsClient(dio),
      _organization = OrganizationClient(dio);

  final Dio _dio;
  final WorkClient _client;
  final RecordsClient _records;
  final OrganizationClient _organization;

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
          extras: withScope(
            WorkClient.transitionWorkItemOpenapiExtras,
            _program(task),
            _dept(task),
          ),
        ),
        StatusEndpoint.ownStatus => _client.ownStatusWorkItem(
          id: task.id,
          body: body,
          extras: withScope(
            WorkClient.ownStatusWorkItemOpenapiExtras,
            _program(task),
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
      extras: withScope(
        WorkClient.addWorkItemNoteOpenapiExtras,
        _program(task),
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
      extras: withScope(
        WorkClient.updateWorkItemNoteOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> deleteNote(TaskItem task, String noteId) => apiCall(
    () => _client.deleteWorkItemNote(
      id: task.id,
      noteId: noteId,
      extras: withScope(
        WorkClient.deleteWorkItemNoteOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> createSubtask(TaskItem task, String title) => apiCall(
    () => _client.createWorkItemSubtask(
      id: task.id,
      body: CreateSubtaskRequest(title: title),
      extras: withScope(
        WorkClient.createWorkItemSubtaskOpenapiExtras,
        _program(task),
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
        extras: withScope(
          WorkClient.updateWorkItemSubtaskOpenapiExtras,
          _program(task),
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
      extras: withScope(
        WorkClient.deleteWorkItemSubtaskOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  // ---- görev -------------------------------------------------------------------------------

  @override
  Future<String> createWorkItem(WorkItemDraft draft) async {
    final p = draft.priority;
    final r = await apiCall(
      () => _client.createWorkItem(
        body: CreateWorkItemRequest(
          title: draft.title,
          startOn: day(draft.start),
          endOn: day(draft.end),
          description: draft.description,
          priority: p == null
              ? null
              : CreateWorkItemRequestPriority.fromJson(taskPriorityToWire(p)),
          assigneeAccountId: draft.assignee,
          completionEvidenceRequired: draft.evidenceRequired,
        ),
        extras: withScope(
          WorkClient.createWorkItemOpenapiExtras,
          draft.programId,
          draft.departmentId,
        ),
      ),
    );
    return r.workItemId;
  }

  @override
  Future<void> updateWorkItem(TaskItem task, WorkItemPatch patch) {
    final p = patch.priority;
    final start = patch.start;
    final end = patch.end;
    return apiCall(
      () => _client.updateWorkItem(
        id: task.id,
        body: UpdateWorkItemRequest(
          title: patch.title,
          priority: p == null
              ? null
              : UpdateWorkItemRequestPriority.fromJson(taskPriorityToWire(p)),
          startOn: start == null ? null : day(start),
          endOn: end == null ? null : day(end),
          completionEvidenceRequired: patch.evidenceRequired,
        ),
        extras: withScope(
          WorkClient.updateWorkItemOpenapiExtras,
          _program(task),
          _dept(task),
        ),
      ),
    );
  }

  @override
  Future<void> deleteWorkItem(TaskItem task) => apiCall(
    () => _client.deleteWorkItem(
      id: task.id,
      extras: withScope(
        WorkClient.deleteWorkItemOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  // ---- atama -------------------------------------------------------------------------------

  @override
  Future<void> addAssignments(TaskItem task, List<String> accountIds) =>
      apiCall(
        () => _client.addAssignments(
          id: task.id,
          body: AssignmentsRequest(accountIds: accountIds),
          extras: withScope(
            WorkClient.addAssignmentsOpenapiExtras,
            _program(task),
            _dept(task),
          ),
        ),
      );

  @override
  Future<void> removeAssignment(TaskItem task, String accountId) => apiCall(
    () => _client.removeAssignment(
      id: task.id,
      accountId: accountId,
      extras: withScope(
        WorkClient.removeAssignmentOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> claim(TaskItem task) => apiCall(
    () => _client.claimWorkItem(
      id: task.id,
      extras: withScope(
        WorkClient.claimWorkItemOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> unclaim(TaskItem task) => apiCall(
    () => _client.unclaimWorkItem(
      id: task.id,
      extras: withScope(
        WorkClient.unclaimWorkItemOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  /// Ekip `listMembers` (S2; departman yolda). `listAssignable` KULLANILMAZ: o uç ekibe
  /// eklenebilecek havuzdur (ekip DIŞI hesaplar), görev ataması ise yalnız ekibe yapılabilir.
  /// Silinmiş üyelik atanamaz (listede yok).
  @override
  Future<List<TeamMember>> listTeam(String departmentId) async {
    final r = await apiCall(() => _organization.listMembers(id: departmentId));
    return [
      for (final m in r.data.members ?? const <RosterMember>[])
        if (m.status == RosterMemberStatus.active)
          TeamMember(
            accountId: m.accountId,
            name: m.fullName,
            coordinator: m.role == 'koordinator',
          ),
    ];
  }

  // ---- tarih talebi ------------------------------------------------------------------------

  @override
  Future<void> requestDateChange(
    TaskItem task,
    DateTime start,
    DateTime end, {
    String? reason,
  }) => apiCall(
    () => _client.requestDateChange(
      body: DateChangeRequestCreate(
        workItemId: task.id,
        newStartOn: day(start),
        newEndOn: day(end),
        reason: reason,
      ),
      extras: withScope(
        WorkClient.requestDateChangeOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> reviewDateChange(String requestId, {required bool approve}) =>
      apiCall(
        () => _client.reviewDateChangeRequest(
          id: requestId,
          body: ReviewRequest(
            decision: approve
                ? ReviewRequestDecision.approved
                : ReviewRequestDecision.rejected,
          ),
        ),
      );

  @override
  Future<void> deleteDateChange(String requestId) =>
      apiCall(() => _client.deleteDateChangeRequest(id: requestId));

  // ---- dosya -------------------------------------------------------------------------------

  @override
  Future<void> attachFile(
    TaskItem task,
    UploadSource file,
    EvidenceTag tag, {
    String? subtaskId,
  }) async {
    final type = file.contentType;
    final wire = evidenceTagToWire(tag);
    if (type == null || wire == null) {
      throw ArgumentError.value(file.name, 'file', 'izinli tür/etiket değil');
    }
    await apiCall(
      () => postWorkItemFile(
        _dio,
        workItemId: task.id,
        tag: wire,
        filePath: file.path,
        filename: file.name,
        contentType: type,
        subtaskId: subtaskId,
        extras: withScope(
          RecordsClient.attachFileOpenapiExtras,
          _program(task),
          _dept(task),
        ),
      ),
    );
  }

  @override
  Future<void> renameFile(TaskItem task, String fileId, String name) => apiCall(
    () => _records.renameFile(
      id: fileId,
      body: RenameFileRequest(displayName: name),
      extras: withScope(
        RecordsClient.renameFileOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> deleteFile(TaskItem task, String fileId) => apiCall(
    () => _records.deleteFile(
      id: fileId,
      extras: withScope(
        RecordsClient.deleteFileOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );

  /// Akışlı indirme ([getFileStream]; `ResponseType.stream`, aynı sözleşme kapısı).
  @override
  Future<Stream<List<int>>> downloadFile(TaskItem task, String fileId) =>
      getFileStream(
        _dio,
        fileId: fileId,
        extras: withScope(
          RecordsClient.downloadFileOpenapiExtras,
          _program(task),
          _dept(task),
        ),
      );

  /// Görevin KENDİ kapsamı (program, departman); eksik değer '' → kapı
  /// `client.scope_missing` ile reddeder (seçili kapsama düşülmez).
  static String _program(TaskItem task) => task.programId ?? '';
  static String _dept(TaskItem task) => task.departmentId ?? '';

  /// `YYYY-AA-GG`; null → '' (kaldır).
  static String _day(DateTime? d) {
    if (d == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';
  }
}
