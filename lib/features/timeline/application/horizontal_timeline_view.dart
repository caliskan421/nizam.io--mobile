import '../../tasks/tasks.dart';
import '../data/sample/timeline_sample.dart';
import '../domain/horizontal_timeline.dart';
import '../domain/timeline.dart';

/// Yatay (tablet) zaman çizelgesinin görünümü: ortak görev kataloğu + ekran durumu. Sıra ve
/// Teknofest günleri örnek veriden (dikey çizelgenin `timelineSample*` verisiyle aynı yer).
GanttView horizontalTimelineView(TaskCatalog catalog, GanttState state) {
  final year = catalog.today.year;
  final fest = seasonDay(timelineSampleFestivalStart, year);
  return buildGanttView(
    catalog,
    state,
    order: timelineSampleGanttOrder,
    festival: DayRange(fest, fest + timelineSampleFestivalDays),
  );
}
