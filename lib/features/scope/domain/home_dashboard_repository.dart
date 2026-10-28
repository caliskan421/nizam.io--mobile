import 'home_dashboard.dart';

/// Ana sayfa özetinin kaynağı (domain portu; gerçekleştirmeler `data/` katmanında). Bugün tek gerçekleştirme geliştirme örneğidir
/// (`data/sample/sample_home_dashboard_repository.dart`); backend özeti hazır olduğunda gerçek
/// gerçekleştirme (DTO → domain eşlemesi bu katmanda) bileşim kökünde onun yerini alır.
abstract interface class HomeDashboardRepository {
  Future<HomeDashboard> load();
}
