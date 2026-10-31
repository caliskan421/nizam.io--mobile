import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import 'task_catalog_controller.dart';

part 'task_detail_controller.g.dart';

/// Ayrıntı sekmeleri.
enum TaskDetailTab { summary, subtasks, files, notes }

/// Durum değişikliğinin sonucu (sonuç bildirimi metnini sunum seçer).
enum StatusChange { unchanged, changed, blockedBySubtasks, blockedByEvidence }

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
    this.membersOpen = false,
  });

  final String title;
  final String coordinatorship;
  final List<String> assignees;
  final TaskPriority priority;
  final DateTime start;
  final DateTime due;
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
    bool? membersOpen,
  }) => TaskEditDraft(
    title: title ?? this.title,
    coordinatorship: coordinatorship ?? this.coordinatorship,
    assignees: assignees ?? this.assignees,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    due: due ?? this.due,
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
  const UploadDraft({this.subtask, required this.tag, required this.name});

  final String? subtask;
  final EvidenceTag tag;
  final String name;

  UploadDraft copyWith({
    String? Function()? subtask,
    EvidenceTag? tag,
    String? name,
  }) => UploadDraft(
    subtask: subtask == null ? this.subtask : subtask(),
    tag: tag ?? this.tag,
    name: name ?? this.name,
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
  );
}

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
/// denetleyicisine yazılır (oturum boyunca listede de görünür).
@riverpod
class TaskDetailController extends _$TaskDetailController {
  @override
  TaskDetailState build(String code) => const TaskDetailState();

  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);
  TaskCatalogController get _store =>
      ref.read(taskCatalogControllerProvider.notifier);

  void _save(TaskItem t) => _store.replace(t);

  void selectTab(TaskDetailTab t) => state = state.copyWith(tab: t);

  // ---- durum, öncelik -------------------------------------------------------------------

  StatusChange setStatus(TaskStatus s) {
    final t = _task;
    if (t == null || s == t.status) return StatusChange.unchanged;
    if (s == TaskStatus.done && t.subtasks.any((u) => !u.done)) {
      return StatusChange.blockedBySubtasks;
    }
    if (s == TaskStatus.done && t.fileEntries.isEmpty) {
      return StatusChange.blockedByEvidence;
    }
    _save(
      t.copyWith(
        status: s,
        completedAt: () => s == TaskStatus.done ? _catalog!.today : null,
      ),
    );
    return StatusChange.changed;
  }

  /// Önceliği değiştirir; değiştiyse true.
  bool setPriority(TaskPriority p) {
    final t = _task;
    if (t == null || t.priority == p) return false;
    _save(t.copyWith(priority: p));
    return true;
  }

  // ---- tarih talebi ---------------------------------------------------------------------

  void approveRequest() {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null || !r.isPending) return;
    _save(
      t.copyWith(
        start: r.start,
        due: r.due,
        dateRequest: () => r.withState(DateRequestState.approved),
      ),
    );
  }

  void rejectRequest() {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null || !r.isPending) return;
    _save(
      t.copyWith(dateRequest: () => r.withState(DateRequestState.rejected)),
    );
  }

  /// Talep formunu açar (bitiş +14 gün önerilir); bekleyen talep varsa açmaz, false döner.
  bool openDateRequest() {
    final t = _task;
    if (t == null || t.hasPendingRequest) return false;
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

  /// Talebi gönderir; geçersizse false.
  bool submitDateRequest() {
    final t = _task;
    final d = state.dateDraft;
    if (t == null || d == null || d.datesInvalid) return false;
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
    return true;
  }

  // ---- düzenle --------------------------------------------------------------------------

  void openEdit() {
    final t = _task;
    if (t == null) return;
    state = state.copyWith(
      edit: () => TaskEditDraft(
        title: t.title,
        coordinatorship: t.coordinatorship,
        assignees: [...t.assignees],
        priority: t.priority,
        start: t.start,
        due: t.due,
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

  /// Kaydeder; eksik/geçersiz alan varsa hataları açar ve false döner.
  bool submitEdit() {
    final t = _task;
    final d = state.edit;
    if (t == null || d == null) return false;
    if (d.titleMissing || d.assigneesMissing || d.datesInvalid) {
      state = state.copyWith(showErrors: true);
      return false;
    }
    _save(
      t.copyWith(
        title: d.title.trim(),
        coordinatorship: d.coordinatorship,
        assignees: d.assignees,
        priority: d.priority,
        start: d.start,
        due: d.due,
      ),
    );
    state = state.copyWith(edit: () => null, showErrors: false);
    return true;
  }

  // ---- kanıt yükle ----------------------------------------------------------------------

  /// Yükleme formunu açar; alt görev önseçilmez (alt görevde kanıt bayrağı yok, ADR-0024).
  void openUpload() {
    if (_task == null) return;
    state = state.copyWith(
      upload: () => const UploadDraft(
        tag: EvidenceTag.result,
        name: 'Saha_fotografi_20261021.jpg',
      ),
      showErrors: false,
    );
  }

  void updateUpload(UploadDraft d) => state = state.copyWith(upload: () => d);

  /// Dosya kaydını ekler ve Dosya sekmesine geçer; ad boşsa false.
  bool submitUpload() {
    final t = _task;
    final d = state.upload;
    if (t == null || d == null) return false;
    final name = d.name.trim();
    if (name.isEmpty) {
      state = state.copyWith(showErrors: true);
      return false;
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
    return true;
  }

  void closeForms() => state = state.copyWith(
    edit: () => null,
    dateDraft: () => null,
    upload: () => null,
    showErrors: false,
  );

  // ---- sil, kopyala ---------------------------------------------------------------------

  void delete() {
    final t = _task;
    if (t == null) return;
    final i = _store.remove(code);
    state = state.copyWith(deleted: () => t, deletedIndex: i);
  }

  void undoDelete() {
    final t = state.deleted;
    if (t == null) return;
    _store.add(t, at: state.deletedIndex);
    state = state.copyWith(deleted: () => null, deletedIndex: -1);
  }

  /// Görevin kopyasını oluşturur; yeni kodu döner.
  String? copy(String suffix) {
    final t = _task;
    final c = _catalog;
    if (t == null || c == null) return null;
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
    return newCode;
  }

  // ---- alt görevler ---------------------------------------------------------------------

  void _updateSub(String id, Subtask Function(Subtask) f) {
    final t = _task;
    if (t == null) return;
    _save(
      t.copyWith(subtasks: [for (final u in t.subtasks) u.id == id ? f(u) : u]),
    );
  }

  /// İşaretler/kaldırır. Alt görevde kanıt bayrağı yok (ADR-0024): kanıt kapısı görev
  /// seviyesindedir ([TaskItem.evidenceRequired]).
  void toggleSubtask(String id) =>
      _updateSub(id, (s) => s.copyWith(done: !s.done));

  void toggleSubtaskOpen(String id) {
    final s = {...state.openSubtasks};
    if (!s.remove(id)) s.add(id);
    state = state.copyWith(openSubtasks: s);
  }

  /// Boş alt görev ekler (ilk bitmiş alt görevin önüne), açık ve ad düzenlemede.
  void addSubtask() {
    final t = _task;
    if (t == null || state.editingSubtask != null) return;
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

  void setSubtaskTitle(String id, String title) =>
      _updateSub(id, (s) => s.copyWith(title: title));

  /// Ad düzenlemesini bitirir; ad boşsa alt görevi atar.
  void finishSubtaskEdit() {
    final id = state.editingSubtask;
    if (id == null) return;
    final t = _task;
    final u = t?.subtasks.where((s) => s.id == id).firstOrNull;
    if (t != null && u != null && u.title.trim().isEmpty) {
      _save(t.copyWith(subtasks: [...t.subtasks]..remove(u)));
    }
    state = state.copyWith(editingSubtask: () => null);
  }

  void setSubtaskAssignee(String id, String? person) =>
      _updateSub(id, (s) => s.copyWith(assignee: () => person));

  /// Başlangıç sonrası bitiş, başlangıçtan önceyse başlangıca çekilir.
  void setSubtaskStart(String id, DateTime? d) => _updateSub(
    id,
    (s) => s.copyWith(
      start: () => d,
      end: () => s.end != null && d != null && s.end!.isBefore(d) ? d : s.end,
    ),
  );

  void setSubtaskEnd(String id, DateTime? d) =>
      _updateSub(id, (s) => s.copyWith(end: () => d));

  void clearSubtaskDates(String id) =>
      _updateSub(id, (s) => s.copyWith(start: () => null, end: () => null));

  /// Alt görevi kaldırır; kaldırılanı döner (bildirim metni için).
  Subtask? removeSubtask(String id) {
    final t = _task;
    final u = t?.subtasks.where((s) => s.id == id).firstOrNull;
    if (t == null || u == null) return null;
    _save(t.copyWith(subtasks: [...t.subtasks]..remove(u)));
    return u;
  }

  // ---- notlar ---------------------------------------------------------------------------

  void setNoteDraft(String v) => state = state.copyWith(noteDraft: v);

  void sendNote() {
    final t = _task;
    final text = state.noteDraft.trim();
    if (t == null || text.isEmpty) return;
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
  }

  /// Notu kurumsal hafızaya ekler; zaten ekliyse false.
  bool addNoteToMemory(int index) {
    final t = _task;
    if (t == null || index >= t.noteEntries.length) return false;
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
