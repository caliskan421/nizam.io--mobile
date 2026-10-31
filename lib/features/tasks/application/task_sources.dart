import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';

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
