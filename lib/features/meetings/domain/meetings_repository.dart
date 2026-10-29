import '../../../core/domain/page_slice.dart';
import 'meeting.dart';

/// Toplantı uçlarının kaynağı (domain portu; gerçekleştirme `data/meetings_api_repository.dart`).
/// Bütün uçlar S2'dir: program başlığı ara katmandan, seçili kapsamdan gelir. Görünürlük sunucu
/// kuralıdır (COLLABORATION-K19). Konferans uçları `v0.2.0-api`'de yoktur.
abstract interface class MeetingsRepository {
  /// `createMeeting`.
  Future<MeetingCreated> createMeeting(MeetingDraft draft);

  /// `listMeetings` — görünür toplantılar (imleçli; tarih aralığı süzgeci yok).
  Future<PageSlice<Meeting>> listMeetings([
    PageRequest page = const PageRequest(),
  ]);

  /// `listDeletedMeetings` — silinmiş toplantılar (yalnız yönetici).
  Future<PageSlice<Meeting>> listDeletedMeetings([
    PageRequest page = const PageRequest(),
  ]);

  /// `adminListDeletedMeetings` — aynı use-case, yönetici yaşam döngüsü yolu.
  Future<PageSlice<Meeting>> adminListDeletedMeetings([
    PageRequest page = const PageRequest(),
  ]);

  /// `restoreMeeting`.
  Future<MeetingLifecycleResult> restoreMeeting(String meetingId);

  /// `permanentDeleteMeeting`.
  Future<MeetingLifecycleResult> permanentDeleteMeeting(String meetingId);

  /// `getMeeting`.
  Future<MeetingDetail> getMeeting(String meetingId);

  /// `updateMeeting`.
  Future<MeetingRevised> updateMeeting(
    String meetingId,
    MeetingChanges changes,
  );

  /// `deleteMeeting` (yumuşak silme).
  Future<void> deleteMeeting(String meetingId);

  /// `addMeetingParticipant` (yanıt yalnız girdiyi yansıtır).
  Future<void> addParticipant(String meetingId, String userId);

  /// `removeMeetingParticipant`.
  Future<void> removeParticipant(String meetingId, String userId);

  /// `addAgendaItem` (en çok 50 madde).
  Future<AgendaItem> addAgendaItem(String meetingId, String title);

  /// `listAgenda` (sıralı; tek sayfa).
  Future<List<AgendaItem>> listAgenda(String meetingId);

  /// `updateAgendaItem`; `null` alan değişmez.
  Future<AgendaItem> updateAgendaItem(
    String itemId, {
    String? title,
    bool? isChecked,
  });

  /// `deleteAgendaItem`.
  Future<void> deleteAgendaItem(String itemId);

  /// `addMeetingNote`.
  Future<MeetingNote> addNote(String meetingId, String content);

  /// `listMeetingNotes` (imleçli).
  Future<PageSlice<MeetingNote>> listNotes(
    String meetingId, [
    PageRequest page = const PageRequest(),
  ]);

  /// `updateMeetingNote`.
  Future<MeetingNote> updateNote(String noteId, String content);

  /// `deleteMeetingNote` (yumuşak silme).
  Future<void> deleteNote(String noteId);

  /// `convertNoteToTask`.
  Future<NoteConversion> convertNoteToTask(String noteId, NoteTaskDraft draft);
}
