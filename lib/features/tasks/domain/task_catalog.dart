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
  final int files;
  final int notes;

  /// Bitiş tarihini kaç gün geçtiği (tamamlanmamış görevde; 0 → gecikme yok).
  final int overdueDays;

  bool get isOverdue => overdueDays > 0;
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
}

/// Görev kataloğunun kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class TaskCatalogRepository {
  Future<TaskCatalog> load();
}
