import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/date_change_request.dart' as api;
import '../../../core/api/generated/models/file_record_list.dart';
import '../../../core/api/generated/models/work_item_detail.dart';
import '../../../core/api/generated/models/work_item_file_list_item.dart';
import '../../../core/api/generated/models/work_item_note_list.dart';
import '../../../core/api/generated/models/work_item_subtask.dart';
import '../../../core/api/generated/models/work_item_subtask_list.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import 'work_item_mapping.dart';

/// Görev ayrıntısının sunucu kaynağı (istemci akışları §3): `getWorkItem` (açıklama ve
/// tarihlerle görevin kendisi) + alt görevler + notlar + dosyalar. Hepsi S3'tür: görevin KENDİ
/// departmanıyla okunur (seçili kapsamın departmanı değil; [withDepartment]). Kişi adları
/// (`assignees[].full_name`, not `author_full_name`, alt görev `assignee_full_name` /
/// `done_by_full_name` / `created_by_full_name`, dosya `uploaded_by_full_name`) null değilse
/// [TaskDetails.names]'e girer; null ad hata değildir (arayüz nötr etiket gösterir). Tarih talebi role
/// göre ([TaskAccess.dateRequestFeed]): şirket yöneticisi inceleme kuyruğu
/// (`GET /v1/date-change-requests?status=pending`, S1), kapsamda koordinatör kendi talepleri
/// (`GET /v1/date-change-requests/mine`, S3, görevin departmanı), üye/rolsüz çağrı yok (yetkisiz
/// uç çağrılıp ayrıntı düşürülmez). Erişim bilinmiyorsa ([access] null) çağrı yok. Okunan
/// uçlardan biri hata verirse ayrıntı kurulmaz.
class ApiTaskDetailsRepository implements TaskDetailsRepository {
  ApiTaskDetailsRepository(Dio dio)
    : _work = WorkClient(dio),
      _records = RecordsClient(dio);

  final WorkClient _work;
  final RecordsClient _records;

  @override
  Future<TaskDetails?> load(TaskItem task, {TaskAccess? access}) async {
    // Departmanı olmayan görev kapıda reddedilir (seçili departmana düşülmez).
    final department = task.departmentId ?? '';
    final id = task.id;
    // eagerError: ilk hata fırlar, diğerleri yutulur (işlenmemiş hata kalmaz).
    final r = await Future.wait<Object>([
      apiCall(
        () => _work.getWorkItem(
          id: id,
          extras: withDepartment(
            WorkClient.getWorkItemOpenapiExtras,
            department,
          ),
        ),
      ),
      apiCall(
        () => _work.listWorkItemSubtasks(
          id: id,
          extras: withDepartment(
            WorkClient.listWorkItemSubtasksOpenapiExtras,
            department,
          ),
        ),
      ),
      apiCall(
        () => _work.listWorkItemNotes(
          id: id,
          extras: withDepartment(
            WorkClient.listWorkItemNotesOpenapiExtras,
            department,
          ),
        ),
      ),
      apiCall(
        () => _records.listWorkItemFiles(
          id: id,
          extras: withDepartment(
            RecordsClient.listWorkItemFilesOpenapiExtras,
            department,
          ),
        ),
      ),
      _dateRequests(
        access?.dateRequestFeed(task.programId, task.departmentId) ??
            DateRequestFeed.none,
        department,
      ),
    ], eagerError: true);
    final item = r[0] as WorkItemDetail;
    final subtasks = (r[1] as WorkItemSubtaskList).subtasks;
    final notes = (r[2] as WorkItemNoteList).notes;
    final files = (r[3] as FileRecordList).files;
    final requests = [
      for (final d in r[4] as List<api.DateChangeRequest>)
        if (d.workItemId == id) d,
    ];
    // Bekleyen önce; yoksa son sonuçlanmış (koordinatörün kendi talepleri tüm durumları taşır).
    final request =
        requests
            .where(
              (d) =>
                  dateRequestState(d.status.json) == DateRequestState.pending,
            )
            .firstOrNull ??
        requests.lastOrNull;
    return TaskDetails(
      item: _item(item, task.shortCode),
      names: [
        for (final a in item.assignees) ?_name(a.accountId, a.fullName),
        for (final n in notes) ?_name(n.authorAccountId, n.authorFullName),
        for (final s in subtasks) ...[
          ?_name(s.createdByAccountId, s.createdByFullName),
          ?_name(s.assigneeAccountId, s.assigneeFullName),
          ?_name(s.doneByAccountId, s.doneByFullName),
        ],
        for (final f in files)
          ?_name(f.uploadedByAccountId, f.uploadedByFullName),
      ],
      subtasks: [for (final s in subtasks) _subtask(s, files)],
      notes: [
        for (final n in notes)
          TaskNote(
            id: n.noteId,
            workItemId: n.workItemId,
            by: n.authorAccountId,
            at: n.createdAt,
            text: n.content,
            updatedAt: n.updatedAt,
          ),
      ],
      files: [
        for (final f in files)
          TaskFile(
            id: f.fileId,
            kind: _kind(f.contentType),
            name: f.displayName,
            tag: _tag(f.tag),
            by: f.uploadedByAccountId,
            sizeKb: (f.sizeBytes / 1024).ceil(),
            subtask: f.subtaskId,
          ),
      ],
      dateRequest: request == null
          ? null
          : DateChangeRequest(
              id: request.requestId,
              workItemId: request.workItemId,
              oldStart: request.oldStartOn,
              oldDue: request.oldEndOn,
              start: request.newStartOn,
              due: request.newEndOn,
              reason: request.reason ?? '',
              state: dateRequestState(request.status.json),
            ),
    );
  }

  @override
  Future<TaskItem?> loadItem(TaskItem task) async {
    final item = await apiCall(
      () => _work.getWorkItem(
        id: task.id,
        extras: withDepartment(
          WorkClient.getWorkItemOpenapiExtras,
          task.departmentId ?? '',
        ),
      ),
    );
    return _item(item, task.shortCode);
  }

  /// Role göre tarih talebi yüzü; [DateRequestFeed.none] → istek yok, boş liste.
  Future<List<api.DateChangeRequest>> _dateRequests(
    DateRequestFeed feed,
    String department,
  ) async => switch (feed) {
    DateRequestFeed.reviewQueue => (await apiCall(
      () => _work.listDateChangeRequests(status: 'pending'),
    )).requests,
    DateRequestFeed.mine => (await apiCall(
      () => _work.myDateChangeRequests(
        extras: withDepartment(
          WorkClient.myDateChangeRequestsOpenapiExtras,
          department,
        ),
      ),
    )).requests,
    DateRequestFeed.none => const [],
  };

  /// Alt görevin bağlı dosyası: ona bağlı ilk dosyanın adı (bilgi; kanıt bayrağı yok).
  static Subtask _subtask(
    WorkItemSubtask s,
    List<WorkItemFileListItem> files,
  ) => Subtask(
    id: s.subtaskId,
    title: s.title,
    done: s.done,
    assignee: s.assigneeAccountId,
    doneBy: s.doneByAccountId,
    createdBy: s.createdByAccountId,
    start: s.startOn,
    end: s.endOn,
    evidence: files
        .where((f) => f.subtaskId == s.subtaskId)
        .firstOrNull
        ?.displayName,
  );

  /// Kimlik ve ad birlikte varsa ad kaydı; null ad (çözülemedi) kayıt üretmez.
  static PersonName? _name(String? id, String? name) =>
      id == null || name == null ? null : PersonName(id, name);

  /// Tekil okuma → [TaskItem] (açıklama, `start_on`/`end_on`, sunucu gecikmesi). Kısa anahtar
  /// katalogdaki görevden (departman kodu ya da adı) korunur.
  static TaskItem _item(WorkItemDetail w, String? shortCode) {
    final lateness = TaskLateness(
      isOverdue: w.isOverdue,
      daysOverdue: w.daysOverdue,
      isCompletedLate: w.isCompletedLate,
      daysLate: w.daysLate,
      isCompletedEarly: w.isCompletedEarly,
      daysEarly: w.daysEarly,
    );
    return TaskItem(
      code: w.workItemId,
      id: w.workItemId,
      shortCode: shortCode,
      title: w.title,
      coordinatorship: w.departmentId,
      departmentId: w.departmentId,
      programId: w.programId,
      status: taskStatusFromWire(w.status.json),
      priority: taskPriorityFromWire(w.priority.json),
      start: day(w.startOn),
      due: day(w.endOn),
      plannedEnd: w.plannedEndOn,
      completedAt: w.completedOn,
      assignees: List.unmodifiable(w.assigneeAccountIds),
      description: w.description,
      lateness: lateness,
      overdueDays: lateness.daysOverdue,
      evidenceRequired: w.completionEvidenceRequired,
      subtaskCounts: (total: w.subtaskCounts.total, done: w.subtaskCounts.done),
    );
  }

  static TaskFileKind _kind(String contentType) =>
      contentType.startsWith('image/')
      ? TaskFileKind.image
      : contentType == 'application/pdf'
      ? TaskFileKind.pdf
      : TaskFileKind.doc;

  static EvidenceTag _tag(String wire) => switch (wire) {
    'ister' => EvidenceTag.requirement,
    'plan' => EvidenceTag.plan,
    'girdi' => EvidenceTag.input,
    'analiz' => EvidenceTag.analysis,
    'cikti' => EvidenceTag.output,
    'sonuc' => EvidenceTag.outcome,
    _ => EvidenceTag.unknown,
  };
}
