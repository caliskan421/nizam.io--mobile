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
/// Etkin rol → kaynak (etkin görünüm `EffectiveAccess`; erişim görev kataloğunda):
/// - yönetici görünümü: [HomeDashboardRepository.load] (pano/rapor uçları);
/// - koordinatör/üye görünümü: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Katalog süzgeçsiz program listesidir
/// (görevler ekranının departman süzgeci özete yansımaz). Yönetici olmayan görünümde özetin
/// departmanı etkin koordinatörlüktür (seçim, yoksa varsayılanı: ilk koordinatörlük, yoksa ilk
/// ekip satırı); hiçbiri yoksa özet `client.scope_missing` hatasıdır — ek istek gönderilmez.
///
/// Önbellek / yenileme: özet uygulama ömrünce bellekte kalır ve okunduğu sahibe (oturum nesli +
/// program + rol + koordinatörlük, [CacheOwnership]) bağlıdır; ekran [visible] durumunu
/// gösterir: başka hesap, kurulum, program ya da görünüm için okunmuş özet görünmez
/// (yükleniyor ya da yalnız hata). [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye/ön plana dönüş) önceki özeti durumda tutarak yeniden
/// okur (`invalidateSelf` → `isRefreshing`, `value` korunur).

@ProviderFor(HomeDashboardController)
final homeDashboardControllerProvider = HomeDashboardControllerProvider._();

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
///
/// Etkin rol → kaynak (etkin görünüm `EffectiveAccess`; erişim görev kataloğunda):
/// - yönetici görünümü: [HomeDashboardRepository.load] (pano/rapor uçları);
/// - koordinatör/üye görünümü: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Katalog süzgeçsiz program listesidir
/// (görevler ekranının departman süzgeci özete yansımaz). Yönetici olmayan görünümde özetin
/// departmanı etkin koordinatörlüktür (seçim, yoksa varsayılanı: ilk koordinatörlük, yoksa ilk
/// ekip satırı); hiçbiri yoksa özet `client.scope_missing` hatasıdır — ek istek gönderilmez.
///
/// Önbellek / yenileme: özet uygulama ömrünce bellekte kalır ve okunduğu sahibe (oturum nesli +
/// program + rol + koordinatörlük, [CacheOwnership]) bağlıdır; ekran [visible] durumunu
/// gösterir: başka hesap, kurulum, program ya da görünüm için okunmuş özet görünmez
/// (yükleniyor ya da yalnız hata). [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye/ön plana dönüş) önceki özeti durumda tutarak yeniden
/// okur (`invalidateSelf` → `isRefreshing`, `value` korunur).
final class HomeDashboardControllerProvider
    extends $AsyncNotifierProvider<HomeDashboardController, HomeDashboard> {
  /// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
  /// dokunuşuyla (`ref.invalidate`).
  ///
  /// Etkin rol → kaynak (etkin görünüm `EffectiveAccess`; erişim görev kataloğunda):
  /// - yönetici görünümü: [HomeDashboardRepository.load] (pano/rapor uçları);
  /// - koordinatör/üye görünümü: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
  ///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
  ///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
  /// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
  /// hatası olarak gösterilir (yeniden dene dokunuşla). Katalog süzgeçsiz program listesidir
  /// (görevler ekranının departman süzgeci özete yansımaz). Yönetici olmayan görünümde özetin
  /// departmanı etkin koordinatörlüktür (seçim, yoksa varsayılanı: ilk koordinatörlük, yoksa ilk
  /// ekip satırı); hiçbiri yoksa özet `client.scope_missing` hatasıdır — ek istek gönderilmez.
  ///
  /// Önbellek / yenileme: özet uygulama ömrünce bellekte kalır ve okunduğu sahibe (oturum nesli +
  /// program + rol + koordinatörlük, [CacheOwnership]) bağlıdır; ekran [visible] durumunu
  /// gösterir: başka hesap, kurulum, program ya da görünüm için okunmuş özet görünmez
  /// (yükleniyor ya da yalnız hata). [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye/ön plana dönüş) önceki özeti durumda tutarak yeniden
  /// okur (`invalidateSelf` → `isRefreshing`, `value` korunur).
  HomeDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardControllerProvider',
        isAutoDispose: false,
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
    r'b41ed94d010dcfbf658d497558365908790d9100';

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
///
/// Etkin rol → kaynak (etkin görünüm `EffectiveAccess`; erişim görev kataloğunda):
/// - yönetici görünümü: [HomeDashboardRepository.load] (pano/rapor uçları);
/// - koordinatör/üye görünümü: yönetici uçları ÇAĞRILMAZ; özet yüklenmiş görev kataloğundan sayılır
///   ([teamDashboard]) + okunmamış sayısı ve (koordinatörde) kendi tarih talepleri. Katalog
///   yeniden kurulunca (yüklemeye geçiş) özet de yeniden kurulur.
/// Katalog okunamazsa rol bilinmez: yönetici rapor uçlarına düşülmez, katalog hatası özetin
/// hatası olarak gösterilir (yeniden dene dokunuşla). Katalog süzgeçsiz program listesidir
/// (görevler ekranının departman süzgeci özete yansımaz). Yönetici olmayan görünümde özetin
/// departmanı etkin koordinatörlüktür (seçim, yoksa varsayılanı: ilk koordinatörlük, yoksa ilk
/// ekip satırı); hiçbiri yoksa özet `client.scope_missing` hatasıdır — ek istek gönderilmez.
///
/// Önbellek / yenileme: özet uygulama ömrünce bellekte kalır ve okunduğu sahibe (oturum nesli +
/// program + rol + koordinatörlük, [CacheOwnership]) bağlıdır; ekran [visible] durumunu
/// gösterir: başka hesap, kurulum, program ya da görünüm için okunmuş özet görünmez
/// (yükleniyor ya da yalnız hata). [refresh] (aşağı çekerek) ve [refreshIfStale] (sekmeye/ön plana dönüş) önceki özeti durumda tutarak yeniden
/// okur (`invalidateSelf` → `isRefreshing`, `value` korunur).

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
