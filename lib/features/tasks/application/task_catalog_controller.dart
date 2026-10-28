import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import 'tasks_providers.dart';

part 'task_catalog_controller.g.dart';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.
@Riverpod(keepAlive: true)
class TaskCatalogController extends _$TaskCatalogController {
  @override
  Future<TaskCatalog> build() => ref.read(taskCatalogRepositoryProvider).load();
}
