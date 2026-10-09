// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: kimlik servisi bileşim kökünde (`identity_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.

@ProviderFor(identityService)
final identityServiceProvider = IdentityServiceProvider._();

/// PORT: kimlik servisi bileşim kökünde (`identity_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.

final class IdentityServiceProvider
    extends
        $FunctionalProvider<IdentityService, IdentityService, IdentityService>
    with $Provider<IdentityService> {
  /// PORT: kimlik servisi bileşim kökünde (`identity_module.dart`, get_it) kurulur ve burada
  /// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.
  IdentityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'identityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$identityServiceHash();

  @$internal
  @override
  $ProviderElement<IdentityService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdentityService create(Ref ref) {
    return identityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdentityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdentityService>(value),
    );
  }
}

String _$identityServiceHash() => r'f57236b74fa6c84b40220b865808332ffad8754b';
