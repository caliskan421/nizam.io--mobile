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

/// Görev dağılımı (Genel bölümündeki Görevler kartı): biten, süren (gecikmesiz, başlamış), geciken, başlamadı.
@immutable
final class CoordPulse {
  const CoordPulse({
    required this.done,
    required this.doing,
    required this.late,
    required this.todo,
  });

  factory CoordPulse.of(List<TaskItem> tasks) {
    var done = 0, doing = 0, late = 0, todo = 0;
    for (final t in tasks) {
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
    return CoordPulse(done: done, doing: doing, late: late, todo: todo);
  }

  final int done;
  final int doing;
  final int late;
  final int todo;

  int get total => done + doing + late + todo;
  int get open => total - done;
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

/// Genel "Akış" öğesi: gecikmesiz açık görevin teslimi ya da toplantı.
sealed class CoordFlowItem {
  const CoordFlowItem();

  DateTime get at;
}

final class CoordFlowTask extends CoordFlowItem {
  const CoordFlowTask(this.task);

  final TaskItem task;

  @override
  DateTime get at => task.due;
}

final class CoordFlowMeeting extends CoordFlowItem {
  const CoordFlowMeeting(this.meeting);

  final CoordMeeting meeting;

  @override
  DateTime get at => meeting.at;
}

/// Genel "Akış" (prototip `flow`): bugünden önce en son teslimi geçmiş üç geciken görev
/// (eskiden yeniye), bugünden sonra ilk dört öğe (en çok üç yaklaşan toplantı ve gecikmesiz
/// açık teslimler, tarihe göre).
({List<TaskItem> late, List<CoordFlowItem> upcoming}) coordFlow(
  List<TaskItem> tasks,
  List<CoordMeeting> meetings,
  DateTime now,
) {
  final late = [
    for (final t in tasks)
      if (!t.isDone && t.isOverdue) t,
  ]..sort((a, b) => a.due.compareTo(b.due));
  final soon = [...meetings.where((m) => !m.at.isBefore(now))]
    ..sort((a, b) => a.at.compareTo(b.at));
  final upcoming = <CoordFlowItem>[
    for (final m in soon.take(3)) CoordFlowMeeting(m),
    for (final t in tasks)
      if (!t.isDone && !t.isOverdue) CoordFlowTask(t),
  ]..sort((a, b) => a.at.compareTo(b.at));
  return (
    late: late.sublist(late.length > 3 ? late.length - 3 : 0),
    upcoming: upcoming.take(4).toList(),
  );
}

/// Genel "İş yükü" satırı: atanan kişinin bu birimdeki geciken, gecikmesiz açık ve biten
/// görev sayısı.
@immutable
final class CoordLoad {
  const CoordLoad({
    required this.id,
    required this.late,
    required this.open,
    required this.done,
  });

  final String id;
  final int late;
  final int open;
  final int done;

  int get total => late + open + done;
}

/// [tasks] atananları iş yüküne göre (önce geciken, sonra açık, sonra toplam); en çok beş.
List<CoordLoad> coordLoad(List<TaskItem> tasks) {
  final ids = <String>{for (final t in tasks) ...t.assignees};
  final rows =
      [
        for (final id in ids)
          () {
            final mine = tasks.where((t) => t.assignees.contains(id));
            return CoordLoad(
              id: id,
              late: mine.where((t) => !t.isDone && t.isOverdue).length,
              open: mine.where((t) => !t.isDone && !t.isOverdue).length,
              done: mine.where((t) => t.isDone).length,
            );
          }(),
      ]..sort((a, b) {
        if (a.late != b.late) return b.late.compareTo(a.late);
        if (a.open != b.open) return b.open.compareTo(a.open);
        return b.total.compareTo(a.total);
      });
  return rows.take(5).toList();
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
