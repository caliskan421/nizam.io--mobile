import '../../../core/domain/page_slice.dart';
import 'coordinatorship_overview.dart';

/// Koordinatörlük istatistiklerinin sunucu kaynağı
/// (`GET /v1/reports/dashboard/coordinatorships`, S2, yalnız şirket yöneticisine açık —
/// diğer roller `ApiError(reporting.not_authorized)` alır). Bugün liste
/// [coordinatorshipStats] ile görev kataloğundan istemcide türetiliyor; bu port aynı
/// [CoordinatorshipStats] varlığını sunucu sayılarıyla döner. Sunucu üye listesi vermez
/// (yalnız sayı): [CoordinatorshipStats.members] boş gelir — entegrasyonda karar.
abstract interface class CoordinatorshipStatsRepository {
  /// En çok 200 satır; kesilme [PageSlice.truncated]. Sıra sunucunundur (ada göre bayt
  /// sırası); Türkçe sıralama için [sortCoordinatorships].
  Future<PageSlice<CoordinatorshipStats>> load();
}
