// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_query_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).

@ProviderFor(CoordinatorshipQueryController)
final coordinatorshipQueryControllerProvider =
    CoordinatorshipQueryControllerProvider._();

/// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).
final class CoordinatorshipQueryControllerProvider
    extends
        $NotifierProvider<
          CoordinatorshipQueryController,
          CoordinatorshipQuery
        > {
  /// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).
  CoordinatorshipQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipQueryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipQueryControllerHash();

  @$internal
  @override
  CoordinatorshipQueryController create() => CoordinatorshipQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipQuery>(value),
    );
  }
}

String _$coordinatorshipQueryControllerHash() =>
    r'dc30d4c91825afb111d23b4e7a6b6508aad87e67';

/// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).

abstract class _$CoordinatorshipQueryController
    extends $Notifier<CoordinatorshipQuery> {
  CoordinatorshipQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CoordinatorshipQuery, CoordinatorshipQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoordinatorshipQuery, CoordinatorshipQuery>,
              CoordinatorshipQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
