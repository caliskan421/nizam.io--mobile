import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/activity_log.dart';
import '../domain/activity_query.dart';
import 'activity_log_controller.dart';

part 'activity_query_controller.g.dart';

/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner.
@riverpod
class ActivityQueryController extends _$ActivityQueryController {
  @override
  ActivityQuery build() => const ActivityQuery();

  void selectKind(ActivityKind? kind) =>
      state = state.copyWith(kind: () => kind, limit: ActivityQuery.pageSize);

  void search(String text) =>
      state = state.copyWith(search: text, limit: ActivityQuery.pageSize);

  void togglePerson(String id) {
    final people = {...state.people};
    if (!people.remove(id)) people.add(id);
    state = state.copyWith(people: people, limit: ActivityQuery.pageSize);
  }

  void removePerson(String id) =>
      state = state.copyWith(people: {...state.people}..remove(id));

  /// Aynı koordinatörlük yeniden seçilirse kaldırılır (tek seçim).
  void toggleCoordinatorship(String code) => state = state.copyWith(
    coordinatorship: () => state.coordinatorship == code ? null : code,
    limit: ActivityQuery.pageSize,
  );

  void clearCoordinatorship() =>
      state = state.copyWith(coordinatorship: () => null);

  /// Alt sayfadaki "Temizle": kişi ve koordinatörlük.
  void clearExtra() =>
      state = state.copyWith(people: const {}, coordinatorship: () => null);

  /// "Tümünü temizle" / "Filtreleri temizle": tür, kişi, koordinatörlük (arama korunur).
  void clearAll() => state = ActivityQuery(search: state.search);

  void showMore() =>
      state = state.copyWith(limit: state.limit + ActivityQuery.moreStep);
}

/// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).
@riverpod
Future<ActivityView> activityView(Ref ref) async {
  final query = ref.watch(activityQueryControllerProvider);
  final log = ref.watch(activityLogControllerProvider.future);
  final catalog = ref.watch(taskCatalogControllerProvider.future);
  return applyActivityQuery(await log, await catalog, query);
}
