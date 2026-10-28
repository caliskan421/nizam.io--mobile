import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';

part 'coordinatorships_controller.g.dart';

/// Koordinatörlük listesinin sıralama ölçütü (kısayol menüsünden değişir; sayfalar arası
/// korunur).
@Riverpod(keepAlive: true)
class CoordinatorshipsController extends _$CoordinatorshipsController {
  @override
  CoordinatorshipSort build() => CoordinatorshipSort.name;

  void sortBy(CoordinatorshipSort sort) => state = sort;
}

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi.
@riverpod
Future<List<CoordinatorshipStats>> coordinatorshipList(Ref ref) async {
  final sort = ref.watch(coordinatorshipsControllerProvider);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  return sortCoordinatorships(coordinatorshipStats(catalog), sort);
}
