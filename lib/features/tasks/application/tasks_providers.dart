import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import '../domain/task_writes.dart';
import 'task_catalog_controller.dart';

part 'tasks_providers.g.dart';

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).
@Riverpod(keepAlive: true)
TaskCatalogRepository taskCatalogRepository(Ref ref) =>
    throw UnimplementedError(
      'taskCatalogRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: görevler ekranının departman süzgeçli okuması (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TaskListRepository taskListRepository(Ref ref) => throw UnimplementedError(
  'taskListRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TaskDetailsRepository taskDetailsRepository(Ref ref) =>
    throw UnimplementedError(
      'taskDetailsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: görev yazmalarının kaynağı (`tasks_module.dart`'ta bağlanır; yalnız sunucu).
@Riverpod(keepAlive: true)
TaskWriteRepository taskWriteRepository(Ref ref) => throw UnimplementedError(
  'taskWriteRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: sistem dosya seçicisi (`tasks_module.dart`'ta `FileUploadPicker` bağlanır).
/// Bağlanmamışsa (testler) "yok" gerçekleştirmesi: form dosya seçtiremez, istek gönderilmez.
@Riverpod(keepAlive: true)
UploadPicker uploadPicker(Ref ref) => const UnavailableUploadPicker();

/// PORT: indirilen dosyanın kaydı (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
DownloadSink downloadSink(Ref ref) => throw UnimplementedError(
  'downloadSinkProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
/// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
/// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).
@riverpod
Future<List<TeamMember>> taskTeam(Ref ref, String departmentId) async {
  final catalog = await ref.read(taskCatalogControllerProvider.future);
  final access = catalog.access;
  if (access != null) {
    final program = ref.read(scopeStateProvider).programId;
    if (program == null || !access.canReadTeamIn(program, departmentId)) {
      throw ApiError('work.not_authorized');
    }
  }
  return ref.read(taskWriteRepositoryProvider).listTeam(departmentId);
}
