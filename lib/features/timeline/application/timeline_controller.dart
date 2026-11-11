import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/server/write_compat.dart';
import '../../tasks/tasks.dart';
import '../domain/timeline.dart';
import '../domain/timeline_view_builder.dart';
import 'gantt_provider.dart';

part 'timeline_controller.g.dart';

/// Tarih talebi gönderme sonucu (prototip `request`).
sealed class TimelineRequestResult {
  const TimelineRequestResult();
}

/// Görevin zaten bekleyen bir talebi var.
final class TimelineRequestPending extends TimelineRequestResult {
  const TimelineRequestPending();
}

/// Taslakta değişiklik yok.
final class TimelineRequestNoChange extends TimelineRequestResult {
  const TimelineRequestNoChange();
}

/// Talep kaydedildi; [end] istenen yeni bitiş.
final class TimelineRequestSent extends TimelineRequestResult {
  const TimelineRequestSent(this.end);

  final DateTime end;
}

/// Zaman çizelgesinin seçim, ölçek, süzgeç ve tarih taslağı bellekte tutulur. Kayıt,
/// geri alma ve tarih talepleri sunucuya gider; sonuç katalog ve Gantt'tan yeniden okunur.
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse tüm koordinatörlükler;
/// [timelineAllCoordinatorships] ise hepsi.
@riverpod
class TimelineController extends _$TimelineController {
  TaskItem? _baseTask;
  bool _busy = false;
  int _epoch = 0;
  int _ownerSession = 0;
  String? _ownerProgram;
  String? _ownerDepartment;
  RequestKeys _requestKeys = const RequestKeys();
  TaskItem? _requestBase;
  String? _requestBody;
  bool _valid(int epoch) {
    if (!ref.mounted || epoch != _epoch) return false;
    final scope = ref.read(scopeControllerProvider).current;
    return ref.read(sessionControllerProvider).generation == _ownerSession &&
        scope.programId == _ownerProgram &&
        scope.departmentId == _ownerDepartment;
  }

  @override
  TimelineState build(String? coordinatorship) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _ownerSession = ref.read(sessionControllerProvider).generation;
    final scope = ref.read(scopeControllerProvider).current;
    _ownerProgram = scope.programId;
    _ownerDepartment = scope.departmentId;
    _epoch++;
    _baseTask = null;
    _busy = false;
    _requestKeys = const RequestKeys();
    _requestBase = null;
    _requestBody = null;
    final all =
        coordinatorship == null ||
        coordinatorship == timelineAllCoordinatorships;
    return TimelineState(
      coordinatorships: coordinatorship == null || all
          ? null
          : [coordinatorship],
      startAll: all,
    );
  }

  TaskCatalog? get _catalog => ref.read(timelineCatalogProvider).value;

  List<String> _coords() {
    final c = _catalog;
    return c == null
        ? (state.coordinatorships ?? const [])
        : resolvedCoordinatorships(c, state);
  }

  TimelineState _cleared(TimelineState s) =>
      s.copyWith(selected: () => null, draft: () => null);

  // --- koordinatörlük seçici ---

  void toggleCoordMenu() =>
      state = state.copyWith(coordMenuOpen: !state.coordMenuOpen);

  void setQuery(String query) => state = _cleared(state.copyWith(query: query));

  void closeCoordMenu() => state = state.copyWith(coordMenuOpen: false);

  /// Seçimde varsa çıkarır, yoksa katalog sırasını koruyarak ekler.
  void toggleCoordinatorship(String code) {
    final cur = _coords();
    final order = _catalog?.coordinatorships.map((c) => c.code).toList() ?? cur;
    final next = cur.contains(code)
        ? [
            for (final c in cur)
              if (c != code) c,
          ]
        : [
            for (final c in order)
              if (c == code || cur.contains(c)) c,
          ];
    state = _cleared(state.copyWith(coordinatorships: next));
  }

  /// Seçim varsa kaldırır, yoksa hepsini seçer (prototip "Seçimi kaldır / Tümünü seç").
  void toggleAllCoordinatorships() {
    final all = _catalog?.coordinatorships.map((c) => c.code).toList() ?? [];
    state = _cleared(
      state.copyWith(coordinatorships: _coords().isEmpty ? all : const []),
    );
  }

  /// Genel bakış sütununa dokunma: o koordinatörlüğü tek seçili açar.
  void openOverviewColumn(String code) => state = _cleared(
    state.copyWith(coordinatorships: [code], overview: false),
  );

  // --- süzgeç / ölçek ---

  void setStatus(TimelineStatusFilter status) =>
      state = _cleared(state.copyWith(status: status));

  void setScale(TimelineScale scale) => state = state.copyWith(scale: scale);

  /// Yakınlaştır (ay → hafta → gün); en yakında etkisiz (prototip `zoomIn`).
  void zoomIn() {
    final i = state.scale.index;
    if (i > 0) setScale(TimelineScale.values[i - 1]);
  }

  /// Uzaklaştır (gün → hafta → ay); en uzakta etkisiz (prototip `zoomOut`).
  void zoomOut() {
    final i = state.scale.index;
    if (i < TimelineScale.values.length - 1) {
      setScale(TimelineScale.values[i + 1]);
    }
  }

  void setOverview(bool on) => state = _cleared(state.copyWith(overview: on));

  void togglePerson(String id) =>
      state = _cleared(state.copyWith(people: _toggled(state.people, id)));

  void togglePriority(TaskPriority p) => state = _cleared(
    state.copyWith(priorities: _toggled(state.priorities, p)),
  );

  /// "Temizle": kişi ve öncelik süzgeci (prototip `clearFilters`; durum korunur).
  void clearFilters() =>
      state = _cleared(state.copyWith(people: const [], priorities: const []));

  /// Filtre penceresindeki bütün seçimleri varsayılana döndürür.
  void clearSheetFilters() => state = _cleared(
    state.copyWith(
      coordinatorships:
          _catalog?.coordinatorships.map((c) => c.code).toList() ?? const [],
      people: const [],
      priorities: const [],
      status: TimelineStatusFilter.all,
    ),
  );

  static List<T> _toggled<T>(List<T> list, T v) => list.contains(v)
      ? [
          for (final x in list)
            if (x != v) x,
        ]
      : [...list, v];

  // --- seçim ve tarih taslağı ---

  void select(String code) {
    _baseTask =
        ref.read(taskCatalogControllerProvider).value?.task(code) ??
        _catalog?.task(code);
    state = state.copyWith(selected: () => code, draft: () => null);
  }

  void closeSelection() => state = _cleared(state);

  DayRange? _current() {
    final c = _catalog;
    final code = state.selected;
    final item = code == null ? null : c?.task(code);
    if (c == null || item == null) return null;
    return currentRange(item, state, c.today.year);
  }

  DayRange? get _base => state.draft ?? _current();

  /// Taslağı günceller; bitiş başlangıçtan sonra kalır (prototip `setD`).
  void _setDraft({int? start, int? end}) {
    final b = _base;
    if (b == null) return;
    final s = start ?? b.start;
    var e = end ?? b.end;
    if (e <= s) e = s + 1;
    state = state.copyWith(draft: () => DayRange(s, e));
  }

  void setDraftStart(DateTime date) {
    final c = _catalog;
    if (c != null) _setDraft(start: seasonDay(date, c.today.year));
  }

  void setDraftEnd(DateTime date) {
    final c = _catalog;
    if (c != null) _setDraft(end: seasonDay(date, c.today.year));
  }

  /// Başlangıç ±1 gün (ileri giderken bitişin bir gün öncesinde durur).
  void nudgeStart(int days) {
    final b = _base;
    if (b == null) return;
    _setDraft(
      start: days > 0 ? math.min(b.start + days, b.end - 1) : b.start + days,
    );
  }

  /// Bitiş ±1 gün (geri giderken başlangıcın bir gün sonrasında durur).
  void nudgeEnd(int days) {
    final b = _base;
    if (b == null) return;
    _setDraft(
      end: days < 0 ? math.max(b.start + 1, b.end + days) : b.end + days,
    );
  }

  /// İki tarihi birlikte kaydırır ("tümünü kaydır", çubuğu sürükleme).
  void shiftDraft(int days) {
    final b = _base;
    if (b != null) state = state.copyWith(draft: () => b.shift(days));
  }

  /// Taslağı kayıtlı aralığa göre [days] kaydırılmış duruma getirir (sürükleme sırasında).
  void dragTo(int days) {
    final cur = _current();
    if (cur != null) state = state.copyWith(draft: () => cur.shift(days));
  }

  /// Taslağı kaydeder; değişiklik yoksa false. Seçim kapanır, geri alma kaydı oluşur.
  Future<bool> save() async {
    final epoch = _epoch;
    final snapshot = state;
    final cur = _current();
    final draft = state.draft;
    final code = state.selected;
    if (cur == null || draft == null || code == null || draft == cur) {
      return false;
    }
    var task = _baseTask;
    if (task == null || _busy) return false;
    if (!TaskPermissions.of(_catalog?.access, task).canManageTask) {
      throw ApiError('work.not_authorized');
    }
    final year = _catalog!.today.year;
    if (task.datesRevision == null) {
      _busy = true;
      try {
        task = await ref.read(taskDetailsRepositoryProvider).loadItem(task);
        if (!_valid(epoch)) return false;
        if (seasonDay(task.start, year) != cur.start ||
            seasonDay(task.due, year) != cur.end) {
          throw ApiError('work.edit_conflict');
        }
      } finally {
        if (_valid(epoch)) _busy = false;
      }
    }
    await _writeDates(task, draft, year);
    if (!_valid(epoch) || !identical(state, snapshot)) return true;
    state = _cleared(
      state.copyWith(
        undo: () => TimelineUndo(
          code: code,
          previousEdit: state.edits[code],
          from: cur,
          to: draft,
          serial: (state.undo?.serial ?? 0) + 1,
        ),
      ),
    );
    return true;
  }

  /// Son kaydı geri alır; geri alınan görevin kodu (yoksa null).
  Future<String?> undo() async {
    final epoch = _epoch;
    final u = state.undo;
    if (u == null) return null;
    if (_busy) return null;
    final task = _catalog?.task(u.code);
    if (task == null) return null;
    final year = _catalog!.today.year;
    _busy = true;
    try {
      final fresh = await ref
          .read(taskDetailsRepositoryProvider)
          .loadItem(task);
      if (!_valid(epoch)) return null;
      if (seasonDay(fresh.start, year) != u.to.start ||
          seasonDay(fresh.due, year) != u.to.end) {
        throw ApiError('work.edit_conflict');
      }
      await _writeDates(fresh, u.from, year);
      if (!_valid(epoch)) return u.code;
      final prev = u.previousEdit;
      state = state.copyWith(
        edits: prev != null
            ? state.edits.put(u.code, prev)
            : state.edits.remove(u.code),
        undo: () => null,
      );
      return u.code;
    } finally {
      if (_valid(epoch)) _busy = false;
    }
  }

  void dismissUndo() => state = state.copyWith(undo: () => null);

  /// Taslaktaki bitişi tarih talebi olarak gönderir (prototip `request`).
  Future<TimelineRequestResult> requestDates() async {
    final epoch = _epoch;
    final snapshot = state;
    final code = state.selected;
    final c = _catalog;
    final cur = _current();
    if (code == null || c == null || cur == null) {
      return const TimelineRequestNoChange();
    }
    final draft = state.draft;
    if (draft == null || draft == cur) return const TimelineRequestNoChange();
    final end = seasonDate(draft.end, c.today.year);
    final task = c.task(code);
    if (task == null || _busy) return const TimelineRequestNoChange();
    if (!TaskPermissions.of(c.access, task).canRequestDate) {
      throw ApiError('work.not_authorized');
    }
    if (task.hasPendingRequest) return const TimelineRequestPending();
    final baseTask = _baseTask;
    if (!serverSupportsVersionedWrites(ref.read(bindingStateProvider)) ||
        baseTask?.datesRevision == null) {
      throw ApiError('client.server_outdated');
    }
    final start = seasonDate(draft.start, c.today.year);
    final body =
        '${task.id}|${start.toIso8601String()}|${end.toIso8601String()}';
    if (_requestBody != body) {
      _requestBody = body;
      _requestBase = baseTask;
    }
    final base = _requestBase!;
    final (keys, key) = _requestKeys.keyFor(
      'date_request',
      '$body|${base.datesRevision}',
    );
    _requestKeys = keys;
    _busy = true;
    try {
      try {
        await ref
            .read(taskWriteRepositoryProvider)
            .requestDateChange(base, start, end, requestKey: key);
      } on Object catch (e) {
        final error = toApiError(e);
        if (_valid(epoch) &&
            (error.code == 'work.edit_conflict' || isKeyReused(error))) {
          _requestKeys = _requestKeys.clear('date_request');
          _requestBase = null;
          _requestBody = null;
          if (error.code == 'work.edit_conflict') {
            try {
              await ref.read(taskCatalogControllerProvider.notifier).reload();
            } on Object {
              /* Hata asıl çakışma sonucunu gölgelemez. */
            }
            if (_valid(epoch)) state = _cleared(state);
          }
        }
        rethrow;
      }
      if (_valid(epoch)) {
        _requestKeys = _requestKeys.clear('date_request');
        _requestBase = null;
        _requestBody = null;
        try {
          await ref.read(taskCatalogControllerProvider.notifier).reload();
          if (_valid(epoch)) await ref.read(ganttScheduleProvider.future);
        } on Object {
          /* Yazma sonucu başarıdır; okuma hatası kaynak durumunda kalır. */
        }
      }
    } finally {
      if (_valid(epoch)) _busy = false;
    }
    if (!_valid(epoch) || !identical(state, snapshot)) {
      return TimelineRequestSent(end);
    }
    state = state.copyWith(draft: () => null);
    return TimelineRequestSent(end);
  }

  Future<void> _writeDates(TaskItem task, DayRange range, int year) async {
    final epoch = _epoch;
    if (!serverSupportsVersionedWrites(ref.read(bindingStateProvider)) ||
        task.datesRevision == null) {
      throw ApiError('client.server_outdated');
    }
    _busy = true;
    final store = ref.read(taskCatalogControllerProvider.notifier);
    try {
      await ref
          .read(taskWriteRepositoryProvider)
          .updateWorkItem(
            task,
            WorkItemPatch.diff(
              task,
              start: seasonDate(range.start, year),
              end: seasonDate(range.end, year),
            ),
          );
    } finally {
      if (_valid(epoch)) {
        try {
          await store.reload();
          if (_valid(epoch)) {
            await ref.read(ganttScheduleProvider.future);
          }
        } finally {
          if (_valid(epoch)) _busy = false;
        }
      }
    }
  }
}

/// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.
@riverpod
AsyncValue<TimelineView> timelineView(Ref ref, String? coordinatorship) {
  final state = ref.watch(timelineControllerProvider(coordinatorship));
  return ref
      .watch(timelineCatalogProvider)
      .whenData(
        (c) => buildTimelineView(
          c,
          state,
          dependent:
              ref.watch(ganttScheduleProvider).value?.dependentIds ?? const {},
        ),
      );
}
