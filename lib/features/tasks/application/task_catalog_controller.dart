import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import 'tasks_providers.dart';

part 'task_catalog_controller.g.dart';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (oturum boyunca;
/// kalıcılık backend bağlanınca kaynaktan gelir). Katalog henüz yüklenmediyse yok sayılır.
@Riverpod(keepAlive: true)
class TaskCatalogController extends _$TaskCatalogController {
  @override
  Future<TaskCatalog> build() => ref.read(taskCatalogRepositoryProvider).load();

  TaskCatalog? get _catalog => state.value;

  /// Görevi ekler ([at] verilirse o sıraya, yoksa başa).
  void add(TaskItem task, {int? at}) {
    final c = _catalog;
    if (c == null) return;
    final list = [...c.tasks];
    list.insert((at ?? 0).clamp(0, list.length), task);
    state = AsyncData(c.withTasks(list));
  }

  /// Aynı kodlu görevi [task] ile değiştirir; gecikme günü yeni bitiş/duruma göre yeniden
  /// hesaplanır (örnek kaynak; gerçek değer sunucudan gelir).
  void replace(TaskItem task) {
    final c = _catalog;
    if (c == null) return;
    final fixed = task.copyWith(
      overdueDays: c.overdueDaysFor(task.due, done: task.isDone),
    );
    state = AsyncData(
      c.withTasks([for (final t in c.tasks) t.code == task.code ? fixed : t]),
    );
  }

  /// Görevi kaldırır; eski sırasını döner (geri almak için `add(at:)`), yoksa -1.
  int remove(String code) {
    final c = _catalog;
    if (c == null) return -1;
    final i = c.tasks.indexWhere((t) => t.code == code);
    if (i < 0) return -1;
    state = AsyncData(c.withTasks([...c.tasks]..removeAt(i)));
    return i;
  }
}
