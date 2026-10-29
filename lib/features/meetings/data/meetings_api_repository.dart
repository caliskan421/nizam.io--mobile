import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/collaboration_client.dart';
import '../../../core/api/generated/models/agenda_item.dart' as api;
import '../../../core/api/generated/models/agenda_item_request.dart';
import '../../../core/api/generated/models/convert_note_request.dart';
import '../../../core/api/generated/models/convert_note_request_priority.dart';
import '../../../core/api/generated/models/create_meeting_request.dart';
import '../../../core/api/generated/models/meeting.dart' as api;
import '../../../core/api/generated/models/meeting_department.dart' as api;
import '../../../core/api/generated/models/meeting_list.dart' as api;
import '../../../core/api/generated/models/meeting_note.dart' as api;
import '../../../core/api/generated/models/meeting_note_list.dart' as api;
import '../../../core/api/generated/models/meeting_side_effects.dart' as api;
import '../../../core/api/generated/models/note_request.dart';
import '../../../core/api/generated/models/participant.dart' as api;
import '../../../core/api/generated/models/participant_request.dart';
import '../../../core/api/generated/models/update_agenda_item_request.dart';
import '../../../core/api/generated/models/update_meeting_request.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/meeting.dart';
import '../domain/meetings_repository.dart';

/// Toplantı uçlarına (collaboration) üretilmiş istemciyle erişim. Mesaj uçları bu sınıfın
/// kapsamı dışındadır (messages feature'ı). Üretilmiş DTO'lar bu katmanda kalır; dışarıya domain
/// varlıkları döner (A1/A2). Bütün hatalar [ApiError] olarak fırlar.
class ApiMeetingsRepository implements MeetingsRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (program başlığını ara katman ekler).
  ApiMeetingsRepository(Dio dio) : _client = CollaborationClient(dio);

  final CollaborationClient _client;

  @override
  Future<MeetingCreated> createMeeting(MeetingDraft draft) async {
    final r = await apiCall(
      () => _client.createMeeting(
        body: CreateMeetingRequest(
          title: draft.title,
          meetingDate: meetingDateWire(draft.meetingDate),
          departmentIds: draft.departmentIds,
          participantIds: draft.participantIds,
          membersIncluded: draft.membersIncluded,
          agendaItems: draft.agendaItems,
          isInstant: draft.isInstant,
        ),
      ),
    );
    return MeetingCreated(
      meeting: _meeting(r.meeting),
      failedParticipants: List.unmodifiable(r.failedParticipants ?? const []),
      sideEffects: _effects(r.sideEffects),
    );
  }

  @override
  Future<PageSlice<Meeting>> listMeetings([
    PageRequest page = const PageRequest(),
  ]) async => _meetings(
    await apiCall(
      () => _client.listMeetings(limit: page.limit, cursor: page.cursor),
    ),
  );

  @override
  Future<PageSlice<Meeting>> listDeletedMeetings([
    PageRequest page = const PageRequest(),
  ]) async => _meetings(
    await apiCall(
      () => _client.listDeletedMeetings(limit: page.limit, cursor: page.cursor),
    ),
  );

  @override
  Future<PageSlice<Meeting>> adminListDeletedMeetings([
    PageRequest page = const PageRequest(),
  ]) async => _meetings(
    await apiCall(
      () => _client.adminListDeletedMeetings(
        limit: page.limit,
        cursor: page.cursor,
      ),
    ),
  );

  @override
  Future<MeetingLifecycleResult> restoreMeeting(String meetingId) async {
    final r = await apiCall(() => _client.restoreMeeting(id: meetingId));
    return MeetingLifecycleResult(
      meetingId: r.meetingId,
      status: _status(r.status.json),
    );
  }

  @override
  Future<MeetingLifecycleResult> permanentDeleteMeeting(
    String meetingId,
  ) async {
    final r = await apiCall(
      () => _client.permanentDeleteMeeting(id: meetingId),
    );
    return MeetingLifecycleResult(
      meetingId: r.meetingId,
      status: _status(r.status.json),
    );
  }

  @override
  Future<MeetingDetail> getMeeting(String meetingId) async {
    final r = await apiCall(() => _client.getMeeting(id: meetingId));
    return MeetingDetail(
      meeting: Meeting(
        id: r.meetingId,
        programId: r.programId,
        ownerDepartmentId: r.ownerDepartmentId,
        title: r.title,
        meetingDate: r.meetingDate,
        membersIncluded: r.membersIncluded,
        createdByAccountId: r.createdByAccountId,
        createdByRole: _role(r.createdByRole.json),
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
        departments: _departments(r.departments),
        deletedAt: r.deletedAt,
      ),
      viewerRole: _role(r.viewerRole.json),
      participants: List.unmodifiable(r.participants.map(_participant)),
      agenda: List.unmodifiable(r.agenda.map(_agenda)),
      notes: _notes(r.notes),
    );
  }

  @override
  Future<MeetingRevised> updateMeeting(
    String meetingId,
    MeetingChanges changes,
  ) async {
    final date = changes.meetingDate;
    final r = await apiCall(
      () => _client.updateMeeting(
        id: meetingId,
        body: UpdateMeetingRequest(
          title: changes.title,
          meetingDate: date == null ? null : meetingDateWire(date),
          departmentIds: changes.departmentIds,
          membersIncluded: changes.membersIncluded,
        ),
      ),
    );
    return MeetingRevised(
      meeting: Meeting(
        id: r.meetingId,
        programId: r.programId,
        ownerDepartmentId: r.ownerDepartmentId,
        title: r.title,
        meetingDate: r.meetingDate,
        membersIncluded: r.membersIncluded,
        createdByAccountId: r.createdByAccountId,
        createdByRole: _role(r.createdByRole.json),
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
        departments: _departments(r.departments),
        deletedAt: r.deletedAt,
      ),
      sideEffects: _effects(r.sideEffects),
    );
  }

  @override
  Future<void> deleteMeeting(String meetingId) =>
      apiCall(() => _client.deleteMeeting(id: meetingId));

  @override
  Future<void> addParticipant(String meetingId, String userId) async {
    await apiCall(
      () => _client.addMeetingParticipant(
        id: meetingId,
        body: ParticipantRequest(userId: userId),
      ),
    );
  }

  @override
  Future<void> removeParticipant(String meetingId, String userId) => apiCall(
    () => _client.removeMeetingParticipant(id: meetingId, userId: userId),
  );

  @override
  Future<AgendaItem> addAgendaItem(String meetingId, String title) async =>
      _agenda(
        await apiCall(
          () => _client.addAgendaItem(
            id: meetingId,
            body: AgendaItemRequest(title: title),
          ),
        ),
      );

  @override
  Future<List<AgendaItem>> listAgenda(String meetingId) async {
    final r = await apiCall(() => _client.listAgenda(id: meetingId));
    return List.unmodifiable(r.items.map(_agenda));
  }

  @override
  Future<AgendaItem> updateAgendaItem(
    String itemId, {
    String? title,
    bool? isChecked,
  }) async => _agenda(
    await apiCall(
      () => _client.updateAgendaItem(
        itemId: itemId,
        body: UpdateAgendaItemRequest(title: title, isChecked: isChecked),
      ),
    ),
  );

  @override
  Future<void> deleteAgendaItem(String itemId) =>
      apiCall(() => _client.deleteAgendaItem(itemId: itemId));

  @override
  Future<MeetingNote> addNote(String meetingId, String content) async => _note(
    await apiCall(
      () => _client.addMeetingNote(
        id: meetingId,
        body: NoteRequest(content: content),
      ),
    ),
  );

  @override
  Future<PageSlice<MeetingNote>> listNotes(
    String meetingId, [
    PageRequest page = const PageRequest(),
  ]) async => _notes(
    await apiCall(
      () => _client.listMeetingNotes(
        id: meetingId,
        limit: page.limit,
        cursor: page.cursor,
      ),
    ),
  );

  @override
  Future<MeetingNote> updateNote(String noteId, String content) async => _note(
    await apiCall(
      () => _client.updateMeetingNote(
        noteId: noteId,
        body: NoteRequest(content: content),
      ),
    ),
  );

  @override
  Future<void> deleteNote(String noteId) =>
      apiCall(() => _client.deleteMeetingNote(noteId: noteId));

  /// Not: üretilmiş `ConvertNoteRequest` `format: date` alanlarını tam ISO tarih-saat
  /// (`2026-11-03T00:00:00.000`) olarak yazar; sunucu yalnız `YYYY-MM-DD` kabul eder. Üretici
  /// düzeltilene kadar bu uç 422 alabilir (envanter: açık sorun). Gün dışı bileşenler atılır.
  @override
  Future<NoteConversion> convertNoteToTask(
    String noteId,
    NoteTaskDraft draft,
  ) async {
    final priority = draft.priority;
    final r = await apiCall(
      () => _client.convertNoteToTask(
        noteId: noteId,
        body: ConvertNoteRequest(
          startDate: _day(draft.startDate),
          endDate: _day(draft.endDate),
          title: draft.title,
          priority: priority == null ? null : _priority(priority),
          departmentId: draft.departmentId,
          assigneeAccountIds: draft.assigneeAccountIds,
        ),
      ),
    );
    return NoteConversion(workItemId: r.workItemId, note: _note(r.note));
  }

  /// `meeting_date` tel biçimi: UTC → RFC 3339 (`…Z`); yerel → saat dilimsiz duvar saati
  /// (`YYYY-MM-DDTHH:MM:SS`, sunucu kurulum saat diliminde yorumlar).
  static String meetingDateWire(DateTime d) {
    if (d.isUtc) return d.toIso8601String();
    String two(int n) => n.toString().padLeft(2, '0');
    final y = d.year.toString().padLeft(4, '0');
    return '$y-${two(d.month)}-${two(d.day)}T'
        '${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static ConvertNoteRequestPriority _priority(MeetingTaskPriority p) =>
      switch (p) {
        MeetingTaskPriority.low => ConvertNoteRequestPriority.dusuk,
        MeetingTaskPriority.medium => ConvertNoteRequestPriority.orta,
        MeetingTaskPriority.high => ConvertNoteRequestPriority.yuksek,
        MeetingTaskPriority.urgent => ConvertNoteRequestPriority.acil,
      };

  static MeetingRole _role(String? wire) =>
      enumFromWire(MeetingRole.values, wire, MeetingRole.unknown);

  static MeetingLifecycleStatus _status(String? wire) => enumFromWire(
    MeetingLifecycleStatus.values,
    wire,
    MeetingLifecycleStatus.unknown,
  );

  /// Sözleşmede `next_cursor` zorunlu dizgedir; boş dizge son sayfadır.
  static String? _cursor(String c) => c.isEmpty ? null : c;

  static PageSlice<Meeting> _meetings(api.MeetingList r) => PageSlice(
    items: r.items.map(_meeting).toList(),
    nextCursor: _cursor(r.nextCursor),
  );

  static PageSlice<MeetingNote> _notes(api.MeetingNoteList r) => PageSlice(
    items: r.items.map(_note).toList(),
    nextCursor: _cursor(r.nextCursor),
  );

  static List<MeetingDepartment> _departments(
    List<api.MeetingDepartment> list,
  ) => List.unmodifiable(
    list.map(
      (d) => MeetingDepartment(id: d.departmentId, name: d.departmentName),
    ),
  );

  static Meeting _meeting(api.Meeting r) => Meeting(
    id: r.meetingId,
    programId: r.programId,
    ownerDepartmentId: r.ownerDepartmentId,
    title: r.title,
    meetingDate: r.meetingDate,
    membersIncluded: r.membersIncluded,
    createdByAccountId: r.createdByAccountId,
    createdByRole: _role(r.createdByRole.json),
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    departments: _departments(r.departments),
    deletedAt: r.deletedAt,
  );

  static MeetingParticipant _participant(api.Participant r) =>
      MeetingParticipant(accountId: r.accountId, fullName: r.fullName);

  static AgendaItem _agenda(api.AgendaItem r) => AgendaItem(
    id: r.agendaItemId,
    meetingId: r.meetingId,
    title: r.title,
    sortOrder: r.sortOrder,
    isChecked: r.isChecked,
    createdAt: r.createdAt,
    checkedAt: r.checkedAt,
    checkedByAccountId: r.checkedByAccountId,
  );

  static MeetingNote _note(api.MeetingNote r) => MeetingNote(
    id: r.noteId,
    meetingId: r.meetingId,
    authorAccountId: r.authorAccountId,
    authorName: r.authorName,
    authorRole: _role(r.authorRole?.json),
    content: r.content,
    convertedToWorkItemId: r.convertedToWorkItemId,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  static MeetingSideEffects _effects(api.MeetingSideEffects r) =>
      MeetingSideEffects(
        failedMessages: r.failedMessages,
        eventFailed: r.eventFailed,
      );
}
