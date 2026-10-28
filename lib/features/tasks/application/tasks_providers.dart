import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';

part 'tasks_providers.g.dart';

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır; bugün geliştirme örneği).
@Riverpod(keepAlive: true)
TaskCatalogRepository taskCatalogRepository(Ref ref) =>
    throw UnimplementedError(
      'taskCatalogRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
