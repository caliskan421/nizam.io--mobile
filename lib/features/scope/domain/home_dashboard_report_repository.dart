import '../../../core/domain/page_slice.dart';
import 'home_dashboard.dart';
import 'home_dashboard_report.dart';

/// Yönetici panosunun sunucu kaynağı (reporting). `HomeDashboardRepository`'den ayrıdır:
/// ana sayfa özeti birden çok uçtan kurulur, bu port yalnız reporting uçlarını taşır.
/// Uçlar S2'dir (`X-Nizamio-Program` ara katmandan) ve yalnız şirket yöneticisine açıktır;
/// diğer roller `ApiError(reporting.not_authorized)` alır (istemci rol kuralı türetmez).
abstract interface class DashboardReportRepository {
  /// `GET /v1/reports/dashboard`.
  Future<DashboardReport> load();

  /// `GET /v1/reports/dashboard/coordinatorships`; en çok 200 satır, kesilme
  /// `X-Result-Truncated` başlığından ([PageSlice.truncated]).
  Future<PageSlice<CoordinatorshipSummary>> coordinatorships();
}
