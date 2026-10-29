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

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi. Eşzamanlı
/// türetilir: katalog (keepAlive) hazırsa sayfanın ilk karesi doludur (yükleme titremesi yok).
@riverpod
AsyncValue<List<CoordinatorshipStats>> coordinatorshipList(Ref ref) {
  final sort = ref.watch(coordinatorshipsControllerProvider);
  return ref
      .watch(taskCatalogControllerProvider)
      .whenData((c) => sortCoordinatorships(coordinatorshipStats(c), sort));
}
