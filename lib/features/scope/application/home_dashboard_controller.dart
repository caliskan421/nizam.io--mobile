import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';
import 'scope_providers.dart';
import 'team_dashboard.dart';

part 'home_dashboard_controller.g.dart';

/// Yardımcı bölümler temel panodan bağımsız yüklenir; geç kalan yanıt eski sahibe aittir.
final homePendingProvider = FutureProvider.autoDispose<PendingOverview?>((
  ref,
) async {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  final session = ref.read(sessionControllerProvider).generation;
  final scope = ref.read(scopeControllerProvider).current;
  bool live() {
    if (!ref.mounted) return false;
    final current = ref.read(scopeControllerProvider).current;
    return session == ref.read(sessionControllerProvider).generation &&
        current.programId == scope.programId &&
        current.departmentId == scope.departmentId;
  }

  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  if (!live()) throw ApiError('client.scope_changed');
  if (catalog.access?.companyAdmin != true) return null;
  final result = await ref.read(homeDashboardRepositoryProvider).loadPending();
  if (!live()) throw ApiError('client.scope_changed');
  return result;
});

final homeUnreadProvider = FutureProvider.autoDispose<int?>((ref) async {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  final session = ref.read(sessionControllerProvider).generation;
  final scope = ref.read(scopeControllerProvider).current;
  bool live() {
    if (!ref.mounted) return false;
    final current = ref.read(scopeControllerProvider).current;
    return session == ref.read(sessionControllerProvider).generation &&
        current.programId == scope.programId &&
        current.departmentId == scope.departmentId;
  }

  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  if (!live()) throw ApiError('client.scope_changed');
  if (catalog.access?.companyAdmin != true) return null;
  final result = await ref.read(homeDashboardRepositoryProvider).loadUnread();
  if (!live()) throw ApiError('client.scope_changed');
  return result;
});

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
/// Önbellek / yenileme: özet uygulama ömrünce bellekte kalır ve okunduğu sahibe (oturum nesli +
/// program, [CacheOwnership]) bağlıdır; ekran [visible] durumunu gösterir: başka hesap, kurulum
/// ya da program için okunmuş özet görünmez (yükleniyor ya da yalnız hata). [refresh] (aşağı
/// çekerek) ve [refreshIfStale] (sekmeye/ön plana dönüş) önceki özeti durumda tutarak yeniden
/// okur (`invalidateSelf` → `isRefreshing`, `value` korunur).
@Riverpod(keepAlive: true)
class HomeDashboardController extends _$HomeDashboardController {
  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _clock = StaleClock();

  /// Durumdaki özetin sahibi (notifier yeniden kurulumlarda korunur).
  final _owner = CacheOwnership();
  ({int session, String? program, String? department})? _realOwner;

  @override
  Future<HomeDashboard> build() async {
    final buildRef = ref;
    final owner = _owner.watch(buildRef);
    final session = buildRef.read(sessionControllerProvider).generation;
    final scope = buildRef.read(scopeControllerProvider).current;
    bool live() {
      if (!buildRef.mounted) return false;
      final current = buildRef.read(scopeControllerProvider).current;
      return session == buildRef.read(sessionControllerProvider).generation &&
          scope.programId == current.programId &&
          scope.departmentId == current.departmentId;
    }

    final dashboard = await _load(live);
    if (live()) {
      _owner.markLoaded(buildRef, owner);
      _realOwner = (
        session: session,
        program: scope.programId,
        department: scope.departmentId,
      );
      _clock.markFresh();
    }
    return dashboard;
  }

  /// Ekranın gösterebileceği durum (bkz. [CacheOwnership.visible]); çağıran sağlayıcıyı izler.
  AsyncValue<HomeDashboard> get visible {
    final scope = ref.read(scopeControllerProvider).current;
    final current = (
      session: ref.read(sessionControllerProvider).generation,
      program: scope.programId,
      department: scope.departmentId,
    );
    return CacheOwnership.ownedOnly(
      _owner.visible(ref, state),
      owned: current == _realOwner,
    );
  }

  /// Kullanıcı yenilemesi: sunucu kapsamında rol kaynağı olan görev kataloğu ve özet yeniden
  /// okunur, ikisi de bitince döner. Hata FIRLATILIR (ortak yenileme kabuğu bildirir); önceki
  /// özet durumda kalır.
  Future<void> refresh() => _refresh((catalog) => catalog.refresh());

  /// Yeniden ziyaret (sekmeye ya da ön plana dönüş): son başarılı okuma [maxAge]'den eskiyse
  /// arka planda yeniden okunur; eski özet görünür kalır, bildirim yok. Hiç yüklenmemişse,
  /// yükleniyorsa ya da son okuma hatayla bittiyse bir şey yapmaz (hata sonrası yeniden deneme
  /// yalnız kullanıcı eylemiyle). Kataloğu zorlamaz: katalog kendi bayatlık kuralıyla
  /// ([TaskCatalogController.refreshIfStale]) yenilenir, sürmekte olan katalog okuması
  /// paylaşılır (tek ön plan olayında tek katalog okuması).
  Future<void> refreshIfStale({Duration maxAge = StaleClock.staleAfter}) =>
      _clock.refreshIfStale(
        state,
        () => _refresh((catalog) => catalog.refreshIfStale(maxAge: maxAge)),
        maxAge: maxAge,
      );

  /// Önce katalog ([catalogStep]), sonra özet; ikisi de bitince ilk hata fırlatılır. Yönetici
  /// olmayan hesapta özet kataloğu izler: katalog yüklemeye geçince kendini zaten yeniden kurar,
  /// ikinci kez geçersizlenmez (çift istek yok).
  Future<void> _refresh(
    Future<void> Function(TaskCatalogController catalog) catalogStep,
  ) async {
    ref.invalidate(homePendingProvider);
    ref.invalidate(homeUnreadProvider);
    final scope = ref.read(scopeStateProvider);
    Object? failure;
    StackTrace? trace;
    if (scope.hasProgram) {
      try {
        await catalogStep(ref.read(taskCatalogControllerProvider.notifier));
      } on Object catch (e, s) {
        reportUnexpected(e, s, source: ReportSource.scope);
        failure = e;
        trace = s;
      }
    }
    if (!state.isLoading) ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, s) {
      reportUnexpected(e, s, source: ReportSource.scope);
      failure ??= e;
      trace ??= s;
    }
    if (failure != null) Error.throwWithStackTrace(failure, trace!);
  }

  Future<HomeDashboard> _load(bool Function() live) async {
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
      if (live()) followCatalog();
      rethrow;
    }
    if (!live()) throw ApiError(ClientErrorCode.scopeChanged);
    final access = catalog.access;
    if (access == null) throw ApiError(ClientErrorCode.scopeMissing);
    if (access.companyAdmin) {
      final dashboard = await repo.load();
      if (!live()) throw ApiError(ClientErrorCode.scopeChanged);
      return dashboard;
    }

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
    if (!live()) throw ApiError(ClientErrorCode.scopeChanged);
    return teamDashboard(
      catalog,
      extras,
      coordinator: coordinator,
      departmentId: dept,
    );
  }
}
