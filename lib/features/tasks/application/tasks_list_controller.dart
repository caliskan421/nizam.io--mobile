import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import '../domain/task_query.dart';
import 'task_catalog_controller.dart';

part 'tasks_list_controller.g.dart';

/// Filtre alt sayfasının grupları.
enum TaskFilterGroup { people, coordinatorship, priority }

/// Görevler listesinin ekran durumu (prototip `S_tasks.state`).
@immutable
final class TasksListState {
  const TasksListState({
    this.view = TaskView.all,
    this.sort = TaskSort.due,
    this.descending = false,
    this.filter = const TaskFilter(),
    this.searchOpen = false,
    this.limit = pageSize,
    this.flippedGroups = const {},
    this.openFilterGroups = const {TaskFilterGroup.people},
  });

  /// "Daha fazla göster" adımı.
  static const pageSize = 8;

  final TaskView view;
  final TaskSort sort;
  final bool descending;
  final TaskFilter filter;
  final bool searchOpen;
  final int limit;

  /// Koordinatörlüğe göre listede varsayılanından (yalnız ilk grup açık) çevrilmiş gruplar.
  final Set<String> flippedGroups;
  final Set<TaskFilterGroup> openFilterGroups;

  bool isGroupOpen(String code, {required bool first}) =>
      flippedGroups.contains(code) ? !first : first;

  TasksListState copyWith({
    TaskView? view,
    TaskSort? sort,
    bool? descending,
    TaskFilter? filter,
    bool? searchOpen,
    int? limit,
    Set<String>? flippedGroups,
    Set<TaskFilterGroup>? openFilterGroups,
  }) => TasksListState(
    view: view ?? this.view,
    sort: sort ?? this.sort,
    descending: descending ?? this.descending,
    filter: filter ?? this.filter,
    searchOpen: searchOpen ?? this.searchOpen,
    limit: limit ?? this.limit,
    flippedGroups: flippedGroups ?? this.flippedGroups,
    openFilterGroups: openFilterGroups ?? this.openFilterGroups,
  );
}

/// Görevler listesinin geçişlerde korunan tercihleri (prototip `openTasks(patch)` yalnız
/// görünüm/süzgeç/arama/sayfayı sıfırlar; sıralama, yön, açık gruplar ve filtre sayfasının
/// açık bölümleri kalır).
typedef TasksListPrefs = ({
  TaskSort sort,
  bool descending,
  Set<String> flippedGroups,
  Set<TaskFilterGroup> openFilterGroups,
});

/// [TasksListPrefs] deposu: oturum boyunca yaşar; her yeni liste denetleyicisi (KPI kartı,
/// ekip kutusu, çekmece rozeti `view`/`people` ile açılan liste) buradan başlar.
@Riverpod(keepAlive: true)
class TasksListPrefsStore extends _$TasksListPrefsStore {
  @override
  TasksListPrefs build() => (
    sort: TaskSort.due,
    descending: false,
    flippedGroups: const <String>{},
    openFilterGroups: const {TaskFilterGroup.people},
  );

  void save(TasksListState s) => state = (
    sort: s.sort,
    descending: s.descending,
    flippedGroups: s.flippedGroups,
    openFilterGroups: s.openFilterGroups,
  );
}

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: uygulama
/// (keepAlive; prototip `S_tasks` alt ekran durumu kalıcıdır: tablette modül gidiş-dönüşünde
/// arama ve süzgeç kalır), tercihler [TasksListPrefsStore]'da.
@Riverpod(keepAlive: true)
class TasksListController extends _$TasksListController {
  @override
  TasksListState build(TaskView view, String people) {
    final prefs = ref.read(tasksListPrefsStoreProvider);
    return TasksListState(
      view: view,
      sort: prefs.sort,
      descending: prefs.descending,
      flippedGroups: prefs.flippedGroups,
      openFilterGroups: prefs.openFilterGroups,
      filter: TaskFilter(
        people: {
          for (final p in people.split(','))
            if (p.isNotEmpty) p,
        },
      ),
    );
  }

  @override
  set state(TasksListState value) {
    super.state = value;
    ref.read(tasksListPrefsStoreProvider.notifier).save(value);
  }

  void selectView(TaskView v) =>
      state = state.copyWith(view: v, limit: TasksListState.pageSize);

  /// Seçili olmayan ölçüt → seçer (varsayılan yön); seçili tarihli ölçüt → yönü çevirir.
  void selectSort(TaskSort s) {
    if (s == state.sort) {
      if (!s.dated) return;
      state = state.copyWith(
        descending: !state.descending,
        limit: TasksListState.pageSize,
      );
      return;
    }
    state = state.copyWith(
      sort: s,
      descending: s.defaultDescending,
      limit: TasksListState.pageSize,
    );
  }

  /// Arama alanını açar/kapatır (kapanınca sorgu silinir).
  void toggleSearch() {
    final open = !state.searchOpen;
    state = state.copyWith(
      searchOpen: open,
      filter: open ? state.filter : _filter(query: ''),
    );
  }

  void setQuery(String q) => state = state.copyWith(
    filter: _filter(query: q),
    limit: TasksListState.pageSize,
  );

  void togglePerson(String id) => state = state.copyWith(
    filter: _filter(people: _toggle(state.filter.people, id)),
    limit: TasksListState.pageSize,
  );

  void toggleCoordinatorship(String code) => state = state.copyWith(
    filter: _filter(
      coordinatorships: _toggle(state.filter.coordinatorships, code),
    ),
    limit: TasksListState.pageSize,
  );

  void togglePriority(TaskPriority p) => state = state.copyWith(
    filter: _filter(priorities: _toggle(state.filter.priorities, p)),
    limit: TasksListState.pageSize,
  );

  /// Kişi/koordinatörlük/öncelik süzgeçlerini temizler (görünüm ve arama kalır).
  void clearExtra() =>
      state = state.copyWith(filter: TaskFilter(query: state.filter.query));

  /// Her şeyi sıfırlar: görünüm Tümü, arama ve süzgeçler boş.
  void clearAll() => state = state.copyWith(
    view: TaskView.all,
    filter: const TaskFilter(),
    limit: TasksListState.pageSize,
  );

  void showMore() =>
      state = state.copyWith(limit: state.limit + TasksListState.pageSize);

  void toggleGroup(String code) =>
      state = state.copyWith(flippedGroups: _toggle(state.flippedGroups, code));

  void toggleFilterGroup(TaskFilterGroup g) => state = state.copyWith(
    openFilterGroups: _toggle(state.openFilterGroups, g),
  );

  TaskFilter _filter({
    String? query,
    Set<String>? people,
    Set<String>? coordinatorships,
    Set<TaskPriority>? priorities,
  }) {
    final f = state.filter;
    return TaskFilter(
      query: query ?? f.query,
      people: people ?? f.people,
      coordinatorships: coordinatorships ?? f.coordinatorships,
      priorities: priorities ?? f.priorities,
    );
  }

  static Set<T> _toggle<T>(Set<T> s, T x) =>
      s.contains(x) ? ({...s}..remove(x)) : {...s, x};
}

/// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
/// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
/// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.
@riverpod
TaskQueryResult? tasksListResult(Ref ref, TaskView view, String people) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  final q = ref.watch(
    tasksListControllerProvider(
      view,
      people,
    ).select((s) => (s.view, s.sort, s.descending, s.filter)),
  );
  if (catalog == null) return null;
  return queryTasks(
    catalog,
    view: q.$1,
    sort: q.$2,
    descending: q.$3,
    filter: q.$4,
  );
}

/// [list] denetleyicisinin aynı başlangıç süzgeçli sonuç sağlayıcısı.
TasksListResultProvider tasksListResultOf(TasksListControllerProvider list) {
  final (view, people) = list.argument! as (TaskView, String);
  return tasksListResultProvider(view, people);
}

/// Filtre alt sayfasının seçenek sayıları; katalog değişince bir kez hesaplanır.
@riverpod
TaskFilterOptions? taskFilterOptions(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  return catalog == null ? null : filterOptions(catalog);
}
