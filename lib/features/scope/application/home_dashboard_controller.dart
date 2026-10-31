import 'package:riverpod_annotation/riverpod_annotation.dart';

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
/// Katalog okunamazsa rol bilinmez; özet yönetici yolundan denenir (sunucu yetkiyi reddeder,
/// hata gösterilir — rol tahmini yapılmaz).
@riverpod
class HomeDashboardController extends _$HomeDashboardController {
  @override
  Future<HomeDashboard> build() async {
    final scope = ref.watch(scopeStateProvider);
    final repo = ref.read(homeDashboardRepositoryProvider);
    final program = scope.programId;
    if (!scope.hasServerProgram || program == null) return repo.load();

    TaskCatalog? catalog;
    try {
      catalog = await ref.read(taskCatalogControllerProvider.future);
    } on Object {
      catalog = null;
    }
    final access = catalog?.access;
    if (catalog == null || access == null || access.companyAdmin) {
      return repo.load();
    }

    ref.listen(taskCatalogControllerProvider, (prev, next) {
      if (next.isLoading && !(prev?.isLoading ?? false)) ref.invalidateSelf();
    });
    final dept = catalog.departmentId;
    final coordinator = dept != null && access.coordinatesIn(program, dept);
    final extras = await repo.loadTeamExtras(
      departmentId: dept,
      coordinator: coordinator,
    );
    return teamDashboard(catalog, extras, coordinator: coordinator);
  }
}
