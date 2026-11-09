import 'dart:async';

import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;
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
    this.noteSubmitting = false,
  }) : notes = List.unmodifiable(notes);

  /// Not ekleme isteği uçuşta: gönder düğmesi kapalı, yeni gönderim reddedilir. Kilit widget'ta
  /// değil burada durur (sekme değişip dönünce sıfırlanmaz).
  final bool noteSubmitting;

  final MeetingDetail detail;
  final List<MeetingNote> notes;

  /// Görüntüleyen toplantıya bağlı bir departmanın koordinatörü (`coordinatorship` kipinde
  /// katılımcı yönetimi, K21).
  final bool coordinatesLinked;

  /// Oturumdaki hesap.
  final String? me;

  Meeting get meeting => detail.meeting;

  /// Ayrıntının güncel özeti (sayaçlar, konferans durumu; liste kartına da yazılır).
  MeetingSummary get summary => MeetingSummary.of(detail, notes: notes.length);

  /// Konferans kartı ve kimlik durumu ([now] anına göre).
  MeetingStatus? status(DateTime now) =>
      meetingStatus(meeting, now: now, summary: summary);

  MeetingPermissions get permissions => MeetingPermissions(
    role: detail.viewerRole,
    me: me,
    byPerson: meeting.byPerson,
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
    noteSubmitting: noteSubmitting ?? this.noteSubmitting,
  );
}

/// Not ekleme sonucu: yalnız [NoteAdded] başarıdır (çağıran taslağı yalnız onda temizler).
sealed class NoteSubmit {
  const NoteSubmit();
}

final class NoteAdded extends NoteSubmit {
  const NoteAdded();
}

final class NoteFailed extends NoteSubmit {
  const NoteFailed(this.error);
  final ApiError error;
}

/// İstek gönderilmedi (uçuşta istek var ya da metin boş); geri bildirim yok.
final class NoteIgnored extends NoteSubmit {
  const NoteIgnored();
}

/// Geri alınabilir bekleyen not silmesi: not, listedeki yeri, zamanlayıcı ve sonuç.
final class _PendingDelete {
  _PendingDelete(this.note, this.index, this.repo);

  final MeetingNote note;
  final int index;

  /// Zamanlama anındaki kaynak (ekran kapansa da istek aynı kaynakla gider).
  final MeetingsRepository repo;
  final done = Completer<ApiError?>();
  Timer? timer;
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
    // Bekleyen silme varken sağlayıcı canlı kalır (yeniden kurulumda bağ yenilenir); kalıcı
    // atılmada (kapsayıcı kapanışı) bekleyen silmeler GÖNDERİLMEDEN iptal edilir.
    _deleteHold = _pendingDeletes.isEmpty ? null : ref.keepAlive();
    ref.onDispose(() {
      if (!ref.mounted) _dropPendingDeletes();
    });
    final program = ref.watch(scopeStateProvider).programId;
    final repo = ref.read(meetingsRepositoryProvider);
    final catalog = await ref.read(taskCatalogControllerProvider.future);
    final detail = await repo.getMeeting(id);
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
      // Silinmesi bekleyen not yeniden okunsa da gizli kalır.
      notes: [
        for (final n in notes)
          if (_pendingFor(n.id) == null) n,
      ],
      me: catalog.me,
      coordinatesLinked: seats.any(
        (s) =>
            s.role == SeatRole.coordinator && linked.contains(s.departmentId),
      ),
      noteSubmitting: _noteInFlight != null,
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
    state = AsyncData(room.copyWith(noteSubmitting: _noteInFlight != null));
    _syncSummary(room);
  }

  /// Liste okunduysa satırın özetini ayrıntıdan günceller (ağ isteği yok).
  void _syncSummary(MeetingRoom room) {
    if (!ref.exists(meetingsBoardControllerProvider)) return;
    ref
        .read(meetingsBoardControllerProvider.notifier)
        .putSummary(id, room.summary);
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

  /// Uçuştaki not ekleme isteğinin kimliği (işlem anahtarından ayrı; her uçuşa ayrı nesne).
  /// State'ten bağımsızdır: yenileme state'i yeniden kursa da kilit kalır;
  /// [MeetingRoom.noteSubmitting] yalnız bundan türer ([_put], [build]).
  Object? _noteInFlight;

  /// Not ekler. Uçuşta istek varken ya da metin boşken istek gönderilmez: [NoteIgnored]
  /// (taslak ve anahtar olduğu gibi kalır). Anahtar yalnız TAMAMLANAN isteğin anahtarıyla
  /// eşleşiyorsa düşer (başarı ya da "anahtar başka istekle kullanılmış"); ağ/zaman aşımı
  /// hatasında kalır, aynı metin aynı anahtarla gider. Kilidi yalnız kendi uçuşu açar.
  Future<NoteSubmit> addNote(String content) async {
    final t = content.trim();
    final r = _room;
    if (t.isEmpty || r == null || _noteInFlight != null) {
      return const NoteIgnored();
    }
    final (keys, key) = _keys.keyFor('note', t);
    _keys = keys;
    final flight = Object();
    _noteInFlight = flight;
    // Kilit alındıktan sonraki her adım try içinde; kilit finally'de (kimlik denetimli) kapanır.
    List<MeetingNote> Function(MeetingRoom cur)? added;
    try {
      _put(r);
      final note = await _repo.addNote(id, t, requestKey: key);
      _clearNoteKey(key);
      added = (cur) => [note, ...cur.notes];
      return const NoteAdded();
    } on Object catch (e) {
      final err = toApiError(e);
      if (isKeyReused(err)) _clearNoteKey(key);
      return NoteFailed(err);
    } finally {
      _endNoteFlight(flight, added);
    }
  }

  /// Bekleyen not ekleme anahtarı (test ve tanı için; yoksa null).
  @visibleForTesting
  String? get pendingNoteKey => _keys.pending('note');

  void _clearNoteKey(String key) {
    if (_keys.pending('note') == key) _keys = _keys.clear('note');
  }

  /// Uçuşu kapatır (yalnız [flight] hâlâ uçuştaki ise); [notes] varsa listeyi günceller.
  void _endNoteFlight(
    Object flight,
    List<MeetingNote> Function(MeetingRoom cur)? notes,
  ) {
    if (identical(_noteInFlight, flight)) _noteInFlight = null;
    final cur = _room;
    if (cur != null) _put(cur.copyWith(notes: notes?.call(cur)));
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

  /// "Geri al" süresi: eylemli bildirimin görünürlüğüyle aynı (`NzToast.lifeWithAction`).
  static const noteUndoWindow = Duration(milliseconds: 3200);

  /// Geri alınabilir bekleyen not silmeleri. State'ten bağımsızdır: yenileme state'i yeniden
  /// kursa da bekleyen not gizli kalır, zamanlayıcı sürer.
  final _pendingDeletes = <_PendingDelete>[];

  _PendingDelete? _pendingFor(String noteId) =>
      _pendingDeletes.where((p) => p.note.id == noteId).firstOrNull;

  /// Bekleyen silme varken sağlayıcıyı canlı tutan bağ (ekran kapansa da istek gider).
  KeepAliveLink? _deleteHold;

  /// Notu hemen gizler; [window] içinde [undoNoteDelete] çağrılmazsa kalıcı siler
  /// (COLLABORATION-K75: sunucuda geri yükleme yok, "Geri al" istemcidedir; F63 devri §4).
  /// Geri alınırsa istek GİTMEZ. Ekran kapanırsa sağlayıcı silme bitene dek canlı kalır ve istek
  /// süre dolunca gider (kullanıcı sildi, geri almadı; bildirimdeki "Geri al" o süre boyunca
  /// çalışır). Sonuç silme bitince ya da geri alınınca gelir: hata (not yerine döner) ya da null.
  Future<ApiError?> deleteNote(
    MeetingNote n, {
    Duration window = noteUndoWindow,
  }) async {
    final r = _room;
    if (r == null || _pendingFor(n.id) != null) return null;
    final p = _PendingDelete(n, r.notes.indexWhere((x) => x.id == n.id), _repo);
    _pendingDeletes.add(p);
    _deleteHold ??= ref.keepAlive();
    _notes([
      for (final x in r.notes)
        if (x.id != n.id) x,
    ]);
    p.timer = Timer(window, () => _commitDelete(n.id));
    return p.done.future;
  }

  /// Bekleyen silmeyi iptal eder (istek gönderilmez, not yerine döner). Süre dolmuşsa ya da
  /// istek uçuştaysa false.
  bool undoNoteDelete(String noteId) {
    final p = _pendingFor(noteId);
    if (p == null || !(p.timer?.isActive ?? false)) return false;
    p.timer!.cancel();
    _pendingDeletes.remove(p);
    _restoreNote(p);
    _releaseHold();
    p.done.complete(null);
    return true;
  }

  Future<void> _commitDelete(String noteId) async {
    final p = _pendingFor(noteId);
    if (p == null) return;
    ApiError? error;
    try {
      await p.repo.deleteNote(noteId);
    } on Object catch (e) {
      error = toApiError(e);
    }
    _pendingDeletes.remove(p);
    if (ref.mounted) {
      if (error != null) _restoreNote(p);
      _releaseHold();
    }
    p.done.complete(error);
  }

  /// Notu eski yerine koyar (zaten listedeyse dokunmaz).
  void _restoreNote(_PendingDelete p) {
    final cur = _room;
    if (cur == null || cur.notes.any((x) => x.id == p.note.id)) return;
    final at = p.index < 0 || p.index > cur.notes.length ? 0 : p.index;
    _notes([...cur.notes]..insert(at, p.note));
  }

  void _releaseHold() {
    if (_pendingDeletes.isNotEmpty) return;
    _deleteHold?.close();
    _deleteHold = null;
  }

  /// Kalıcı atılma: bekleyen silmeler gönderilmeden iptal (oturum/kapsayıcı gitti).
  void _dropPendingDeletes() {
    for (final p in _pendingDeletes) {
      if (p.timer?.isActive ?? false) {
        p.timer!.cancel();
        p.done.complete(null);
      }
    }
    _pendingDeletes.removeWhere((p) => p.done.isCompleted);
    _deleteHold = null;
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

  /// Konferansı herkes için bitirir, sonra ayrıntıyı sunucudan yeniden okur: kapanış durumu,
  /// `last_conference` ve özet (liste kartı dahil) sunucudan gelir; geçmiş yerelde uydurulmaz.
  /// Yeniden okuma düşerse bitirme yine başarıdır; konferans "kapanıyor" (`ending`) görünür ve
  /// aşağı çekerek yenilenir (otomatik yeniden deneme yok).
  Future<ApiError?> endConference() async {
    try {
      await _repo.endConference(id);
    } on Object catch (e) {
      return toApiError(e);
    }
    try {
      final detail = await _repo.getMeeting(id);
      final cur = _room;
      if (cur != null) _put(cur.copyWith(detail: detail));
    } on Object {
      final cur = _room;
      final c = cur?.detail.conference;
      if (cur != null && c != null) {
        _put(
          cur.copyWith(
            detail: cur.detail.copyWith(conference: () => c.closing),
          ),
        );
      }
    }
    return null;
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
