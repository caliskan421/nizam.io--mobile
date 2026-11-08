import '../../tasks/tasks.dart';
import '../domain/horizontal_timeline.dart';

/// Yatay (tablet) zaman çizelgesinin görünümü: ortak görev kataloğu + ekran durumu.
GanttView horizontalTimelineView(TaskCatalog catalog, GanttState state) =>
    buildGanttView(catalog, state);
