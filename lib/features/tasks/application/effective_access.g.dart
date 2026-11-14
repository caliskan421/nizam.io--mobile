// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effective_access.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Etkin görünüm (rol, koordinatörlük, yetenek bayrakları). Katalog erişimi ya da seçim
/// değişince yeniden kurulur; görev yazmaları (aynı erişim nesnesi) yeniden kurmaz.

@ProviderFor(effectiveAccess)
final effectiveAccessProvider = EffectiveAccessProvider._();

/// Etkin görünüm (rol, koordinatörlük, yetenek bayrakları). Katalog erişimi ya da seçim
/// değişince yeniden kurulur; görev yazmaları (aynı erişim nesnesi) yeniden kurmaz.

final class EffectiveAccessProvider
    extends
        $FunctionalProvider<EffectiveAccess, EffectiveAccess, EffectiveAccess>
    with $Provider<EffectiveAccess> {
  /// Etkin görünüm (rol, koordinatörlük, yetenek bayrakları). Katalog erişimi ya da seçim
  /// değişince yeniden kurulur; görev yazmaları (aynı erişim nesnesi) yeniden kurmaz.
  EffectiveAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveAccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveAccessHash();

  @$internal
  @override
  $ProviderElement<EffectiveAccess> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EffectiveAccess create(Ref ref) {
    return effectiveAccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EffectiveAccess value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EffectiveAccess>(value),
    );
  }
}

String _$effectiveAccessHash() => r'076243e02680fd27461189f59a88d9aa7c03f3c6';
