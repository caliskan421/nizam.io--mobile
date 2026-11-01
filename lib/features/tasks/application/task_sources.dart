import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';

/// Görev kataloğunun kaynak seçimi: sunucu programı seçiliyse sunucu, örnek kapsamda
/// ("örnek verilerle devam") geliştirme örneği. Seçim her okumada güncel kapsamdan yapılır;
/// katalog kapsam değişince yeniden okunur.
final class TaskCatalogSource implements TaskCatalogRepository {
  TaskCatalogSource({
    required this.scope,
    required this.server,
    required this.sample,
  });

  final ScopeController scope;

  /// Doğrulanmış bağın sunucu kaynağı; bağ yoksa null.
  final TaskCatalogRepository? Function() server;
  final TaskCatalogRepository sample;

  @override
  Future<TaskCatalog> load() async {
    if (!scope.current.hasServerProgram) return sample.load();
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.load();
  }
}

/// Görev ayrıntısının kaynak seçimi: örnek kapsamda ayrıntı yüklenmez (örnek görev zaten
/// taşır, null döner); sunucu programında sunucudan okunur.
final class TaskDetailsSource implements TaskDetailsRepository {
  TaskDetailsSource({required this.scope, required this.server});

  final ScopeController scope;
  final TaskDetailsRepository? Function() server;

  @override
  Future<TaskDetails?> load(TaskItem task, {TaskAccess? access}) async {
    if (!scope.current.hasServerProgram) return null;
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.load(task, access: access);
  }
}

/// Görev yazmalarının kaynağı: yalnız doğrulanmış bağın sunucusu. Örnek katalogda yazma
/// denetleyicide yereldir (bu kaynak çağrılmaz); bağ yoksa `client.server_not_verified`.
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
  Future<void> addNote(TaskItem task, String text) async =>
      _s.addNote(task, text);

  @override
  Future<void> updateNote(TaskItem task, String noteId, String text) async =>
      _s.updateNote(task, noteId, text);

  @override
  Future<void> deleteNote(TaskItem task, String noteId) async =>
      _s.deleteNote(task, noteId);

  @override
  Future<void> createSubtask(TaskItem task, String title) async =>
      _s.createSubtask(task, title);

  @override
  Future<void> updateSubtask(
    TaskItem task,
    String subtaskId,
    SubtaskPatch patch,
  ) async => _s.updateSubtask(task, subtaskId, patch);

  @override
  Future<void> deleteSubtask(TaskItem task, String subtaskId) async =>
      _s.deleteSubtask(task, subtaskId);
}
