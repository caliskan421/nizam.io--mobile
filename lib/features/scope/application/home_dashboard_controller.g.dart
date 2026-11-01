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
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Yönetici olmayan hesapta departman
/// bağlamı yoksa ([TaskCatalog.departmentRequired]) özet `client.scope_missing` hatasıdır
/// ("departman seç"; görev listesiyle aynı metin) — ek istek gönderilmez.

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
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Yönetici olmayan hesapta departman
/// bağlamı yoksa ([TaskCatalog.departmentRequired]) özet `client.scope_missing` hatasıdır
/// ("departman seç"; görev listesiyle aynı metin) — ek istek gönderilmez.
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
  /// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
  /// hatası olarak gösterilir (yeniden dene dokunuşla). Yönetici olmayan hesapta departman
  /// bağlamı yoksa ([TaskCatalog.departmentRequired]) özet `client.scope_missing` hatasıdır
  /// ("departman seç"; görev listesiyle aynı metin) — ek istek gönderilmez.
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
    r'54c4cb97985667d9e1ad409a73e1ae8b3f10dc01';

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
