part of 'task_detail_controller.dart';

// Görev ayrıntısının durum ve taslak tipleri: yazma sonucu, düzenleme taslağı ve V3 çakışma
// birleştirmesi, tarih talebi ve yükleme taslakları, ekran durumu ([TaskDetailState]).

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

  /// Sonuç bilinmiyor (zaman aşımı, ağ kopması, 5xx; S12): istek işlenmiş olabilir. Taslak ve
  /// işlem anahtarı korunur; kullanıcı aynı isteği yeniden gönderir (aynı anahtar → ikinci
  /// kayıt oluşmaz). "Başarısız, yeniden oluştur" denmez (`client.outcome_unknown`).
  unknown,

  /// Sunucu 409 `work.edit_conflict` (V3): kayıt formu açtıktan sonra değişti. Görev yeniden
  /// okundu; taslak korunur. Görev formunda çakışan alanlar [TaskEditDraft.conflicts]'ta,
  /// not/alt görev metninde sunucudaki metin [WriteOutcome.serverText]'te: seçim kullanıcının;
  /// otomatik tekrar yok.
  conflict,
}

/// Yazma komutunun sonucu.
@immutable
final class WriteOutcome {
  const WriteOutcome(this.kind, [this.error, this.serverText]);

  static const done = WriteOutcome(WriteKind.done);
  static const unchanged = WriteOutcome(WriteKind.unchanged);
  static const busy = WriteOutcome(WriteKind.busy);
  static const invalid = WriteOutcome(WriteKind.invalid);

  final WriteKind kind;
  final ApiError? error;

  /// [WriteKind.conflict]'te not/alt görev metninin sunucudaki güncel hâli (iki seçenekli
  /// karar için); yoksa null.
  final String? serverText;

  bool get ok => kind == WriteKind.done;
}

/// Metin taslağının hedefi (not içeriği, alt görev adı).
enum TextTarget { note, subtask }

/// Metin taslağı anahtarı: (hedef, kayıt kimliği).
typedef TextDraftKey = (TextTarget, String);

/// Görev formunun sürümlü alanları (V3 çakışma görünümü).
enum EditField { title, priority, start, due, evidenceRequired }

/// Aynı alanın üç görüntüsü: formun açıldığı taban, kullanıcının değeri, sunucunun yeni
/// değeri (V3). Değerler alanın kendi tipindedir.
@immutable
final class EditConflict {
  const EditConflict({
    required this.base,
    required this.local,
    required this.server,
  });

  final Object base;
  final Object local;
  final Object server;
}

/// "Görevi düzenle" taslağı. [base]: formun açıldığı andaki görev (sunucuda taze okuma);
/// fark ve gönderilen sürümler ONDAN hesaplanır (açıkken katalog tazelense de kullanıcının
/// dokunmadığı alan eski değerle geri yazılmaz). [conflicts]: 409 `work.edit_conflict` sonrası
/// kullanıcı seçimi bekleyen alanlar.
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
    this.base,
    this.conflicts = const {},
  });

  /// Formun açıldığı taban.
  final TaskItem? base;
  final Map<EditField, EditConflict> conflicts;

  final String title;
  final String coordinatorship;
  final List<String> assignees;
  final TaskPriority priority;
  final DateTime start;
  final DateTime due;
  final bool evidenceRequired;

  bool get titleMissing => title.trim().isEmpty;
  bool get datesInvalid => due.isBefore(start);

  TaskEditDraft copyWith({
    String? title,
    String? coordinatorship,
    List<String>? assignees,
    TaskPriority? priority,
    DateTime? start,
    DateTime? due,
    bool? evidenceRequired,
    TaskItem? base,
    Map<EditField, EditConflict>? conflicts,
  }) => TaskEditDraft(
    title: title ?? this.title,
    coordinatorship: coordinatorship ?? this.coordinatorship,
    assignees: assignees ?? this.assignees,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    due: due ?? this.due,
    evidenceRequired: evidenceRequired ?? this.evidenceRequired,
    base: base ?? this.base,
    conflicts: conflicts ?? this.conflicts,
  );

  /// Alanın taslaktaki değeri.
  Object valueOf(EditField f) => switch (f) {
    EditField.title => title.trim(),
    EditField.priority => priority,
    EditField.start => _d(start),
    EditField.due => _d(due),
    EditField.evidenceRequired => evidenceRequired,
  };

  /// Alana [v] yazılmış taslak.
  TaskEditDraft withValue(EditField f, Object v) => switch (f) {
    EditField.title => copyWith(title: v as String),
    EditField.priority => copyWith(priority: v as TaskPriority),
    EditField.start => copyWith(start: v as DateTime),
    EditField.due => copyWith(due: v as DateTime),
    EditField.evidenceRequired => copyWith(evidenceRequired: v as bool),
  };
}

DateTime _d(DateTime d) => DateTime(d.year, d.month, d.day);

/// Görev kaleminde alanın değeri (taslakla aynı biçimde; tarihler gün).
Object editValueOf(TaskItem t, EditField f) => switch (f) {
  EditField.title => t.title,
  EditField.priority => t.priority,
  EditField.start => _d(t.start),
  EditField.due => _d(t.due),
  EditField.evidenceRequired => t.evidenceRequired,
};

/// 409 `work.edit_conflict` zarfının bayat grubu (`fields[].field`): `expected_revision` →
/// alanlar, `expected_dates_revision` → tarihler; alan bilgisi yoksa ikisi.
Set<EditField> _staleFields(ApiError e) {
  final names = {for (final f in e.fields) f.field};
  const fields = {
    EditField.title,
    EditField.priority,
    EditField.evidenceRequired,
  };
  const dates = {EditField.start, EditField.due};
  final out = <EditField>{
    if (names.contains('expected_revision')) ...fields,
    if (names.contains('expected_dates_revision')) ...dates,
  };
  return out.isEmpty ? {...fields, ...dates} : out;
}

/// Üç görüntülü birleştirme (V3): dokunulmamış alan sunucu değerini alır, yalnız yerelde
/// değişen korunur, iki tarafta farklı değişen [EditConflict] olur. Yeni taban [server];
/// atananlar sürümsüzdür (dokunulmamışsa sunucudaki).
TaskEditDraft mergeEditDraft(
  TaskEditDraft d,
  TaskItem server, {
  Set<EditField> stale = const {...EditField.values},
}) {
  final base = d.base ?? server;
  var out = d;
  final conflicts = <EditField, EditConflict>{...d.conflicts};
  for (final f in EditField.values) {
    final b = editValueOf(base, f);
    final l = d.valueOf(f);
    final s = editValueOf(server, f);
    if (l == b) {
      out = out.withValue(f, s);
    } else if (s != b && s != l && stale.contains(f)) {
      conflicts[f] = EditConflict(base: b, local: l, server: s);
    }
  }
  final assigneesTouched = !_sameSet(d.assignees, base.assignees);
  return out.copyWith(
    base: server,
    conflicts: conflicts,
    assignees: assigneesTouched ? null : [...server.assignees],
  );
}

bool _sameSet(List<String> a, List<String> b) =>
    a.length == b.length && a.toSet().containsAll(b);

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

  /// Sistem seçicisinden seçilen dosya.
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
    this.deleted,
    this.noteDraft = '',
    this.edit,
    this.dateDraft,
    this.upload,
    this.showErrors = false,
    this.busy = false,
    this.keys = const RequestKeys(),
    this.textDrafts = const {},
  });

  final TaskDetailTab tab;
  final Set<String> openSubtasks;

  /// Silinen görev (ekran "silindi" durumunu gösterir).
  final TaskItem? deleted;
  final String noteDraft;
  final TaskEditDraft? edit;
  final DateRequestDraft? dateDraft;
  final UploadDraft? upload;

  /// Açık formda doğrulama hataları gösterilsin mi (ilk gönderme denemesinden sonra).
  final bool showErrors;

  /// Sunucu yazması uçuşta: yeni yazma komutu istek göndermez ([WriteKind.busy]).
  final bool busy;

  /// Bekleyen oluşturma eylemlerinin işlem anahtarları (ADR-0027; bellek içi, ekran ömrü).
  final RequestKeys keys;

  /// Gönderilemeyen metin düzenlemeleri ((tür, kimlik) → metin; S12): hata, çakışma
  /// ya da bilinmeyen sonuçta kullanıcının yazdığı kaybolmaz, diyalog bununla yeniden açılır.
  /// Başarıda ya da kullanıcı sunucudakini seçince düşer.
  final Map<TextDraftKey, String> textDrafts;

  TaskDetailState copyWith({
    TaskDetailTab? tab,
    Set<String>? openSubtasks,
    TaskItem? Function()? deleted,
    String? noteDraft,
    TaskEditDraft? Function()? edit,
    DateRequestDraft? Function()? dateDraft,
    UploadDraft? Function()? upload,
    bool? showErrors,
    bool? busy,
    RequestKeys? keys,
    Map<TextDraftKey, String>? textDrafts,
  }) => TaskDetailState(
    tab: tab ?? this.tab,
    openSubtasks: openSubtasks ?? this.openSubtasks,
    deleted: deleted == null ? this.deleted : deleted(),
    noteDraft: noteDraft ?? this.noteDraft,
    edit: edit == null ? this.edit : edit(),
    dateDraft: dateDraft == null ? this.dateDraft : dateDraft(),
    upload: upload == null ? this.upload : upload(),
    showErrors: showErrors ?? this.showErrors,
    busy: busy ?? this.busy,
    keys: keys ?? this.keys,
    textDrafts: textDrafts ?? this.textDrafts,
  );
}
