// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Çıkış durumu. Sunucu çıkışı başarısız olsa da yerel oturum kapanır (`IdentityService.logout`);
/// kapanış faz makinesiyle giriş ekranına döner.

@ProviderFor(LogoutController)
final logoutControllerProvider = LogoutControllerProvider._();

/// Çıkış durumu. Sunucu çıkışı başarısız olsa da yerel oturum kapanır (`IdentityService.logout`);
/// kapanış faz makinesiyle giriş ekranına döner.
final class LogoutControllerProvider
    extends $AsyncNotifierProvider<LogoutController, void> {
  /// Çıkış durumu. Sunucu çıkışı başarısız olsa da yerel oturum kapanır (`IdentityService.logout`);
  /// kapanış faz makinesiyle giriş ekranına döner.
  LogoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutControllerHash();

  @$internal
  @override
  LogoutController create() => LogoutController();
}

String _$logoutControllerHash() => r'bc7b3f66dec6da2833952ecb4890e00ac190e6c8';

/// Çıkış durumu. Sunucu çıkışı başarısız olsa da yerel oturum kapanır (`IdentityService.logout`);
/// kapanış faz makinesiyle giriş ekranına döner.

abstract class _$LogoutController extends $AsyncNotifier<void> {
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
