import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/tasks_providers.dart';
import 'data/sample/sample_task_catalog_repository.dart';
import 'domain/task_catalog.dart';

/// tasks modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerTasksModule(GetIt locator) {
  // GEÇİCİ: görev kataloğu backend'de hazır olana kadar geliştirme örneği.
  locator.registerLazySingleton<TaskCatalogRepository>(
    SampleTaskCatalogRepository.new,
  );
}

/// tasks'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> tasksOverrides(GetIt locator) => [
  taskCatalogRepositoryProvider.overrideWith(
    (ref) => locator<TaskCatalogRepository>(),
  ),
];
