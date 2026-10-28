// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_profiles_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Koordinatörlük ek bilgileri (üst birim, alt birimler, açıklama, son etkinlik).

@ProviderFor(CoordinatorshipProfilesController)
final coordinatorshipProfilesControllerProvider =
    CoordinatorshipProfilesControllerProvider._();

/// Koordinatörlük ek bilgileri (üst birim, alt birimler, açıklama, son etkinlik).
final class CoordinatorshipProfilesControllerProvider
    extends
        $AsyncNotifierProvider<
          CoordinatorshipProfilesController,
          List<CoordinatorshipProfile>
        > {
  /// Koordinatörlük ek bilgileri (üst birim, alt birimler, açıklama, son etkinlik).
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
    r'a72750d0bc117cdbf3e2b73970a3412352682c43';

/// Koordinatörlük ek bilgileri (üst birim, alt birimler, açıklama, son etkinlik).

abstract class _$CoordinatorshipProfilesController
    extends $AsyncNotifier<List<CoordinatorshipProfile>> {
  FutureOr<List<CoordinatorshipProfile>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CoordinatorshipProfile>>,
              List<CoordinatorshipProfile>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CoordinatorshipProfile>>,
                List<CoordinatorshipProfile>
              >,
              AsyncValue<List<CoordinatorshipProfile>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
