import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProvider, Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/coordinatorship_stats_repository.dart';

part 'coordinatorships_controller.g.dart';

final coordinatorshipStatsRepositoryProvider =
    Provider<CoordinatorshipStatsRepository>(
      (ref) => throw UnimplementedError(),
    );

final serverCoordinatorshipStatsProvider = FutureProvider((ref) async {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final local = coordinatorshipStats(catalog);
  if (catalog.access?.companyAdmin != true) return PageSlice(items: local);
  final result = await ref.read(coordinatorshipStatsRepositoryProvider).load();
  return PageSlice(
    truncated: result.truncated,
    items: [
      for (final server in result.items)
        CoordinatorshipStats(
          code: server.code,
          name: server.name,
          done: server.done,
          total: server.total,
          late: server.late,
          leads: server.leads,
          members:
              local.where((s) => s.code == server.code).firstOrNull?.members ??
              const [],
          shortCode: local
              .where((s) => s.code == server.code)
              .firstOrNull
              ?.shortCode,
        ),
    ],
  );
});

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
      .watch(serverCoordinatorshipStatsProvider)
      .whenData((page) => sortCoordinatorships(page.items, sort));
}
