import 'dart:typed_data';

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
import '../../../core/http/interceptors.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';
import 'work_item_mapping.dart';

/// [TaskWriteRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. Her istek görevin
/// KENDİ departmanıyla gider ([withDepartment]; seçili kapsamın departmanı değil). Departmanı
/// olmayan görev kapıda reddedilir (boş kimlik seçili departmana düşmez). Yanıt gövdeleri
/// okunmaz (yalnız yeni görevin kimliği): çağıran başarıdan sonra kaynağı yeniden okur
/// (istemci akışları §8).
///
/// Dosya yükleme üretilmiş `attachFile` ile DEĞİL elle kurulan multipart ile gider: üretilmiş
/// istemci parçayı `application/octet-stream` bildirir, sunucu ise türü parçanın
/// `Content-Type`'ından okur ve küme dışı türü reddeder (RECORDS-K03). Yol, yöntem ve
/// operationId aynıdır (sözleşme kapısı ve kapsam başlıkları aynen uygulanır).
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
        extras: withDepartment(
          WorkClient.createWorkItemOpenapiExtras,
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
        extras: withDepartment(
          WorkClient.updateWorkItemOpenapiExtras,
          _dept(task),
        ),
      ),
    );
  }

  @override
  Future<void> deleteWorkItem(TaskItem task) => apiCall(
    () => _client.deleteWorkItem(
      id: task.id,
      extras: withDepartment(
        WorkClient.deleteWorkItemOpenapiExtras,
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
          extras: withDepartment(
            WorkClient.addAssignmentsOpenapiExtras,
            _dept(task),
          ),
        ),
      );

  @override
  Future<void> removeAssignment(TaskItem task, String accountId) => apiCall(
    () => _client.removeAssignment(
      id: task.id,
      accountId: accountId,
      extras: withDepartment(
        WorkClient.removeAssignmentOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> claim(TaskItem task) => apiCall(
    () => _client.claimWorkItem(
      id: task.id,
      extras: withDepartment(
        WorkClient.claimWorkItemOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> unclaim(TaskItem task) => apiCall(
    () => _client.unclaimWorkItem(
      id: task.id,
      extras: withDepartment(
        WorkClient.unclaimWorkItemOpenapiExtras,
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
      extras: withDepartment(
        WorkClient.requestDateChangeOpenapiExtras,
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
    final form = FormData()
      ..files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
            contentType: DioMediaType.parse(type),
          ),
        ),
      );
    // Sorgu dizesi elle (D2: features içinde dize anahtarlı Map yok); değerler kodlanır.
    final query = StringBuffer('tag=${Uri.encodeQueryComponent(wire)}');
    if (subtaskId != null) {
      query.write('&subtask_id=${Uri.encodeQueryComponent(subtaskId)}');
    }
    await apiCall(
      () => _dio.post<Object?>(
        '/v1/work-items/${Uri.encodeComponent(task.id)}/files?$query',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          extra: withDepartment(
            RecordsClient.attachFileOpenapiExtras,
            _dept(task),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> renameFile(TaskItem task, String fileId, String name) => apiCall(
    () => _records.renameFile(
      id: fileId,
      body: RenameFileRequest(displayName: name),
      extras: withDepartment(
        RecordsClient.renameFileOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<void> deleteFile(TaskItem task, String fileId) => apiCall(
    () => _records.deleteFile(
      id: fileId,
      extras: withDepartment(
        RecordsClient.deleteFileOpenapiExtras,
        _dept(task),
      ),
    ),
  );

  @override
  Future<Uint8List> downloadFile(TaskItem task, String fileId) async {
    final r = await apiCall(
      () => _records.downloadFile(
        id: fileId,
        extras: withDepartment(
          RecordsClient.downloadFileOpenapiExtras,
          _dept(task),
        ),
      ),
    );
    return Uint8List.fromList(r.data);
  }

  /// Görevin departmanı; yoksa '' (kapı `client.scope_missing` ile reddeder).
  static String _dept(TaskItem task) => task.departmentId ?? '';

  /// `YYYY-AA-GG`; null → '' (kaldır).
  static String _day(DateTime? d) {
    if (d == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';
  }
}
