import 'package:meta/meta.dart';

import 'task_catalog.dart';

// Hızlı toplantı formunun ve "nottan görev" kipindeki yeni görev formunun dış bağımlılığı.
// Formlar tasks'tadır; toplantı uçları meetings feature'ınındır. Gerçekleştirme meetings'te
// (`MeetingsPlanner`), bağlama bileşim kökünde (`meetingsOverrides`). Böylece tasks meetings'i
// import etmez (feature'lar arası tek yön: meetings → tasks).

/// Toplantı açma/düzenleme girdisi.
@immutable
final class MeetingPlan {
  const MeetingPlan({
    required this.title,
    required this.at,
    required this.departmentIds,
    this.participantIds = const [],
    this.membersIncluded = false,
    this.agenda = const [],
  });

  final String title;

  /// Yerel duvar saati (sunucu kurulum saat diliminde yorumlar).
  final DateTime at;

  /// En az bir departman; ilki sahip departmandır.
  final List<String> departmentIds;

  /// Kişi bazlı davette katılımcılar (yalnız açılışta).
  final List<String> participantIds;
  final bool membersIncluded;

  /// İlk gündem maddeleri (yalnız açılışta).
  final List<String> agenda;
}

/// Nottan görev girdisi (`convertNoteToTask`).
@immutable
final class NoteTaskPlan {
  const NoteTaskPlan({
    required this.title,
    required this.start,
    required this.end,
    required this.priority,
    required this.departmentId,
    this.assigneeIds = const [],
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final TaskPriority priority;
  final String departmentId;
  final List<String> assigneeIds;
}

/// Toplantı yazmaları (hata: `ApiError`).
abstract interface class MeetingPlanner {
  /// Yeni toplantı; kimliğini döner.
  Future<String> create(MeetingPlan plan);

  /// Başlık, an, departman seti ve üye bayrağını günceller (katılımcı ve gündem değişmez).
  Future<void> update(String meetingId, MeetingPlan plan);

  /// Notu göreve dönüştürür; görev kimliğini döner.
  Future<String> convertNote(String noteId, NoteTaskPlan plan);
}
