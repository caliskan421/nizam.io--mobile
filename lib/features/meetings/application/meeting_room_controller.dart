import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import '../domain/meeting_status.dart';
import '../domain/meetings_repository.dart';
import 'meeting_summary_controller.dart';
import 'meetings_controller.dart';
import 'meetings_providers.dart';

part 'meeting_room_controller.g.dart';

/// Ayrıntı bölümleri (prototip segmentli sekmeler).
enum MeetingSection { agenda, notes, people, info }

/// Ayrıntı ekranının görünüm durumu ([MeetingDetailViewController]).
@immutable
final class MeetingDetailView {
  const MeetingDetailView({
    this.section = MeetingSection.agenda,
    this.noteFilter = NoteFilter.all,
  });

  final MeetingSection section;
  final NoteFilter noteFilter;

  @override
  bool operator ==(Object other) =>
      other is MeetingDetailView &&
      other.section == section &&
      other.noteFilter == noteFilter;

  @override
  int get hashCode => Object.hash(section, noteFilter);
}

/// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).
@riverpod
class MeetingDetailViewController extends _$MeetingDetailViewController {
  @override
  MeetingDetailView build(String id) => const MeetingDetailView();

  void select(MeetingSection s) =>
      state = MeetingDetailView(section: s, noteFilter: state.noteFilter);

  void filterNotes(NoteFilter f) =>
      state = MeetingDetailView(section: state.section, noteFilter: f);
}

/// Toplantı ayrıntısı + bütün notlar (ayrıntı ilk sayfayı taşır; kalan sayfalar okunur).
@immutable
final class MeetingRoom {
  MeetingRoom({
    required this.detail,
    required List<MeetingNote> notes,
    this.coordinatesLinked = false,
    this.me,
    this.extras = MeetingExtras.none,
    this.noteSubmitting = false,
  }) : notes = List.unmodifiable(notes);

  /// Not ekleme isteği uçuşta: gönder düğmesi kapalı, yeni gönderim reddedilir. Kilit widget'ta
  /// değil burada durur (sekme değişip dönünce sıfırlanmaz).
  final bool noteSubmitting;

  final MeetingDetail detail;
  final List<MeetingNote> notes;

  /// Görüntüleyen toplantıya bağlı bir departmanın koordinatörü (katılımcı yönetimi, K21).
  final bool coordinatesLinked;

  /// Oturumdaki hesap.
  final String? me;

  /// Backend'in taşımadığı olgular (geçici; üretimde boş).
  final MeetingExtras extras;

  Meeting get meeting => detail.meeting;

  /// Konferans kartı ve kimlik durumu ([now] anına göre).
  MeetingStatus? status(DateTime now) => meetingStatus(
    meeting,
    now: now,
    conference: detail.conference,
    conferenceKnown: true,
    extras: extras,
  );

  MeetingPermissions get permissions => MeetingPermissions(
    role: detail.viewerRole,
    me: me,
    coordinatesLinked: coordinatesLinked,
  );

  MeetingRoom copyWith({
    MeetingDetail? detail,
    List<MeetingNote>? notes,
    bool? noteSubmitting,
  }) => MeetingRoom(
    detail: detail ?? this.detail,
    notes: notes ?? this.notes,
    coordinatesLinked: coordinatesLinked,
    me: me,
    extras: extras,
    noteSubmitting: noteSubmitting ?? this.noteSubmitting,
  );
}

/// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
/// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.
@riverpod
class MeetingRoomController extends _$MeetingRoomController {
  static const notesPageSize = 100;
  static const notesMaxPages = 10;

  MeetingsRepository get _repo => ref.read(meetingsRepositoryProvider);

  /// Bekleyen not ekleme anahtarı (ADR-0027): aynı metnin yeniden gönderimi aynı anahtarla.
  RequestKeys _keys = const RequestKeys();

  @override
  Future<MeetingRoom> build(String id) async {
    final program = ref.watch(scopeStateProvider).programId;
    final repo = ref.read(meetingsRepositoryProvider);
    final catalog = await ref.read(taskCatalogControllerProvider.future);
    final detail = await repo.getMeeting(id);
    final now = DateTime.now();
    final notes = [...detail.notes.items];
    var cursor = detail.notes.nextCursor;
    for (var p = 0; cursor != null && p < notesMaxPages; p++) {
      final next = await repo.listNotes(
        id,
        PageRequest(limit: notesPageSize, cursor: cursor),
      );
      notes.addAll(next.items);
      cursor = next.nextCursor;
    }
    final linked = {for (final d in detail.meeting.departments) d.id};
    final seats = program == null
        ? const <TeamSeat>[]
        : catalog.access?.seatsIn(program) ?? const <TeamSeat>[];
    final room = MeetingRoom(
      detail: detail,
      notes: notes,
      me: catalog.me,
      extras: ref
          .read(meetingExtrasRepositoryProvider)
          .of(detail.meeting, DateTime(now.year, now.month, now.day)),
      coordinatesLinked: seats.any(
        (s) =>
            s.role == SeatRole.coordinator && linked.contains(s.departmentId),
      ),
    );
    _syncSummary(room);
    return room;
  }

  /// Aşağı çekerek yenileme: yeniden okur ve bitmesini bekler (hata ekranda görünür).
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Hata durumda (AsyncError) gösterilir; yenileme göstergesi kapanır.
    }
  }

  MeetingRoom? get _room => state.value;

  void _put(MeetingRoom room) {
    if (!ref.mounted) return;
    state = AsyncData(room);
    _syncSummary(room);
  }

  /// Liste kartı açıksa sayaçlarını ayrıntıdan günceller (ağ isteği yok).
  void _syncSummary(MeetingRoom room) {
    final summary = meetingSummaryControllerProvider(id);
    if (!ref.exists(summary)) return;
    ref
        .read(summary.notifier)
        .put(MeetingSummary.of(room.detail, notes: room.notes.length));
  }

  void _agenda(List<AgendaItem> items) {
    final r = _room;
    if (r != null) _put(r.copyWith(detail: r.detail.copyWith(agenda: items)));
  }

  void _notes(List<MeetingNote> notes) {
    final r = _room;
    if (r != null) _put(r.copyWith(notes: notes));
  }

  static List<T> _replace<T>(List<T> list, T old, T next) => [
    for (final x in list) identical(x, old) ? next : x,
  ];

  /// Gündem maddesini işaretler/kaldırır (iyimser).
  Future<ApiError?> toggleAgenda(AgendaItem a) async {
    final r = _room;
    if (r == null) return null;
    final now = DateTime.now();
    final optimistic = AgendaItem(
      id: a.id,
      meetingId: a.meetingId,
      title: a.title,
      sortOrder: a.sortOrder,
      isChecked: !a.isChecked,
      createdAt: a.createdAt,
      checkedAt: a.isChecked ? null : now,
      checkedByAccountId: a.isChecked ? null : r.me,
    );
    _agenda(_replace(r.detail.agenda, a, optimistic));
    try {
      final saved = await _repo.updateAgendaItem(
        a.id,
        isChecked: optimistic.isChecked,
      );
      final cur = _room;
      if (cur != null) _agenda(_replace(cur.detail.agenda, optimistic, saved));
      return null;
    } on Object catch (e) {
      final cur = _room;
      if (cur != null) _agenda(_replace(cur.detail.agenda, optimistic, a));
      return toApiError(e);
    }
  }

  /// Gündem maddesi ekler (1–300 karakter, toplantı başına en çok 50; sunucu denetler).
  Future<ApiError?> addAgenda(String title) async {
    final t = title.trim();
    if (t.isEmpty || _room == null) return null;
    try {
      final item = await _repo.addAgendaItem(id, t);
      final cur = _room;
      if (cur != null) _agenda([...cur.detail.agenda, item]);
      return null;
    } on Object catch (e) {
      return toApiError(e);
    }
  }

  /// Gündem maddesini siler (silme kalıcıdır; iyimser).
  Future<ApiError?> deleteAgenda(AgendaItem a) async {
    final r = _room;
    if (r == null) return null;
    final before = r.detail.agenda;
    _agenda([
      for (final x in before)
        if (!identical(x, a)) x,
    ]);
    try {
      await _repo.deleteAgendaItem(a.id);
      return null;
    } on Object catch (e) {
      _agenda(before);
      return toApiError(e);
    }
  }

  /// Uçuştaki not ekleme isteğinin anahtarı (kilidi yalnız kendi isteği açar).
  String? _noteInFlight;

  /// Not ekler. Uçuşta istek varken ([MeetingRoom.noteSubmitting]) istek gönderilmez. Anahtar
  /// yalnız TAMAMLANAN isteğin anahtarıyla eşleşiyorsa düşer (başarı ya da "anahtar başka
  /// istekle kullanılmış"); ağ/zaman aşımı hatasında kalır, aynı metin aynı anahtarla gider.
  Future<ApiError?> addNote(String content) async {
    final t = content.trim();
    final r = _room;
    if (t.isEmpty || r == null || r.noteSubmitting) return null;
    final (keys, key) = _keys.keyFor('note', t);
    _keys = keys;
    _noteInFlight = key;
    _put(r.copyWith(noteSubmitting: true));
    try {
      final note = await _repo.addNote(id, t, requestKey: key);
      _clearNoteKey(key);
      _releaseNote(key, (cur) => [note, ...cur.notes]);
      return null;
    } on Object catch (e) {
      final err = toApiError(e);
      if (isKeyReused(err)) _clearNoteKey(key);
      _releaseNote(key, null);
      return err;
    }
  }

  void _clearNoteKey(String key) {
    if (_keys.pending('note') == key) _keys = _keys.clear('note');
  }

  /// Kilidi yalnız [key] isteği hâlâ uçuştaki istekse açar; [notes] varsa listeyi günceller.
  void _releaseNote(
    String key,
    List<MeetingNote> Function(MeetingRoom cur)? notes,
  ) {
    final cur = _room;
    if (cur == null) return;
    final mine = _noteInFlight == key;
    if (mine) _noteInFlight = null;
    if (!mine && notes == null) return;
    _put(
      cur.copyWith(
        notes: notes?.call(cur),
        noteSubmitting: mine ? false : null,
      ),
    );
  }

  Future<ApiError?> updateNote(MeetingNote n, String content) async {
    final t = content.trim();
    if (t.isEmpty || t == n.content) return null;
    try {
      final saved = await _repo.updateNote(
        n.id,
        t,
        expectedRevision: n.editRevision,
      );
      final cur = _room;
      if (cur != null) _notes(_replace(cur.notes, n, saved));
      return null;
    } on Object catch (e) {
      return toApiError(e);
    }
  }

  /// Notu siler (yumuşak; iyimser).
  Future<ApiError?> deleteNote(MeetingNote n) async {
    final r = _room;
    if (r == null) return null;
    _notes([
      for (final x in r.notes)
        if (!identical(x, n)) x,
    ]);
    try {
      await _repo.deleteNote(n.id);
      return null;
    } on Object catch (e) {
      final cur = _room;
      if (cur != null) _notes([n, ...cur.notes]);
      return toApiError(e);
    }
  }

  /// Konferansı başlatır (aktif varsa sunucu mevcut olanı döner).
  Future<ApiError?> startConference() async {
    try {
      final c = await _repo.startConference(id);
      final cur = _room;
      if (cur != null) {
        _put(cur.copyWith(detail: cur.detail.copyWith(conference: () => c)));
      }
      return null;
    } on Object catch (e) {
      return toApiError(e);
    }
  }

  /// Konferansı herkes için bitirir.
  Future<ApiError?> endConference() async {
    try {
      await _repo.endConference(id);
      final cur = _room;
      if (cur != null) {
        _put(cur.copyWith(detail: cur.detail.copyWith(conference: () => null)));
      }
      return null;
    } on Object catch (e) {
      return toApiError(e);
    }
  }

  /// [people] sırayla eklenir (yanıt yalnız girdiyi yansıtır; ad katalogdan gelir); eklenemeyenler
  /// sayılır, ilk hata döner.
  Future<({int added, int failed, ApiError? error})> addParticipants(
    List<MeetingParticipant> people,
  ) async {
    var added = 0;
    var failed = 0;
    ApiError? first;
    for (final person in people) {
      try {
        await _repo.addParticipant(id, person.accountId);
        added++;
        final cur = _room;
        if (cur != null) {
          _put(
            cur.copyWith(
              detail: cur.detail.copyWith(
                participants: [...cur.detail.participants, person],
              ),
            ),
          );
        }
      } on Object catch (e) {
        failed++;
        first ??= toApiError(e);
      }
    }
    return (added: added, failed: failed, error: first);
  }

  Future<ApiError?> removeParticipant(String accountId) async {
    try {
      await _repo.removeParticipant(id, accountId);
      final cur = _room;
      if (cur != null) {
        _put(
          cur.copyWith(
            detail: cur.detail.copyWith(
              participants: [
                for (final p in cur.detail.participants)
                  if (p.accountId != accountId) p,
              ],
            ),
          ),
        );
      }
      return null;
    } on Object catch (e) {
      return toApiError(e);
    }
  }

  /// Toplantıyı siler (yumuşak; aktif konferans da kapanır). Liste yeniden okunur.
  Future<ApiError?> deleteMeeting() async {
    try {
      await _repo.deleteMeeting(id);
    } on Object catch (e) {
      return toApiError(e);
    }
    ref.invalidate(meetingsBoardControllerProvider);
    return null;
  }
}
