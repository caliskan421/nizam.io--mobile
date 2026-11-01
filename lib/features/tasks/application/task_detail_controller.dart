import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import '../domain/task_writes.dart';
import 'task_catalog_controller.dart';
import 'task_details_controller.dart';
import 'tasks_providers.dart';

part 'task_detail_controller.g.dart';

/// Ayrıntı sekmeleri.
enum TaskDetailTab { summary, subtasks, files, notes }

/// Yazma komutunun sonuç türü (bildirim metnini sunum seçer).
enum WriteKind {
  /// Yazıldı (sunucuda: başarı + yeniden okuma).
  done,

  /// Değişiklik yok (aynı değer); istek gönderilmedi.
  unchanged,

  /// Önceki istek uçuşta; istek gönderilmedi (çift dokunma = tek istek).
  busy,

  /// Eylem bu görevde bu hesaba açık değil ya da girdi geçersiz; istek gönderilmedi.
  invalid,

  /// Geri alma gerekçesi eksik/kısa ([revertReasonMinLength]); istek gönderilmedi.
  reasonRequired,

  /// Sunucu 409 `work.subtasks_open`: kullanıcıya "alt görevleri de kapat" sorulur; onaylarsa
  /// aynı geçiş `closeSubtasks: true` ile yeniden gönderilir (kullanıcı kararı; otomatik değil).
  subtasksOpen,

  /// Sunucu hatası ([WriteOutcome.error]; metin hata kodundan).
  failed,

  /// Örnek katalog kuralları: açık alt görev / kanıt dosyası yok.
  blockedBySubtasks,
  blockedByEvidence,
}

/// Yazma komutunun sonucu.
@immutable
final class WriteOutcome {
  const WriteOutcome(this.kind, [this.error]);

  static const done = WriteOutcome(WriteKind.done);
  static const unchanged = WriteOutcome(WriteKind.unchanged);
  static const busy = WriteOutcome(WriteKind.busy);
  static const invalid = WriteOutcome(WriteKind.invalid);

  final WriteKind kind;
  final ApiError? error;

  bool get ok => kind == WriteKind.done;
}

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

/// Yerel ön denetimin hatası: istek gönderilmez, metin yine koddan (sunucu kataloğundaki kod).
WriteOutcome _rejected(String code) =>
    WriteOutcome(WriteKind.failed, ApiError(code));

/// "Görevi düzenle" taslağı.
@immutable
final class TaskEditDraft {
  const TaskEditDraft({
    required this.title,
    required this.coordinatorship,
    required this.assignees,
    required this.priority,
    required this.start,
    required this.due,
    this.evidenceRequired = false,
    this.membersOpen = false,
  });

  final String title;
  final String coordinatorship;
  final List<String> assignees;
  final TaskPriority priority;
  final DateTime start;
  final DateTime due;
  final bool evidenceRequired;
  final bool membersOpen;

  bool get titleMissing => title.trim().isEmpty;
  bool get assigneesMissing => assignees.isEmpty;
  bool get datesInvalid => due.isBefore(start);

  TaskEditDraft copyWith({
    String? title,
    String? coordinatorship,
    List<String>? assignees,
    TaskPriority? priority,
    DateTime? start,
    DateTime? due,
    bool? evidenceRequired,
    bool? membersOpen,
  }) => TaskEditDraft(
    title: title ?? this.title,
    coordinatorship: coordinatorship ?? this.coordinatorship,
    assignees: assignees ?? this.assignees,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    due: due ?? this.due,
    evidenceRequired: evidenceRequired ?? this.evidenceRequired,
    membersOpen: membersOpen ?? this.membersOpen,
  );
}

/// "Tarih değişikliği iste" taslağı.
@immutable
final class DateRequestDraft {
  const DateRequestDraft({
    required this.start,
    required this.due,
    this.reason = '',
  });

  final DateTime start;
  final DateTime due;
  final String reason;

  bool get datesInvalid => due.isBefore(start);

  DateRequestDraft copyWith({DateTime? start, DateTime? due, String? reason}) =>
      DateRequestDraft(
        start: start ?? this.start,
        due: due ?? this.due,
        reason: reason ?? this.reason,
      );
}

/// "Kanıt dosyası yükle" taslağı.
@immutable
final class UploadDraft {
  const UploadDraft({
    this.subtask,
    required this.tag,
    required this.name,
    this.file,
  });

  final String? subtask;
  final EvidenceTag tag;
  final String name;

  /// Sunucuda seçilen yerel dosya (örnekte yok; ad elle yazılır).
  final UploadSource? file;

  UploadDraft copyWith({
    String? Function()? subtask,
    EvidenceTag? tag,
    String? name,
    UploadSource? Function()? file,
  }) => UploadDraft(
    subtask: subtask == null ? this.subtask : subtask(),
    tag: tag ?? this.tag,
    name: name ?? this.name,
    file: file == null ? this.file : file(),
  );
}

/// Ayrıntı ekranının yerel durumu; görev verisi katalogdadır.
@immutable
final class TaskDetailState {
  const TaskDetailState({
    this.tab = TaskDetailTab.summary,
    this.openSubtasks = const {},
    this.editingSubtask,
    this.deleted,
    this.deletedIndex = -1,
    this.noteDraft = '',
    this.edit,
    this.dateDraft,
    this.upload,
    this.showErrors = false,
    this.seq = 1,
    this.busy = false,
  });

  final TaskDetailTab tab;
  final Set<String> openSubtasks;
  final String? editingSubtask;

  /// Silinen görev (geri almak için) ve katalogdaki eski sırası.
  final TaskItem? deleted;
  final int deletedIndex;
  final String noteDraft;
  final TaskEditDraft? edit;
  final DateRequestDraft? dateDraft;
  final UploadDraft? upload;

  /// Açık formda doğrulama hataları gösterilsin mi (ilk gönderme denemesinden sonra).
  final bool showErrors;
  final int seq;

  /// Sunucu yazması uçuşta: yeni yazma komutu istek göndermez ([WriteKind.busy]).
  final bool busy;

  TaskDetailState copyWith({
    TaskDetailTab? tab,
    Set<String>? openSubtasks,
    String? Function()? editingSubtask,
    TaskItem? Function()? deleted,
    int? deletedIndex,
    String? noteDraft,
    TaskEditDraft? Function()? edit,
    DateRequestDraft? Function()? dateDraft,
    UploadDraft? Function()? upload,
    bool? showErrors,
    int? seq,
    bool? busy,
  }) => TaskDetailState(
    tab: tab ?? this.tab,
    openSubtasks: openSubtasks ?? this.openSubtasks,
    editingSubtask: editingSubtask == null
        ? this.editingSubtask
        : editingSubtask(),
    deleted: deleted == null ? this.deleted : deleted(),
    deletedIndex: deletedIndex ?? this.deletedIndex,
    noteDraft: noteDraft ?? this.noteDraft,
    edit: edit == null ? this.edit : edit(),
    dateDraft: dateDraft == null ? this.dateDraft : dateDraft(),
    upload: upload == null ? this.upload : upload(),
    showErrors: showErrors ?? this.showErrors,
    seq: seq ?? this.seq,
    busy: busy ?? this.busy,
  );
}

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`).
///
/// Sunucu kataloğunda (P2: durum, not, alt görev) yazma [TaskWriteRepository]'ye gider:
/// iyimser güncelleme YOK; başarıdan sonra ilgili kaynak yeniden okunur (liste etkileniyorsa
/// katalog — durum, `subtask_counts` — ve ayrıntı; yalnız not ise ayrıntı). Uçuştaki yazma
/// varken yeni yazma istek göndermez ([TaskDetailState.busy]). 409'da yeniden okunur, sonuç
/// [WriteKind.failed]/[WriteKind.subtasksOpen] döner; otomatik tekrar yok. Eylem
/// görünürlüğü [permissions]'tan (işlem bazlı olgular).
///
/// P3: öncelik/düzenle/kopyala/sil, atama ve üstlen/bırak, tarih talebi aç/karar/sil,
/// dosya yükle/adlandır/sil/indir de aynı kapıdan gider. Örnek katalogda değişiklik katalog
/// denetleyicisinde bellekte kalır.
@riverpod
class TaskDetailController extends _$TaskDetailController {
  @override
  TaskDetailState build(String code) => const TaskDetailState();

  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);
  TaskCatalogController get _store =>
      ref.read(taskCatalogControllerProvider.notifier);
  TaskWriteRepository get _writes => ref.read(taskWriteRepositoryProvider);

  /// Katalog sunucudan mı (yazmalar sunucuya gider).
  bool get _server => _catalog?.access != null;

  void _save(TaskItem t) => _store.replace(t);

  /// Görevdeki işlem bazlı yetkiler (sunum düğme görünürlüğünü buradan okur).
  TaskPermissions get permissions {
    final t = _task;
    return t == null
        ? const TaskPermissions.local()
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
        if (rereadOnError || _rereadAfter(err)) {
          await _reread(store, list: list || _isForbidden(err));
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
    if (!_server) return _setStatusLocal(t, s);
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

  WriteOutcome _setStatusLocal(TaskItem t, TaskStatus s) {
    if (s == TaskStatus.done && t.subtasks.any((u) => !u.done)) {
      return const WriteOutcome(WriteKind.blockedBySubtasks);
    }
    if (s == TaskStatus.done && t.fileEntries.isEmpty) {
      return const WriteOutcome(WriteKind.blockedByEvidence);
    }
    _save(
      t.copyWith(
        status: s,
        completedAt: () => s == TaskStatus.done ? _catalog!.today : null,
      ),
    );
    return WriteOutcome.done;
  }

  /// Önceliği değiştirir (sunucuda `PATCH` yalnız `priority`; yönetici ya da koordinatör).
  Future<WriteOutcome> setPriority(TaskPriority p) async {
    final t = _task;
    if (t == null || t.priority == p) return WriteOutcome.unchanged;
    if (!_server) {
      _save(t.copyWith(priority: p));
      return WriteOutcome.done;
    }
    if (!permissions.canManageTask) return WriteOutcome.invalid;
    return _write(
      () => _writes.updateWorkItem(t, WorkItemPatch(priority: p)),
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
    if (!_server) {
      _save(
        approve
            ? t.copyWith(
                start: r.start,
                due: r.due,
                dateRequest: () => r.withState(DateRequestState.approved),
              )
            : t.copyWith(
                dateRequest: () => r.withState(DateRequestState.rejected),
              ),
      );
      return WriteOutcome.done;
    }
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
    if (t == null || r == null || !_server) return WriteOutcome.invalid;
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
    if (_server && !permissions.canRequestDate) return false;
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
    if (!_server) {
      final today = _catalog!.today;
      _save(
        t.copyWith(
          dateRequest: () => DateChangeRequest(
            by: _catalog!.me,
            at: DateTime(today.year, today.month, today.day, 14, 5),
            oldDue: t.due,
            start: d.start,
            due: d.due,
            reason: d.reason.trim(),
          ),
        ),
      );
      state = state.copyWith(dateDraft: () => null);
      return WriteOutcome.done;
    }
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
    if (!_server) {
      _openEditFrom(t);
      return WriteOutcome.done;
    }
    if (!permissions.canManageTask) return WriteOutcome.invalid;
    if (state.busy) return WriteOutcome.busy;
    state = state.copyWith(busy: true);
    final store = _store;
    try {
      final fresh = await ref.read(taskDetailsRepositoryProvider).loadItem(t);
      if (fresh == null) return WriteOutcome.invalid;
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
      ),
      showErrors: false,
    );
  }

  void updateEdit(TaskEditDraft d) => state = state.copyWith(edit: () => d);

  /// Koordinatörlük değişince yalnız yeni ekipte olan atananlar kalır.
  void editCoordinatorship(String code) {
    final d = state.edit;
    final team = _catalog?.coordinatorship(code)?.team ?? const <String>[];
    if (d == null) return;
    updateEdit(
      d.copyWith(
        coordinatorship: code,
        assignees: [
          for (final a in d.assignees)
            if (team.contains(a)) a,
        ],
      ),
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
    final missingAssignee = !_server && d.assigneesMissing;
    if (d.titleMissing || missingAssignee || d.datesInvalid) {
      state = state.copyWith(showErrors: true);
      return WriteOutcome.invalid;
    }
    if (!_server) {
      _save(
        t.copyWith(
          title: d.title.trim(),
          coordinatorship: d.coordinatorship,
          assignees: d.assignees,
          priority: d.priority,
          start: d.start,
          due: d.due,
          evidenceRequired: d.evidenceRequired,
        ),
      );
      state = state.copyWith(edit: () => null, showErrors: false);
      return WriteOutcome.done;
    }
    final perms = permissions;
    if (!perms.canManageTask) return WriteOutcome.invalid;
    final patch = WorkItemPatch.diff(
      t,
      title: d.title.trim(),
      priority: d.priority,
      start: d.start,
      end: d.due,
      evidenceRequired: d.evidenceRequired,
    );
    final added = perms.canAssign
        ? [
            for (final a in d.assignees)
              if (!t.assignees.contains(a)) a,
          ]
        : const <String>[];
    final removed = perms.canAssign
        ? [
            for (final a in t.assignees)
              if (!d.assignees.contains(a)) a,
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
    return r;
  }

  /// Atamasız görevi üstlenir (yalnız kapsam koordinatörü).
  Future<WriteOutcome> claim() async {
    final t = _task;
    if (t == null || !_server || !permissions.canClaim(t)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.claim(t), list: false);
  }

  /// Kendi atamasını bırakır (koordinatör; tamamlanmış görevde değil).
  Future<WriteOutcome> unclaim() async {
    final t = _task;
    if (t == null || !_server || !permissions.canUnclaim(t)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.unclaim(t), list: false);
  }

  // ---- kanıt yükle ----------------------------------------------------------------------

  /// Yükleme formunu açar; alt görev önseçilmez (alt görevde kanıt bayrağı yok, ADR-0024).
  /// Sunucuda yalnız yükleme yetkisi varsa (koordinatör ya da atanmış üye; yönetici hayır).
  bool openUpload() {
    if (_task == null) return false;
    if (_server && !permissions.canUpload) return false;
    state = state.copyWith(
      upload: () => _server
          ? const UploadDraft(tag: EvidenceTag.outcome, name: '')
          : const UploadDraft(
              tag: EvidenceTag.result,
              name: 'Saha_fotografi_20261021.jpg',
            ),
      showErrors: false,
    );
    return true;
  }

  void updateUpload(UploadDraft d) => state = state.copyWith(upload: () => d);

  /// Sistem seçicisinden dosya seçer (sunucu). Seçici yoksa ya da vazgeçilirse false.
  Future<bool> pickUploadFile() async {
    final picker = ref.read(uploadPickerProvider);
    if (!picker.available) return false;
    final f = await picker.pick();
    final d = state.upload;
    if (f == null || d == null || !ref.mounted) return false;
    state = state.copyWith(
      upload: () => d.copyWith(file: () => f, name: f.name),
    );
    return true;
  }

  /// Dosyayı yükler ve Dosya sekmesine geçer. Sunucuda istek öncesi yerel denetim (istek
  /// gönderilmez, metin yine koddan): dosya seçilmemiş → [WriteKind.invalid]; izinli tür
  /// dışı → `records.content_rejected`; 90 MiB → `records.too_large`; görevde 30 dosya →
  /// `records.too_many_files`. Başarıda yalnız ayrıntı yeniden okunur (liste dosya taşımaz).
  Future<WriteOutcome> submitUpload() async {
    final t = _task;
    final d = state.upload;
    if (t == null || d == null) return WriteOutcome.invalid;
    if (_server) return _submitUploadServer(t, d);
    final name = d.name.trim();
    if (name.isEmpty) {
      state = state.copyWith(showErrors: true);
      return WriteOutcome.invalid;
    }
    final lower = name.toLowerCase();
    final kind = lower.endsWith('.pdf')
        ? TaskFileKind.pdf
        : RegExp(r'\.(docx?|xlsx?)$').hasMatch(lower)
        ? TaskFileKind.doc
        : TaskFileKind.image;
    final seq = state.seq + 1;
    final file = TaskFile(
      id: 'f$seq',
      kind: kind,
      name: name,
      tag: d.tag,
      by: _catalog!.me,
      sizeKb: 120 + (seq * 53) % 700,
      subtask: d.subtask,
    );
    _save(
      t.copyWith(
        fileEntries: [file, ...t.fileEntries],
        subtasks: [
          for (final u in t.subtasks)
            u.id == d.subtask ? u.copyWith(evidence: name) : u,
        ],
      ),
    );
    state = state.copyWith(
      upload: () => null,
      showErrors: false,
      seq: seq,
      tab: TaskDetailTab.files,
    );
    return WriteOutcome.done;
  }

  Future<WriteOutcome> _submitUploadServer(TaskItem t, UploadDraft d) async {
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
    final r = await _write(
      () => _writes.attachFile(t, f, d.tag, subtaskId: d.subtask),
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
    if (t == null || v.isEmpty || !_server) return WriteOutcome.invalid;
    if (v == file.name) return WriteOutcome.unchanged;
    if (!permissions.canRenameFile(file)) return WriteOutcome.invalid;
    return _write(() => _writes.renameFile(t, file.id, v), list: false);
  }

  /// Dosyayı siler (yalnız yükleyen, ekip satırı varken).
  Future<WriteOutcome> deleteFile(TaskFile file) async {
    final t = _task;
    if (t == null || !_server) return WriteOutcome.invalid;
    if (!permissions.canDeleteFile(file)) return WriteOutcome.invalid;
    return _write(() => _writes.deleteFile(t, file.id), list: false);
  }

  /// Dosyayı indirir ve kaydeder; kaydedilen yol döner. Okumadır: yeniden okuma yok, kilit
  /// var (çift dokunma = tek istek).
  Future<(WriteOutcome, String?)> downloadFile(TaskFile file) async {
    final t = _task;
    if (t == null || !_server || !permissions.canDownloadFile) {
      return (WriteOutcome.invalid, null);
    }
    if (state.busy) return (WriteOutcome.busy, null);
    state = state.copyWith(busy: true);
    final sink = ref.read(downloadSinkProvider);
    try {
      final Uint8List bytes = await _writes.downloadFile(t, file.id);
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

  /// Görevi siler. Sunucuda yumuşak silme (yönetici ya da koordinatör) + katalog yeniden
  /// okunur; geri alma sunucuda yok (silinen görevler yönetici yüzündedir).
  Future<WriteOutcome> delete() async {
    final t = _task;
    if (t == null) return WriteOutcome.invalid;
    if (!_server) {
      final i = _store.remove(code);
      state = state.copyWith(deleted: () => t, deletedIndex: i);
      return WriteOutcome.done;
    }
    if (!permissions.canManageTask) return WriteOutcome.invalid;
    final r = await _write(() => _writes.deleteWorkItem(t), list: true);
    if (r.ok && ref.mounted) {
      state = state.copyWith(deleted: () => t, deletedIndex: -1);
    }
    return r;
  }

  /// Örnek katalogda silmeyi geri alır (sunucuda yok).
  void undoDelete() {
    final t = state.deleted;
    if (t == null || _server) return;
    _store.add(t, at: state.deletedIndex);
    state = state.copyWith(deleted: () => null, deletedIndex: -1);
  }

  /// Görevin kopyasını oluşturur; yeni görevin kodunu (sunucuda sunucu kimliği) döner.
  /// Sunucuda `createWorkItem`: aynı departman, başlık + [suffix], tarihler, öncelik, kanıt
  /// bayrağı; sunucu tek atanan aldığından ilk atanan (yoksa atamasız). Katalog yeniden okunur.
  Future<(WriteOutcome, String?)> copy(String suffix) async {
    final t = _task;
    final c = _catalog;
    if (t == null || c == null) return (WriteOutcome.invalid, null);
    if (!_server) {
      final newCode = c.nextCode(t.coordinatorship);
      _store.add(
        TaskItem(
          code: newCode,
          title: '${t.title} $suffix',
          coordinatorship: t.coordinatorship,
          status: TaskStatus.todo,
          priority: t.priority,
          start: t.start,
          due: t.due,
          assignees: t.assignees,
          creator: c.me,
          createdAt: c.today,
          overdueDays: c.overdueDaysFor(t.due, done: false),
        ),
      );
      return (WriteOutcome.done, newCode);
    }
    final dept = t.departmentId;
    final program = t.programId;
    if (dept == null || program == null || !permissions.canManageTask) {
      return (WriteOutcome.invalid, null);
    }
    String? id;
    final r = await _write(
      () async => id = await _writes.createWorkItem(
        WorkItemDraft(
          programId: program,
          departmentId: dept,
          title: '${t.title} $suffix',
          start: t.start,
          end: t.due,
          priority: t.priority == TaskPriority.unknown ? null : t.priority,
          assignee: t.assignees.firstOrNull,
          evidenceRequired: t.evidenceRequired,
        ),
      ),
      list: true,
    );
    return (r, r.ok ? id : null);
  }

  // ---- alt görevler ---------------------------------------------------------------------

  void _updateSub(String id, Subtask Function(Subtask) f) {
    final t = _task;
    if (t == null) return;
    _save(
      t.copyWith(subtasks: [for (final u in t.subtasks) u.id == id ? f(u) : u]),
    );
  }

  Subtask? _sub(String id) =>
      _task?.subtasks.where((s) => s.id == id).firstOrNull;

  /// Sunucu alt görev değişikliği; alt görev sayıları tekil okumayla kalemde yenilenir.
  Future<WriteOutcome> _patchSub(String id, SubtaskPatch patch) {
    final t = _task;
    if (t == null) return Future.value(WriteOutcome.invalid);
    return _write(() => _writes.updateSubtask(t, id, patch), list: false);
  }

  /// İşaretler/kaldırır. Alt görevde kanıt bayrağı yok (ADR-0024): kanıt kapısı görev
  /// seviyesindedir ([TaskItem.evidenceRequired]). Sunucuda yetki
  /// [TaskPermissions.canToggleSubtask].
  Future<WriteOutcome> toggleSubtask(String id) async {
    final u = _sub(id);
    if (u == null) return WriteOutcome.invalid;
    if (!_server) {
      _updateSub(id, (s) => s.copyWith(done: !s.done));
      return WriteOutcome.done;
    }
    if (!permissions.canToggleSubtask(u)) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(done: !u.done));
  }

  void toggleSubtaskOpen(String id) {
    final s = {...state.openSubtasks};
    if (!s.remove(id)) s.add(id);
    state = state.copyWith(openSubtasks: s);
  }

  /// Örnek katalog: boş alt görev ekler (ilk bitmiş alt görevin önüne), açık ve ad
  /// düzenlemede. Sunucuda alt görev [createSubtask] ile başlığıyla açılır.
  void addSubtask() {
    final t = _task;
    if (t == null || _server || state.editingSubtask != null) return;
    final id = 'n${state.seq + 1}';
    final list = [...t.subtasks];
    final firstDone = list.indexWhere((u) => u.done);
    final item = Subtask(id: id, title: '');
    if (firstDone < 0) {
      list.add(item);
    } else {
      list.insert(firstDone, item);
    }
    _save(t.copyWith(subtasks: list));
    state = state.copyWith(
      seq: state.seq + 1,
      openSubtasks: {...state.openSubtasks, id},
      editingSubtask: () => id,
    );
  }

  /// Sunucuda [title] başlıklı alt görev açar (yönetici ya da koordinatör; tamamlanmış
  /// görevde 409 `work.item_completed`, tavan 50 → 409 `work.subtask_limit_reached`).
  Future<WriteOutcome> createSubtask(String title) async {
    final t = _task;
    final name = title.trim();
    if (t == null || name.isEmpty) return WriteOutcome.invalid;
    if (!_server) {
      _save(
        t.copyWith(
          subtasks: [
            ...t.subtasks,
            Subtask(id: 'n${state.seq + 1}', title: name),
          ],
        ),
      );
      state = state.copyWith(seq: state.seq + 1);
      return WriteOutcome.done;
    }
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _write(() => _writes.createSubtask(t, name), list: false);
  }

  /// Örnek katalogda satır içi ad düzenlemesi (yazdıkça).
  void setSubtaskTitle(String id, String title) {
    if (_server) return;
    _updateSub(id, (s) => s.copyWith(title: title));
  }

  /// Başlığı değiştirir (yönetici ya da koordinatör).
  Future<WriteOutcome> renameSubtask(String id, String title) async {
    final u = _sub(id);
    final name = title.trim();
    if (u == null || name.isEmpty) return WriteOutcome.invalid;
    if (name == u.title) return WriteOutcome.unchanged;
    if (!_server) {
      _updateSub(id, (s) => s.copyWith(title: name));
      return WriteOutcome.done;
    }
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(title: name));
  }

  /// Ad düzenlemesini bitirir; ad boşsa alt görevi atar (örnek katalog).
  void finishSubtaskEdit() {
    final id = state.editingSubtask;
    if (id == null) return;
    final t = _task;
    final u = _sub(id);
    if (t != null && u != null && u.title.trim().isEmpty) {
      _save(t.copyWith(subtasks: [...t.subtasks]..remove(u)));
    }
    state = state.copyWith(editingSubtask: () => null);
  }

  /// Atananı değiştirir; null → kaldır. Sunucuda aday yalnız ana görevin atananları.
  Future<WriteOutcome> setSubtaskAssignee(String id, String? person) async {
    final u = _sub(id);
    if (u == null) return WriteOutcome.invalid;
    if (u.assignee == person) return WriteOutcome.unchanged;
    if (!_server) {
      _updateSub(id, (s) => s.copyWith(assignee: () => person));
      return WriteOutcome.done;
    }
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
    if (!_server) {
      _updateSub(id, (s) => s.copyWith(start: () => start, end: () => end));
      return WriteOutcome.done;
    }
    if (!permissions.canManageSubtasks) return WriteOutcome.invalid;
    return _patchSub(id, SubtaskPatch(dates: (start: start, end: end)));
  }

  /// Başlangıç; sonrasındaki bitiş başlangıçtan önceyse başlangıca çekilir. Sunucuda bitiş
  /// yoksa başlangıç gününe eşitlenir (iki gün birlikte gider).
  Future<WriteOutcome> setSubtaskStart(String id, DateTime? d) {
    final u = _sub(id);
    if (u == null) return Future.value(WriteOutcome.invalid);
    if (d == null) return clearSubtaskDates(id);
    final end = u.end != null && !u.end!.isBefore(d)
        ? u.end
        : (_server || u.end != null ? d : null);
    return _setSubtaskDates(id, d, end);
  }

  /// Bitiş; sunucuda başlangıç yoksa (ya da sonraysa) bitiş gününe eşitlenir.
  Future<WriteOutcome> setSubtaskEnd(String id, DateTime? d) {
    final u = _sub(id);
    if (u == null) return Future.value(WriteOutcome.invalid);
    if (d == null) return clearSubtaskDates(id);
    if (!_server) return _setSubtaskDates(id, u.start, d);
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
    if (!_server) {
      _save(t.copyWith(subtasks: [...t.subtasks]..remove(u)));
      return (WriteOutcome.done, u);
    }
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
    if (!_server) {
      final today = _catalog!.today;
      _save(
        t.copyWith(
          noteEntries: [
            ...t.noteEntries,
            TaskNote(
              by: _catalog!.me,
              at: DateTime(today.year, today.month, today.day, 14, 5),
              text: text,
            ),
          ],
        ),
      );
      state = state.copyWith(noteDraft: '');
      return WriteOutcome.done;
    }
    if (!permissions.canAddNote) return WriteOutcome.invalid;
    final r = await _write(() => _writes.addNote(t, text), list: false);
    if (r.ok && ref.mounted) state = state.copyWith(noteDraft: '');
    return r;
  }

  /// Notu [text] ile değiştirir (yalnız yazarı; yalnız sunucu notu — örnekte not kimliksiz).
  Future<WriteOutcome> editNote(TaskNote note, String text) async {
    final t = _task;
    final v = text.trim();
    final id = note.id;
    if (t == null || v.isEmpty || id == null || !_server) {
      return WriteOutcome.invalid;
    }
    if (v == note.text) return WriteOutcome.unchanged;
    if (!permissions.canEditNote(note)) return WriteOutcome.invalid;
    return _write(() => _writes.updateNote(t, id, v), list: false);
  }

  /// Notu siler (yalnız yazarı; yalnız sunucu notu).
  Future<WriteOutcome> deleteNote(TaskNote note) async {
    final t = _task;
    final id = note.id;
    if (t == null || id == null || !_server) return WriteOutcome.invalid;
    if (!permissions.canEditNote(note)) return WriteOutcome.invalid;
    return _write(() => _writes.deleteNote(t, id), list: false);
  }

  /// Sunucuda karşılığı yok (backend adayı B-17): sunucu notunda yerel sahte yazma yapılmaz.
  bool addNoteToMemory(int index) {
    final t = _task;
    if (t == null || _server || index >= t.noteEntries.length) return false;
    final n = t.noteEntries[index];
    if (n.inMemory) return false;
    _save(
      t.copyWith(
        noteEntries: [
          for (var i = 0; i < t.noteEntries.length; i++)
            i == index
                ? TaskNote(by: n.by, at: n.at, text: n.text, inMemory: true)
                : t.noteEntries[i],
        ],
      ),
    );
    return true;
  }
}
