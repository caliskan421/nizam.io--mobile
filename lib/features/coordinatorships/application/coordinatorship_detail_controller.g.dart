// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel sekmesinden başlar).

@ProviderFor(CoordinatorshipDetailController)
final coordinatorshipDetailControllerProvider =
    CoordinatorshipDetailControllerFamily._();

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel sekmesinden başlar).
final class CoordinatorshipDetailControllerProvider
    extends
        $NotifierProvider<
          CoordinatorshipDetailController,
          CoordinatorshipDetailView
        > {
  /// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
  /// Genel sekmesinden başlar).
  CoordinatorshipDetailControllerProvider._({
    required CoordinatorshipDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipDetailControllerHash();

  @override
  String toString() {
    return r'coordinatorshipDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CoordinatorshipDetailController create() => CoordinatorshipDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipDetailView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipDetailView>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipDetailControllerHash() =>
    r'30f7620cda8683e56ac3fb75e4019ef8bd403e47';

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel sekmesinden başlar).

final class CoordinatorshipDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CoordinatorshipDetailController,
          CoordinatorshipDetailView,
          CoordinatorshipDetailView,
          CoordinatorshipDetailView,
          String
        > {
  CoordinatorshipDetailControllerFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
  /// Genel sekmesinden başlar).

  CoordinatorshipDetailControllerProvider call(String code) =>
      CoordinatorshipDetailControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipDetailControllerProvider';
}

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel sekmesinden başlar).

abstract class _$CoordinatorshipDetailController
    extends $Notifier<CoordinatorshipDetailView> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  CoordinatorshipDetailView build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CoordinatorshipDetailView, CoordinatorshipDetailView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoordinatorshipDetailView, CoordinatorshipDetailView>,
              CoordinatorshipDetailView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.

@ProviderFor(coordinatorshipDetail)
final coordinatorshipDetailProvider = CoordinatorshipDetailFamily._();

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.

final class CoordinatorshipDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoordinatorshipDetail?>,
          CoordinatorshipDetail?,
          FutureOr<CoordinatorshipDetail?>
        >
    with
        $FutureModifier<CoordinatorshipDetail?>,
        $FutureProvider<CoordinatorshipDetail?> {
  /// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
  CoordinatorshipDetailProvider._({
    required CoordinatorshipDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipDetailHash();

  @override
  String toString() {
    return r'coordinatorshipDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CoordinatorshipDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CoordinatorshipDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return coordinatorshipDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipDetailHash() =>
    r'0da2d9ab9a0a8ab0d163cb95e5802a3ae90ec1e1';

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.

final class CoordinatorshipDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CoordinatorshipDetail?>, String> {
  CoordinatorshipDetailFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.

  CoordinatorshipDetailProvider call(String code) =>
      CoordinatorshipDetailProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipDetailProvider';
}
