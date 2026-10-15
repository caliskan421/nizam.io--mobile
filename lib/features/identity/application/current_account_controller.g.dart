// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Oturumdaki hesap (`GET /v1/me`); profil ekranı okur. Yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

@ProviderFor(CurrentAccountController)
final currentAccountControllerProvider = CurrentAccountControllerProvider._();

/// Oturumdaki hesap (`GET /v1/me`); profil ekranı okur. Yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
final class CurrentAccountControllerProvider
    extends $AsyncNotifierProvider<CurrentAccountController, CurrentAccount> {
  /// Oturumdaki hesap (`GET /v1/me`); profil ekranı okur. Yeniden yükleme yalnız kullanıcı
  /// dokunuşuyla (`ref.invalidate`).
  CurrentAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAccountControllerHash();

  @$internal
  @override
  CurrentAccountController create() => CurrentAccountController();
}

String _$currentAccountControllerHash() =>
    r'60468905c028aeb1e74c5f30d5f658a31c4dc976';

/// Oturumdaki hesap (`GET /v1/me`); profil ekranı okur. Yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

abstract class _$CurrentAccountController
    extends $AsyncNotifier<CurrentAccount> {
  FutureOr<CurrentAccount> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CurrentAccount>, CurrentAccount>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CurrentAccount>, CurrentAccount>,
              AsyncValue<CurrentAccount>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
