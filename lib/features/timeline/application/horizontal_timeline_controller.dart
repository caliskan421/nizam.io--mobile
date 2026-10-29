import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/horizontal_timeline.dart';
import '../domain/timeline.dart';

part 'horizontal_timeline_controller.g.dart';

/// Yatay (tablet) zaman çizelgesinin ekran durumu ve komutları (prototip `S_hgantt.state`:
/// ölçek, durum süzgeci, koordinatörlük seçimi, kapalı gruplar, seçili görev). Prototipte bileşen
/// sayfa kapanınca yaşamaya devam eder; bu yüzden sağlayıcı canlı tutulur (`keepAlive`) ve sayfa
/// kapatılıp yeniden açılınca durum korunur. Kaydırma ve ortalama isteği sayfa içinde kalır.
@Riverpod(keepAlive: true)
class HorizontalTimelineController extends _$HorizontalTimelineController {
  @override
  GanttState build() => const GanttState();

  /// Sayfanın gezinme niyeti (sayfa başına bir kez):
  /// - null → genel açılış (görev listesinden): durum olduğu gibi kalır.
  /// - [timelineAllCoordinatorships] → bütün koordinatörlükler, seçim kalkar.
  /// - kod → [openCoord].
  /// Ölçek, durum süzgeci ve kapalı gruplar hiçbir niyette değişmez.
  void open(String? coordinatorship) {
    if (coordinatorship == null) return;
    if (coordinatorship == timelineAllCoordinatorships) {
      state = state.clearCoords().clearSelection();
    } else {
      openCoord(coordinatorship);
    }
  }

  /// Yalnız [code] seçili açar ve seçimi kaldırır.
  void openCoord(String code) =>
      state = state.withCoords([code]).clearSelection();

  void setZoom(GanttZoom zoom) => state = state.withZoom(zoom);

  void setFilter(GanttFilter filter) => state = state.withFilter(filter);

  void toggleCoord(String code) => state = state.toggleCoord(code);

  void clearCoords() => state = state.clearCoords();

  void toggleGroup(String code) => state = state.toggleGroup(code);

  void pick(String code) => state = state.pick(code);

  void clearSelection() => state = state.clearSelection();
}
