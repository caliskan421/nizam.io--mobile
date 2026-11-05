import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../tasks/tasks.dart';
import '../../application/horizontal_timeline_controller.dart';
import '../../application/horizontal_timeline_view.dart';
import 'gantt_geometry.dart';

/// Yatay çizelgenin yerleşimi (tek girişli önbellek): katalog örneği ya da ekran durumu
/// ([GanttState] eşitliği: ölçek, süzgeç, arama, koordinatörlükler, kapalı gruplar, seçim)
/// değişmedikçe yeniden hesaplanmaz. Görünüm genişliği yerleşime girmez (yalnız ortalamayı
/// etkiler).
///
/// Ömür kapsama bağlıdır: aynı kapsamda katalog yenilenirken (aşağı çekme, sekmeye dönüş)
/// önceki yerleşim kalır; kapsam (program/departman) değişince ya da çıkışta (kapsam temizlenir)
/// atılır ve yeni kapsamın kataloğu gelene kadar (`isReloading`) yerleşim yoktur — önceki
/// programın verisi yeni kapsamın altında çizilmez. Sayfa kapanınca bırakılır (autoDispose):
/// yeniden açılışta bir kez kurulur.
/// Katalog ya da program yoksa null.
final ganttLayoutProvider = Provider.autoDispose<GanttLayout?>((ref) {
  if (!ref.watch(scopeStateProvider).hasProgram) return null;
  final catalog = ref.watch(
    taskCatalogControllerProvider.select((c) => c.isReloading ? null : c.value),
  );
  if (catalog == null) return null;
  final state = ref.watch(horizontalTimelineControllerProvider);
  return GanttLayout.of(horizontalTimelineView(catalog, state));
});
