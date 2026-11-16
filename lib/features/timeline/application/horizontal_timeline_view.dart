import '../../tasks/tasks.dart';
import '../domain/horizontal_timeline.dart';
import '../domain/timeline.dart';

/// Yatay (tablet) zaman çizelgesinin görünümü: ortak görev kataloğu + ekran durumu.
/// [rangeOf]: kaydedilmiş düzenleme ya da +/- taslağı (bkz. [buildGanttView]).
GanttView horizontalTimelineView(
  TaskCatalog catalog,
  GanttState state, {
  Set<String> dependent = const {},
  DayRange? Function(String code)? rangeOf,
  bool byStatus = false,
}) => buildGanttView(
  catalog,
  state,
  dependent: dependent,
  rangeOf: rangeOf,
  byStatus: byStatus,
);
