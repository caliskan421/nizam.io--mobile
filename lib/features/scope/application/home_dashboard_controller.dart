import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';
import 'scope_providers.dart';
import 'team_dashboard.dart';

part 'home_dashboard_controller.g.dart';

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
///
/// Rol → kaynak (rol türetme `TaskAccess`, görev kataloğunda):
/// - şirket yöneticisi: [HomeDashboardRepository.load] (pano/rapor uçları);
/// - koordinatör/üye: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Katalog süzgeçsiz program listesidir
/// (görevler ekranının departman süzgeci özete yansımaz). Yönetici olmayan hesapta özetin
/// departmanı programdaki ilk koordinatörlük, yoksa ilk ekip satırıdır
/// ([TaskAccess.primaryDepartmentIn]); hiçbiri yoksa özet `client.scope_missing` hatasıdır —
/// ek istek gönderilmez.
///
/// Önbellek / yenileme: özet ekranda açık kaldıkça (kabuk dalı korunur) bellekte kalır;
/// [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye dönüş) önceki özeti durumda tutarak
/// yeniden okur (`invalidateSelf` → `isRefreshing`, `value` korunur). Kapsam değişimi
/// bağımlılık yeniden kurulumudur (`isReloading`); ekran o durumda iskelet gösterir.
@riverpod
class HomeDashboardController extends _$HomeDashboardController {
  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _clock = StaleClock();

  /// Önceki başarılı okumanın ait olduğu program (kapsam). Yeniden kurulum aynı programda ise
  /// eski özet başka kümeye ait değildir; ekran iskelet yerine onu gösterir.
  Object? loadedProgram;

  @override
  Future<HomeDashboard> build() async {
    final program = ref.read(scopeStateProvider).programId;
    final dashboard = await _load();
    loadedProgram = program;
    _clock.markFresh();
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
    if (scope.hasProgram) {
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
  Future<void> refreshIfStale({Duration maxAge = StaleClock.staleAfter}) =>
      _clock.refreshIfStale(state, refresh, maxAge: maxAge);

  Future<HomeDashboard> _load() async {
    final scope = ref.watch(scopeStateProvider);
    final repo = ref.read(homeDashboardRepositoryProvider);
    final program = scope.programId;
    if (!scope.hasProgram || program == null) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }

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
    if (access == null) throw ApiError(ClientErrorCode.scopeMissing);
    if (access.companyAdmin) return repo.load();

    followCatalog();
    // Özetin departmanı (görevler ekranının süzgecinden bağımsız): programdaki ilk
    // koordinatörlük, yoksa ilk ekip satırı.
    final dept = access.primaryDepartmentIn(program);
    if (dept == null) throw ApiError(ClientErrorCode.scopeMissing);
    final coordinator = access.coordinatesIn(program, dept);
    final extras = await repo.loadTeamExtras(
      departmentId: dept,
      coordinator: coordinator,
    );
    return teamDashboard(
      catalog,
      extras,
      coordinator: coordinator,
      departmentId: dept,
    );
  }
}
