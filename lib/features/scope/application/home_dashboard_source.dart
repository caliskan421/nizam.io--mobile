import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../domain/home_dashboard.dart';
import '../domain/home_dashboard_repository.dart';

/// Ana sayfa özetinin kaynak seçimi: sunucu programı seçiliyse sunucu, örnek kapsamda
/// ("örnek verilerle devam") geliştirme örneği. Seçim her okumada güncel kapsamdan yapılır;
/// controller kapsam değişince yeniden okur.
final class HomeDashboardSource implements HomeDashboardRepository {
  HomeDashboardSource({
    required this.scope,
    required this.server,
    required this.sample,
  });

  final ScopeController scope;

  /// Doğrulanmış bağın sunucu kaynağı; bağ yoksa null.
  final HomeDashboardRepository? Function() server;
  final HomeDashboardRepository sample;

  @override
  Future<HomeDashboard> load() async {
    if (!scope.current.hasServerProgram) return sample.load();
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.load();
  }

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async {
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s.loadTeamExtras(
      departmentId: departmentId,
      coordinator: coordinator,
    );
  }
}
