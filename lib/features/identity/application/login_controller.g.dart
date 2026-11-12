// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Giriş gönderim durumu. Parola YALNIZ [submit] parametresidir: duruma, `toString`'e ve log'a
/// girmez (durum `AsyncValue<void>`: yükleniyor / hata [ApiError] / bitti). Oturumun açılması
/// durum değildir: `sessionStateProvider` değişir, faz makinesi yönlendirir.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Giriş gönderim durumu. Parola YALNIZ [submit] parametresidir: duruma, `toString`'e ve log'a
/// girmez (durum `AsyncValue<void>`: yükleniyor / hata [ApiError] / bitti). Oturumun açılması
/// durum değildir: `sessionStateProvider` değişir, faz makinesi yönlendirir.
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// Giriş gönderim durumu. Parola YALNIZ [submit] parametresidir: duruma, `toString`'e ve log'a
  /// girmez (durum `AsyncValue<void>`: yükleniyor / hata [ApiError] / bitti). Oturumun açılması
  /// durum değildir: `sessionStateProvider` değişir, faz makinesi yönlendirir.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'c0b00f8e0817260d66ee4d7d61d21fb62f9130ee';

/// Giriş gönderim durumu. Parola YALNIZ [submit] parametresidir: duruma, `toString`'e ve log'a
/// girmez (durum `AsyncValue<void>`: yükleniyor / hata [ApiError] / bitti). Oturumun açılması
/// durum değildir: `sessionStateProvider` değişir, faz makinesi yönlendirir.

abstract class _$LoginController extends $AsyncNotifier<void> {
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
