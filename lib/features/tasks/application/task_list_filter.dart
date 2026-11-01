import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../domain/task_catalog.dart';
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'task_list_filter.g.dart';

/// Görevler ekranının departman süzgeci (istemci akışları §2). Paylaşılan katalog
/// (`TaskCatalogController`) her zaman süzgeçsiz program listesidir; süzgeç YALNIZ görevler
/// ekranının görünümünü ([taskListCatalogProvider]) etkiler.
@immutable
final class TaskListFilterState {
  const TaskListFilterState({
    this.program,
    this.departmentId,
    this.cleared = false,
  });

  /// Süzgecin ait olduğu program (seçim anındaki).
  final String? program;

  /// Sunucu süzgeci (`department_id`); null → süzgeç yok.
  final String? departmentId;

  /// Önceki süzgeç geçersiz çıktı ve temizlendi (kısa bilgi; yeni seçimle düşer).
  final bool cleared;

  @override
  bool operator ==(Object other) =>
      other is TaskListFilterState &&
      other.program == program &&
      other.departmentId == departmentId &&
      other.cleared == cleared;

  @override
  int get hashCode => Object.hash(program, departmentId, cleared);
}

/// Departman süzgecinin durumu (bellekte). Program değişince sıfırlanır (yeniden kurulum).
@Riverpod(keepAlive: true)
class TaskListFilter extends _$TaskListFilter {
  @override
  TaskListFilterState build() =>
      TaskListFilterState(program: ref.watch(scopeStateProvider).programId);

  /// Süzgeci seçer (null ya da boş → süzgeç yok). Aynı süzgeç no-op.
  void select(String? departmentId) {
    final id = departmentId == null || departmentId.isEmpty
        ? null
        : departmentId;
    if (id == state.departmentId && !state.cleared) return;
    state = TaskListFilterState(program: state.program, departmentId: id);
  }

  /// [departmentId] süzgeci ([program] programında) geçersiz: YALNIZ hâlâ etkin süzgeç oysa
  /// temizlenir (geç gelen eski yanıt yeni seçimi ya da başka programı bozmaz).
  void dropInvalid(String departmentId, String? program) {
    if (state.departmentId != departmentId || state.program != program) return;
    state = TaskListFilterState(program: state.program, cleared: true);
  }
}

/// Süzgeçli okumanın sonucu: YALNIZ sunucunun döndürdüğü görev kimlikleri ve sırası (satırlar
/// paylaşılan katalogdadır — tek depo kuralı).
@immutable
final class TaskListIds {
  TaskListIds(List<String> codes, {this.truncated = false})
    : codes = List.unmodifiable(codes);

  final List<String> codes;
  final bool truncated;
}

/// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
/// istek YOK (görünüm katalogdan). Tek depo kuralı: okunan satırlar paylaşılan kataloğa
/// işlenir ([TaskCatalogController.upsert]; taze alanlar katalogda güncellenir, katalogda
/// olmayan görev eklenir — ayrıntısı açılabilir; okuma sürerken yerelde güncellenen satır
/// ezilmez), sonuç yalnız kimlik listesidir. Katalog yeniden okununca (yazma sonrası `reload`,
/// yenileme) bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur
/// ve sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir; 404'te paylaşılan katalog BİR KEZ yeniden okunur
/// (silinmiş departmanın satırları/seçenekleri kalmasın; süzgeç artık null → döngü yok).
@riverpod
Future<TaskListIds?> taskListPage(Ref ref) async {
  final filter = ref.watch(taskListFilterProvider);
  final department = filter.departmentId;
  if (department == null) return null;
  var current = true;
  ref
    ..onDispose(() => current = false)
    ..listen(taskCatalogControllerProvider, (prev, next) {
      if (next.isLoading && !(prev?.isLoading ?? false)) ref.invalidateSelf();
    });
  final store = ref.read(taskCatalogControllerProvider.notifier);
  final filters = ref.read(taskListFilterProvider.notifier);
  bool stillCurrent() => current && ref.read(taskListFilterProvider) == filter;
  bool drop() {
    if (!stillCurrent()) return false;
    filters.dropInvalid(department, filter.program);
    return true;
  }

  final base = await ref.read(taskCatalogControllerProvider.future);
  if (!stillCurrent()) return null;
  if (!base.departmentsTruncated &&
      !base.departments.any((d) => d.id == department)) {
    drop();
    return null;
  }
  final since = store.generation;
  try {
    final page = await ref
        .read(taskListRepositoryProvider)
        .loadTasks(
          department,
          isCurrent: stillCurrent,
          departments: base.departments,
        );
    if (!stillCurrent()) return null;
    store.upsert(page.tasks, since: since, names: page.names);
    return TaskListIds([
      for (final t in page.tasks) t.code,
    ], truncated: page.truncated);
  } on ApiError catch (e) {
    if (e.code != 'work.program_scope_invalid') rethrow;
    if (drop()) unawaited(store.reload());
    return null;
  }
}

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun satırları süzgeçli okumanın kimlik sırasıyla ([TaskCatalog.filtered]).
/// Katalog güncellemeleri (ayrıntı, yazma, upsert) görünüme yansır.
@riverpod
AsyncValue<TaskCatalog> taskListCatalog(Ref ref) {
  final base = ref.watch(taskCatalogControllerProvider);
  final filter = ref.watch(taskListFilterProvider);
  final department = filter.departmentId;
  final catalog = base.value;
  if (department == null || catalog == null) {
    return filter.cleared && catalog != null
        ? base.whenData((c) => c.filtered(cleared: true))
        : base;
  }
  final page = ref.watch(taskListPageProvider);
  // Süzgeç değişince (yeniden kurulum) eski süzgecin satırları gösterilmez: yükleniyor.
  if (page.isReloading) return const AsyncLoading();
  if (page.hasError && !page.isLoading) {
    return AsyncError(page.error!, page.stackTrace ?? StackTrace.current);
  }
  if (!page.hasValue) return const AsyncLoading();
  final ids = page.value;
  return AsyncData(
    ids == null
        ? catalog.filtered(cleared: filter.cleared)
        : catalog.filtered(
            departmentId: department,
            codes: ids.codes,
            truncated: ids.truncated,
          ),
  );
}
