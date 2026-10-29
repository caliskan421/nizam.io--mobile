import 'package:meta/meta.dart';

import 'report_common.dart';

/// Toplantının bağlı olduğu departman (sunucu `ReportMeetingDepartment`).
@immutable
final class ReportMeetingDepartment {
  const ReportMeetingDepartment({
    required this.departmentId,
    required this.name,
    required this.deleted,
  });

  final String departmentId;
  final String name;
  final bool deleted;
}

/// Rapor toplantı satırı (sunucu `ReportMeeting`).
@immutable
final class ReportMeeting {
  const ReportMeeting({
    required this.meetingId,
    required this.title,
    required this.meetingDate,
    required this.ownerDepartmentId,
    required this.coordinatorships,
    required this.createdBy,
    required this.createdByRole,
    required this.membersIncluded,
    required this.participants,
    required this.participantCount,
    required this.noteCount,
  });

  final String meetingId;
  final String title;
  final DateTime meetingDate;
  final String ownerDepartmentId;
  final List<ReportMeetingDepartment> coordinatorships;
  final ReportPerson createdBy;

  /// Sözleşmede `admin` | `coordinator`.
  final ReportRole createdByRole;
  final bool membersIncluded;
  final List<ReportPerson> participants;
  final int participantCount;
  final int noteCount;
}

/// Toplantı katılımcısı (sunucu `ReportParticipant`; rol serbest dizge).
@immutable
final class ReportParticipant {
  const ReportParticipant({
    required this.accountId,
    required this.fullName,
    required this.role,
  });

  final String accountId;
  final String fullName;
  final ReportRole role;
}

/// Gündem maddesi.
@immutable
final class ReportAgendaItem {
  const ReportAgendaItem({required this.title, required this.isChecked});

  final String title;
  final bool isChecked;
}

/// Toplantı notu (sunucu `ReportMeetingNote`).
@immutable
final class ReportMeetingNote {
  const ReportMeetingNote({
    required this.noteId,
    required this.content,
    required this.author,
    required this.createdAt,
    this.authorRole,
    this.convertedToTaskId,
    this.convertedTaskTitle,
  });

  final String noteId;
  final String content;
  final ReportPerson author;

  /// Yazarın rol kopyası; rolü kaydedilmemiş eski notlarda (sunucu boş dizge) null.
  final ReportRole? authorRole;
  final DateTime createdAt;
  final String? convertedToTaskId;
  final String? convertedTaskTitle;
}

/// Toplantı detay raporu (`GET /v1/reports/meetings/{id}`).
@immutable
final class ReportMeetingDetail {
  const ReportMeetingDetail({
    required this.meeting,
    required this.participants,
    required this.agenda,
    required this.notes,
  });

  final ReportMeeting meeting;
  final List<ReportParticipant> participants;
  final List<ReportAgendaItem> agenda;
  final List<ReportMeetingNote> notes;
}
