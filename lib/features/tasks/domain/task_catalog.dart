import 'package:meta/meta.dart';

import 'date_change_request.dart';
import 'task_access.dart';

export 'date_change_request.dart';

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

  /// Sunucuda var (`acil`); ARB'de etiketi yok — entegrasyonda karar.
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
    this.shortCode,
  });

  /// Anahtar: `department_id` (kullanıcıya gösterilmez; ekranda [label]).
  final String code;
  final String name;

  /// Departman kodu (`listProgramDepartments` `code`); verilmemişse null.
  final String? shortCode;

  /// Ekranda gösterilen kısa etiket: departman kodu, yoksa ad ([TaskDepartment.label] ile aynı
  /// kural).
  String get label {
    final c = shortCode;
    return c == null || c.isEmpty ? name : c;
  }

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
    this.doneBy,
    this.createdBy,
    this.editRevision,
    this.evidenceRequired = false,
  });

  final String id;
  final String title;

  /// Kanıt bayrağı (`evidence_required`, WORK-K70): açıksa bağlı dosya olmadan kapatılamaz.
  final bool evidenceRequired;

  /// Düzenleme sürümü (`edit_revision`, ADR-0027): başlık/atanan/tarih değişikliği bunu
  /// `expected_revision` olarak geri gönderir. Örnek veride null.
  final int? editRevision;
  final bool done;
  final String? assignee;

  /// Kapatan kişi kimliği (`done_by_account_id`); açıkta null.
  final String? doneBy;

  /// Oluşturan kişi kimliği (`created_by_account_id`).
  final String? createdBy;
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
    doneBy: doneBy,
    createdBy: createdBy,
    editRevision: editRevision,
    evidenceRequired: evidenceRequired,
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
  unknown,
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
    this.editRevision,
  });

  /// Not kimliği (düzenleme/silme bununla).
  final String? id;

  /// İçeriğin düzenleme sürümü (`edit_revision`, ADR-0027); düzenleme `expected_revision`
  /// olarak geri gönderir.
  final int? editRevision;

  /// Notun görevi.
  final String? workItemId;

  /// Yazar kişi kimliği.
  final String by;
  final DateTime at;
  final String text;

  /// Son düzenleme anı.
  final DateTime? updatedAt;
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

/// Görev. Sayılar ve [overdueDays] sunucunun hesapladığı değerlerdir.
///
/// Görev kataloğunda sunucu kaynağı `WorkItem`'dır (`GET /v1/work-items`): `work_item_id` →
/// [id] (ve [code]), `department_id` → [departmentId] (ve [coordinatorship]), `program_id` →
/// [programId], `planned_end_on` → [plannedEnd], `completed_on` → [completedAt] (gün),
/// `assignee_account_ids` → [assignees] (adlar `assignees[].full_name` → [TaskCatalog.nameOf]),
/// `start_on` → [start], `end_on` → [due], gecikme düz alanları → [lateness] (ve [overdueDays] ←
/// `days_overdue`), `completion_evidence_required` → [evidenceRequired], `subtask_counts` →
/// [subtaskCounts]. [description] yalnız tekil uçtan (`getWorkItem`). Zaman çizelgesi aynı alan
/// adlarıyla `GanttTask`'tan eşler.
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
    this.editRevision,
    this.datesRevision,
  }) : id = id ?? code;

  /// Rota kimliği. Sunucuda insan okunur görev anahtarı yok (backend adayı B-03): [id]
  /// (`work_item_id`) ile aynıdır; arayüzde görev anahtarı gösterilmez (ürün sahibi,
  /// 2026-11-12) — yerine başlık ya da koordinatörlük adı yazılır.
  final String code;

  /// Sunucu kimliği (`work_item_id`); verilmezse [code].
  final String id;

  /// Ekranda gösterilen kısa anahtar: departman kodu (`listProgramDepartments` `code`), kod
  /// yoksa departmanın programdaki adı; sunucu kimliği kullanıcıya gösterilmez. null → [code].
  final String? shortCode;

  /// Görev anahtarı (departman etiketi; yoksa [code]); arayüzde gösterilmez, yalnız arama.
  String get displayCode => shortCode ?? code;
  final String title;

  /// Koordinatörlük anahtarı: `department_id` (bkz. [departmentId]).
  final String coordinatorship;

  /// Departman kimliği (`department_id`).
  final String? departmentId;

  /// Program kimliği (`program_id`).
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

  /// Açıklama. Listede yok; tekil okumada (`getWorkItem` → `WorkItemDetail.description`)
  /// dolar. null → ayrıntı henüz okunmadı.
  final String? description;

  /// Sunucunun gecikme bayrakları.
  final TaskLateness? lateness;

  /// Kanıt dosyası sayısı. Sunucu listesi dosya sayısı taşımaz (F56 M-4) ve listede
  /// gösterilmez; ayrıntıda [fileEntries] uzunluğu.
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
  /// listede ilerleme için. null → kaynak taşımaz ([subtasks] sayılır).
  final ({int total, int done})? subtaskCounts;

  /// Alan grubunun (başlık, açıklama, öncelik, kanıt bayrağı) düzenleme sürümü (`edit_revision`,
  /// ADR-0027). Örnek veride null; sunucu kaleminde null ise sunucu sürümlü yazmayı
  /// desteklemiyordur (eski backend) ve yazma gönderilmez.
  final int? editRevision;

  /// Tarih grubunun (başlangıç, bitiş, planlanan bitiş) düzenleme sürümü (`dates_revision`).
  final int? datesRevision;

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
    bool? evidenceRequired,
    String? Function()? description,
    int? datesRevision,
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
    description: description == null ? this.description : description(),
    lateness: lateness,
    files: fileEntries?.length ?? files,
    notes: noteEntries?.length ?? notes,
    overdueDays: overdueDays ?? this.overdueDays,
    subtasks: subtasks ?? this.subtasks,
    dateRequest: dateRequest == null ? this.dateRequest : dateRequest(),
    fileEntries: fileEntries ?? this.fileEntries,
    noteEntries: noteEntries ?? this.noteEntries,
    evidenceRequired: evidenceRequired ?? this.evidenceRequired,
    subtaskCounts: subtaskCounts,
    editRevision: editRevision,
    datesRevision: datesRevision ?? this.datesRevision,
  );
}

/// Sunucunun bir kayıtla verdiği kişi adı (`full_name`; null ad bu tipe girmez). Ayrı ekip
/// dizini ucu yoktur: ad yalnız görünen kaydın aktörü içindir.
@immutable
final class PersonName {
  const PersonName(this.id, this.name);

  /// Hesap kimliği.
  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is PersonName && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}

/// Görev listesinin departman süzgeci seçeneği: kimlik, programdaki ad ve (varsa) katalog kodu.
@immutable
final class TaskDepartment {
  const TaskDepartment({required this.id, required this.name, this.code});

  final String id;
  final String name;

  /// Katalog kodu (`listProgramDepartments` `code`); verilmemişse null.
  final String? code;

  /// Kartlardaki kısa etiket: kod, yoksa ad.
  String get label {
    final c = code;
    return c == null || c.isEmpty ? name : c;
  }

  @override
  bool operator ==(Object other) =>
      other is TaskDepartment &&
      other.id == id &&
      other.name == name &&
      other.code == code;

  @override
  int get hashCode => Object.hash(id, name, code);
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
    this.accountEmail,
    this.departmentId,
    this.departmentFilterCleared = false,
    this.truncated = false,
    List<TaskDepartment> departments = const [],
    this.departmentsTruncated = false,
    List<PersonName> names = const [],
  }) : tasks = List.unmodifiable(tasks),
       people = List.unmodifiable(people),
       coordinatorships = List.unmodifiable(coordinatorships),
       departments = List.unmodifiable(departments),
       names = List.unmodifiable(names);

  final DateTime today;

  /// Oturumdaki kişinin kimliği.
  final String me;

  /// Yalnız oturumdaki hesabın /me yanıtındaki doğrulanmış e-posta adresi.
  final String? accountEmail;
  final List<TaskItem> tasks;
  final List<Person> people;
  final List<CoordinatorshipRef> coordinatorships;

  /// Oturumdaki hesabın görev erişimi (rol türetme); null → hiçbir eylem açık değil.
  final TaskAccess? access;

  /// Görevler ekranı görünümünün sunucu departman süzgeci (`department_id`; [filtered]).
  /// Paylaşılan katalogda (`TaskCatalogController`) her zaman null: program listesi süzgeçsiz.
  final String? departmentId;

  /// Görevler ekranında istenen süzgeç geçersizdi (404 `work.program_scope_invalid`: departman
  /// silinmiş ya da programa bağlı değil; ya da artık seçenekler arasında yok) ve temizlendi;
  /// arayüz kısa bilgi gösterir. Paylaşılan katalogda false.
  final bool departmentFilterCleared;

  /// Liste sayfa tavanında kesildi (sunucuda daha fazla görev var); arayüz uyarı gösterir.
  final bool truncated;

  /// Departman süzgecinin seçenekleri. Şirket yöneticisinde
  /// `listProgramDepartments`, diğerlerinde `/v1/me/departments`'ın bu programdaki satırları
  /// (istemci akışları §2).
  final List<TaskDepartment> departments;

  /// Departman listesi sunucu tavanında kesildi (`X-Result-Truncated: true`).
  final bool departmentsTruncated;

  /// Sunucunun verdiği kişi adları: liste atananları (`assignees[].full_name`) ve okunmuş
  /// ayrıntıların adları. Null ad girmez; aynı kimlikte sonraki geçerlidir.
  final List<PersonName> names;

  /// Kişinin görünen adı: kişi listesinden, yoksa sunucunun verdiği addan; bilinmiyorsa null
  /// (arayüz nötr "Bilinmeyen kişi" gösterir; rol tahmini yok).
  String? nameOf(String id) => person(id)?.name ?? _names[id];

  // Kimlik → öğe dizinleri: kart/arama/filtre her satırda ad çözer; doğrusal arama yerine
  // ilk kullanımda bir kez kurulur (katalog değişmez, `withTasks` yeni örnek üretir).
  late final _people = {for (final p in people) p.id: p};
  late final _coords = {for (final c in coordinatorships) c.code: c};
  late final _tasks = {for (final t in tasks) t.code: t};
  late final _names = {for (final n in names) n.id: n.name};

  Person? person(String id) => _people[id];

  CoordinatorshipRef? coordinatorship(String code) => _coords[code];

  TaskItem? task(String code) => _tasks[code];

  List<TaskItem> tasksOf(String coordinatorship) => [
    for (final t in tasks)
      if (t.coordinatorship == coordinatorship) t,
  ];

  /// Aynı kişi/koordinatörlük kümesiyle yeni görev listesi.
  TaskCatalog withTasks(List<TaskItem> tasks, {bool? truncated}) => TaskCatalog(
    today: today,
    me: me,
    accountEmail: accountEmail,
    tasks: tasks,
    people: people,
    coordinatorships: coordinatorships,
    access: access,
    departmentId: departmentId,
    departmentFilterCleared: departmentFilterCleared,
    truncated: truncated ?? this.truncated,
    departments: departments,
    departmentsTruncated: departmentsTruncated,
    names: names,
  );

  /// Görevler ekranı görünümü: aynı kişi/departman/rol kümesi; [codes] verilirse görev listesi
  /// o kimlikler, o sırayla, katalogdaki satırlardan (tek depo: süzgeçli okuma satırları önce
  /// kataloğa işlenir, görünüm ayrı satır tutmaz; katalogda olmayan kimlik atlanır). [codes]
  /// null → süzgeçsiz katalog. [cleared] süzgecin temizlendiği bilgisi.
  TaskCatalog filtered({
    String? departmentId,
    List<String>? codes,
    bool truncated = false,
    bool cleared = false,
  }) => TaskCatalog(
    today: today,
    me: me,
    accountEmail: accountEmail,
    tasks: codes == null ? tasks : [for (final code in codes) ?task(code)],
    people: people,
    coordinatorships: coordinatorships,
    access: access,
    departmentId: codes == null ? null : departmentId,
    departmentFilterCleared: cleared,
    truncated: codes == null ? this.truncated : truncated,
    departments: departments,
    departmentsTruncated: departmentsTruncated,
    names: names,
  );

  /// [more] adlarını ekleyerek (aynı kimlikte yeni ad geçerli) yeni katalog.
  TaskCatalog withNames(List<PersonName> more) => more.isEmpty
      ? this
      : TaskCatalog(
          today: today,
          me: me,
          accountEmail: accountEmail,
          tasks: tasks,
          people: people,
          coordinatorships: coordinatorships,
          access: access,
          departmentId: departmentId,
          departmentFilterCleared: departmentFilterCleared,
          truncated: truncated,
          departments: departments,
          departmentsTruncated: departmentsTruncated,
          names: [...names, ...more],
        );
}

/// Görev kataloğunun kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class TaskCatalogRepository {
  Future<TaskCatalog> load();
}

/// Departman süzgeçli görev sayfalarının sonucu (`listProgramWorkItems` `department_id`).
@immutable
final class TaskListPage {
  TaskListPage({
    required List<TaskItem> tasks,
    List<PersonName> names = const [],
    this.truncated = false,
  }) : tasks = List.unmodifiable(tasks),
       names = List.unmodifiable(names);

  final List<TaskItem> tasks;
  final List<PersonName> names;

  /// Sayfalar kesildi (imleç tekrarı ya da sayfa tavanı).
  final bool truncated;
}

/// Görevler ekranının sunucu departman süzgecinin kaynağı (domain portu). Yalnız görev
/// sayfalarını okur (kimlik, ekip satırı ve departman seçenekleri yeniden okunmaz).
/// [isCurrent] false dönerse sayfa döngüsü durur (`client.scope_changed`).
abstract interface class TaskListRepository {
  /// [departments]: görünen kısa anahtarın kaynağı (katalogdaki [TaskDepartment.label]).
  Future<TaskListPage> loadTasks(
    String departmentId, {
    bool Function()? isCurrent,
    List<TaskDepartment> departments = const [],
  });
}
