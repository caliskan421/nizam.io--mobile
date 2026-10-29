// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horizontal_timeline_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Yatay (tablet) zaman çizelgesinin ekran durumu ve komutları (prototip `S_hgantt.state`:
/// ölçek, durum süzgeci, koordinatörlük seçimi, kapalı gruplar, seçili görev). Prototipte bileşen
/// sayfa kapanınca yaşamaya devam eder; bu yüzden sağlayıcı canlı tutulur (`keepAlive`) ve sayfa
/// kapatılıp yeniden açılınca durum korunur. Kaydırma ve ortalama isteği sayfa içinde kalır.

@ProviderFor(HorizontalTimelineController)
final horizontalTimelineControllerProvider =
    HorizontalTimelineControllerProvider._();

/// Yatay (tablet) zaman çizelgesinin ekran durumu ve komutları (prototip `S_hgantt.state`:
/// ölçek, durum süzgeci, koordinatörlük seçimi, kapalı gruplar, seçili görev). Prototipte bileşen
/// sayfa kapanınca yaşamaya devam eder; bu yüzden sağlayıcı canlı tutulur (`keepAlive`) ve sayfa
/// kapatılıp yeniden açılınca durum korunur. Kaydırma ve ortalama isteği sayfa içinde kalır.
final class HorizontalTimelineControllerProvider
    extends $NotifierProvider<HorizontalTimelineController, GanttState> {
  /// Yatay (tablet) zaman çizelgesinin ekran durumu ve komutları (prototip `S_hgantt.state`:
  /// ölçek, durum süzgeci, koordinatörlük seçimi, kapalı gruplar, seçili görev). Prototipte bileşen
  /// sayfa kapanınca yaşamaya devam eder; bu yüzden sağlayıcı canlı tutulur (`keepAlive`) ve sayfa
  /// kapatılıp yeniden açılınca durum korunur. Kaydırma ve ortalama isteği sayfa içinde kalır.
  HorizontalTimelineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'horizontalTimelineControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$horizontalTimelineControllerHash();

  @$internal
  @override
  HorizontalTimelineController create() => HorizontalTimelineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GanttState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GanttState>(value),
    );
  }
}

String _$horizontalTimelineControllerHash() =>
    r'2d63d50b760f19fa950d7cb661769395bb5820e4';

/// Yatay (tablet) zaman çizelgesinin ekran durumu ve komutları (prototip `S_hgantt.state`:
/// ölçek, durum süzgeci, koordinatörlük seçimi, kapalı gruplar, seçili görev). Prototipte bileşen
/// sayfa kapanınca yaşamaya devam eder; bu yüzden sağlayıcı canlı tutulur (`keepAlive`) ve sayfa
/// kapatılıp yeniden açılınca durum korunur. Kaydırma ve ortalama isteği sayfa içinde kalır.

abstract class _$HorizontalTimelineController extends $Notifier<GanttState> {
  GanttState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GanttState, GanttState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GanttState, GanttState>,
              GanttState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
