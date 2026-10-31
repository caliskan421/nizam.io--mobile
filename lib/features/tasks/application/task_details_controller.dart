import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'task_details_controller.g.dart';

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.
@riverpod
Future<void> taskDetails(Ref ref, String code) async {
  ref.watch(scopeStateProvider);
  final catalog = await ref.read(taskCatalogControllerProvider.future);
  final task = catalog.task(code);
  if (task == null) return;
  final details = await ref.read(taskDetailsRepositoryProvider).load(task);
  if (details == null) return;
  ref.read(taskCatalogControllerProvider.notifier).applyDetails(code, details);
}
