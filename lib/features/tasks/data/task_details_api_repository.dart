import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/date_change_request.dart' as api;
import '../../../core/api/generated/models/file_list_item.dart';
import '../../../core/api/generated/models/file_record_list.dart';
import '../../../core/api/generated/models/work_item_note_list.dart';
import '../../../core/api/generated/models/work_item_subtask.dart';
import '../../../core/api/generated/models/work_item_subtask_list.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import 'work_item_mapping.dart';

/// Görev ayrıntısının sunucu kaynağı. Alt görevler, notlar ve dosyalar S3'tür: görevin KENDİ
/// departmanıyla okunur (seçili kapsamın departmanı değil; [withDepartment]). Tarih talebi role
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
    final subtasks = (r[0] as WorkItemSubtaskList).subtasks;
    final notes = (r[1] as WorkItemNoteList).notes;
    final files = (r[2] as FileRecordList).files;
    final requests = [
      for (final d in r[3] as List<api.DateChangeRequest>)
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
  static Subtask _subtask(WorkItemSubtask s, List<FileListItem> files) =>
      Subtask(
        id: s.subtaskId,
        title: s.title,
        done: s.done,
        assignee: s.assigneeAccountId,
        start: s.startOn,
        end: s.endOn,
        evidence: files
            .where((f) => f.subtaskId == s.subtaskId)
            .firstOrNull
            ?.displayName,
      );

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
