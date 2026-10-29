// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Takvim komutları (prototip `S_cal`). Durum ekrandan uzun yaşar (modül değişiminde ve
/// yeniden boyutlanmada seçili gün, ay ve kip korunur).

@ProviderFor(CalendarController)
final calendarControllerProvider = CalendarControllerProvider._();

/// Takvim komutları (prototip `S_cal`). Durum ekrandan uzun yaşar (modül değişiminde ve
/// yeniden boyutlanmada seçili gün, ay ve kip korunur).
final class CalendarControllerProvider
    extends $NotifierProvider<CalendarController, CalendarViewState> {
  /// Takvim komutları (prototip `S_cal`). Durum ekrandan uzun yaşar (modül değişiminde ve
  /// yeniden boyutlanmada seçili gün, ay ve kip korunur).
  CalendarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarControllerHash();

  @$internal
  @override
  CalendarController create() => CalendarController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarViewState>(value),
    );
  }
}

String _$calendarControllerHash() =>
    r'4f2aee98634400c03065714c4e7942717debb05c';

/// Takvim komutları (prototip `S_cal`). Durum ekrandan uzun yaşar (modül değişiminde ve
/// yeniden boyutlanmada seçili gün, ay ve kip korunur).

abstract class _$CalendarController extends $Notifier<CalendarViewState> {
  CalendarViewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CalendarViewState, CalendarViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalendarViewState, CalendarViewState>,
              CalendarViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
