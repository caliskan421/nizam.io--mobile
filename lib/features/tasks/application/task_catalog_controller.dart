import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import 'tasks_providers.dart';

part 'task_catalog_controller.g.dart';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog).
/// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
/// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
/// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.
@Riverpod(keepAlive: true)
class TaskCatalogController extends _$TaskCatalogController {
  @override
  Future<TaskCatalog> build() {
    ref.watch(scopeStateProvider);
    return ref.read(taskCatalogRepositoryProvider).load();
  }

  TaskCatalog? get _catalog => state.value;

  // Yerel güncelleme nesli: [replace] / [applyDetails] / [applyItem] görevi işaretler; [upsert]
  // okuma başladıktan SONRA yerelde güncellenmiş görevi eski okumayla ezmez.
  int _generation = 0;
  final _touched = HashMap<String, int>();

  void _touch(String code) => _touched[code] = ++_generation;

  /// Okuma başlangıcının nesli ([upsert] `since`).
  int get generation => _generation;

  /// Tek depo kuralı: süzgeçli okumanın ([since] neslinde başlayan) satırları katalogda
  /// güncellenir ya da eklenir (sunucunun görünür saydığı görev). Aynı kimlikli satırın alanları
  /// sunucu değeriyle değişir, ayrıntı parçaları (alt görev, not, dosya, tarih talebi) korunur;
  /// okuma başladıktan sonra yerelde güncellenmiş satır olduğu gibi kalır. Adlar katılır.
  /// Katalog yokken yok sayılır.
  void upsert(
    List<TaskItem> items, {
    required int since,
    List<PersonName> names = const [],
  }) {
    final c = _catalog;
    if (c == null || items.isEmpty) return;
    final fresh = {
      for (final i in items)
        if ((_touched[i.code] ?? 0) <= since) i.code: i,
    };
    final merged = [
      for (final t in c.tasks)
        if (fresh.remove(t.code) case final i?)
          i.copyWith(
            subtasks: t.subtasks,
            noteEntries: t.noteEntries,
            fileEntries: t.fileEntries,
            dateRequest: () => t.dateRequest,
          )
        else
          t,
      // Katalogda olmayanlar (ör. katalog sonrası açılan ya da kesik katalog) sona eklenir.
      ...fresh.values,
    ];
    state = AsyncData(c.withTasks(merged).withNames(names));
  }

  /// Kaynaktan yeniden okur ve yeni kataloğu bekler (yazma sonrası). Okuma hatası fırlatılmaz:
  /// hata katalog durumunda kalır (ekran gösterir). Açık ayrıntı ekranları katalog yüklemeye
  /// geçince kendini yeniden okur ([taskDetailsProvider]).
  Future<void> reload() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Hata durumda; çağıran yazmanın sonucunu bildirir.
    }
  }

  /// Görevi ekler ([at] verilirse o sıraya, yoksa başa).
  void add(TaskItem task, {int? at}) {
    final c = _catalog;
    if (c == null) return;
    final list = [...c.tasks];
    list.insert((at ?? 0).clamp(0, list.length), task);
    state = AsyncData(c.withTasks(list));
  }

  /// Aynı kodlu görevi [task] ile değiştirir. Örnek görevde gecikme günü yeni bitiş/duruma
  /// göre yeniden hesaplanır; sunucu görevinde ([TaskItem.lateness] dolu) sunucu değeri
  /// korunur (istemci gecikme türetmez — WORK-K37).
  void replace(TaskItem task) {
    _touch(task.code);
    final c = _catalog;
    if (c == null) return;
    final fixed = task.lateness != null
        ? task
        : task.copyWith(
            overdueDays: c.overdueDaysFor(task.due, done: task.isDone),
          );
    state = AsyncData(
      c.withTasks([for (final t in c.tasks) t.code == task.code ? fixed : t]),
    );
  }

  /// [code] görevine sunucudan okunan ayrıntıyı uygular: tekil okuma ([TaskDetails.item];
  /// tarih, açıklama, durum, atananlar, sayılar) katalogdaki görevin YERİNE geçer, alt görev /
  /// not / dosya / tarih talebi eklenir, adlar [TaskCatalog.names]'e katılır. Yazma sonrası
  /// "kalemi yeniden oku" budur (tüm liste okunmaz). Gecikme sunucu değeridir; yeniden
  /// hesaplanmaz.
  void applyDetails(String code, TaskDetails d) {
    _touch(code);
    final c = _catalog;
    if (c == null) return;
    state = AsyncData(
      c
          .withTasks([
            for (final t in c.tasks)
              t.code == code
                  ? (d.item ?? t).copyWith(
                      subtasks: d.subtasks,
                      noteEntries: d.notes,
                      fileEntries: d.files,
                      dateRequest: () => d.dateRequest,
                    )
                  : t,
          ])
          .withNames(d.names),
    );
  }

  /// [code] görevini taze tekil okumayla ([item]; açıklama, tarih, atananlar) değiştirir;
  /// ayrıntı parçaları (alt görev, not, dosya, tarih talebi) korunur. Gecikme sunucu değeri.
  void applyItem(String code, TaskItem item) {
    _touch(code);
    final c = _catalog;
    if (c == null) return;
    state = AsyncData(
      c.withTasks([
        for (final t in c.tasks)
          t.code == code
              ? item.copyWith(
                  subtasks: t.subtasks,
                  noteEntries: t.noteEntries,
                  fileEntries: t.fileEntries,
                  dateRequest: () => t.dateRequest,
                )
              : t,
      ]),
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

/// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yönetici ya da programda en az bir
/// departmanın koordinatörü ([TaskAccess.canCreateAnyIn]; üye hayır — WORK-K05; departman
/// formda açılabilenlerden seçilir). Katalog ya da program yokken hayır (fail-closed).
@riverpod
bool canCreateTask(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return false;
  final access = catalog.access;
  if (access == null) return true;
  final program = ref.watch(scopeStateProvider).programId;
  return program != null && access.canCreateAnyIn(program);
}
