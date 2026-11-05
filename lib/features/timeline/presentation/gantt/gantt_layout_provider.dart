import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tasks/tasks.dart';
import '../../application/horizontal_timeline_controller.dart';
import '../../application/horizontal_timeline_view.dart';
import 'gantt_geometry.dart';

/// Yatay çizelgenin yerleşimi (tek girişli önbellek): katalog örneği ya da ekran durumu
/// ([GanttState] eşitliği: ölçek, süzgeç, arama, koordinatörlükler, kapalı gruplar, seçim)
/// değişmedikçe yeniden hesaplanmaz. Katalog yenilenirken aynı örnek kalırsa yerleşim de kalır.
/// Canlı tutulur: sayfa kapanıp açılınca hazırdır; dinleyici yokken girdiler değişirse ilk
/// okumada yeniden kurulur. Görünüm genişliği yerleşime girmez (yalnız ortalamayı etkiler).
/// Katalog henüz yoksa null.
final ganttLayoutProvider = Provider<GanttLayout?>((ref) {
  final catalog = ref.watch(
    taskCatalogControllerProvider.select((c) => c.value),
  );
  if (catalog == null) return null;
  final state = ref.watch(horizontalTimelineControllerProvider);
  return GanttLayout.of(horizontalTimelineView(catalog, state));
});
