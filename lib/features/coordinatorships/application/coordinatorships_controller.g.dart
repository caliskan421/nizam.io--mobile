// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorships_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Koordinatörlük listesinin sıralama ölçütü (kısayol menüsünden değişir; sayfalar arası
/// korunur).

@ProviderFor(CoordinatorshipsController)
final coordinatorshipsControllerProvider =
    CoordinatorshipsControllerProvider._();

/// Koordinatörlük listesinin sıralama ölçütü (kısayol menüsünden değişir; sayfalar arası
/// korunur).
final class CoordinatorshipsControllerProvider
    extends $NotifierProvider<CoordinatorshipsController, CoordinatorshipSort> {
  /// Koordinatörlük listesinin sıralama ölçütü (kısayol menüsünden değişir; sayfalar arası
  /// korunur).
  CoordinatorshipsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipsControllerHash();

  @$internal
  @override
  CoordinatorshipsController create() => CoordinatorshipsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipSort>(value),
    );
  }
}

String _$coordinatorshipsControllerHash() =>
    r'355d48eff14c9a86f834a4d246a4f3dbda15f2e1';

/// Koordinatörlük listesinin sıralama ölçütü (kısayol menüsünden değişir; sayfalar arası
/// korunur).

abstract class _$CoordinatorshipsController
    extends $Notifier<CoordinatorshipSort> {
  CoordinatorshipSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CoordinatorshipSort, CoordinatorshipSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoordinatorshipSort, CoordinatorshipSort>,
              CoordinatorshipSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi. Eşzamanlı
/// türetilir: katalog (keepAlive) hazırsa sayfanın ilk karesi doludur (yükleme titremesi yok).

@ProviderFor(coordinatorshipList)
final coordinatorshipListProvider = CoordinatorshipListProvider._();

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi. Eşzamanlı
/// türetilir: katalog (keepAlive) hazırsa sayfanın ilk karesi doludur (yükleme titremesi yok).

final class CoordinatorshipListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoordinatorshipStats>>,
          AsyncValue<List<CoordinatorshipStats>>,
          AsyncValue<List<CoordinatorshipStats>>
        >
    with $Provider<AsyncValue<List<CoordinatorshipStats>>> {
  /// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi. Eşzamanlı
  /// türetilir: katalog (keepAlive) hazırsa sayfanın ilk karesi doludur (yükleme titremesi yok).
  CoordinatorshipListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipListHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<CoordinatorshipStats>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<CoordinatorshipStats>> create(Ref ref) {
    return coordinatorshipList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<CoordinatorshipStats>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<CoordinatorshipStats>>>(value),
    );
  }
}

String _$coordinatorshipListHash() =>
    r'14f48aab01cc2bedf1f193b249d40f81194a3c2a';
