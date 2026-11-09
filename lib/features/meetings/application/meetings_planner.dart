import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/meeting.dart';
import '../domain/meetings_repository.dart';
import 'meeting_room_controller.dart';
import 'meetings_controller.dart';
import 'meetings_providers.dart';

/// tasks'ın [MeetingPlanner] portunun gerçekleştirmesi (hızlı toplantı formu, nottan görev).
/// Başarılı yazmadan sonra etkilenen liste ve ayrıntı yeniden okunur.
class MeetingsPlanner implements MeetingPlanner {
  MeetingsPlanner(this._ref);

  final Ref _ref;

  MeetingsRepository get _repo => _ref.read(meetingsRepositoryProvider);

  @override
  Future<String> create(MeetingPlan plan) async {
    final r = await _repo.createMeeting(
      MeetingDraft(
        title: plan.title,
        meetingDate: plan.at,
        departmentIds: plan.departmentIds,
        participantIds: plan.participantIds.isEmpty
            ? null
            : plan.participantIds,
        membersIncluded: plan.membersIncluded,
        agendaItems: plan.agenda.isEmpty ? null : plan.agenda,
        place: plan.place.isEmpty ? null : plan.place,
        inviteMode: plan.byPerson
            ? MeetingInviteMode.person
            : MeetingInviteMode.coordinatorship,
      ),
    );
    _ref.invalidate(meetingsBoardControllerProvider);
    return r.meeting.id;
  }

  @override
  Future<void> update(String meetingId, MeetingPlan plan) async {
    await _repo.updateMeeting(
      meetingId,
      // Kişi kipinde departman seti ve üye bayrağı gönderilmez (K73: 422). Boş yer kaldırır.
      MeetingChanges(
        title: plan.title,
        meetingDate: plan.at,
        departmentIds: plan.byPerson ? null : plan.departmentIds,
        membersIncluded: plan.byPerson ? null : plan.membersIncluded,
        place: plan.place,
      ),
    );
    _ref
      ..invalidate(meetingsBoardControllerProvider)
      ..invalidate(meetingRoomControllerProvider(meetingId));
  }

  @override
  Future<String> convertNote(String noteId, NoteTaskPlan plan) async {
    final r = await _repo.convertNoteToTask(
      noteId,
      NoteTaskDraft(
        startDate: plan.start,
        endDate: plan.end,
        title: plan.title,
        priority: switch (plan.priority) {
          TaskPriority.low => MeetingTaskPriority.low,
          TaskPriority.medium => MeetingTaskPriority.medium,
          TaskPriority.high => MeetingTaskPriority.high,
          TaskPriority.urgent => MeetingTaskPriority.urgent,
          TaskPriority.unknown => null,
        },
        departmentId: plan.departmentId,
        assigneeAccountIds: plan.assigneeIds.isEmpty ? null : plan.assigneeIds,
      ),
    );
    _ref.invalidate(meetingRoomControllerProvider(r.note.meetingId));
    return r.workItemId;
  }
}
