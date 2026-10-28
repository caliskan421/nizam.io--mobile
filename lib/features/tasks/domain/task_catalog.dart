import 'package:meta/meta.dart';

/// Görev durumu (sunucu kavramı; istemci geçiş kuralı türetmez).
enum TaskStatus { todo, inProgress, review, returned, done }

/// Görev önceliği.
enum TaskPriority { low, medium, high }

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

/// Alt görev. Kişi ve tarih isteğe bağlıdır; [evidenceRequired] ise kanıt ([evidence])
/// yüklenmeden bitirilemez.
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
    this.evidenceRequired = false,
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
  final bool evidenceRequired;

  bool get missingEvidence => !done && evidenceRequired && evidence == null;
  bool get missingAssignee => !done && assigneeRequired && assignee == null;

  Subtask copyWith({
    String? title,
    bool? done,
    String? Function()? assignee,
    DateTime? Function()? start,
    DateTime? Function()? end,
    String? evidence,
    bool? evidenceRequired,
  }) => Subtask(
    id: id,
    title: title ?? this.title,
    done: done ?? this.done,
    assignee: assignee == null ? this.assignee : assignee(),
    start: start == null ? this.start : start(),
    end: end == null ? this.end : end(),
    evidence: evidence ?? this.evidence,
    assigneeRequired: assigneeRequired,
    evidenceRequired: evidenceRequired ?? this.evidenceRequired,
  );
}

/// Tarih değişikliği talebinin durumu.
enum DateRequestState { pending, approved, rejected }

/// Tarih değişikliği talebi: [oldDue] → [due] (yeni aralık [start]–[due]).
@immutable
final class DateChangeRequest {
  const DateChangeRequest({
    required this.by,
    required this.at,
    required this.oldDue,
    required this.start,
    required this.due,
    required this.reason,
    this.state = DateRequestState.pending,
  });

  /// Talep eden kişi kimliği.
  final String by;
  final DateTime at;
  final DateTime oldDue;
  final DateTime start;
  final DateTime due;
  final String reason;
  final DateRequestState state;

  bool get isPending => state == DateRequestState.pending;

  DateChangeRequest withState(DateRequestState s) => DateChangeRequest(
    by: by,
    at: at,
    oldDue: oldDue,
    start: start,
    due: due,
    reason: reason,
    state: s,
  );
}

/// Kanıt dosyasının türü (ikon çipi).
enum TaskFileKind { image, pdf, doc }

/// Kanıt dosyasının etiketi.
enum EvidenceTag { site, result, status }

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

/// Görev notu.
@immutable
final class TaskNote {
  const TaskNote({
    required this.by,
    required this.at,
    required this.text,
    this.inMemory = false,
  });

  final String by;
  final DateTime at;
  final String text;

  /// Kurumsal hafızaya deneyim olarak eklendi mi.
  final bool inMemory;
}

/// Görev. Sayılar ve [overdueDays] sunucunun hesapladığı değerlerdir (örnek kaynakta sabittir).
@immutable
final class TaskItem {
  const TaskItem({
    required this.code,
    required this.title,
    required this.coordinatorship,
    required this.status,
    required this.priority,
    required this.start,
    required this.due,
    required this.assignees,
    required this.creator,
    required this.createdAt,
    this.completedAt,
    this.files = 0,
    this.notes = 0,
    this.overdueDays = 0,
    this.subtasks = const [],
    this.dateRequest,
    this.fileEntries = const [],
    this.noteEntries = const [],
    this.evidenceRequired = false,
  });

  /// Görev kodu (`ALT-7`); rota kimliği.
  final String code;
  final String title;

  /// Koordinatörlük kodu.
  final String coordinatorship;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime start;
  final DateTime due;

  /// Atanan kişi kimlikleri.
  final List<String> assignees;

  /// Oluşturan kişi kimliği.
  final String creator;
  final DateTime createdAt;
  final DateTime? completedAt;

  /// Kanıt dosyası sayısı.
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

  /// Tamamlamak için kanıt dosyası zorunlu mu.
  final bool evidenceRequired;

  bool get isOverdue => overdueDays > 0;
  bool get isDone => status == TaskStatus.done;
  bool get hasPendingRequest => dateRequest?.isPending ?? false;
  int get subtasksDone => subtasks.where((s) => s.done).length;

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
    title: title ?? this.title,
    coordinatorship: coordinatorship ?? this.coordinatorship,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    due: due ?? this.due,
    assignees: assignees ?? this.assignees,
    creator: creator,
    createdAt: createdAt,
    completedAt: completedAt == null ? this.completedAt : completedAt(),
    files: fileEntries?.length ?? files,
    notes: noteEntries?.length ?? notes,
    overdueDays: overdueDays ?? this.overdueDays,
    subtasks: subtasks ?? this.subtasks,
    dateRequest: dateRequest == null ? this.dateRequest : dateRequest(),
    fileEntries: fileEntries ?? this.fileEntries,
    noteEntries: noteEntries ?? this.noteEntries,
    evidenceRequired: evidenceRequired,
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
  }) : tasks = List.unmodifiable(tasks),
       people = List.unmodifiable(people),
       coordinatorships = List.unmodifiable(coordinatorships);

  final DateTime today;

  /// Oturumdaki kişinin kimliği.
  final String me;
  final List<TaskItem> tasks;
  final List<Person> people;
  final List<CoordinatorshipRef> coordinatorships;
  Person? person(String id) => people.where((p) => p.id == id).firstOrNull;

  CoordinatorshipRef? coordinatorship(String code) =>
      coordinatorships.where((c) => c.code == code).firstOrNull;

  TaskItem? task(String code) => tasks.where((t) => t.code == code).firstOrNull;

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
