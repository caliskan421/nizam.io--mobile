import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';

/// Rota parametresinde "bütün koordinatörlükler" (prototip koordinatörlük listesi kısayolu
/// "Tümünü zaman çizelgesinde gör": `coords` = hepsi).
const timelineAllCoordinatorships = '*';

/// Çizelge ölçeği (prototip `scale`: gün / hafta / ay). Gün başına düşen piksel görünüm
/// geometrisidir (presentation); burada yalnız sıra ve ad.
enum TimelineScale { day, week, month }

/// Durum süzgeci (prototip `status`: tümü / açık / geciken / biten).
enum TimelineStatusFilter { all, open, late, done }

/// Sezonun gün sırası: yılın 1 Ocak'ı 0. Saat dilimi kaymasından bağımsız (UTC takvim günü).
int seasonDay(DateTime date, int year) => DateTime.utc(
  date.year,
  date.month,
  date.day,
).difference(DateTime.utc(year)).inDays;

/// [seasonDay]'in tersi (yerel takvim günü).
DateTime seasonDate(int day, int year) => DateTime(year, 1, 1 + day);

/// Gün aralığı (başlangıç ve bitiş günü, `start < end`).
@immutable
final class DayRange {
  const DayRange(this.start, this.end);

  final int start;
  final int end;

  int get length => end - start;

  DayRange shift(int days) => DayRange(start + days, end + days);

  @override
  bool operator ==(Object other) =>
      other is DayRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DayRange($start, $end)';
}

/// Görev koduna göre değer tablosu (değişmez; yazımda yeni örnek). Dize anahtarlı `Map` yerine
/// (sınır kuralı D2: elle JSON gövdesiyle karışmasın).
@immutable
final class ByTask<V> {
  const ByTask([this._entries = const []]);

  final List<(String, V)> _entries;

  V? operator [](String code) {
    for (final (k, v) in _entries) {
      if (k == code) return v;
    }
    return null;
  }

  bool containsKey(String code) => _entries.any((e) => e.$1 == code);

  ByTask<V> put(String code, V value) => ByTask([
    for (final e in _entries)
      if (e.$1 != code) e,
    (code, value),
  ]);

  ByTask<V> remove(String code) => ByTask([
    for (final e in _entries)
      if (e.$1 != code) e,
  ]);

  int get length => _entries.length;
}

/// Kaydedilmiş tarih değişikliğinin geri alma kaydı (prototip `snack`).
@immutable
final class TimelineUndo {
  const TimelineUndo({
    required this.code,
    required this.previousEdit,
    required this.from,
    required this.to,
    required this.serial,
  });

  final String code;

  /// Kayıttan önceki düzenleme (yoksa özgün tarihlere dönülür).
  final DayRange? previousEdit;
  final DayRange from;
  final DayRange to;

  /// Her kayıtta artar (bildirim süresinin yeniden başlaması için).
  final int serial;

  int get startDelta => to.start - from.start;
  int get endDelta => to.end - from.end;

  /// Başlangıç ve bitiş aynı miktar kaydı → kaydırma; değilse süre değişti.
  bool get isShift => startDelta == endDelta;
}

/// Ekran durumu (bellekte; sunucuya yazılmaz).
@immutable
final class TimelineState {
  const TimelineState({
    this.coordinatorships,
    this.status = TimelineStatusFilter.all,
    this.scale = TimelineScale.week,
    this.overview = false,
    this.people = const [],
    this.priorities = const [],
    this.selected,
    this.draft,
    this.edits = const ByTask(),
    this.requests = const ByTask(),
    this.undo,
    this.coordMenuOpen = false,
    this.startAll = false,
  });

  /// Seçili koordinatörlük kodları; null → kataloğun ilk koordinatörlüğü (ya da [startAll]
  /// ise hepsi).
  final List<String>? coordinatorships;

  /// Açılışta bütün koordinatörlükler seçili (rota `coord=*`).
  final bool startAll;
  final TimelineStatusFilter status;
  final TimelineScale scale;

  /// Genel bakış: her koordinatörlük bir sütun, görevleri ince şeritler.
  final bool overview;
  final List<String> people;
  final List<TaskPriority> priorities;
  final String? selected;

  /// Seçili görevin kaydedilmemiş tarih taslağı.
  final DayRange? draft;

  /// Kaydedilmiş tarih düzenlemeleri (görev kodu → aralık).
  final ByTask<DayRange> edits;

  /// Bekleyen tarih talepleri (görev kodu → istenen bitiş tarihi).
  final ByTask<DateTime> requests;
  final TimelineUndo? undo;
  final bool coordMenuOpen;

  /// Kişi + öncelik süzgeç sayısı (+ durum süzgeci) — Filtre düğmesindeki rozet.
  int get filterCount =>
      people.length +
      priorities.length +
      (status == TimelineStatusFilter.all ? 0 : 1);

  /// Rozet görünür mü (prototip `hasChips`: kişi ya da öncelik seçili; sayı [filterCount]).
  bool get hasChips => people.isNotEmpty || priorities.isNotEmpty;

  TimelineState copyWith({
    List<String>? coordinatorships,
    TimelineStatusFilter? status,
    TimelineScale? scale,
    bool? overview,
    List<String>? people,
    List<TaskPriority>? priorities,
    String? Function()? selected,
    DayRange? Function()? draft,
    ByTask<DayRange>? edits,
    ByTask<DateTime>? requests,
    TimelineUndo? Function()? undo,
    bool? coordMenuOpen,
  }) => TimelineState(
    startAll: startAll,
    coordinatorships: coordinatorships ?? this.coordinatorships,
    status: status ?? this.status,
    scale: scale ?? this.scale,
    overview: overview ?? this.overview,
    people: people ?? this.people,
    priorities: priorities ?? this.priorities,
    selected: selected == null ? this.selected : selected(),
    draft: draft == null ? this.draft : draft(),
    edits: edits ?? this.edits,
    requests: requests ?? this.requests,
    undo: undo == null ? this.undo : undo(),
    coordMenuOpen: coordMenuOpen ?? this.coordMenuOpen,
  );
}

/// Çizelgedeki görev (tarihler sezon günü; düzenleme/taslak uygulanmış).
@immutable
final class TimelineTask {
  const TimelineTask({
    required this.item,
    required this.range,
    required this.doneAt,
    required this.today,
    required this.request,
    required this.packStart,
    required this.packEnd,
    required this.dependent,
  });

  final TaskItem item;

  /// Planlanan aralık (başlangıç → bitiş).
  final DayRange range;
  final int? doneAt;
  final int today;

  /// Bekleyen tarih talebinin istenen bitiş günü.
  final int? request;

  /// Şerit yerleşiminde kullanılan (taslaksız) aralık — taslak sürerken çubuk şerit değiştirmez.
  final int packStart;
  final int packEnd;

  /// Başka göreve bağımlı (prototip "bağımlı").
  final bool dependent;

  String get code => item.code;
  TaskStatus get status => item.status;

  /// Bitmemiş ve bitiş günü geçmiş.
  bool get late => status != TaskStatus.done && range.end < today;

  /// Bitmiş ama bitiş gününden sonra.
  bool get doneLate =>
      status == TaskStatus.done && doneAt != null && doneAt! > range.end;

  /// Çubuğun görünen sonu: geç bittiyse bitiş tarihi, gecikmedeyse bugün.
  int get visibleEnd => doneLate
      ? doneAt!
      : late
      ? today
      : range.end;

  /// Çubuk + talep çerçevesinin sonu (yoğunluk ve yerleşim).
  int get extentEnd => math.max(
    math.max(visibleEnd, (request ?? 0) > visibleEnd ? request! : 0),
    range.start + 1,
  );

  /// Planın ötesine taşan (gecikmiş / geç bitmiş) kısım var.
  bool get overrun => visibleEnd > range.end;

  /// Talep çerçevesi çubuğun sonundan uzanır.
  bool get hasRequest => request != null && request! > visibleEnd;

  /// Gecikme gün sayısı (yoksa 0).
  int get lateDays => late ? today - range.end : 0;

  /// Geç bitiş gün sayısı (yoksa 0).
  int get doneLateDays => doneLate ? doneAt! - range.end : 0;
}

/// Bir koordinatörlüğün çizelgedeki yerleşimi: görev → şerit sırası.
@immutable
final class TimelineGroup {
  const TimelineGroup({
    required this.code,
    required this.name,
    required this.lanes,
    required this.placed,
    required this.done,
    required this.total,
    required this.late,
  });

  final String code;
  final String name;

  /// Şerit sayısı (en az 1 görev varsa ≥ 1).
  final int lanes;
  final List<(TimelineTask, int)> placed;

  /// Kişi/öncelik süzgecinden geçen görevlerden biten / toplam / geciken.
  final int done;
  final int total;
  final int late;
}

/// Koordinatörlük seçici satırı.
@immutable
final class TimelineCoordOption {
  const TimelineCoordOption({
    required this.code,
    required this.name,
    required this.count,
    required this.selected,
  });

  final String code;
  final String name;
  final int count;
  final bool selected;
}

/// Kişi süzgeci seçeneği.
@immutable
final class TimelinePersonOption {
  const TimelinePersonOption({
    required this.id,
    required this.name,
    required this.count,
    required this.selected,
  });

  final String id;
  final String name;
  final int count;
  final bool selected;
}

/// Sezon şeridinin bir haftası.
@immutable
final class TimelineWeek {
  const TimelineWeek({required this.count, required this.late});

  final int count;

  /// Bu hafta gecikmenin başladığı (bitişi bu haftada olan geciken/geç biten) görev var.
  final bool late;
}

/// Seçili görevin kart özeti.
@immutable
final class TimelineSelection {
  const TimelineSelection({
    required this.task,
    required this.coordinatorshipName,
    required this.assignees,
    required this.current,
    required this.draft,
  });

  final TimelineTask task;
  final String coordinatorshipName;
  final List<String> assignees;

  /// Kayıtlı aralık (düzenleme ya da özgün).
  final DayRange current;

  /// Kartta görünen aralık (taslak yoksa [current]).
  final DayRange draft;

  int get startDelta => draft.start - current.start;
  int get endDelta => draft.end - current.end;
  bool get changed => startDelta != 0 || endDelta != 0;

  /// Süre hafta olarak (en az 1; prototip `wkN`).
  static int weeks(DayRange r) => math.max(1, (r.length / 7).round());
}

/// Ekranın türetilmiş görünümü (katalog + durum).
@immutable
final class TimelineView {
  const TimelineView({
    required this.year,
    required this.days,
    required this.today,
    required this.state,
    required this.coordinatorships,
    required this.selectedCoordinatorships,
    required this.groups,
    required this.shown,
    required this.statusCounts,
    required this.coordOptions,
    required this.personOptions,
    required this.weeks,
    required this.selection,
    required this.overviewGroups,
  });

  final int year;

  /// Sezondaki gün sayısı.
  final int days;
  final int today;
  final TimelineState state;

  /// Katalog sırasıyla bütün koordinatörlükler (kod → ad).
  final List<CoordinatorshipRef> coordinatorships;
  final List<String> selectedCoordinatorships;

  /// Görevi olan seçili koordinatörlükler (katalog sırası).
  final List<TimelineGroup> groups;

  /// Bütün süzgeçlerden geçen görevler.
  final List<TimelineTask> shown;
  final Map<TimelineStatusFilter, int> statusCounts;
  final List<TimelineCoordOption> coordOptions;
  final List<TimelinePersonOption> personOptions;
  final List<TimelineWeek> weeks;
  final TimelineSelection? selection;

  /// Genel bakış sütunları: her koordinatörlük (seçimden bağımsız; durum/kişi/öncelik süzgeci
  /// uygulanmış). Genel bakış kapalıyken boş.
  final List<TimelineGroup> overviewGroups;

  bool get multi => groups.length > 1;
  bool get empty => shown.isEmpty;
  bool get noneSelected => selectedCoordinatorships.isEmpty;
  bool get allSelected =>
      selectedCoordinatorships.length == coordinatorships.length;

  String nameOf(String code) =>
      coordinatorships.where((c) => c.code == code).firstOrNull?.name ?? code;
}
