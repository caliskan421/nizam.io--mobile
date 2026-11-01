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

/// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
/// istek YOK (görünüm katalogdan). Katalog yeniden okununca (yazma sonrası `reload`, yenileme)
/// bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur ve
/// sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir.
@riverpod
Future<TaskListPage?> taskListPage(Ref ref) async {
  final filter = ref.watch(taskListFilterProvider);
  final department = filter.departmentId;
  if (department == null) return null;
  var current = true;
  ref
    ..onDispose(() => current = false)
    ..listen(taskCatalogControllerProvider, (prev, next) {
      if (next.isLoading && !(prev?.isLoading ?? false)) ref.invalidateSelf();
    });
  bool stillCurrent() => current && ref.read(taskListFilterProvider) == filter;
  void drop() {
    if (stillCurrent()) {
      ref
          .read(taskListFilterProvider.notifier)
          .dropInvalid(department, filter.program);
    }
  }

  final base = await ref.read(taskCatalogControllerProvider.future);
  if (!stillCurrent()) return null;
  if (!base.departmentsTruncated &&
      !base.departments.any((d) => d.id == department)) {
    drop();
    return null;
  }
  try {
    return await ref
        .read(taskListRepositoryProvider)
        .loadTasks(department, isCurrent: stillCurrent);
  } on ApiError catch (e) {
    if (e.code != 'work.program_scope_invalid') rethrow;
    drop();
    return null;
  }
}

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun kişi/rol/departman kümesi + süzgeçli görev sayfaları
/// ([TaskCatalog.filtered]). Katalog yerel güncellemeleri (ayrıntı, yazma) görünüme yansır.
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
  final value = page.value;
  return AsyncData(
    value == null
        ? catalog.filtered(cleared: filter.cleared)
        : catalog.filtered(departmentId: department, page: value),
  );
}
