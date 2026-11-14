import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProvider, Notifier, NotifierProvider, Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/providers.dart';
import '../../../core/refresh.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/coordinatorship_stats_repository.dart';
import 'coordinatorship_detail_controller.dart';

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
          inProgress: server.inProgress,
          todo: server.todo,
          memberCount: server.memberCount,
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
  CoordinatorshipSort build() => CoordinatorshipSort.tasks;

  /// Katalog ve ekranın bağlı kaynakları; katalog yenilemesi raporu da geçersiz kılar.
  Future<void> refresh({String? code}) => refreshWithFeedback(
    shown: code == null
        ? ref.read(serverCoordinatorshipStatsProvider).hasValue
        : ref.read(coordinatorshipDetailProvider(code)).value != null,
    reload: () async {
      await ref.read(taskCatalogControllerProvider.notifier).refresh();
      if (code == null) {
        await ref.read(serverCoordinatorshipStatsProvider.future);
      } else {
        ref.invalidate(programDepartmentProvider(code));
        await ref.read(programDepartmentProvider(code).future);
      }
    },
  );

  void sortBy(CoordinatorshipSort sort) {
    ref.read(coordinatorshipSortDescendingProvider.notifier).setFor(sort);
    state = sort;
  }
}

/// Sayfa içindeki sıralama yönü.
final coordinatorshipSortDescendingProvider =
    NotifierProvider<CoordinatorshipSortDescending, bool>(
      CoordinatorshipSortDescending.new,
    );

class CoordinatorshipSortDescending extends Notifier<bool> {
  @override
  bool build() => true;
  void flip() => state = !state;
  void setFor(CoordinatorshipSort sort) =>
      state = sort != CoordinatorshipSort.name;
}

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi. Eşzamanlı
/// türetilir: katalog (keepAlive) hazırsa sayfanın ilk karesi doludur (yükleme titremesi yok).
@riverpod
AsyncValue<List<CoordinatorshipStats>> coordinatorshipList(Ref ref) {
  final sort = ref.watch(coordinatorshipsControllerProvider);
  final descending = ref.watch(coordinatorshipSortDescendingProvider);
  return ref
      .watch(serverCoordinatorshipStatsProvider)
      .whenData(
        (page) =>
            sortCoordinatorships(page.items, sort, descending: descending),
      );
}
