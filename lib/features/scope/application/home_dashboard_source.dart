import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/home_dashboard.dart';
import '../domain/home_dashboard_repository.dart';

/// Ana sayfa özetinin kaynağı: doğrulanmış bağın sunucusu; bağ yoksa
/// `client.server_not_verified`. Program seçimi denetleyicide denetlenir.
final class HomeDashboardSource implements HomeDashboardRepository {
  HomeDashboardSource({required this.server});

  /// Doğrulanmış bağın sunucu kaynağı; bağ yoksa null.
  final HomeDashboardRepository? Function() server;

  HomeDashboardRepository get _s {
    final s = server();
    if (s == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return s;
  }

  @override
  Future<HomeDashboard> load() => _s.load();

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) => _s.loadTeamExtras(departmentId: departmentId, coordinator: coordinator);
}
