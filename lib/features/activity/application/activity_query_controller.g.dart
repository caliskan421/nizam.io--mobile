// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_query_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner.

@ProviderFor(ActivityQueryController)
final activityQueryControllerProvider = ActivityQueryControllerProvider._();

/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner.
final class ActivityQueryControllerProvider
    extends $NotifierProvider<ActivityQueryController, ActivityQuery> {
  /// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
  /// Süzgeç değişince gösterilen sınır ilk sayfaya döner.
  ActivityQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityQueryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityQueryControllerHash();

  @$internal
  @override
  ActivityQueryController create() => ActivityQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityQuery>(value),
    );
  }
}

String _$activityQueryControllerHash() =>
    r'72329657aa01ee284a5505162cd552cc85866e91';

/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner.

abstract class _$ActivityQueryController extends $Notifier<ActivityQuery> {
  ActivityQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActivityQuery, ActivityQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityQuery, ActivityQuery>,
              ActivityQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).

@ProviderFor(activityView)
final activityViewProvider = ActivityViewProvider._();

/// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).

final class ActivityViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityView>,
          ActivityView,
          FutureOr<ActivityView>
        >
    with $FutureModifier<ActivityView>, $FutureProvider<ActivityView> {
  /// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).
  ActivityViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityViewHash();

  @$internal
  @override
  $FutureProviderElement<ActivityView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActivityView> create(Ref ref) {
    return activityView(ref);
  }
}

String _$activityViewHash() => r'80e857e25d7963f1da974185b794fbe35147969e';
