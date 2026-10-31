import 'package:meta/meta.dart';

import 'task_access.dart';
import 'task_catalog.dart';

/// Görev ayrıntısının listede gelmeyen parçaları: alt görevler, notlar, kanıt dosyaları ve
/// bekleyen tarih değişikliği talebi. Katalogdaki göreve eklenir ([TaskItem.copyWith]).
@immutable
final class TaskDetails {
  TaskDetails({
    required List<Subtask> subtasks,
    required List<TaskNote> notes,
    required List<TaskFile> files,
    this.dateRequest,
  }) : subtasks = List.unmodifiable(subtasks),
       notes = List.unmodifiable(notes),
       files = List.unmodifiable(files);

  final List<Subtask> subtasks;
  final List<TaskNote> notes;
  final List<TaskFile> files;

  /// Görevin bekleyen tarih talebi; yoksa null.
  final DateChangeRequest? dateRequest;
}

/// Görev ayrıntısının kaynağı (domain portu; gerçekleştirmeler `data/`). Ayrıntı görevin
/// kendi departmanında okunur (S3). null → kaynak ayrıntı taşımaz (örnek katalog görevi zaten
/// içerir). [access]: oturumun rolü (tarih talebi yüzünü seçer; null → tarih talebi okunmaz).
abstract interface class TaskDetailsRepository {
  Future<TaskDetails?> load(TaskItem task, {TaskAccess? access});
}
