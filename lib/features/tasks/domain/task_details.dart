import 'package:meta/meta.dart';

import 'task_access.dart';
import 'task_catalog.dart';

/// Görev ayrıntısı: tekil okumadaki görevin kendisi ([item]; açıklama ve tarihler dahil) ve
/// listede gelmeyen parçalar — alt görevler, notlar, kanıt dosyaları, bekleyen tarih talebi,
/// kişi adları. Katalogdaki görevin yerine geçer ([item] varsa) ve ona eklenir.
@immutable
final class TaskDetails {
  TaskDetails({
    required List<Subtask> subtasks,
    required List<TaskNote> notes,
    required List<TaskFile> files,
    this.dateRequest,
    this.item,
    List<PersonName> names = const [],
  }) : subtasks = List.unmodifiable(subtasks),
       notes = List.unmodifiable(notes),
       files = List.unmodifiable(files),
       names = List.unmodifiable(names);

  /// Tekil okumadaki görev (`getWorkItem`); null → kaynak tekil okuma yapmadı.
  final TaskItem? item;

  /// Ayrıntıdaki kişi adları (null ad girmez): atananlar, not yazarları, alt görev
  /// atanan/kapatan/oluşturan, dosya yükleyenleri.
  final List<PersonName> names;

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
