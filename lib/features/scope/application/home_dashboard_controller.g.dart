// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

@ProviderFor(HomeDashboardController)
final homeDashboardControllerProvider = HomeDashboardControllerProvider._();

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
final class HomeDashboardControllerProvider
    extends $AsyncNotifierProvider<HomeDashboardController, HomeDashboard> {
  /// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
  /// dokunuşuyla (`ref.invalidate`).
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
    r'bc48d741db0b40efb6e4291c1cfd8e3869ab1d4b';

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

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
