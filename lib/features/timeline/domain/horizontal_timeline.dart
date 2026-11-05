import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';
import 'timeline.dart';

/// Yatay çizelgenin ölçeği: [week] gün gün ("Günlük"), [month] hafta hafta ("Haftalık"). Gün
/// başına piksel görünüm geometrisidir (presentation).
enum GanttZoom { week, month }

/// Yatay çizelgenin durum süzgeci (prototip `filt`: tümü / açık / geciken).
enum GanttFilter { all, open, late }

/// Yatay çizelgenin ekran durumu (bellekte; sunucuya yazılmaz). Prototip `S_hgantt.state`:
/// `zoom`, `filt`, `coords` (seçim sırasıyla), `closed` (kapalı gruplar), `sel`.
@immutable
final class GanttState {
  const GanttState({
    this.zoom = GanttZoom.month,
    this.filter = GanttFilter.all,
    this.coords = const [],
    this.closed = const {},
    this.selected,
    this.query = '',
  });

  final GanttZoom zoom;
  final GanttFilter filter;

  /// Seçili koordinatörlük kodları, seçilme sırasıyla; boş → hepsi.
  final List<String> coords;

  /// Kapalı (daraltılmış) grup kodları.
  final Set<String> closed;

  /// Seçili görev kodu.
  final String? selected;

  /// Arama metni (görev başlığı, koordinatörlük etiketi/adı ya da atanan kişi adı içinde);
  /// boş → süzgeç yok.
  final String query;

  GanttState _copy({
    GanttZoom? zoom,
    GanttFilter? filter,
    List<String>? coords,
    Set<String>? closed,
    String? Function()? selected,
    String? query,
  }) => GanttState(
    zoom: zoom ?? this.zoom,
    filter: filter ?? this.filter,
    coords: coords ?? this.coords,
    closed: closed ?? this.closed,
    selected: selected == null ? this.selected : selected(),
    query: query ?? this.query,
  );

  GanttState withQuery(String q) => _copy(query: q);

  GanttState withZoom(GanttZoom z) => _copy(zoom: z);

  GanttState withFilter(GanttFilter f) => _copy(filter: f);

  /// Koordinatörlük çipi: seçiliyse çıkarır, değilse sona ekler (prototip `coords.concat`).
  GanttState toggleCoord(String code) => _copy(
    coords: coords.contains(code)
        ? [
            for (final c in coords)
              if (c != code) c,
          ]
        : [...coords, code],
  );

  /// Seçimi [codes] yapar (gezinme niyeti: tek koordinatörlük).
  GanttState withCoords(List<String> codes) =>
      _copy(coords: List.unmodifiable(codes));

  /// "Tüm koordinatörlükler" çipi.
  GanttState clearCoords() => _copy(coords: const []);

  /// Grup başlığı: açıksa kapatır, kapalıysa açar.
  GanttState toggleGroup(String code) => _copy(
    closed: closed.contains(code)
        ? {
            for (final c in closed)
              if (c != code) c,
          }
        : {...closed, code},
  );

  /// Çubuğa ya da satıra dokunma: seçili görevse seçimi kaldırır, değilse seçer.
  GanttState pick(String code) =>
      _copy(selected: () => selected == code ? null : code);

  GanttState clearSelection() => _copy(selected: () => null);

  @override
  bool operator ==(Object other) =>
      other is GanttState &&
      other.zoom == zoom &&
      other.filter == filter &&
      _sameList(other.coords, coords) &&
      other.closed.length == closed.length &&
      other.closed.containsAll(closed) &&
      other.selected == selected &&
      other.query == query;

  @override
  int get hashCode => Object.hash(
    zoom,
    filter,
    Object.hashAll(coords),
    Object.hashAllUnordered(closed),
    selected,
    query,
  );

  static bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Yatay çizelgedeki görev: sezon günleri ([start] dahil, [end] hariç — prototip `a`, `b`).
@immutable
final class GanttTask {
  const GanttTask(this.task);

  /// Dikey çizelgeyle ortak görev modeli (gecikme / geç bitiş kuralı tek yerde).
  final TimelineTask task;

  TaskItem get item => task.item;
  String get code => task.code;
  TaskStatus get status => task.status;

  /// Başlangıç günü (`a`).
  int get start => task.range.start;

  /// Bitişin ertesi günü (`b`; bitiş günü dahil).
  int get end => task.range.end + 1;

  /// Bitmemiş ve bitiş günü geçmiş (`late`).
  bool get late => task.late;

  /// Gecikme şeridinin sonu (`lateTo`): gecikmedeyse bugün, geç bittiyse bitiş gününün ertesi.
  int? get lateTo => task.late
      ? task.today
      : task.doneLate
      ? task.doneAt! + 1
      : null;

  /// Çubuk ve gecikme şeridinin sağ ucu.
  int get extentEnd => lateTo != null && lateTo! > end ? lateTo! : end;

  /// Gecikme gün sayısı (`TD - day(end)`).
  int get lateDays => task.lateDays;
}

/// Çizelge satırı: koordinatörlük başlığı ya da görev.
@immutable
sealed class GanttRow {
  const GanttRow();
}

/// Koordinatörlük grubu başlığı (prototip `isHead`).
final class GanttHeadRow extends GanttRow {
  const GanttHeadRow({
    required this.code,
    required this.label,
    required this.name,
    required this.count,
    required this.late,
    required this.open,
    required this.start,
    required this.end,
  });

  /// Anahtar (sunucuda `department_id`; ekranda gösterilmez).
  final String code;

  /// Ekrandaki kısa etiket ([CoordinatorshipRef.label]: departman kodu, yoksa ad).
  final String label;
  final String name;

  /// Görünen (süzgeçten geçen) görev sayısı.
  final int count;

  /// Görünenlerden geciken sayısı.
  final int late;
  final bool open;

  /// Grup özet çizgisinin ilk ve son günü (`mn`, `mx`; gecikme şeridi dahil).
  final int start;
  final int end;
}

/// Görev satırı (prototip `isRow`).
final class GanttTaskRow extends GanttRow {
  const GanttTaskRow({
    required this.task,
    required this.selected,
    required this.label,
    required this.number,
  });

  final GanttTask task;
  final bool selected;

  /// Koordinatörlük etiketi (grup başlığıyla aynı).
  final String label;

  /// Koordinatörlük içindeki sıra (1'den; oluşturma sırası, süzgeçten bağımsız).
  final int number;

  /// Ekrandaki görev anahtarı: "ALT 3".
  String get key => '$label $number';
}

/// Koordinatörlük çipi.
@immutable
final class GanttCoordChip {
  const GanttCoordChip({
    required this.code,
    required this.label,
    required this.name,
    required this.selected,
  });

  final String code;

  /// Ekrandaki kısa etiket ([CoordinatorshipRef.label]).
  final String label;
  final String name;
  final bool selected;
}

/// Seçili görev kartı.
@immutable
final class GanttSelection {
  const GanttSelection({
    required this.task,
    required this.coordinatorshipName,
    required this.assignees,
  });

  final GanttTask task;
  final String coordinatorshipName;

  /// Atananların adları (boş → "Atanmamış").
  final List<String> assignees;
}

/// Yatay çizelgenin türetilmiş görünümü (katalog + durum).
@immutable
final class GanttView {
  const GanttView({
    required this.state,
    required this.year,
    required this.days,
    required this.today,
    required this.rows,
    required this.visible,
    required this.lateAll,
    required this.chips,
    required this.selection,
  });

  final GanttState state;
  final int year;

  /// Sezonun gün sayısı (yılın günleri).
  final int days;

  /// Bugünün sezon günü (katalog `today`).
  final int today;
  final List<GanttRow> rows;

  /// Süzgeçlerden geçen görev sayısı (`vis.length`).
  final int visible;

  /// Bütün katalogda geciken görev sayısı ("Geciken · 15").
  final int lateAll;

  /// "Tüm koordinatörlükler" dışındaki çipler (prototip sırası).
  final List<GanttCoordChip> chips;

  final GanttSelection? selection;

  bool get empty => rows.isEmpty;

  /// Görev satırı (yoksa null).
  GanttTaskRow? rowOf(String code) => rows
      .whereType<GanttTaskRow>()
      .where((r) => r.task.code == code)
      .firstOrNull;
}

/// Görev → koordinatörlük içindeki sıra numarası (1'den). Sunucuda insan okunur görev anahtarı
/// yoktur; numara yalnız gösterimdir ve kalıcı değildir (görev silinir ya da taşınırsa kayar).
/// Sıra oluşturma zamanıdır (`created_at`; zamansız görevler sonda), eşitlikte katalog sırası;
/// süzgeç numarayı değiştirmez (tüm katalog görevleri sayılır).
Map<String, int> taskNumbers(List<TaskItem> tasks) {
  final groups = <String, List<(int, TaskItem)>>{};
  for (final (i, t) in tasks.indexed) {
    (groups[t.coordinatorship] ??= []).add((i, t));
  }
  final numbers = <String, int>{};
  for (final group in groups.values) {
    group.sort((a, b) {
      final x = a.$2.createdAt;
      final y = b.$2.createdAt;
      // Zamanı olan önce; ikisi de varsa zamana, yoksa katalog sırasına göre.
      final byTime = x == null
          ? (y == null ? 0 : 1)
          : (y == null ? -1 : x.compareTo(y));
      return byTime != 0 ? byTime : a.$1 - b.$1;
    });
    for (final (n, (_, t)) in group.indexed) {
      numbers[t.code] = n + 1;
    }
  }
  return numbers;
}

/// Prototip `S_hgantt.renderVals` mantığı: süzgeç, gruplama (başlangıca göre kararlı sıra),
/// kapalı gruplar, sayılar, çipler ve seçili kart. Katalog görevlerinin hepsi kullanılır (ikinci
/// veri kaynağı yok).
GanttView buildGanttView(TaskCatalog catalog, GanttState s) {
  final year = catalog.today.year;
  final today = seasonDay(catalog.today, year);
  final days = DateTime.utc(year + 1).difference(DateTime.utc(year)).inDays;

  final tasks = [
    for (final item in catalog.tasks)
      GanttTask(
        TimelineTask(
          item: item,
          range: DayRange(
            seasonDay(item.start, year),
            seasonDay(item.due, year),
          ),
          doneAt: item.completedAt == null
              ? null
              : seasonDay(item.completedAt!, year),
          today: today,
          request: null,
          packStart: 0,
          packEnd: 0,
          dependent: false,
        ),
      ),
  ];

  bool statusOk(GanttTask t) => switch (s.filter) {
    GanttFilter.all => true,
    GanttFilter.open => t.status != TaskStatus.done,
    GanttFilter.late => t.late,
  };
  bool coordOk(GanttTask t) =>
      s.coords.isEmpty || s.coords.contains(t.item.coordinatorship);
  final q = s.query.trim().toLowerCase();
  bool queryOk(GanttTask t) {
    if (q.isEmpty) return true;
    bool has(String? s) => s != null && s.toLowerCase().contains(q);
    final c = catalog.coordinatorship(t.item.coordinatorship);
    return has(t.item.title) ||
        has(c?.label) ||
        has(c?.name) ||
        t.item.assignees.any((id) => has(catalog.nameOf(id)));
  }

  final visible = [
    for (final t in tasks)
      if (statusOk(t) && coordOk(t) && queryOk(t)) t,
  ];

  final coords = catalog.coordinatorships;
  final numbers = taskNumbers(catalog.tasks);
  final rows = <GanttRow>[];
  for (final c in coords) {
    final indexed = [
      for (final (i, t) in visible.indexed)
        if (t.item.coordinatorship == c.code) (i, t),
    ];
    if (indexed.isEmpty) continue;
    // JS `sort` kararlıdır; eşit başlangıçta katalog sırası korunur.
    indexed.sort((p, q) {
      final d = p.$2.start - q.$2.start;
      return d != 0 ? d : p.$1 - q.$1;
    });
    final group = [for (final (_, t) in indexed) t];
    final open = !s.closed.contains(c.code);
    rows.add(
      GanttHeadRow(
        code: c.code,
        label: c.label,
        name: c.name,
        count: group.length,
        late: group.where((t) => t.late).length,
        open: open,
        start: group.map((t) => t.start).reduce((a, b) => a < b ? a : b),
        end: group.map((t) => t.extentEnd).reduce((a, b) => a > b ? a : b),
      ),
    );
    if (open) {
      for (final t in group) {
        rows.add(
          GanttTaskRow(
            task: t,
            selected: s.selected == t.code,
            label: c.label,
            number: numbers[t.code]!,
          ),
        );
      }
    }
  }

  GanttSelection? selection;
  final sel = s.selected;
  final selTask = sel == null
      ? null
      : tasks.where((t) => t.code == sel).firstOrNull;
  if (selTask != null) {
    selection = GanttSelection(
      task: selTask,
      coordinatorshipName:
          catalog.coordinatorship(selTask.item.coordinatorship)?.name ??
          selTask.item.coordinatorship,
      assignees: [
        for (final id in selTask.item.assignees) catalog.nameOf(id) ?? id,
      ],
    );
  }

  return GanttView(
    state: s,
    year: year,
    days: days,
    today: today,
    rows: rows,
    visible: visible.length,
    lateAll: tasks.where((t) => t.late).length,
    chips: [
      for (final c in coords)
        GanttCoordChip(
          code: c.code,
          label: c.label,
          name: c.name,
          selected: s.coords.contains(c.code),
        ),
    ],
    selection: selection,
  );
}
