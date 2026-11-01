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
///
/// Departman süzgeci ([selectDepartment]) sunucu süzgecidir (`department_id`): seçim kataloğu
/// yeniden okur; süzgeç bu denetleyicide bellekte tutulur, program değişince temizlenir.
/// Kaynak süzgeci temizlediyse (404 `work.program_scope_invalid`) bellekteki seçim de düşer.
@Riverpod(keepAlive: true)
class TaskCatalogController extends _$TaskCatalogController {
  String? _department;
  String? _departmentProgram;

  @override
  Future<TaskCatalog> build() async {
    final program = ref.watch(scopeStateProvider).programId;
    if (program != _departmentProgram) {
      _departmentProgram = program;
      _department = null;
    }
    final catalog = await ref
        .read(taskCatalogRepositoryProvider)
        .load(departmentId: _department);
    _department = catalog.departmentId;
    return catalog;
  }

  TaskCatalog? get _catalog => state.value;

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

  /// Görev listesinin sunucu departman süzgecini seçer (null ya da boş → süzgeç yok) ve
  /// kataloğu yeniden okur. Seçenekler [TaskCatalog.departments]; aynı süzgeç yeniden okunmaz.
  void selectDepartment(String? departmentId) {
    final id = departmentId == null || departmentId.isEmpty
        ? null
        : departmentId;
    if (_department == id && _catalog?.departmentId == id) return;
    _department = id;
    ref.invalidateSelf();
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
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yönetici ya da koordinatör
/// ([TaskAccess.canCreateIn]; üye hayır — WORK-K05): departman süzgeci varsa o departmanda,
/// yoksa programdaki herhangi bir departmanda. Katalog ya da program yokken hayır (fail-closed).
@riverpod
bool canCreateTask(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return false;
  final access = catalog.access;
  if (access == null) return true;
  final program = ref.watch(scopeStateProvider).programId;
  if (program == null) return false;
  final department = catalog.departmentId;
  return department != null
      ? access.canCreateIn(program, department)
      : access.canCreateAnyIn(program);
}
