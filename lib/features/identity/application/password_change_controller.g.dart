// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_change_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Zorunlu parola değişikliği gönderim durumu. Parolalar YALNIZ [submit] parametresidir; durum
/// yalnız gönderim sonucudur (yükleniyor / hata [ApiError] / bitti). Başarıda bayrak
/// `IdentityService`'te düşer ve faz makinesi kapsam seçimine yönlendirir.

@ProviderFor(PasswordChangeController)
final passwordChangeControllerProvider = PasswordChangeControllerProvider._();

/// Zorunlu parola değişikliği gönderim durumu. Parolalar YALNIZ [submit] parametresidir; durum
/// yalnız gönderim sonucudur (yükleniyor / hata [ApiError] / bitti). Başarıda bayrak
/// `IdentityService`'te düşer ve faz makinesi kapsam seçimine yönlendirir.
final class PasswordChangeControllerProvider
    extends $AsyncNotifierProvider<PasswordChangeController, void> {
  /// Zorunlu parola değişikliği gönderim durumu. Parolalar YALNIZ [submit] parametresidir; durum
  /// yalnız gönderim sonucudur (yükleniyor / hata [ApiError] / bitti). Başarıda bayrak
  /// `IdentityService`'te düşer ve faz makinesi kapsam seçimine yönlendirir.
  PasswordChangeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordChangeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordChangeControllerHash();

  @$internal
  @override
  PasswordChangeController create() => PasswordChangeController();
}

String _$passwordChangeControllerHash() =>
    r'545d8088402ff14695e3ecd02c08edab9c4814ab';

/// Zorunlu parola değişikliği gönderim durumu. Parolalar YALNIZ [submit] parametresidir; durum
/// yalnız gönderim sonucudur (yükleniyor / hata [ApiError] / bitti). Başarıda bayrak
/// `IdentityService`'te düşer ve faz makinesi kapsam seçimine yönlendirir.

abstract class _$PasswordChangeController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
