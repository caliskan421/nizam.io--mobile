// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(identityService)
final identityServiceProvider = IdentityServiceProvider._();

final class IdentityServiceProvider
    extends
        $FunctionalProvider<IdentityService, IdentityService, IdentityService>
    with $Provider<IdentityService> {
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

String _$identityServiceHash() => r'd30c2ab08df4ea168993853d622eb603916cb234';
