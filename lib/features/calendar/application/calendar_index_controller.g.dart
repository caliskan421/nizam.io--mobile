// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_index_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez).

@ProviderFor(calendarIndex)
final calendarIndexProvider = CalendarIndexProvider._();

/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez).

final class CalendarIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<CalendarIndex>,
          CalendarIndex,
          FutureOr<CalendarIndex>
        >
    with $FutureModifier<CalendarIndex>, $FutureProvider<CalendarIndex> {
  /// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
  /// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
  /// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
  /// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
  /// durumundadır (kısmi veriyle devam etmez).
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

String _$calendarIndexHash() => r'cfe1aae3b5a97c26448cc466e983f902b210b62e';
