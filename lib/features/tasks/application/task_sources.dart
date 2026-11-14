import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';

/// Görev kataloğunun kaynağı: seçili programın sunucu kataloğu. Program seçili değilse
/// `client.scope_missing`, doğrulanmış bağ yoksa `client.server_not_verified`; katalog kapsam
/// değişince yeniden okunur.
final class TaskCatalogSource implements TaskCatalogRepository {
  TaskCatalogSource({required this.scope, required this.server});

  final ScopeController scope;

  /// Doğrulanmış bağın sunucu kaynağı; bağ yoksa null.
  final TaskCatalogRepository? Function() server;

  @override
  Future<TaskCatalog> load() async {
    if (!scope.current.hasProgram) throw ApiError(ClientErrorCode.scopeMissing);
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.load();
  }
}

/// Departman süzgeçli okumanın kaynağı: seçili programın sunucusu (program yoksa
/// `client.scope_missing`).
final class TaskListSource implements TaskListRepository {
  TaskListSource({required this.scope, required this.server});

  final ScopeController scope;
  final TaskListRepository? Function() server;

  @override
  Future<TaskListPage> loadTasks(
    String departmentId, {
    bool Function()? isCurrent,
    List<TaskDepartment> departments = const [],
  }) async {
    if (!scope.current.hasProgram) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.loadTasks(
      departmentId,
      isCurrent: isCurrent,
      departments: departments,
    );
  }
}

/// Görev ayrıntısının kaynağı: seçili programın sunucusu (program yoksa `client.scope_missing`).
final class TaskDetailsSource implements TaskDetailsRepository {
  TaskDetailsSource({required this.scope, required this.server});

  final ScopeController scope;
  final TaskDetailsRepository? Function() server;

  @override
  Future<TaskDetails> load(TaskItem task, {TaskAccess? access}) async {
    if (!scope.current.hasProgram) throw ApiError(ClientErrorCode.scopeMissing);
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.load(task, access: access);
  }

  @override
  Future<TaskItem> loadItem(TaskItem task) async {
    if (!scope.current.hasProgram) throw ApiError(ClientErrorCode.scopeMissing);
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.loadItem(task);
  }
}

/// Görev yazmalarının kaynağı: doğrulanmış bağın sunucusu; bağ yoksa
/// `client.server_not_verified`.
final class TaskWriteSource implements TaskWriteRepository {
  TaskWriteSource({required this.server});

  final TaskWriteRepository? Function() server;

  TaskWriteRepository get _s {
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s;
  }

  @override
  Future<void> changeStatus(
    TaskItem task,
    StatusEndpoint via,
    TaskStatus to, {
    String? reason,
    bool closeSubtasks = false,
  }) async => _s.changeStatus(
    task,
    via,
    to,
    reason: reason,
    closeSubtasks: closeSubtasks,
  );

  @override
  Future<void> addNote(
    TaskItem task,
    String text, {
    required String requestKey,
  }) async => _s.addNote(task, text, requestKey: requestKey);

  @override
  Future<void> updateNote(
    TaskItem task,
    String noteId,
    String text, {
    required int expectedRevision,
  }) async =>
      _s.updateNote(task, noteId, text, expectedRevision: expectedRevision);

  @override
  Future<void> deleteNote(TaskItem task, String noteId) async =>
      _s.deleteNote(task, noteId);

  @override
  Future<void> createSubtask(
    TaskItem task,
    String title, {
    required String requestKey,
    bool evidenceRequired = false,
  }) async => _s.createSubtask(
    task,
    title,
    requestKey: requestKey,
    evidenceRequired: evidenceRequired,
  );

  @override
  Future<void> updateSubtask(
    TaskItem task,
    String subtaskId,
    SubtaskPatch patch,
  ) async => _s.updateSubtask(task, subtaskId, patch);

  @override
  Future<void> deleteSubtask(TaskItem task, String subtaskId) async =>
      _s.deleteSubtask(task, subtaskId);

  @override
  Future<String> createWorkItem(
    WorkItemDraft draft, {
    required String requestKey,
  }) async => _s.createWorkItem(draft, requestKey: requestKey);

  @override
  Future<void> updateWorkItem(TaskItem task, WorkItemPatch patch) async =>
      _s.updateWorkItem(task, patch);

  @override
  Future<void> deleteWorkItem(TaskItem task) async => _s.deleteWorkItem(task);

  @override
  Future<void> addAssignments(TaskItem task, List<String> accountIds) async =>
      _s.addAssignments(task, accountIds);

  @override
  Future<void> removeAssignment(TaskItem task, String accountId) async =>
      _s.removeAssignment(task, accountId);

  @override
  Future<void> claim(TaskItem task) async => _s.claim(task);

  @override
  Future<void> unclaim(TaskItem task) async => _s.unclaim(task);

  @override
  Future<List<TeamMember>> listTeam(String departmentId) async =>
      _s.listTeam(departmentId);

  @override
  Future<void> enrollMember(MemberEnrollment enrollment) async =>
      _s.enrollMember(enrollment);

  @override
  Future<void> requestDateChange(
    TaskItem task,
    DateTime start,
    DateTime end, {
    required String requestKey,
    String? reason,
  }) async => _s.requestDateChange(
    task,
    start,
    end,
    requestKey: requestKey,
    reason: reason,
  );

  @override
  Future<void> reviewDateChange(
    String requestId, {
    required bool approve,
    String? reason,
  }) async => _s.reviewDateChange(requestId, approve: approve, reason: reason);

  @override
  Future<void> deleteDateChange(String requestId) async =>
      _s.deleteDateChange(requestId);

  @override
  Future<void> attachFile(
    TaskItem task,
    UploadSource file,
    EvidenceTag tag, {
    String? subtaskId,
    required String requestKey,
  }) async => _s.attachFile(
    task,
    file,
    tag,
    subtaskId: subtaskId,
    requestKey: requestKey,
  );

  @override
  Future<void> renameFile(TaskItem task, String fileId, String name) async =>
      _s.renameFile(task, fileId, name);

  @override
  Future<void> deleteFile(TaskItem task, String fileId) async =>
      _s.deleteFile(task, fileId);

  @override
  Future<Stream<List<int>>> downloadFile(TaskItem task, String fileId) async =>
      _s.downloadFile(task, fileId);
}
