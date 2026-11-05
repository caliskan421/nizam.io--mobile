// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope_selection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kapsam seçimi eylemleri. Seçimin sonucu durum değildir: `scopeStateProvider` değişir, faz
/// makinesi (`sessionOpen` ↔ `scoped`) ekranı yönlendirir; durum yalnız eylemin hatasıdır.

@ProviderFor(ScopeSelectionController)
final scopeSelectionControllerProvider = ScopeSelectionControllerProvider._();

/// Kapsam seçimi eylemleri. Seçimin sonucu durum değildir: `scopeStateProvider` değişir, faz
/// makinesi (`sessionOpen` ↔ `scoped`) ekranı yönlendirir; durum yalnız eylemin hatasıdır.
final class ScopeSelectionControllerProvider
    extends $AsyncNotifierProvider<ScopeSelectionController, void> {
  /// Kapsam seçimi eylemleri. Seçimin sonucu durum değildir: `scopeStateProvider` değişir, faz
  /// makinesi (`sessionOpen` ↔ `scoped`) ekranı yönlendirir; durum yalnız eylemin hatasıdır.
  ScopeSelectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopeSelectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopeSelectionControllerHash();

  @$internal
  @override
  ScopeSelectionController create() => ScopeSelectionController();
}

String _$scopeSelectionControllerHash() =>
    r'49e22bdf781d662123b66283d1101e298b0fe7a3';

/// Kapsam seçimi eylemleri. Seçimin sonucu durum değildir: `scopeStateProvider` değişir, faz
/// makinesi (`sessionOpen` ↔ `scoped`) ekranı yönlendirir; durum yalnız eylemin hatasıdır.

abstract class _$ScopeSelectionController extends $AsyncNotifier<void> {
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
