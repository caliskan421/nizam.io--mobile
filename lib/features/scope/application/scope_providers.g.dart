// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: kapsam servisi bileşim kökünde (`scope_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.

@ProviderFor(scopeService)
final scopeServiceProvider = ScopeServiceProvider._();

/// PORT: kapsam servisi bileşim kökünde (`scope_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.

final class ScopeServiceProvider
    extends $FunctionalProvider<ScopeService, ScopeService, ScopeService>
    with $Provider<ScopeService> {
  /// PORT: kapsam servisi bileşim kökünde (`scope_module.dart`, get_it) kurulur ve burada
  /// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.
  ScopeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopeServiceHash();

  @$internal
  @override
  $ProviderElement<ScopeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScopeService create(Ref ref) {
    return scopeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScopeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScopeService>(value),
    );
  }
}

String _$scopeServiceHash() => r'79dd23c80dbce21bf68c74769b6004849924cb53';

/// PORT: ana sayfa özetinin kaynağı (`scope_module.dart`'ta bağlanır; bugün geliştirme örneği).

@ProviderFor(homeDashboardRepository)
final homeDashboardRepositoryProvider = HomeDashboardRepositoryProvider._();

/// PORT: ana sayfa özetinin kaynağı (`scope_module.dart`'ta bağlanır; bugün geliştirme örneği).

final class HomeDashboardRepositoryProvider
    extends
        $FunctionalProvider<
          HomeDashboardRepository,
          HomeDashboardRepository,
          HomeDashboardRepository
        >
    with $Provider<HomeDashboardRepository> {
  /// PORT: ana sayfa özetinin kaynağı (`scope_module.dart`'ta bağlanır; bugün geliştirme örneği).
  HomeDashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeDashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeDashboardRepository create(Ref ref) {
    return homeDashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeDashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeDashboardRepository>(value),
    );
  }
}

String _$homeDashboardRepositoryHash() =>
    r'1a49010f24795778367da239b236d453486dc4bd';
