// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_connect_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sunucu bağlama gönderim durumu (ekran akışı). Doğrulamanın kendisi core
/// `ServerBindingController.verify`'dadır (well-known + profile, https, sürüm uyumu; fail-closed);
/// bu denetleyici onu yeniden yazmaz, yalnız çağırır. SONUÇ burada tutulmaz: bağın durumu
/// (doğrulandı / güncelleme gerekli / başarısız + hata kodu) tek kaynak olan `bindingStateProvider`
/// üzerinden okunur ve faz makinesi ekranı yönlendirir.

@ProviderFor(ServerConnectController)
final serverConnectControllerProvider = ServerConnectControllerProvider._();

/// Sunucu bağlama gönderim durumu (ekran akışı). Doğrulamanın kendisi core
/// `ServerBindingController.verify`'dadır (well-known + profile, https, sürüm uyumu; fail-closed);
/// bu denetleyici onu yeniden yazmaz, yalnız çağırır. SONUÇ burada tutulmaz: bağın durumu
/// (doğrulandı / güncelleme gerekli / başarısız + hata kodu) tek kaynak olan `bindingStateProvider`
/// üzerinden okunur ve faz makinesi ekranı yönlendirir.
final class ServerConnectControllerProvider
    extends $AsyncNotifierProvider<ServerConnectController, void> {
  /// Sunucu bağlama gönderim durumu (ekran akışı). Doğrulamanın kendisi core
  /// `ServerBindingController.verify`'dadır (well-known + profile, https, sürüm uyumu; fail-closed);
  /// bu denetleyici onu yeniden yazmaz, yalnız çağırır. SONUÇ burada tutulmaz: bağın durumu
  /// (doğrulandı / güncelleme gerekli / başarısız + hata kodu) tek kaynak olan `bindingStateProvider`
  /// üzerinden okunur ve faz makinesi ekranı yönlendirir.
  ServerConnectControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverConnectControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverConnectControllerHash();

  @$internal
  @override
  ServerConnectController create() => ServerConnectController();
}

String _$serverConnectControllerHash() =>
    r'd3fd9451e22431d94624bddb9786129c8fb75c0e';

/// Sunucu bağlama gönderim durumu (ekran akışı). Doğrulamanın kendisi core
/// `ServerBindingController.verify`'dadır (well-known + profile, https, sürüm uyumu; fail-closed);
/// bu denetleyici onu yeniden yazmaz, yalnız çağırır. SONUÇ burada tutulmaz: bağın durumu
/// (doğrulandı / güncelleme gerekli / başarısız + hata kodu) tek kaynak olan `bindingStateProvider`
/// üzerinden okunur ve faz makinesi ekranı yönlendirir.

abstract class _$ServerConnectController extends $AsyncNotifier<void> {
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
