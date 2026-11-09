import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/server/write_compat.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';
import 'task_catalog_controller.dart';
import 'task_details_controller.dart';
import 'tasks_providers.dart';
import 'upload_digest_memo.dart';

part 'task_detail_controller.g.dart';
part 'task_detail_state.dart';

/// Sunucu 409'u: görev yeniden okunur, ileti gösterilir, otomatik tekrar YOK (istemci
/// akışları §8). Kod listesi durum dışı 409'ları da kapsasın diye HTTP durumu da okunur.
bool _isConflict(ApiError e) =>
    e.status == 409 ||
    const {
      'work.stale_transition',
      'work.stale_completion',
      'platform.conflict_retry',
      'work.subtasks_open',
      'work.item_completed',
      'work.transition_not_allowed',
      'work.dependency_not_completed',
      'work.date_request_pending_exists',
      'work.date_request_already_reviewed',
    }.contains(e.code);

/// Sunucu 403 (`work.not_authorized` / `work.not_assigned`): yetki ya da atama değişmiş
/// olabilir → görev VE rol olguları (katalog: `/v1/me`, `/v1/me/departments`) yeniden okunur;
/// otomatik tekrar yok.
bool _isForbidden(ApiError e) =>
    e.status == 403 ||
    const {'work.not_authorized', 'work.not_assigned'}.contains(e.code);

/// Hata sonrası yeniden okuma gerekir mi (çakışma ya da yetki reddi).
bool _rereadAfter(ApiError e) => _isConflict(e) || _isForbidden(e);

// İşlem anahtarı eylem adları ([TaskDetailState.keys]).
const _note = 'note';
const _subtask = 'subtask';
const _upload = 'upload';
const _copy = 'copy';

/// Bayat düzenleme sürümü (ADR-0027).
const _editConflict = 'work.edit_conflict';

/// Yerel ön denetimin hatası: istek gönderilmez, metin yine koddan (sunucu kataloğundaki kod).
WriteOutcome _rejected(String code) =>
    WriteOutcome(WriteKind.failed, ApiError(code));

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`).
///
/// Yazmalar (P2: durum, not, alt görev) [TaskWriteRepository]'ye gider:
/// iyimser güncelleme YOK; başarıdan sonra ilgili kaynak yeniden okunur (liste etkileniyorsa
/// katalog — durum, `subtask_counts` — ve ayrıntı; yalnız not ise ayrıntı). Uçuştaki yazma
/// varken yeni yazma istek göndermez ([TaskDetailState.busy]). 409'da yeniden okunur, sonuç
/// [WriteKind.failed]/[WriteKind.subtasksOpen] döner; otomatik tekrar yok. Eylem
/// görünürlüğü [permissions]'tan (işlem bazlı olgular).
///
/// P3: öncelik/düzenle/kopyala/sil, atama ve üstlen/bırak, tarih talebi aç/karar/sil,
/// dosya yükle/adlandır/sil/indir de aynı kapıdan gider.
@riverpod
class TaskDetailController extends _$TaskDetailController {
  @override
  TaskDetailState build(String code) => const TaskDetailState();

  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);
  TaskCatalogController get _store =>
      ref.read(taskCatalogControllerProvider.notifier);
  TaskWriteRepository get _writes => ref.read(taskWriteRepositoryProvider);
  final _digests = UploadDigestMemo();

  /// Görevdeki işlem bazlı yetkiler (sunum düğme görünürlüğünü buradan okur). Görev ya da
  /// erişim bilinmiyorsa hiçbir eylem açık değil.
  TaskPermissions get permissions {
    final t = _task;
    return t == null
        ? const TaskPermissions.none()
        : TaskPermissions.of(_catalog?.access, t);
  }

  void selectTab(TaskDetailTab t) => state = state.copyWith(tab: t);

  // ---- sunucu yazması --------------------------------------------------------------------

  /// Tek yazma kapısı: kilit → istek → (başarı, 409 ya da 403) yeniden okuma → kilit açılır.
  /// Yeniden okuma varsayılan olarak YALNIZ kalemdir: ayrıntı (`getWorkItem` + alt görev / not /
  /// dosya) okunur ve katalogdaki kalemin yerine geçer ([TaskCatalogController.applyDetails]).
  /// [list]: görev kümesi değişti (oluşturma, silme, zincirli tarih onayı) → liste de okunur.
  Future<WriteOutcome> _write(
    Future<void> Function() call, {
    required bool list,
    bool rereadOnError = false,
  }) async {
    if (state.busy) return WriteOutcome.busy;
    if (!_versionedServer) return _rejected(ClientErrorCode.serverOutdated);
    state = state.copyWith(busy: true);
    // Denetleyici istek sırasında kapanabilir (ekrandan çıkış): katalog yine yenilenir.
    final store = _store;
    try {
      try {
        await call();
      } on Object catch (e) {
        final err = toApiError(e);
        // Çok adımlı yazmada (düzenle + atama) ilk adımlar yazılmış olabilir: her hatada
        // yeniden okunur; tek adımlıda 409 ve 403'te. 403'te rol olguları da bayat olabilir
        // (koordinatörlük kaldırılmış): katalog yeniden kurulur → `/v1/me` +
        // `/v1/me/departments` yeniden okunur, [TaskAccess] ve eylem yetkileri yeniden
        // hesaplanır. Otomatik tekrar yok.
        if (isOutcomeUnknown(err)) {
          return WriteOutcome(
            WriteKind.unknown,
            ApiError(ClientErrorCode.outcomeUnknown, status: err.status),
          );
        }
        if (rereadOnError || _rereadAfter(err)) {
          await _reread(store, list: list || _isForbidden(err));
        }
        if (isKeyReused(err)) {
          return WriteOutcome(
            WriteKind.failed,
            ApiError(ClientErrorCode.requestNotResent, status: err.status),
          );
        }
        return WriteOutcome(
          err.code == 'work.subtasks_open'
              ? WriteKind.subtasksOpen
              : WriteKind.failed,
          err,
        );
      }
      await _reread(store, list: list);
      return WriteOutcome.done;
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  /// Sunucu uyum kapısı (CX-P0K-04, ADR-0027): bağlı sunucunun sürümü sürümlü yazmayı
  /// desteklemiyorsa ya da kalem `edit_revision` taşımıyorsa (eski backend) yazma gönderilmez
  /// (`client.server_outdated`): eski sunucu sürümü ve işlem anahtarını sessizce yok sayar.
  bool get _versionedServer =>
      serverSupportsVersionedWrites(ref.read(bindingStateProvider)) &&
      _task?.editRevision != null;

  /// Oluşturma eylemi (işlem anahtarlı, ADR-0027): [action] + [body] için anahtar alınır —
  /// aynı eylem ve gövdenin yeniden gönderimi (sonucu bilinmeyen isteğin tekrarı) AYNI anahtarı,
  /// değişen gövde yeni anahtarı alır. 409 `platform.conflict_retry` aynı anahtarla bir kez
  /// otomatik yeniden denenir. Anahtar başarıda ve "anahtar başka istekle kullanılmış"
  /// yanıtında düşer (sonraki gönderim yeni eylem); diğer hatalarda korunur.
  Future<WriteOutcome> _writeKeyed(
    String action,
    String body,
    Future<void> Function(String key) call, {
    required bool list,
  }) async {
    if (state.busy) return WriteOutcome.busy;
    final (keys, key) = state.keys.keyFor(action, body);
    state = state.copyWith(keys: keys);
    final r = await _write(() async {
      try {
        await call(key);
      } on ApiError catch (e) {
        if (e.code != conflictRetryCode) rethrow;
        await call(key);
      }
    }, list: list);
    if (ref.mounted &&
        (r.ok || r.error?.code == ClientErrorCode.requestNotResent)) {
      state = state.copyWith(keys: state.keys.clear(action));
    }
    return r;
  }

  /// Gönderilemeyen yeni alt görevin adı (sonuç bilinmiyor / hata; diyalog bununla açılır).
  String? get pendingSubtaskTitle => state.keys.pendingBody(_subtask);

  /// Çok adımlı yazmanın başladığı bağlam: oturum nesli + seçili kapsam (program, departman).
  ({int session, String? program, String? department}) _writeContext() {
    final sel = ref.read(scopeStateProvider);
    return (
      session: ref.read(sessionControllerProvider).generation,
      program: sel.programId,
      department: sel.departmentId,
    );
  }

  /// Bağlam değiştiyse sonraki adım gönderilmez: oturum değiştiyse `client.session_ended`,
  /// kapsam değiştiyse `client.scope_changed` (yazılmış adımlar yeniden okumayla görünür).
  void _ensureContext(({int session, String? program, String? department}) c) {
    final now = _writeContext();
    if (now.session != c.session) {
      throw ApiError(ClientErrorCode.sessionEnded);
    }
    if (now != c) throw ApiError(ClientErrorCode.scopeChanged);
  }

  /// Yazma sonrası yeniden okuma; okuma hatası ekranda (katalog/ayrıntı durumu) gösterilir.
  Future<void> _reread(
    TaskCatalogController store, {
    required bool list,
  }) async {
    // Liste: katalog yüklemeye geçince açık ayrıntı kendini geçersiz kılar
    // (taskDetailsProvider). Kalem: yalnız ayrıntı (tekil okuma) yeniden okunur.
    if (list) await store.reload();
    if (!ref.mounted) return;
    if (!list) ref.invalidate(taskDetailsProvider(code));
    final sub = ref.listen(taskDetailsProvider(code).future, (_, _) {});
    try {
      await sub.read();
    } on Object {
      // Ayrıntı hatası ekranda şeritle gösterilir.
    } finally {
      sub.close();
    }
  }

  // ---- durum, öncelik -------------------------------------------------------------------

  /// Durumu [s]'ye geçirir. Sunucuda uç ve hedefler [permissions]'tan; `tamamlandi`'dan
  /// çıkışta [reason] zorunlu. [closeSubtasks] yalnız kullanıcı "alt görevleri de kapat"
  /// dediğinde (409 `work.subtasks_open` sonrası) ve yalnız `tamamlandi` hedefinde.
  Future<WriteOutcome> setStatus(
    TaskStatus s, {
    String? reason,
    bool closeSubtasks = false,
  }) async {
    final t = _task;
    if (t == null || s == t.status) return WriteOutcome.unchanged;
    final perms = permissions;
    final via = perms.statusEndpoint;
    if (via == null || !perms.statusTargets(t.status).contains(s)) {
      return WriteOutcome.invalid;
    }
    final why = reason?.trim() ?? '';
    final needsReason = requiresRevertReason(t.status, s);
    if (needsReason && why.length < revertReasonMinLength) {
      return const WriteOutcome(WriteKind.reasonRequired);
    }
    return _write(
      () => _writes.changeStatus(
        t,
        via,
        s,
        reason: needsReason ? why : null,
        closeSubtasks: closeSubtasks && s == TaskStatus.done,
      ),
      list: false,
    );
  }

  /// Önceliği değiştirir (sunucuda `PATCH` yalnız `priority`; yönetici ya da koordinatör).
  Future<WriteOutcome> setPriority(TaskPriority p) async {
    final t = _task;
    if (t == null || t.priority == p) return WriteOutcome.unchanged;
    if (!permissions.canManageTask) return WriteOutcome.invalid;
    return _write(
      () => _writes.updateWorkItem(t, WorkItemPatch.diff(t, priority: p)),
      list: false,
    );
  }

  // ---- tarih talebi ---------------------------------------------------------------------

  /// Bekleyen talebi onaylar (yalnız şirket yöneticisi). Onay bağımlı görevleri zincirle
  /// öteleyebilir → liste de yeniden okunur; ret yalnız kalemi etkiler.
  Future<WriteOutcome> approveRequest() => _review(approve: true);

  Future<WriteOutcome> rejectRequest() => _review(approve: false);

  Future<WriteOutcome> _review({required bool approve}) async {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null || !r.isPending) return WriteOutcome.invalid;
    final id = r.id;
    if (id == null || !permissions.canReviewDate) return WriteOutcome.invalid;
    return _write(
      () => _writes.reviewDateChange(id, approve: approve),
      list: approve,
    );
  }

  /// İncelenmiş talebi siler (yalnız şirket yöneticisi; bekleyen silinemez).
  Future<WriteOutcome> deleteDateRequest() async {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null) return WriteOutcome.invalid;
    final id = r.id;
    if (id == null || !permissions.canDeleteDateRequest(r)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.deleteDateChange(id), list: false);
  }

  /// Talep formunu açar (bitiş +14 gün önerilir); bekleyen talep varsa ya da eylem bu
  /// hesaba açık değilse açmaz, false döner.
  bool openDateRequest() {
    final t = _task;
    if (t == null || t.hasPendingRequest) return false;
    if (!permissions.canRequestDate) return false;
    state = state.copyWith(
      dateDraft: () => DateRequestDraft(
        start: t.start,
        due: t.due.add(const Duration(days: 14)),
      ),
      showErrors: false,
    );
    return true;
  }

  void updateDateDraft(DateRequestDraft d) =>
      state = state.copyWith(dateDraft: () => d);

  /// Talebi gönderir (sunucuda yalnız kapsam koordinatörü; bekleyen varken 409
  /// `work.date_request_pending_exists` → yeniden okunur). Başarıda form kapanır.
  Future<WriteOutcome> submitDateRequest() async {
    final t = _task;
    final d = state.dateDraft;
    if (t == null || d == null || d.datesInvalid) return WriteOutcome.invalid;
    if (!permissions.canRequestDate) return WriteOutcome.invalid;
    final reason = d.reason.trim();
    final r = await _write(
      () => _writes.requestDateChange(
        t,
        d.start,
        d.due,
        reason: reason.isEmpty ? null : reason,
      ),
      list: false,
    );
    if (r.ok && ref.mounted) state = state.copyWith(dateDraft: () => null);
    return r;
  }

  // ---- düzenle --------------------------------------------------------------------------

  /// Düzenleme formunu açar. Sunucuda form açılmadan görev `getWorkItem` ile TAZE okunur
  /// (istemci akışları §8: `updateWorkItem` sürüm taşımaz, son yazan kazanır) ve taslak
  /// okunan değerden kurulur; okuma hatasında form AÇILMAZ ([WriteKind.failed] + hata kodu).
  /// Eylem bu hesaba açık değilse [WriteKind.invalid]; uçuştaki istekte [WriteKind.busy].
  Future<WriteOutcome> openEdit() async {
    final t = _task;
    if (t == null) return WriteOutcome.invalid;
    if (!permissions.canManageTask) return WriteOutcome.invalid;
    if (state.busy) return WriteOutcome.busy;
    state = state.copyWith(busy: true);
    final store = _store;
    try {
      final fresh = await ref.read(taskDetailsRepositoryProvider).loadItem(t);
      store.applyItem(code, fresh);
      final now = ref.mounted ? _task : null;
      if (now == null || !permissions.canManageTask) {
        return WriteOutcome.invalid;
      }
      _openEditFrom(now);
      return WriteOutcome.done;
    } on Object catch (e) {
      return WriteOutcome(WriteKind.failed, toApiError(e));
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  void _openEditFrom(TaskItem t) {
    state = state.copyWith(
      edit: () => TaskEditDraft(
        title: t.title,
        coordinatorship: t.coordinatorship,
        assignees: [...t.assignees],
        priority: t.priority,
        start: t.start,
        due: t.due,
        evidenceRequired: t.evidenceRequired,
        base: t,
      ),
      showErrors: false,
    );
  }

  void updateEdit(TaskEditDraft d) => state = state.copyWith(edit: () => d);

  /// Çakışan alan için kullanıcı seçimi (V3): [useServer] → sunucudaki değer, değilse
  /// kullanıcının değeri kalır. Seçimden sonra gönderim yeni tabanın sürümüyle gider.
  void resolveConflict(EditField f, {required bool useServer}) {
    final d = state.edit;
    final c = d?.conflicts[f];
    if (d == null || c == null) return;
    updateEdit(
      d
          .withValue(f, useServer ? c.server : c.local)
          .copyWith(conflicts: {...d.conflicts}..remove(f)),
    );
  }

  void editToggleAssignee(String id) {
    final d = state.edit;
    if (d == null) return;
    updateEdit(
      d.copyWith(
        assignees: d.assignees.contains(id)
            ? [
                for (final a in d.assignees)
                  if (a != id) a,
              ]
            : [...d.assignees, id],
      ),
    );
  }

  /// Kaydeder; eksik/geçersiz alan varsa hataları açar ([WriteKind.invalid]).
  ///
  /// Sunucuda: `PATCH` YALNIZ değişen alanlarla (başlık, öncelik, tarihler, kanıt bayrağı;
  /// yönetici ya da koordinatör), ardından atama farkı (eklenenler tek `addAssignments`,
  /// çıkarılanlar tek tek `removeAssignment`; YALNIZ koordinatör). Departman (koordinatörlük)
  /// bu formdan değişmez. Atamasız görev sunucuda geçerlidir. Sonuçta kalem (tekil okuma)
  /// yeniden okunur (hata olsa da: önceki adımlar yazılmış olabilir). Adımlar arasında oturum
  /// nesli ya da seçili kapsam değişirse kalan adımlar gönderilmez (`client.session_ended` /
  /// `client.scope_changed`).
  Future<WriteOutcome> submitEdit() async {
    final t = _task;
    final d = state.edit;
    if (t == null || d == null) return WriteOutcome.invalid;
    if (d.titleMissing || d.datesInvalid) {
      state = state.copyWith(showErrors: true);
      return WriteOutcome.invalid;
    }
    final perms = permissions;
    if (!perms.canManageTask) return WriteOutcome.invalid;
    // Seçilmemiş çakışma varken gönderilmez (karar kullanıcının).
    if (d.conflicts.isNotEmpty) {
      state = state.copyWith(showErrors: true);
      return const WriteOutcome(WriteKind.conflict);
    }
    // Fark ve sürümler formun AÇILIŞ tabanından (canlı katalog değil): açıkken tazelenen
    // katalogdaki yeni sunucu değeri, kullanıcının dokunmadığı alanda geri yazılmaz.
    final base = d.base ?? t;
    final patch = WorkItemPatch.diff(
      base,
      title: d.title.trim(),
      priority: d.priority,
      start: d.start,
      end: d.due,
      evidenceRequired: d.evidenceRequired,
    );
    // Atama farkı da tabana göre: başkasının bu arada eklediği atanan kaldırılmaz.
    final added = perms.canAssign
        ? [
            for (final a in d.assignees)
              if (!base.assignees.contains(a) && !t.assignees.contains(a)) a,
          ]
        : const <String>[];
    final removed = perms.canAssign
        ? [
            for (final a in base.assignees)
              if (!d.assignees.contains(a) && t.assignees.contains(a)) a,
          ]
        : const <String>[];
    if (patch.isEmpty && added.isEmpty && removed.isEmpty) {
      state = state.copyWith(edit: () => null, showErrors: false);
      return WriteOutcome.unchanged;
    }
    // Adımlar arasında oturum nesli ya da seçili kapsam değişirse kalan adımlar gitmez.
    final ctx = _writeContext();
    var first = true;
    Future<void> step(Future<void> Function() call) async {
      if (!first) _ensureContext(ctx);
      first = false;
      await call();
    }

    final r = await _write(
      () async {
        if (!patch.isEmpty) await step(() => _writes.updateWorkItem(t, patch));
        if (added.isNotEmpty) {
          await step(() => _writes.addAssignments(t, added));
        }
        for (final a in removed) {
          await step(() => _writes.removeAssignment(t, a));
        }
      },
      // Tarih değişikliği bağımlı görevleri aynı işlemde öteleyebilir (WORK-K28): liste de
      // yeniden okunur; diğer alanlarda yalnız kalem.
      list: patch.start != null || patch.end != null,
      rereadOnError: true,
    );
    if (r.ok && ref.mounted) {
      state = state.copyWith(edit: () => null, showErrors: false);
    }
    if (r.error?.code == _editConflict && ref.mounted) {
      // Görev yeniden okundu: taban / yerel / sunucu ayrılır, aynı alandaki fark seçime kalır.
      final fresh = _task;
      final now = state.edit;
      if (fresh != null && now != null) {
        updateEdit(mergeEditDraft(now, fresh, stale: _staleFields(r.error!)));
      }
      return WriteOutcome(WriteKind.conflict, r.error);
    }
    return r;
  }

  /// Atamasız görevi üstlenir (yalnız kapsam koordinatörü).
  Future<WriteOutcome> claim() async {
    final t = _task;
    if (t == null || !permissions.canClaim(t)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.claim(t), list: false);
  }

  /// Kendi atamasını bırakır (koordinatör; tamamlanmış görevde değil).
  Future<WriteOutcome> unclaim() async {
    final t = _task;
    if (t == null || !permissions.canUnclaim(t)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.unclaim(t), list: false);
  }

  // ---- kanıt yükle ----------------------------------------------------------------------

  /// Yükleme formunu açar; alt görev önseçilmez (alt görevde kanıt bayrağı yok, ADR-0024).
  /// Sunucuda yalnız yükleme yetkisi varsa (koordinatör ya da atanmış üye; yönetici hayır).
  bool openUpload() {
    if (_task == null || !permissions.canUpload) return false;
    state = state.copyWith(
      upload: () => const UploadDraft(tag: EvidenceTag.outcome, name: ''),
      showErrors: false,
    );
    return true;
  }

  void updateUpload(UploadDraft d) => state = state.copyWith(upload: () => d);

  /// Dosya seçer (içerik okunmaz): seçim → done; yok/vazgeçme → unchanged; hata → failed.
  Future<WriteOutcome> pickUploadFile(UploadOrigin origin) async {
    final picker = ref.read(uploadPickerProvider);
    if (!picker.available) return WriteOutcome.unchanged;
    final UploadSource? f;
    try {
      f = await picker.pick(origin);
    } on ApiError catch (e) {
      return WriteOutcome(WriteKind.failed, e);
    }
    final d = state.upload;
    if (f == null || d == null || !ref.mounted) return WriteOutcome.unchanged;
    final next = d.copyWith(file: () => f, name: f.name);
    state = state.copyWith(upload: () => next);
    return WriteOutcome.done;
  }

  /// Dosyayı yükler, Dosya sekmesine geçer. Yerel denetim (istek yok, metin koddan): seçim yok
  /// → invalid; tür dışı → `records.content_rejected`; 90 MiB → `records.too_large`; 30 dosya
  /// → `records.too_many_files`. İçerik özeti ([UploadDigestMemo]) bunlardan SONRA alınır
  /// (sınır dışı dosya okunmaz). Başarıda yalnız ayrıntı okunur (liste dosya taşımaz).
  Future<WriteOutcome> submitUpload() async {
    final t = _task;
    final d = state.upload;
    if (t == null || d == null) return WriteOutcome.invalid;
    if (!permissions.canUpload) return WriteOutcome.invalid;
    final f = d.file;
    if (f == null) {
      state = state.copyWith(showErrors: true);
      return WriteOutcome.invalid;
    }
    if (!uploadTags.contains(d.tag)) return WriteOutcome.invalid;
    if (f.contentType == null) return _rejected('records.content_rejected');
    if (f.tooLarge) return _rejected('records.too_large');
    if (t.fileEntries.length >= uploadMaxFilesPerTask) {
      return _rejected('records.too_many_files');
    }
    final String? digest;
    try {
      digest = await _digests.of(ref, f);
    } on ApiError catch (e) {
      return WriteOutcome(WriteKind.failed, e);
    }
    if (digest == null || !ref.mounted) return WriteOutcome.unchanged;
    final r = await _writeKeyed(
      _upload,
      // Yol imzada yok (yeniden seçim aynı anahtar); özet var: farklı içerik yeni anahtar (§8).
      '${f.name}|${f.sizeBytes}|$digest|${d.tag.name}|${d.subtask}',
      (key) => _writes.attachFile(
        t,
        f,
        d.tag,
        subtaskId: d.subtask,
        requestKey: key,
      ),
      list: false,
    );
    if (r.ok && ref.mounted) {
      state = state.copyWith(
        upload: () => null,
        showErrors: false,
        tab: TaskDetailTab.files,
      );
    }
    return r;
  }

  /// Görünen adı değiştirir (yönetici, koordinatör ya da ekip satırlı yükleyen).
  Future<WriteOutcome> renameFile(TaskFile file, String name) async {
    final t = _task;
    final v = name.trim();
    if (t == null || v.isEmpty) return WriteOutcome.invalid;
    if (v == file.name) return WriteOutcome.unchanged;
    if (!permissions.canRenameFile(file)) return WriteOutcome.invalid;
    return _write(() => _writes.renameFile(t, file.id, v), list: false);
  }

  /// Dosyayı siler (yalnız yükleyen, ekip satırı varken).
  Future<WriteOutcome> deleteFile(TaskFile file) async {
    final t = _task;
    if (t == null) return WriteOutcome.invalid;
    if (!permissions.canDeleteFile(file)) return WriteOutcome.invalid;
    return _write(() => _writes.deleteFile(t, file.id), list: false);
  }

  /// Dosyayı akışla indirir ve parça parça kaydeder (belleğe toplanmaz); kaydedilen yol döner. Okumadır: yeniden okuma yok, kilit
  /// var (çift dokunma = tek istek).
  Future<(WriteOutcome, String?)> downloadFile(TaskFile file) async {
    final t = _task;
    if (t == null || !permissions.canDownloadFile) {
      return (WriteOutcome.invalid, null);
    }
    if (state.busy) return (WriteOutcome.busy, null);
    state = state.copyWith(busy: true);
    final sink = ref.read(downloadSinkProvider);
    try {
      final bytes = await _writes.downloadFile(t, file.id);
      return (WriteOutcome.done, await sink.save(file.name, bytes));
    } on Object catch (e) {
      return (WriteOutcome(WriteKind.failed, toApiError(e)), null);
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  void closeForms() => state = state.copyWith(
    edit: () => null,
    dateDraft: () => null,
    upload: () => null,
    showErrors: false,
  );

  // ---- sil, kopyala ---------------------------------------------------------------------

  /// Görevi siler: yumuşak silme (yönetici ya da koordinatör) + katalog yeniden okunur; geri
  /// alma yok (silinen görevler yönetici yüzündedir).
  Future<WriteOutcome> delete() async {
    final t = _task;
    if (t == null || !permissions.canManageTask) return WriteOutcome.invalid;
    final r = await _write(() => _writes.deleteWorkItem(t), list: true);
    if (r.ok && ref.mounted) state = state.copyWith(deleted: () => t);
    return r;
  }

  /// Görevin kopyasını oluşturur; yeni görevin sunucu kimliğini döner. `createWorkItem`: aynı departman, başlık + [suffix], tarihler, öncelik, kanıt
  /// bayrağı; sunucu tek atanan aldığından ilk atanan (yoksa atamasız). Katalog yeniden okunur.
  Future<(WriteOutcome, String?)> copy(String suffix) async {
    final t = _task;
    final c = _catalog;
    if (t == null || c == null) return (WriteOutcome.invalid, null);
    final dept = t.departmentId;
    final program = t.programId;
    if (dept == null || program == null || !permissions.canManageTask) {
      return (WriteOutcome.invalid, null);
    }
    String? id;
    final draft = WorkItemDraft(
      programId: program,
      departmentId: dept,
      title: '${t.title} $suffix',
      start: t.start,
      end: t.due,
      priority: t.priority == TaskPriority.unknown ? null : t.priority,
      assignee: t.assignees.firstOrNull,
      evidenceRequired: t.evidenceRequired,
    );
    final r = await _writeKeyed(
      _copy,
      draft.signature,
      (key) async => id = await _writes.createWorkItem(draft, requestKey: key),
      list: true,
    );
    return (r, r.ok ? id : null);
  }

  // ---- alt görevler ---------------------------------------------------------------------

  Subtask? _sub(String id) =>
      _task?.subtasks.where((s) => s.id == id).firstOrNull;

  /// Sunucu alt görev değişikliği; alt görev sayıları tekil okumayla kalemde yenilenir.
  /// Başlık/atanan/tarih değişikliği alt görevin okunan sürümünü taşır (ADR-0027); yalnız
  /// işaretleme ([SubtaskPatch.done]) sürüm istemez.
  Future<WriteOutcome> _patchSub(String id, SubtaskPatch patch) {
    final t = _task;
    final u = _sub(id);
    if (t == null || u == null) return Future.value(WriteOutcome.invalid);
    final versioned =
        patch.title != null || patch.assignee != null || patch.dates != null;
    final rev = u.editRevision;
    if (versioned && rev == null) {
      return Future.value(_rejected(ClientErrorCode.serverOutdated));
    }
    final body = SubtaskPatch(
      title: patch.title,
      assignee: patch.assignee,
      dates: patch.dates,
      done: patch.done,
      expectedRevision: versioned ? rev : null,
    );
    return _write(() => _writes.updateSubtask(t, id, body), list: false);
  }

  /// İşaretler/kaldırır. Alt görevde kanıt bayrağı yok (ADR-0024): kanıt kapısı görev
  /// seviyesindedir ([TaskItem.evidenceRequired]). Yetki [TaskPermissions.canToggleSubtask].
  Future<WriteOutcome> toggleSubtask(String id) async {
    final u = _sub(id);
    if (u == null) return WriteOutcome.invalid;
    if (!permissions.canToggleSubtask(u)) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(done: !u.done));
  }

  void toggleSubtaskOpen(String id) {
    final s = {...state.openSubtasks};
    if (!s.remove(id)) s.add(id);
    state = state.copyWith(openSubtasks: s);
  }

  /// [title] başlıklı alt görev açar (yönetici ya da koordinatör; tamamlanmış
  /// görevde 409 `work.item_completed`, tavan 50 → 409 `work.subtask_limit_reached`).
  Future<WriteOutcome> createSubtask(String title) async {
    final t = _task;
    final name = title.trim();
    if (t == null || name.isEmpty) return WriteOutcome.invalid;
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _writeKeyed(
      _subtask,
      name,
      (key) => _writes.createSubtask(t, name, requestKey: key),
      list: false,
    );
  }

  /// Başlığı değiştirir (yönetici ya da koordinatör).
  Future<WriteOutcome> renameSubtask(String id, String title) async {
    final u = _sub(id);
    final name = title.trim();
    if (u == null || name.isEmpty) return WriteOutcome.invalid;
    if (name == u.title) return WriteOutcome.unchanged;
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _writeText(
      (TextTarget.subtask, id),
      name,
      () => _patchSub(id, SubtaskPatch(title: name)),
      serverText: () => _sub(id)?.title,
    );
  }

  /// Tek metinli düzenleme (not içeriği, alt görev adı): metin [key] altında state'te tutulur;
  /// başarıda düşer. 409 `work.edit_conflict`'te kayıt yeniden okunmuştur: sunucudaki metin
  /// [WriteOutcome.serverText] ile döner, iki seçenekli karar sunumdadır.
  Future<WriteOutcome> _writeText(
    TextDraftKey key,
    String text,
    Future<WriteOutcome> Function() write, {
    required String? Function() serverText,
  }) async {
    state = state.copyWith(textDrafts: {...state.textDrafts, key: text});
    final r = await write();
    if (!ref.mounted) return r;
    if (r.ok) discardTextDraft(key);
    if (r.error?.code == _editConflict) {
      return WriteOutcome(WriteKind.conflict, r.error, serverText());
    }
    return r;
  }

  /// Atananı değiştirir; null → kaldır. Aday yalnız ana görevin atananları.
  Future<WriteOutcome> setSubtaskAssignee(String id, String? person) async {
    final u = _sub(id);
    if (u == null) return WriteOutcome.invalid;
    if (u.assignee == person) return WriteOutcome.unchanged;
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(assignee: (id: person)));
  }

  /// Tarihleri yazar. Sunucu başlangıç ve bitişi birlikte ister: eksik uç seçilen güne
  /// eşitlenir; bitiş başlangıçtan önceyse başlangıca çekilir.
  Future<WriteOutcome> _setSubtaskDates(
    String id,
    DateTime? start,
    DateTime? end,
  ) async {
    final u = _sub(id);
    if (u == null) return WriteOutcome.invalid;
    if (u.start == start && u.end == end) return WriteOutcome.unchanged;
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(dates: (start: start, end: end)));
  }

  /// Başlangıç; sonrasındaki bitiş başlangıçtan önceyse başlangıca çekilir. Bitiş yoksa
  /// başlangıç gününe eşitlenir (iki gün birlikte gider).
  Future<WriteOutcome> setSubtaskStart(String id, DateTime? d) {
    final u = _sub(id);
    if (u == null) return Future.value(WriteOutcome.invalid);
    if (d == null) return clearSubtaskDates(id);
    final end = u.end != null && !u.end!.isBefore(d) ? u.end : d;
    return _setSubtaskDates(id, d, end);
  }

  /// Bitiş; başlangıç yoksa (ya da sonraysa) bitiş gününe eşitlenir.
  Future<WriteOutcome> setSubtaskEnd(String id, DateTime? d) {
    final u = _sub(id);
    if (u == null) return Future.value(WriteOutcome.invalid);
    if (d == null) return clearSubtaskDates(id);
    final start = u.start != null && !u.start!.isAfter(d) ? u.start : d;
    return _setSubtaskDates(id, start, d);
  }

  Future<WriteOutcome> clearSubtaskDates(String id) =>
      _setSubtaskDates(id, null, null);

  /// Alt görevi kaldırır; sonuç ve kaldırılan (bildirim metni için).
  Future<(WriteOutcome, Subtask?)> removeSubtask(String id) async {
    final t = _task;
    final u = _sub(id);
    if (t == null || u == null) return (WriteOutcome.invalid, null);
    if (!permissions.canManageSubtasks) return (WriteOutcome.invalid, u);
    return (await _write(() => _writes.deleteSubtask(t, id), list: false), u);
  }

  // ---- notlar ---------------------------------------------------------------------------

  void setNoteDraft(String v) => state = state.copyWith(noteDraft: v);

  /// Taslağı not olarak ekler (koordinatör ya da atanmış üye; yönetici yazamaz). Başarıda
  /// taslak temizlenir.
  Future<WriteOutcome> sendNote() async {
    final t = _task;
    final text = state.noteDraft.trim();
    if (t == null || text.isEmpty) return WriteOutcome.invalid;
    if (!permissions.canAddNote) return WriteOutcome.invalid;
    final r = await _writeKeyed(
      _note,
      text,
      (key) => _writes.addNote(t, text, requestKey: key),
      list: false,
    );
    if (r.ok && ref.mounted) state = state.copyWith(noteDraft: '');
    return r;
  }

  /// Notu [text] ile değiştirir (yalnız yazarı).
  Future<WriteOutcome> editNote(TaskNote note, String text) async {
    final t = _task;
    final v = text.trim();
    final id = note.id;
    if (t == null || v.isEmpty || id == null) return WriteOutcome.invalid;
    if (v == note.text) return WriteOutcome.unchanged;
    if (!permissions.canEditNote(note)) return WriteOutcome.invalid;
    final rev = note.editRevision;
    if (rev == null) return _rejected(ClientErrorCode.serverOutdated);
    return _writeText(
      (TextTarget.note, id),
      v,
      () => _write(
        () => _writes.updateNote(t, id, v, expectedRevision: rev),
        list: false,
      ),
      serverText: () =>
          _task?.noteEntries.where((n) => n.id == id).firstOrNull?.text,
    );
  }

  /// Notun gönderilemeyen düzenleme metni (yoksa null).
  String? noteEditDraft(TaskNote note) =>
      state.textDrafts[(TextTarget.note, note.id ?? '')];

  /// Alt görevin gönderilemeyen yeni adı (yoksa null).
  String? subtaskRenameDraft(String id) =>
      state.textDrafts[(TextTarget.subtask, id)];

  /// Metin taslağını bırakır (kullanıcı sunucudaki metni seçti ya da vazgeçti).
  void discardTextDraft(TextDraftKey key) =>
      state = state.copyWith(textDrafts: {...state.textDrafts}..remove(key));

  /// Notu siler (yalnız yazarı).
  Future<WriteOutcome> deleteNote(TaskNote note) async {
    final t = _task;
    final id = note.id;
    if (t == null || id == null) return WriteOutcome.invalid;
    if (!permissions.canEditNote(note)) return WriteOutcome.invalid;
    return _write(() => _writes.deleteNote(t, id), list: false);
  }
}
