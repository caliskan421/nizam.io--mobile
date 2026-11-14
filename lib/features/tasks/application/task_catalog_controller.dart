import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
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
      _clearLookups();
      _lookupInFlight.clear();
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

  /// Kimlik araması sonuçları ([resolveMissing]): kesin sonuç, 429 bekleme bitişi, uçuştaki
  /// arama.
  final _lookupDone = HashMap<String, ({bool limited})>();
  final _lookupHeld = HashMap<String, (DateTime, ApiError)>();
  final _lookupInFlight = HashMap<String, Future<void>>();

  /// Süzgeçli okumayla kataloğa eklenmiş görevler: yeniden okumada katalogdan düşmeleri
  /// beklenir, geri gelişleri süzgeçli yoldandır ([resolveMissing] onları aramaz).
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
  /// tablo referansı — açılan görev): görevi kimlikle çözümler.
  /// - Tam katalogda katalog yeniden okunur (liste programın görünür görevlerinin tamamıdır).
  /// - Kesik katalogda (sayfa tavanı) liste kimlikle süzülemez (`listProgramWorkItems` yalnız
  ///   departman/atanan süzgeci taşır) ve tekil okuma (`getWorkItem`, S3) görevin departman
  ///   başlığını ister: görev çağıranın bu programdaki görünür departmanlarında (önce kendi ekip
  ///   satırları, sonra katalog departmanları; en çok [maxDepartmentProbes]) sırayla denenir.
  ///
  /// Sonuçlar: bulunursa kataloğa eklenir. KESİN "bulunamadı" (bütün adaylarda 404 ya da
  /// 403 `work.not_assigned`) kimlik başına kaydedilir ve tekrar aranmaz (katalog yenilemesi ve sahip
  /// değişimi kaydı siler). Aday sınırı dolarsa `client.task_lookup_limit` FIRLAR (kesin).
  /// Geçici hata (ağ, 5xx, 429) FIRLAR ve kaydedilmez: ayrıntı yenilemesi aramayı tekrarlar;
  /// 429'da `Retry-After` dolmadan istek atılmaz (aynı hata yeniden fırlar). Süzgeçli okumayla
  /// gelmiş görev bu yoldan geçmez. Kapsam/oturum değişirse arama sessizce biter.
  Future<void> resolveMissing(String code) {
    if (_upserted.contains(code)) return Future.value();
    final done = _lookupDone[code];
    if (done != null) {
      return done.limited ? Future.error(_limitError()) : Future.value();
    }
    final held = _lookupHeld[code];
    if (held != null && held.$1.isAfter(DateTime.now())) {
      return Future.error(held.$2);
    }
    if (_lookupInFlight[code] case final running?) return running;
    // Uçuştaki kayıt sahip değişiminde silinir ([build]); eski aramanın tamamlanması yalnız
    // KENDİ kaydını siler (gelecek eşitliği), yeni sahibin aramasını değil. Gövde bloklu:
    // `remove` geleceğin kendisini döndürür; whenComplete onu beklerse kilitlenir.
    late final Future<void> lookup;
    lookup = _resolve(code).whenComplete(() {
      if (identical(_lookupInFlight[code], lookup)) {
        _lookupInFlight.remove(code);
      }
    });
    return _lookupInFlight[code] = lookup;
  }

  /// Kesik katalogda görev başına denenecek en çok departman (her biri bir `getWorkItem`).
  static const maxDepartmentProbes = 20;

  ApiError _limitError() => ApiError(ClientErrorCode.taskLookupLimit);

  Future<void> _resolve(String code) async {
    final c = _catalog;
    if (c == null) return;
    final owner = _owner;
    try {
      if (!c.truncated) {
        await refresh();
        if (!ref.mounted || _owner != owner) return;
        if (_catalog?.task(code) == null) _lookupDone[code] = (limited: false);
        return;
      }
      await _probe(code, c, owner);
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tasks);
      if (!ref.mounted || _owner != owner) return;
      if (e.status == 429) {
        _lookupHeld[code] = (
          DateTime.now().add(e.retryAfter ?? const Duration(seconds: 2)),
          e,
        );
      }
      rethrow;
    }
  }

  Future<void> _probe(String code, TaskCatalog c, CacheOwner? owner) async {
    final program = ref.read(scopeStateProvider).programId;
    if (program == null || program.isEmpty) return;
    final since = _generation;
    final all = <String>{
      for (final s in c.access?.seatsIn(program) ?? const <TeamSeat>[])
        s.departmentId,
      for (final d in c.departments) d.id,
    };
    final details = ref.read(taskDetailsRepositoryProvider);
    for (final department in all.take(maxDepartmentProbes)) {
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
      final TaskItem item;
      try {
        item = await details.loadItem(probe);
      } on ApiError catch (e, st) {
        // Aynı hata nesnesi [_resolve]'da yeniden raporlanmaz (ErrorReporting.alreadyHandled).
        reportUnexpected(e, st, source: ReportSource.tasks);
        if (!ref.mounted || _owner != owner) return;
        if (e.status == 404) continue;
        if (e.code == 'work.not_assigned') {
          // Görev bu departmanda var ama okuyana atanmamış: kesin sonuç. Diğer 403'ler
          // (yetki, üyelik, parola değişimi) genel hatadır: aşağıda fırlar.
          _lookupDone[code] = (limited: false);
          return;
        }
        rethrow; // geçici ya da yetki: çağıran raporlar ve fırlatır
      }
      if (!ref.mounted || _owner != owner) return;
      upsert([item], since: since);
      return;
    }
    if (!ref.mounted || _owner != owner) return;
    final limited = all.length > maxDepartmentProbes;
    _lookupDone[code] = (limited: limited);
    if (limited) throw _limitError();
  }

  /// Kullanıcı yenilemesi (aşağı çekerek): kaynaktan yeniden okur ve bitmesini bekler; okuma
  /// hatası FIRLATILIR (çağıran bildirir), önceki katalog durumda kalır.
  Future<void> refresh() async {
    _clearLookups();
    ref.invalidateSelf();
    await future;
  }

  void _clearLookups() {
    _lookupDone.clear();
    _lookupHeld.clear();
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
