// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_index_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Takvim kaynakları (sezon, toplantı, talep, tablo kaydı); yeniden yükleme yalnız dokunuşla.

@ProviderFor(calendarSources)
final calendarSourcesProvider = CalendarSourcesProvider._();

/// Takvim kaynakları (sezon, toplantı, talep, tablo kaydı); yeniden yükleme yalnız dokunuşla.

final class CalendarSourcesProvider
    extends
        $FunctionalProvider<
          AsyncValue<CalendarSources>,
          CalendarSources,
          FutureOr<CalendarSources>
        >
    with $FutureModifier<CalendarSources>, $FutureProvider<CalendarSources> {
  /// Takvim kaynakları (sezon, toplantı, talep, tablo kaydı); yeniden yükleme yalnız dokunuşla.
  CalendarSourcesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarSourcesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarSourcesHash();

  @$internal
  @override
  $FutureProviderElement<CalendarSources> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CalendarSources> create(Ref ref) {
    return calendarSources(ref);
  }
}

String _$calendarSourcesHash() => r'7271439c8f130a4d5a5d09894c4d3e884b314996';

/// Günlere dağıtılmış kayıtlar: kaynaklar + görevler sayfasının okuduğu aynı görev kataloğu
/// (katalog değişince — yeni/silinen görev — takvim de güncellenir).

@ProviderFor(calendarIndex)
final calendarIndexProvider = CalendarIndexProvider._();

/// Günlere dağıtılmış kayıtlar: kaynaklar + görevler sayfasının okuduğu aynı görev kataloğu
/// (katalog değişince — yeni/silinen görev — takvim de güncellenir).

final class CalendarIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<CalendarIndex>,
          CalendarIndex,
          FutureOr<CalendarIndex>
        >
    with $FutureModifier<CalendarIndex>, $FutureProvider<CalendarIndex> {
  /// Günlere dağıtılmış kayıtlar: kaynaklar + görevler sayfasının okuduğu aynı görev kataloğu
  /// (katalog değişince — yeni/silinen görev — takvim de güncellenir).
  CalendarIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarIndexHash();

  @$internal
  @override
  $FutureProviderElement<CalendarIndex> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CalendarIndex> create(Ref ref) {
    return calendarIndex(ref);
  }
}

String _$calendarIndexHash() => r'e03bea91615de5f1c70722fbfc6602a6298a7242';
