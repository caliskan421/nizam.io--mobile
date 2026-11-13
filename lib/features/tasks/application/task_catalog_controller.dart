import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import 'tasks_providers.dart';

part 'task_catalog_controller.g.dart';
part 'task_catalog_owner.dart';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; oturum nesli veya program değişince eski
/// değer durumdan silinerek yeniden okunur (yüklenirken ve hatada önceki sahip görünmez),
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
/// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
/// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse uygulamalar yok sayılır.
///
/// Önbellek: sağlayıcı uygulama ömrünce yaşar; ekranlar ilk yüklemeden sonra eski kataloğu
/// hemen gösterir. [refresh] / [refreshIfStale] / [reload] yeniden okurken önceki katalog
/// durumda kalır (Riverpod `invalidateSelf` → `isRefreshing`, `value` korunur); yenileme
/// hatasında da (`AsyncError` önceki değeri taşır) görünür veri silinmez.
class TaskCatalogController extends AsyncNotifier<TaskCatalog> {
  /// Son başarılı okumadan beri geçen süre (aynı sahipte yeniden kurulumlarda korunur).
  var _clock = StaleClock();
  final _ownership = CacheOwnership();
  CacheOwner? _owner;

  @override
  Future<TaskCatalog> build() async {
    final buildRef = ref;
    final owner = _ownership.watch(buildRef);
    if (_owner != owner) {
      _owner = owner;
      _touched.clear();
      _missed.clear();
      _upserted.clear();
      _generation++;
      _namesAt = 0;
      _clock = StaleClock();
    }
    final catalog = await ref.read(taskCatalogRepositoryProvider).load();
    // Riverpod iptal edilmiş build'in sonucunu atar; notifier alanı da eski okumadan etkilenmez.
    if (buildRef.mounted) {
      _ownership.markLoaded(buildRef, owner);
      if (_ownership.owns(buildRef)) _clock.markFresh();
    }
    return catalog;
  }

  @override
  bool updateShouldNotify(
    AsyncValue<TaskCatalog> previous,
    AsyncValue<TaskCatalog> next,
  ) {
    // Eleman eski değeri süzerken iki durum da loading olabilir; sahip değişimi yine
    // bildirilir ki value okuyan ekranlar önceki çizdikleri kataloğu da kaldırsın.
    if (!ref.mounted || (_owner != null && !_ownership.owns(ref))) return true;
    return super.updateShouldNotify(previous, next);
  }

  TaskCatalog? get _catalog => _ownership.visible(ref, state).value;

  // Yerel güncelleme nesli: [replace] / [applyDetails] / [applyItem] görevi işaretler; [upsert]
  // okuma başladıktan SONRA yerelde güncellenmiş görevi eski okumayla ezmez.
  int _generation = 0;
  final _touched = HashMap<String, int>();

  /// Katalogda bulunmadığı için yeniden okuma tetiklemiş görev kimlikleri (sahip başına bir kez).
  final _missed = <String>{};

  /// Süzgeçli okumayla kataloğa eklenmiş görevler: yeniden okumada katalogdan düşmeleri
  /// beklenir, geri gelişleri süzgeçli yoldandır ([refreshForMissing] onları yenilemez).
  final _upserted = <String>{};

  void _touch(String code) => _touched[code] = ++_generation;

  // Ad nesli: [applyDetails] yeni adlar getirdiğinde işaretlenir; [upsert] okuma başladıktan
  // sonra adlar güncellendiyse eski yanıtın adlarıyla var olan adları ezmez (yalnız eksikleri
  // tamamlar).
  int _namesAt = 0;

  /// Okuma başlangıcının nesli ([upsert] `since`).
  int get generation => _generation;

  /// Tek depo kuralı: süzgeçli okumanın ([since] neslinde başlayan) satırları katalogda
  /// güncellenir ya da eklenir (sunucunun görünür saydığı görev). Aynı kimlikli satırın alanları
  /// sunucu değeriyle değişir, ayrıntı parçaları (alt görev, not, dosya, tarih talebi) korunur;
  /// okuma başladıktan sonra yerelde güncellenmiş satır olduğu gibi kalır. Açıklama listede
  /// yoksa katalogdaki korunur. Adlar katılır; okuma başladıktan sonra yerelde ad güncellendiyse
  /// yalnız eksik adlar eklenir.
  /// Katalog yokken yok sayılır.
  void upsert(
    List<TaskItem> items, {
    required int since,
    List<PersonName> names = const [],
  }) {
    final c = _catalog;
    if (c == null || items.isEmpty) return;
    _upserted.addAll(items.map((i) => i.code));
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
            // Liste satırı açıklama taşımaz: ayrıntıda okunmuş açıklama korunur.
            description: () => i.description ?? t.description,
          )
        else
          t,
      // Katalogda olmayanlar (ör. katalog sonrası açılan ya da kesik katalog) sona eklenir.
      ...fresh.values,
    ];
    final newNames = _namesAt > since
        ? [
            for (final n in names)
              if (c.nameOf(n.id) == null) n,
          ]
        : names;
    state = AsyncData(c.withTasks(merged).withNames(newNames));
  }

  /// Kaynaktan yeniden okur ve yeni kataloğu bekler (yazma sonrası). Okuma hatası fırlatılmaz:
  /// hata katalog durumunda kalır (ekran gösterir). Açık ayrıntı ekranları katalog yüklemeye
  /// geçince kendini yeniden okur ([taskDetailsProvider]).
  Future<void> reload() async {
    try {
      await refresh();
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tasks);
      // Hata durumda; çağıran yazmanın sonucunu bildirir.
    }
  }

  /// [code] yüklü katalogda yok (ör. katalog yüklendikten sonra oluşturulup başka ekrandan —
  /// tablo referansı — açılan görev). Kimlik başına BİR KEZ:
  /// - tam katalogda katalog yeniden okunur (liste programın görünür görevlerinin tamamıdır);
  /// - kesik katalogda (sayfa tavanı) yeniden okuma görevi getirmeyebilir ve görev listesi
  ///   kimlikle süzülemez (`listProgramWorkItems` yalnız departman/atanan süzgeci taşır);
  ///   tekil okuma (`getWorkItem`, S3) görevin departman başlığını ister. Görev, çağıranın bu
  ///   programdaki görünür departmanlarında (önce kendi ekip satırları, sonra katalog
  ///   departmanları; en çok [maxDepartmentProbes]) kimlikle sırayla denenir: 404 → sıradaki;
  ///   bulununca kataloğa eklenir; 403 ya da başka hata → durur (görünmüyor). Kapsam/oturum
  ///   değişirse arama iptal olur.
  /// Süzgeçli okumayla gelmiş görev bu yoldan geçmez. Hata durumda kalır (yutulur).
  Future<void> refreshForMissing(String code) async {
    if (_upserted.contains(code) || !_missed.add(code) || state.isLoading) {
      return;
    }
    final c = _catalog;
    try {
      if (c != null && c.truncated) {
        await _probe(code, c);
      } else {
        await refresh();
      }
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tasks);
    }
  }

  /// Kesik katalogda görev başına denenecek en çok departman (her biri bir `getWorkItem`).
  static const maxDepartmentProbes = 20;

  Future<void> _probe(String code, TaskCatalog c) async {
    final program = ref.read(scopeStateProvider).programId;
    if (program == null || program.isEmpty) return;
    final owner = _owner;
    final since = _generation;
    final departments = <String>{
      for (final s in c.access?.seatsIn(program) ?? const <TeamSeat>[])
        s.departmentId,
      for (final d in c.departments) d.id,
    }.take(maxDepartmentProbes);
    final details = ref.read(taskDetailsRepositoryProvider);
    for (final department in departments) {
      final probe = TaskItem(
        code: code,
        title: '',
        coordinatorship: department,
        departmentId: department,
        programId: program,
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        start: c.today,
        due: c.today,
        assignees: const [],
      );
      try {
        final item = await details.loadItem(probe);
        if (!ref.mounted || _owner != owner) return;
        upsert([item], since: since);
        return;
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.tasks);
        if (!ref.mounted || _owner != owner) return;
        if (e.status != 404) return;
      }
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
  Future<void> refreshIfStale({Duration maxAge = StaleClock.staleAfter}) =>
      _clock.refreshIfStale(state, refresh, maxAge: maxAge);

  /// [code] görevine sunucudan okunan ayrıntıyı uygular: tekil okuma ([TaskDetails.item];
  /// tarih, açıklama, durum, atananlar, sayılar) katalogdaki görevin YERİNE geçer, alt görev /
  /// not / dosya / tarih talebi eklenir, adlar [TaskCatalog.names]'e katılır. Yazma sonrası
  /// "kalemi yeniden oku" budur (tüm liste okunmaz). Gecikme sunucu değeridir; yeniden
  /// hesaplanmaz.
  void applyDetails(String code, TaskDetails d) {
    _touch(code);
    if (d.names.isNotEmpty) _namesAt = _generation;
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
  /// ayrıntı parçaları (alt görev, not, dosya) korunur. Gecikme sunucu değeri. Tarih talebi:
  /// tekil okuma bekleyen talebi taşır (WORK-K82); aynı talep zaten ayrıntıdan okunmuşsa
  /// (gerekçe, talep eden) o korunur; bekleyen talep kalmadıysa eldeki bekleyen talep düşer,
  /// incelenmiş talep (ayrıntı geçmişi) kalır.
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
                  dateRequest: () =>
                      _mergeRequest(t.dateRequest, item.dateRequest),
                )
              : t,
      ]),
    );
  }

  static DateChangeRequest? _mergeRequest(
    DateChangeRequest? held,
    DateChangeRequest? fresh,
  ) {
    if (fresh == null) return held != null && held.isPending ? null : held;
    return held != null && held.id == fresh.id ? held : fresh;
  }
}

/// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
/// kapısı): yönetici ya da programda en az bir
/// departmanın koordinatörü ([TaskAccess.canCreateAnyIn]; üye hayır — WORK-K05; departman
/// formda açılabilenlerden seçilir). Katalog ya da program yokken hayır (fail-closed).
@riverpod
bool canCreateTask(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return false;
  final access = catalog.access;
  final program = ref.watch(scopeStateProvider).programId;
  return access != null && program != null && access.canCreateAnyIn(program);
}
