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
///
/// Önbellek / yenileme: özet ekranda açık kaldıkça (kabuk dalı korunur) bellekte kalır;
/// [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye dönüş) önceki özeti durumda tutarak
/// yeniden okur (`invalidateSelf` → `isRefreshing`, `value` korunur). Kapsam değişimi
/// bağımlılık yeniden kurulumudur (`isReloading`); ekran o durumda iskelet gösterir.
@riverpod
class HomeDashboardController extends _$HomeDashboardController {
  /// Yeniden ziyarette özetin taze sayıldığı süre.
  static const staleAfter = Duration(seconds: 30);

  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _age = Stopwatch();

  @override
  Future<HomeDashboard> build() async {
    final dashboard = await _load();
    _age
      ..reset()
      ..start();
    return dashboard;
  }

  /// Kullanıcı yenilemesi: sunucu kapsamında rol kaynağı olan görev kataloğu ve özet yeniden
  /// okunur, ikisi de bitince döner. Hata FIRLATILIR (çağıran bildirir); önceki özet durumda
  /// kalır. Yönetici olmayan hesapta özet kataloğu izler: katalog yüklemeye geçince kendini
  /// zaten yeniden kurar, ikinci kez geçersizlenmez (çift istek yok).
  Future<void> refresh() async {
    final scope = ref.read(scopeStateProvider);
    Object? failure;
    StackTrace? trace;
    if (scope.hasServerProgram && scope.programId != null) {
      try {
        await ref.read(taskCatalogControllerProvider.notifier).refresh();
      } on Object catch (e, s) {
        failure = e;
        trace = s;
      }
    }
    if (!state.isLoading) ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, s) {
      failure ??= e;
      trace ??= s;
    }
    if (failure != null) Error.throwWithStackTrace(failure, trace!);
  }

  /// Yeniden ziyaret: son başarılı okuma [maxAge]'den eskiyse arka planda [refresh]; eski
  /// özet görünür kalır. Hiç yüklenmemişse ya da yükleniyorsa bir şey yapmaz; hata yutulur.
  Future<void> refreshIfStale({Duration maxAge = staleAfter}) async {
    if (state.isLoading || !state.hasValue) return;
    if (_age.isRunning && _age.elapsed < maxAge) return;
    try {
      await refresh();
    } on Object {
      // Arka plan yenilemesi: hata durumda, veri yerinde.
    }
  }

  Future<HomeDashboard> _load() async {
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
