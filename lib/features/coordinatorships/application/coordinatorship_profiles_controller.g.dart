// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_profiles_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Departman kayıtları (tür, açıklama). Yalnız ayrıntı ekranı izler ve yalnız şirket
/// yöneticisinde (`coordinatorshipDetail`); liste ekranı istek atmaz.

@ProviderFor(CoordinatorshipProfilesController)
final coordinatorshipProfilesControllerProvider =
    CoordinatorshipProfilesControllerProvider._();

/// Departman kayıtları (tür, açıklama). Yalnız ayrıntı ekranı izler ve yalnız şirket
/// yöneticisinde (`coordinatorshipDetail`); liste ekranı istek atmaz.
final class CoordinatorshipProfilesControllerProvider
    extends
        $AsyncNotifierProvider<
          CoordinatorshipProfilesController,
          List<Department>
        > {
  /// Departman kayıtları (tür, açıklama). Yalnız ayrıntı ekranı izler ve yalnız şirket
  /// yöneticisinde (`coordinatorshipDetail`); liste ekranı istek atmaz.
  CoordinatorshipProfilesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipProfilesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$coordinatorshipProfilesControllerHash();

  @$internal
  @override
  CoordinatorshipProfilesController create() =>
      CoordinatorshipProfilesController();
}

String _$coordinatorshipProfilesControllerHash() =>
    r'6e212577fafd6a1e1d4851d88c5f0269ed90f2b7';

/// Departman kayıtları (tür, açıklama). Yalnız ayrıntı ekranı izler ve yalnız şirket
/// yöneticisinde (`coordinatorshipDetail`); liste ekranı istek atmaz.

abstract class _$CoordinatorshipProfilesController
    extends $AsyncNotifier<List<Department>> {
  FutureOr<List<Department>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Department>>, List<Department>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Department>>, List<Department>>,
              AsyncValue<List<Department>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
