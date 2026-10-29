// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_prefill.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// null = boş form (varsayılan). Bileşim kökü dev'de geçersiz kılar.

@ProviderFor(loginPrefill)
final loginPrefillProvider = LoginPrefillProvider._();

/// null = boş form (varsayılan). Bileşim kökü dev'de geçersiz kılar.

final class LoginPrefillProvider
    extends $FunctionalProvider<LoginPrefill?, LoginPrefill?, LoginPrefill?>
    with $Provider<LoginPrefill?> {
  /// null = boş form (varsayılan). Bileşim kökü dev'de geçersiz kılar.
  LoginPrefillProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginPrefillProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginPrefillHash();

  @$internal
  @override
  $ProviderElement<LoginPrefill?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginPrefill? create(Ref ref) {
    return loginPrefill(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginPrefill? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginPrefill?>(value),
    );
  }
}

String _$loginPrefillHash() => r'3f5441177b91a399f09514ac227f40fc03ecc1b2';
