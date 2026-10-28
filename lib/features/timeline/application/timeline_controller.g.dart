// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
/// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.

@ProviderFor(TimelineController)
final timelineControllerProvider = TimelineControllerFamily._();

/// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
/// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.
final class TimelineControllerProvider
    extends $NotifierProvider<TimelineController, TimelineState> {
  /// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
  /// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
  /// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.
  TimelineControllerProvider._({
    required TimelineControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'timelineControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$timelineControllerHash();

  @override
  String toString() {
    return r'timelineControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TimelineController create() => TimelineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimelineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimelineState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timelineControllerHash() =>
    r'4f5feecf325cc5de57cdcc54907f6f2cd97fa954';

/// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
/// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.

final class TimelineControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TimelineController,
          TimelineState,
          TimelineState,
          TimelineState,
          String?
        > {
  TimelineControllerFamily._()
    : super(
        retry: null,
        name: r'timelineControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
  /// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
  /// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.

  TimelineControllerProvider call(String? coordinatorship) =>
      TimelineControllerProvider._(argument: coordinatorship, from: this);

  @override
  String toString() => r'timelineControllerProvider';
}

/// Zaman çizelgesi ekranının durumu ve komutları (prototip `S_gantt`). Seçim, ölçek, süzgeçler,
/// tarih taslağı, kayıt/geri alma ve tarih talepleri bellekte tutulur (sunucuya yazılmaz).
/// [coordinatorship] verilirse yalnız o koordinatörlük seçili açılır; verilmezse kataloğun ilki.

abstract class _$TimelineController extends $Notifier<TimelineState> {
  late final _$args = ref.$arg as String?;
  String? get coordinatorship => _$args;

  TimelineState build(String? coordinatorship);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TimelineState, TimelineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimelineState, TimelineState>,
              TimelineState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.

@ProviderFor(timelineView)
final timelineViewProvider = TimelineViewFamily._();

/// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.

final class TimelineViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TimelineView>,
          AsyncValue<TimelineView>,
          AsyncValue<TimelineView>
        >
    with $Provider<AsyncValue<TimelineView>> {
  /// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.
  TimelineViewProvider._({
    required TimelineViewFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'timelineViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$timelineViewHash();

  @override
  String toString() {
    return r'timelineViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<TimelineView>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TimelineView> create(Ref ref) {
    final argument = this.argument as String?;
    return timelineView(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TimelineView> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TimelineView>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timelineViewHash() => r'207d4c4ceb272041ea1eb22f3c97795e08ac8da9';

/// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.

final class TimelineViewFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<TimelineView>, String?> {
  TimelineViewFamily._()
    : super(
        retry: null,
        name: r'timelineViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ekranın türetilmiş görünümü: görev kataloğu + ekran durumu.

  TimelineViewProvider call(String? coordinatorship) =>
      TimelineViewProvider._(argument: coordinatorship, from: this);

  @override
  String toString() => r'timelineViewProvider';
}
