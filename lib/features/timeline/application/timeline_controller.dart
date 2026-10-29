import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../data/sample/timeline_sample.dart';
import '../domain/timeline.dart';
import '../domain/timeline_view_builder.dart';

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

/// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
/// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki;
/// [timelineAllCoordinatorships] ise hepsi.
@riverpod
class TimelineController extends _$TimelineController {
  @override
  TimelineState build(String? coordinatorship) {
    final all = coordinatorship == timelineAllCoordinatorships;
    return TimelineState(
      coordinatorships: coordinatorship == null || all
          ? null
          : [coordinatorship],
      startAll: all,
      requests: timelineSampleRequests,
    );
  }

  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;

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

  static List<T> _toggled<T>(List<T> list, T v) => list.contains(v)
      ? [
          for (final x in list)
            if (x != v) x,
        ]
      : [...list, v];

  // --- seçim ve tarih taslağı ---

  void select(String code) =>
      state = state.copyWith(selected: () => code, draft: () => null);

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
  bool save() {
    final cur = _current();
    final draft = state.draft;
    final code = state.selected;
    if (cur == null || draft == null || code == null || draft == cur) {
      return false;
    }
    state = _cleared(
      state.copyWith(
        edits: state.edits.put(code, draft),
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
  String? undo() {
    final u = state.undo;
    if (u == null) return null;
    final prev = u.previousEdit;
    state = state.copyWith(
      edits: prev != null
          ? state.edits.put(u.code, prev)
          : state.edits.remove(u.code),
      undo: () => null,
    );
    return u.code;
  }

  void dismissUndo() => state = state.copyWith(undo: () => null);

  /// Taslaktaki bitişi tarih talebi olarak gönderir (prototip `request`).
  TimelineRequestResult requestDates() {
    final code = state.selected;
    final c = _catalog;
    final cur = _current();
    if (code == null || c == null || cur == null) {
      return const TimelineRequestNoChange();
    }
    if (state.requests.containsKey(code)) return const TimelineRequestPending();
    final draft = state.draft;
    if (draft == null || draft == cur) return const TimelineRequestNoChange();
    final end = seasonDate(draft.end, c.today.year);
    state = state.copyWith(
      requests: state.requests.put(code, end),
      draft: () => null,
    );
    return TimelineRequestSent(end);
  }
}

/// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.
@riverpod
AsyncValue<TimelineView> timelineView(Ref ref, String? coordinatorship) {
  final state = ref.watch(timelineControllerProvider(coordinatorship));
  return ref
      .watch(taskCatalogControllerProvider)
      .whenData(
        (c) => buildTimelineView(c, state, dependent: timelineSampleDependent),
      );
}
