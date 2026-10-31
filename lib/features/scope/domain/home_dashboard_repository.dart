import 'home_dashboard.dart';

/// Ana sayfa özetinin kaynağı (domain portu; gerçekleştirmeler `data/` katmanında).
///
/// - [load]: şirket yöneticisi özeti (pano/rapor uçları; yalnız yönetici) ya da örnek fikstür.
/// - [loadTeamExtras]: yönetici OLMAYAN hesabın özetinde görev listesinden sayılamayan iki
///   parça — okunmamış mesaj sayısı ve (yalnız [coordinator]) çağıranın bekleyen tarih
///   talepleri (`myDateChangeRequests`, [departmentId] ile). Yönetici uçları çağrılmaz.
abstract interface class HomeDashboardRepository {
  Future<HomeDashboard> load();

  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  });
}
