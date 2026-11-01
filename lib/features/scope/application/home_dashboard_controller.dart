import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';
import 'scope_providers.dart';
import 'team_dashboard.dart';

part 'home_dashboard_controller.g.dart';

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
///
/// Rol → kaynak (rol türetme `TaskAccess`, görev kataloğunda):
/// - örnek kapsam ya da şirket yöneticisi: [HomeDashboardRepository.load] (pano/rapor uçları);
/// - koordinatör/üye: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Yönetici olmayan hesapta departman
/// bağlamı yoksa ([TaskCatalog.departmentRequired]) özet `client.scope_missing` hatasıdır
/// ("departman seç"; görev listesiyle aynı metin) — ek istek gönderilmez.
@riverpod
class HomeDashboardController extends _$HomeDashboardController {
  @override
  Future<HomeDashboard> build() async {
    final scope = ref.watch(scopeStateProvider);
    final repo = ref.read(homeDashboardRepositoryProvider);
    final program = scope.programId;
    if (!scope.hasServerProgram || program == null) return repo.load();

    void followCatalog() => ref.listen(taskCatalogControllerProvider, (
      prev,
      next,
    ) {
      if (next.isLoading && !(prev?.isLoading ?? false)) ref.invalidateSelf();
    });

    final TaskCatalog catalog;
    try {
      catalog = await ref.read(taskCatalogControllerProvider.future);
    } on Object {
      // Hata yukarı taşınır (rol tahmini yok; yönetici uçlarına düşüş yok). Katalog yeniden
      // okununca özet de yeniden kurulur.
      followCatalog();
      rethrow;
    }
    final access = catalog.access;
    if (access == null || access.companyAdmin) return repo.load();

    followCatalog();
    if (catalog.departmentRequired) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }
    final dept = catalog.departmentId;
    final coordinator = dept != null && access.coordinatesIn(program, dept);
    final extras = await repo.loadTeamExtras(
      departmentId: dept,
      coordinator: coordinator,
    );
    return teamDashboard(catalog, extras, coordinator: coordinator);
  }
}
