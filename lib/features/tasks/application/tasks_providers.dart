import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import '../domain/task_details.dart';

part 'tasks_providers.g.dart';

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).
@Riverpod(keepAlive: true)
TaskCatalogRepository taskCatalogRepository(Ref ref) =>
    throw UnimplementedError(
      'taskCatalogRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TaskDetailsRepository taskDetailsRepository(Ref ref) =>
    throw UnimplementedError(
      'taskDetailsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
