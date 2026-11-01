import 'package:meta/meta.dart';

import 'task_catalog.dart';
import 'task_permissions.dart';

/// Alt görev değişikliği (`PATCH …/subtasks/{id}`). null alan değişmez. [assignee] verilirse
/// `id` null → atamayı kaldır; [dates] verilirse ikisi birlikte gider (ikisi null → kaldır).
@immutable
final class SubtaskPatch {
  const SubtaskPatch({this.title, this.assignee, this.dates, this.done});

  final String? title;
  final ({String? id})? assignee;
  final ({DateTime? start, DateTime? end})? dates;
  final bool? done;
}

/// Görev ayrıntısının sunucu yazmaları (domain portu; gerçekleştirme `data/`). Her çağrı
/// görevin KENDİ (program, departman) kapsamıyla gider (S3). Yanıt gövdesi yerel durumu
/// değiştirmek için kullanılmaz (iyimser güncelleme yok; çağıran yeniden okur). Hatalar
/// `ApiError` olarak fırlar.
abstract interface class TaskWriteRepository {
  /// [via] ucuyla durum geçişi; [closeSubtasks] yalnız `tamamlandi` hedefinde.
  Future<void> changeStatus(
    TaskItem task,
    StatusEndpoint via,
    TaskStatus to, {
    String? reason,
    bool closeSubtasks = false,
  });

  Future<void> addNote(TaskItem task, String text);

  Future<void> updateNote(TaskItem task, String noteId, String text);

  Future<void> deleteNote(TaskItem task, String noteId);

  Future<void> createSubtask(TaskItem task, String title);

  Future<void> updateSubtask(
    TaskItem task,
    String subtaskId,
    SubtaskPatch patch,
  );

  Future<void> deleteSubtask(TaskItem task, String subtaskId);
}
