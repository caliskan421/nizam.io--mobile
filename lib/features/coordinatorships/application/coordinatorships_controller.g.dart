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

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi.

@ProviderFor(coordinatorshipList)
final coordinatorshipListProvider = CoordinatorshipListProvider._();

/// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi.

final class CoordinatorshipListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoordinatorshipStats>>,
          List<CoordinatorshipStats>,
          FutureOr<List<CoordinatorshipStats>>
        >
    with
        $FutureModifier<List<CoordinatorshipStats>>,
        $FutureProvider<List<CoordinatorshipStats>> {
  /// Görev kataloğundan türetilmiş, seçili ölçütle sıralı koordinatörlük listesi.
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
  $FutureProviderElement<List<CoordinatorshipStats>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoordinatorshipStats>> create(Ref ref) {
    return coordinatorshipList(ref);
  }
}

String _$coordinatorshipListHash() =>
    r'63f8d271d099b094ec3e25a0abad2754587defe7';
