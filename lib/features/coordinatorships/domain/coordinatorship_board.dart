import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';

/// Ayrıntı "Görevler" sekmesinin durum süzgeci (prototip `TFD`).
enum CoordTaskFilter {
  open,
  late,
  review,
  dateRequest,
  notStarted,
  done,
  all;

  bool matches(TaskItem t) => switch (this) {
    open => !t.isDone,
    late => !t.isDone && t.isOverdue,
    review => t.status == TaskStatus.review,
    dateRequest => t.hasPendingRequest,
    notStarted => t.status == TaskStatus.todo,
    done => t.isDone,
    all => true,
  };
}

/// İlerleme kartının dağılımı: biten, süren (gecikmesiz, başlamış), geciken, başlamadı.
@immutable
final class CoordPulse {
  const CoordPulse({
    required this.done,
    required this.doing,
    required this.late,
    required this.todo,
    required this.requests,
  });

  factory CoordPulse.of(List<TaskItem> tasks) {
    var done = 0, doing = 0, late = 0, todo = 0, requests = 0;
    for (final t in tasks) {
      if (t.hasPendingRequest) requests++;
      if (t.isDone) {
        done++;
      } else if (t.isOverdue) {
        late++;
      } else if (t.status == TaskStatus.todo) {
        todo++;
      } else {
        doing++;
      }
    }
    return CoordPulse(
      done: done,
      doing: doing,
      late: late,
      todo: todo,
      requests: requests,
    );
  }

  final int done;
  final int doing;
  final int late;
  final int todo;

  /// Bekleyen tarih talebi olan görev sayısı.
  final int requests;

  int get total => done + doing + late + todo;
  int get open => total - done;
  double get ratio => total == 0 ? 0 : done / total;
}

/// Ekip satırı: koordinatörlükteki açık/geciken görev sayısıyla.
@immutable
final class CoordPerson {
  const CoordPerson({
    required this.id,
    required this.name,
    required this.lead,
    required this.open,
    required this.late,
  });

  final String id;
  final String name;
  final bool lead;
  final int open;
  final int late;
}

/// [lead] ve [members] kişileri, [tasks] içindeki açık/geciken atamalarıyla; önce
/// koordinatörler, sonra açık görevi çok olan.
List<CoordPerson> coordPeople(
  List<Person> leads,
  List<Person> members,
  List<TaskItem> tasks,
) {
  CoordPerson row(Person p, bool lead) {
    final mine = tasks.where((t) => !t.isDone && t.assignees.contains(p.id));
    return CoordPerson(
      id: p.id,
      name: p.name,
      lead: lead,
      open: mine.length,
      late: mine.where((t) => t.isOverdue).length,
    );
  }

  final seen = <String>{};
  return [
    for (final p in leads)
      if (seen.add(p.id)) row(p, true),
    for (final p in members)
      if (seen.add(p.id)) row(p, false),
  ]..sort((a, b) {
    if (a.lead != b.lead) return a.lead ? -1 : 1;
    return b.open.compareTo(a.open);
  });
}

/// Koordinatörlüğün toplantısı (`listMeetings` satırı).
@immutable
final class CoordMeeting {
  const CoordMeeting({
    required this.id,
    required this.title,
    required this.at,
    required this.owner,
    required this.departments,
  });

  final String id;
  final String title;

  /// Yerel an.
  final DateTime at;

  /// Bu koordinatörlük sahip mi (değilse davetli).
  final bool owner;

  /// Katılan birim sayısı.
  final int departments;
}

/// Arşiv dosyası türü (prototip `IMG` / `DOC` / `PDF`).
enum CoordFileKind { image, document, pdf }

/// Koordinatörlük arşivindeki dosya (`archiveAttachments` satırı).
@immutable
final class CoordFile {
  const CoordFile({
    required this.id,
    required this.name,
    required this.kind,
    required this.sizeBytes,
    required this.workItemId,
    required this.uploaderId,
  });

  final String id;
  final String name;
  final CoordFileKind kind;
  final int sizeBytes;
  final String workItemId;
  final String uploaderId;

  /// İçerik türünden.
  static CoordFileKind kindOf(String contentType) {
    if (contentType.startsWith('image/')) return CoordFileKind.image;
    if (contentType == 'application/pdf') return CoordFileKind.pdf;
    return CoordFileKind.document;
  }
}

/// Koordinatörlük toplantı ve arşiv kaynağı (domain portu; gerçekleştirme `data/`).
abstract interface class CoordinatorshipActivityRepository {
  /// Departmanın katıldığı (sahip ya da davetli) görünür toplantılar.
  Future<List<CoordMeeting>> meetings(String departmentId);

  /// Departman arşivinde [workItemIds] görevlerine bağlı dosyalar (sunucu sırası: yeni önce).
  Future<List<CoordFile>> files(String departmentId, Set<String> workItemIds);
}
