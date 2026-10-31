import 'package:meta/meta.dart';

import 'task_access.dart';

/// Görev durumu (sunucu kavramı; istemci geçiş kuralı türetmez). Sunucu değerleri (`data`
/// katmanında eşlenir): todo ↔ `baslanmadi`, inProgress ↔ `devam_ediyor`, review ↔
/// `onaya_sunuldu`, returned ↔ `iade_edildi`, done ↔ `tamamlandi`. [unknown]: sunucunun yeni
/// etiketteki tanımsız değeri (asla `throw` edilmez; UI güvenli varsayılana bağlar).
enum TaskStatus {
  todo,
  inProgress,
  review,
  returned,
  done,
  unknown;

  /// Seçicide gösterilen tanımlı durumlar ([unknown] hariç; sözleşme sırası).
  static const known = [todo, inProgress, review, returned, done];
}

/// Görev önceliği. Sunucu değerleri: low ↔ `dusuk`, medium ↔ `orta`, high ↔ `yuksek`, urgent ↔
/// `acil`. [unknown]: tanımsız sunucu değeri.
enum TaskPriority {
  low,
  medium,
  high,

  /// Sunucuda var (`acil`); örnek veride ve ARB'de etiketi yok — entegrasyonda karar.
  urgent,
  unknown;

  /// Formlarda seçtirilen öncelikler. [urgent] ARB etiketi eklenene kadar seçtirilmez
  /// (sunucudan gelirse gösterilir); [unknown] hiç seçtirilmez.
  static const pickable = [low, medium, high];
}

/// Kişi rolü (görünüm etiketi ve rol rengi için; yetki kararı sunucudadır).
enum PersonRole { admin, coordinator, member }

/// Kişi (görev ataması, koordinatörlük ekibi, sohbet üyesi).
@immutable
final class Person {
  const Person({required this.id, required this.name, required this.role});

  final String id;
  final String name;
  final PersonRole role;
}

/// Koordinatörlük kimliği ve ekibi.
@immutable
final class CoordinatorshipRef {
  const CoordinatorshipRef({
    required this.code,
    required this.name,
    required this.leads,
    required this.members,
  });

  /// Kısa kod (`ALT`).
  final String code;
  final String name;

  /// Koordinatör kişi kimlikleri (boş → atanmamış).
  final List<String> leads;

  /// Üye kişi kimlikleri.
  final List<String> members;

  /// Ekip: önce koordinatörler, sonra üyeler.
  List<String> get team => [...leads, ...members];
}

/// Alt görev. Kişi ve tarih isteğe bağlıdır. Alt görevde kanıt bayrağı yoktur (ADR-0024: kanıt
/// görev seviyesinde, [TaskItem.evidenceRequired]); [evidence] yalnız bağlı dosyanın adıdır.
@immutable
final class Subtask {
  const Subtask({
    required this.id,
    required this.title,
    this.done = false,
    this.assignee,
    this.start,
    this.end,
    this.evidence,
    this.assigneeRequired = false,
  });

  final String id;
  final String title;
  final bool done;
  final String? assignee;
  final DateTime? start;
  final DateTime? end;

  /// Bu alt göreve bağlı kanıt dosyasının adı.
  final String? evidence;
  final bool assigneeRequired;

  bool get missingAssignee => !done && assigneeRequired && assignee == null;

  Subtask copyWith({
    String? title,
    bool? done,
    String? Function()? assignee,
    DateTime? Function()? start,
    DateTime? Function()? end,
    String? evidence,
  }) => Subtask(
    id: id,
    title: title ?? this.title,
    done: done ?? this.done,
    assignee: assignee == null ? this.assignee : assignee(),
    start: start == null ? this.start : start(),
    end: end == null ? this.end : end(),
    evidence: evidence ?? this.evidence,
    assigneeRequired: assigneeRequired,
  );
}

/// Tarih değişikliği talebinin durumu (sunucu `pending`/`approved`/`rejected`; [unknown]:
/// tanımsız sunucu değeri).
enum DateRequestState { pending, approved, rejected, unknown }

/// Tarih talebi incelemesinin kararı (`POST /v1/date-change-requests/{id}/review`).
enum DateRequestDecision { approve, reject }

/// Tarih değişikliği talebi: [oldDue] → [due] (yeni aralık [start]–[due]). Sunucu şeması
/// `DateChangeRequest` ile birleşik: `request_id` → [id], `work_item_id` → [workItemId],
/// `old_start_on` → [oldStart], `old_end_on` → [oldDue], `new_start_on` → [start],
/// `new_end_on` → [due], `status` → [state], `reason` → [reason] (sunucuda isteğe bağlı; yoksa
/// boş dize).
@immutable
final class DateChangeRequest {
  const DateChangeRequest({
    this.id,
    this.workItemId,
    this.by,
    this.at,
    this.oldStart,
    required this.oldDue,
    required this.start,
    required this.due,
    this.reason = '',
    this.state = DateRequestState.pending,
  });

  /// Talep kimliği (`request_id`; inceleme ve silme bununla yapılır). Örnek veride yok.
  final String? id;

  /// Talebin görevi (`work_item_id`). Örnek veride yok (görev zaten bağlam).
  final String? workItemId;

  /// Talep eden kişi kimliği. Sunucuda yok — entegrasyonda karar (backend adayı B-08).
  final String? by;

  /// Talep anı. Sunucuda yok — entegrasyonda karar (backend adayı B-08).
  final DateTime? at;

  /// Talep anındaki başlangıç (`old_start_on`). Örnek veride yok.
  final DateTime? oldStart;
  final DateTime oldDue;
  final DateTime start;
  final DateTime due;

  /// Gerekçe; sunucuda isteğe bağlı (yoksa boş).
  final String reason;
  final DateRequestState state;

  bool get isPending => state == DateRequestState.pending;

  DateChangeRequest withState(DateRequestState s) => DateChangeRequest(
    id: id,
    workItemId: workItemId,
    by: by,
    at: at,
    oldStart: oldStart,
    oldDue: oldDue,
    start: start,
    due: due,
    reason: reason,
    state: s,
  );
}

/// Kanıt dosyasının türü (ikon çipi).
enum TaskFileKind { image, pdf, doc }

/// Kanıt dosyasının etiketi. [site]/[result]/[status] prototip etiketleridir (yerel yükleme
/// formu); diğerleri sunucu etiketleridir (`FileRecord.tag`): requirement ↔ `ister`, plan ↔
/// `plan`, input ↔ `girdi`, analysis ↔ `analiz`, output ↔ `cikti`, outcome ↔ `sonuc`.
/// [unknown]: tanımsız sunucu değeri.
enum EvidenceTag {
  site,
  result,
  status,
  requirement,
  plan,
  input,
  analysis,
  output,
  outcome,
  unknown;

  /// Yerel yükleme formunda seçtirilen prototip etiketleri.
  static const prototype = [site, result, status];
}

/// Görevin kanıt dosyası (arşivde görev klasörüne kaydedilir).
@immutable
final class TaskFile {
  const TaskFile({
    required this.id,
    required this.kind,
    required this.name,
    required this.tag,
    required this.by,
    required this.sizeKb,
    this.subtask,
  });

  final String id;
  final TaskFileKind kind;
  final String name;
  final EvidenceTag tag;

  /// Yükleyen kişi kimliği.
  final String by;
  final int sizeKb;

  /// Bağlı alt görev kimliği (null → görevin kendisi).
  final String? subtask;
}

/// Görev notu. Sunucu şeması `WorkItemNote` ile birleşik: `note_id` → [id], `work_item_id` →
/// [workItemId], `author_account_id` → [by], `created_at` → [at], `content` → [text],
/// `updated_at` → [updatedAt].
@immutable
final class TaskNote {
  const TaskNote({
    this.id,
    this.workItemId,
    required this.by,
    required this.at,
    required this.text,
    this.updatedAt,
    this.inMemory = false,
  });

  /// Not kimliği (düzenleme/silme bununla). Örnek veride yok.
  final String? id;

  /// Notun görevi. Örnek veride yok.
  final String? workItemId;

  /// Yazar kişi kimliği.
  final String by;
  final DateTime at;
  final String text;

  /// Son düzenleme anı. Örnek veride yok.
  final DateTime? updatedAt;

  /// Kurumsal hafızaya deneyim olarak eklendi mi. Sunucuda yok — entegrasyonda karar
  /// (backend adayı B-17).
  final bool inMemory;
}

/// Sunucunun hesapladığı gecikme bayrakları (`WorkItem` düz alanları ve `GanttTask.lateness`;
/// tek kaynak — WORK-K37). İstemci gecikme türetmez.
@immutable
final class TaskLateness {
  const TaskLateness({
    this.isOverdue = false,
    this.daysOverdue = 0,
    this.isCompletedLate = false,
    this.daysLate = 0,
    this.isCompletedEarly = false,
    this.daysEarly = 0,
  });

  /// Bitmemiş ve bitiş günü geçmiş.
  final bool isOverdue;
  final int daysOverdue;

  /// Planlanan bitişten (`planned_end_on`) sonra tamamlandı.
  final bool isCompletedLate;
  final int daysLate;

  /// Planlanan bitişten önce tamamlandı.
  final bool isCompletedEarly;
  final int daysEarly;

  @override
  bool operator ==(Object other) =>
      other is TaskLateness &&
      other.isOverdue == isOverdue &&
      other.daysOverdue == daysOverdue &&
      other.isCompletedLate == isCompletedLate &&
      other.daysLate == daysLate &&
      other.isCompletedEarly == isCompletedEarly &&
      other.daysEarly == daysEarly;

  @override
  int get hashCode => Object.hash(
    isOverdue,
    daysOverdue,
    isCompletedLate,
    daysLate,
    isCompletedEarly,
    daysEarly,
  );
}

/// Görevler arası bağımlılık kenarı: [workItemId] (bağımlı) [dependsOnId]'nin (ön görev)
/// bitmesini bekler. Sunucu `DependencyEdge` (`work_item_id`, `depends_on_work_item_id`) ve
/// `GanttLink` (`target` = bağımlı, `source` = ön görev) ile birleşik.
@immutable
final class TaskDependency {
  const TaskDependency({
    required this.id,
    required this.workItemId,
    required this.dependsOnId,
    this.crossDepartment,
  });

  /// Kenar kimliği (`dependency_id`); kaldırma bununla yapılır (ön görev kimliği değil).
  final String id;

  /// Bağımlı görev.
  final String workItemId;

  /// Ön görev.
  final String dependsOnId;

  /// İki görev farklı departmanda mı (yalnız Gantt bağlantısında dolu).
  final bool? crossDepartment;

  @override
  bool operator ==(Object other) =>
      other is TaskDependency &&
      other.id == id &&
      other.workItemId == workItemId &&
      other.dependsOnId == dependsOnId &&
      other.crossDepartment == crossDepartment;

  @override
  int get hashCode => Object.hash(id, workItemId, dependsOnId, crossDepartment);
}

/// Görev. Sayılar ve [overdueDays] sunucunun hesapladığı değerlerdir (örnek kaynakta sabittir).
///
/// Görev kataloğunda sunucu kaynağı `WorkItem`'dır (`GET /v1/work-items`): `work_item_id` →
/// [id] (ve [code]), `department_id` → [departmentId] (ve [coordinatorship]), `program_id` →
/// [programId], `planned_end_on` → [plannedEnd], `completed_on` → [completedAt] (gün),
/// `assignee_account_ids` → [assignees], gecikme düz alanları → [lateness] (ve [overdueDays] ←
/// `days_overdue`), `completion_evidence_required` → [evidenceRequired], `subtask_counts` →
/// [subtaskCounts]. [start]/[due]: v0.6.0 `start_on`/`end_on` gelene kadar GEÇİCİ olarak
/// katalog günü (F57 P1b). Zaman çizelgesi aynı alan adlarıyla `GanttTask`'tan eşler.
@immutable
final class TaskItem {
  const TaskItem({
    required this.code,
    String? id,
    this.shortCode,
    required this.title,
    required this.coordinatorship,
    this.departmentId,
    this.programId,
    required this.status,
    required this.priority,
    required this.start,
    required this.due,
    this.plannedEnd,
    required this.assignees,
    this.creator,
    this.createdAt,
    this.completedAt,
    this.description,
    this.lateness,
    this.files = 0,
    this.notes = 0,
    this.overdueDays = 0,
    this.subtasks = const [],
    this.dateRequest,
    this.fileEntries = const [],
    this.noteEntries = const [],
    this.evidenceRequired = false,
    this.subtaskCounts,
  }) : id = id ?? code;

  /// Görev kodu (`ALT-7`); rota kimliği. Sunucuda insan okunur görev anahtarı yok (backend
  /// adayı B-03): sunucudan eşlenen görevde [id] ile aynıdır.
  final String code;

  /// Sunucu kimliği (`work_item_id`); örnek veride verilmezse [code].
  final String id;

  /// Ekranda gösterilen kısa anahtar; null → [code]. Sunucu kaynağında departman kodu
  /// (`ALT`): sunucu kimliği kullanıcıya gösterilmez.
  final String? shortCode;

  /// Ekranda gösterilen görev anahtarı (örnekte `ALT-7`, sunucuda departman kodu).
  String get displayCode => shortCode ?? code;
  final String title;

  /// Koordinatörlük anahtarı: örnek veride kısa kod, sunucudan eşlenen görevde
  /// `department_id` (bkz. [departmentId]).
  final String coordinatorship;

  /// Departman kimliği (`department_id`). Örnek veride yok.
  final String? departmentId;

  /// Program kimliği (`program_id`). Örnek veride yok.
  final String? programId;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime start;
  final DateTime due;

  /// Planlanan bitiş (`planned_end_on`): onayda [due] tamamlanma gününe itilir, eski bitiş
  /// buraya yazılır (WORK-K19). `null` → planlanan bitiş [due].
  final DateTime? plannedEnd;

  /// Atanan kişi kimlikleri.
  final List<String> assignees;

  /// Oluşturan kişi kimliği. Görev yüzlerinde (`WorkItem`, `GanttTask`) yok — yalnız ŞY
  /// raporunda; entegrasyonda karar (backend adayı B-02).
  final String? creator;

  /// Oluşturma anı. Sunucu görev yüzlerinde yok — entegrasyonda karar (backend adayı B-02).
  final DateTime? createdAt;

  /// Tamamlanma günü (`completed_on`; sunucuda gün çözünürlüğü).
  final DateTime? completedAt;

  /// Açıklama. Görev okuma yüzlerinde yok (yalnız oluşturma/güncelleme ve ŞY raporu).
  final String? description;

  /// Sunucunun gecikme bayrakları; örnek veride yok ([overdueDays] kullanılır).
  final TaskLateness? lateness;

  /// Kanıt dosyası sayısı — YALNIZ örnek kaynağın dosya üreticisi. Sunucu listesi dosya
  /// sayısı taşımaz (F56 M-4) ve listede gösterilmez; ayrıntıda [fileEntries] uzunluğu.
  final int files;

  /// Not sayısı.
  final int notes;

  /// Bitiş tarihini kaç gün geçtiği (tamamlanmamış görevde; 0 → gecikme yok).
  final int overdueDays;

  /// Alt görevler (boş → yok).
  final List<Subtask> subtasks;

  /// Son tarih değişikliği talebi (bekleyen ya da sonuçlanmış).
  final DateChangeRequest? dateRequest;

  /// Kanıt dosyaları (ayrıntı ekranı).
  final List<TaskFile> fileEntries;

  /// Notlar (ayrıntı ekranı).
  final List<TaskNote> noteEntries;

  /// Tamamlamak için kanıt dosyası zorunlu mu (`WorkItem.completion_evidence_required`,
  /// ADR-0024; görev seviyesinde). "Dosya var" göstergesi DEĞİLDİR.
  final bool evidenceRequired;

  /// Sunucunun alt görev sayıları (`subtask_counts`: toplam, biten); ayrıntı yüklenmeden
  /// listede ilerleme için. null → kaynak taşımaz (örnek veri; [subtasks] sayılır).
  final ({int total, int done})? subtaskCounts;

  bool get isOverdue => overdueDays > 0;
  bool get isDone => status == TaskStatus.done;
  bool get hasPendingRequest => dateRequest?.isPending ?? false;
  int get subtasksDone => subtasks.where((s) => s.done).length;

  /// Listede gösterilen alt görev toplamı: ayrıntı yüklendiyse [subtasks], yoksa sunucu sayısı.
  int get subtaskTotal =>
      subtasks.isNotEmpty ? subtasks.length : subtaskCounts?.total ?? 0;

  /// Listede gösterilen biten alt görev sayısı ([subtaskTotal] ile aynı kaynaktan).
  int get subtaskDoneTotal =>
      subtasks.isNotEmpty ? subtasksDone : subtaskCounts?.done ?? 0;

  TaskItem copyWith({
    String? code,
    String? title,
    String? coordinatorship,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? start,
    DateTime? due,
    List<String>? assignees,
    DateTime? Function()? completedAt,
    int? overdueDays,
    List<Subtask>? subtasks,
    DateChangeRequest? Function()? dateRequest,
    List<TaskFile>? fileEntries,
    List<TaskNote>? noteEntries,
  }) => TaskItem(
    code: code ?? this.code,
    id: code == null || id != this.code ? id : code,
    shortCode: shortCode,
    title: title ?? this.title,
    coordinatorship: coordinatorship ?? this.coordinatorship,
    departmentId: departmentId,
    programId: programId,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    due: due ?? this.due,
    plannedEnd: plannedEnd,
    assignees: assignees ?? this.assignees,
    creator: creator,
    createdAt: createdAt,
    completedAt: completedAt == null ? this.completedAt : completedAt(),
    description: description,
    lateness: lateness,
    files: fileEntries?.length ?? files,
    notes: noteEntries?.length ?? notes,
    overdueDays: overdueDays ?? this.overdueDays,
    subtasks: subtasks ?? this.subtasks,
    dateRequest: dateRequest == null ? this.dateRequest : dateRequest(),
    fileEntries: fileEntries ?? this.fileEntries,
    noteEntries: noteEntries ?? this.noteEntries,
    evidenceRequired: evidenceRequired,
    subtaskCounts: subtaskCounts,
  );
}

/// Görev kataloğu: görevler, kişiler, koordinatörlükler ve verinin "bugün"ü (sunucu saati).
@immutable
final class TaskCatalog {
  TaskCatalog({
    required this.today,
    required this.me,
    required List<TaskItem> tasks,
    required List<Person> people,
    required List<CoordinatorshipRef> coordinatorships,
    this.access,
  }) : tasks = List.unmodifiable(tasks),
       people = List.unmodifiable(people),
       coordinatorships = List.unmodifiable(coordinatorships);

  final DateTime today;

  /// Oturumdaki kişinin kimliği.
  final String me;
  final List<TaskItem> tasks;
  final List<Person> people;
  final List<CoordinatorshipRef> coordinatorships;

  /// Oturumdaki hesabın görev erişimi (rol türetme); örnek kaynakta null.
  final TaskAccess? access;

  // Kimlik → öğe dizinleri: kart/arama/filtre her satırda ad çözer; doğrusal arama yerine
  // ilk kullanımda bir kez kurulur (katalog değişmez, `withTasks` yeni örnek üretir).
  late final _people = {for (final p in people) p.id: p};
  late final _coords = {for (final c in coordinatorships) c.code: c};
  late final _tasks = {for (final t in tasks) t.code: t};

  Person? person(String id) => _people[id];

  CoordinatorshipRef? coordinatorship(String code) => _coords[code];

  TaskItem? task(String code) => _tasks[code];

  List<TaskItem> tasksOf(String coordinatorship) => [
    for (final t in tasks)
      if (t.coordinatorship == coordinatorship) t,
  ];

  /// Aynı kişi/koordinatörlük kümesiyle yeni görev listesi.
  TaskCatalog withTasks(List<TaskItem> tasks) => TaskCatalog(
    today: today,
    me: me,
    tasks: tasks,
    people: people,
    coordinatorships: coordinatorships,
    access: access,
  );

  /// Koordinatörlükte sıradaki görev kodu (`ALT-14` → `ALT-15`).
  String nextCode(String coordinatorship) {
    var max = 0;
    for (final t in tasks) {
      if (t.coordinatorship != coordinatorship) continue;
      final n = int.tryParse(t.code.split('-').last) ?? 0;
      if (n > max) max = n;
    }
    return '$coordinatorship-${max + 1}';
  }

  /// [due]'nin bugüne göre gecikme günü (tamamlanmış görevde 0).
  int overdueDaysFor(DateTime due, {required bool done}) {
    if (done) return 0;
    final d = DateTime.utc(
      today.year,
      today.month,
      today.day,
    ).difference(DateTime.utc(due.year, due.month, due.day)).inDays;
    return d > 0 ? d : 0;
  }
}

/// Görev kataloğunun kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class TaskCatalogRepository {
  Future<TaskCatalog> load();
}
