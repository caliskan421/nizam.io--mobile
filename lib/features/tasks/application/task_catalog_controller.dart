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
/// Önbellek: sağlayıcı uygulama ömrünce yaşar; ekranlar ilk yüklemeden sonra eski kataloğu
/// hemen gösterir. [refresh] / [refreshIfStale] / [reload] yeniden okurken önceki katalog
/// durumda kalır (Riverpod `invalidateSelf` → `isRefreshing`, `value` korunur); yenileme
/// hatasında da (`AsyncError` önceki değeri taşır) görünür veri silinmez.
@Riverpod(keepAlive: true)
class TaskCatalogController extends _$TaskCatalogController {
  /// Yeniden ziyarette ([refreshIfStale]) kataloğun taze sayıldığı süre.
  static const staleAfter = Duration(seconds: 30);

  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _age = Stopwatch();

  @override
  Future<TaskCatalog> build() async {
    ref.watch(scopeStateProvider);
    final catalog = await ref.read(taskCatalogRepositoryProvider).load();
    _age
      ..reset()
      ..start();
    return catalog;
  }

  TaskCatalog? get _catalog => state.value;

  /// Kaynaktan yeniden okur ve yeni kataloğu bekler (yazma sonrası). Okuma hatası fırlatılmaz:
  /// hata katalog durumunda kalır (ekran gösterir). Açık ayrıntı ekranları katalog yüklemeye
  /// geçince kendini yeniden okur ([taskDetailsProvider]).
  Future<void> reload() async {
    try {
      await refresh();
    } on Object {
      // Hata durumda; çağıran yazmanın sonucunu bildirir.
    }
  }

  /// Kullanıcı yenilemesi (aşağı çekerek): kaynaktan yeniden okur ve bitmesini bekler; okuma
  /// hatası FIRLATILIR (çağıran bildirir), önceki katalog durumda kalır.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Yeniden ziyaret (sekmeye dönüş): son başarılı okuma [maxAge]'den eskiyse arka planda
  /// yeniden okur; eski katalog görünür kalır. Hiç yüklenmemişse (ilk yükleme hatası yalnız
  /// dokunuşla yeniden denenir) ya da zaten yükleniyorsa bir şey yapmaz. Hata yutulur
  /// (durumda kalır).
  Future<void> refreshIfStale({Duration maxAge = staleAfter}) async {
    if (state.isLoading || !state.hasValue) return;
    if (_age.isRunning && _age.elapsed < maxAge) return;
    try {
      await refresh();
    } on Object {
      // Arka plan yenilemesi: hata durumda, veri yerinde.
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

  /// Görev listesinin departmanını seçer (kapsam değişir → katalog yeniden okunur).
  /// Seçilebilirler [TaskCatalog.departments]; aynı departman yeniden seçilmez.
  void selectDepartment(String departmentId) {
    if (_catalog?.departmentId == departmentId) return;
    ref.read(scopeControllerProvider).selectDepartment(departmentId);
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
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yalnız seçili (program, departman)
/// kapsamında yönetici ya da koordinatör ([TaskAccess.canCreateIn]; üye hayır — WORK-K05).
/// Katalog yokken ya da departman seçilmemişken hayır (fail-closed).
@riverpod
bool canCreateTask(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return false;
  final access = catalog.access;
  if (access == null) return true;
  final program = ref.watch(scopeStateProvider).programId;
  final department = catalog.departmentId;
  return program != null &&
      department != null &&
      access.canCreateIn(program, department);
}
