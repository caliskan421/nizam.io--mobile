// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(HomeDashboardController)
final homeDashboardControllerProvider = HomeDashboardControllerProvider._();

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
final class HomeDashboardControllerProvider
    extends $AsyncNotifierProvider<HomeDashboardController, HomeDashboard> {
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
  HomeDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardControllerHash();

  @$internal
  @override
  HomeDashboardController create() => HomeDashboardController();
}

String _$homeDashboardControllerHash() =>
    r'78aca7e303ea73c1b5b6bfdf49d79bb156d08d9f';

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

abstract class _$HomeDashboardController extends $AsyncNotifier<HomeDashboard> {
  FutureOr<HomeDashboard> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeDashboard>, HomeDashboard>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeDashboard>, HomeDashboard>,
              AsyncValue<HomeDashboard>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
