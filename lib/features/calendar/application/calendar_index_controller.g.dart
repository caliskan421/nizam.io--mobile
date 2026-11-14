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
/// durumundadır (kısmi veriyle devam etmez). Kaynaklardan biri kesikse (toplantı listesi ya da
/// katalog sayfa tavanında) dizin [CalendarIndex.truncated] taşır. Koordinatör ve Üye
/// görünümünde yalnız etkin koordinatörlüğün kayıtları ([calendarScope]); görev bitişleri
/// katalogdan türetilir (takvim ucu yok).

@ProviderFor(calendarIndex)
final calendarIndexProvider = CalendarIndexProvider._();

/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez). Kaynaklardan biri kesikse (toplantı listesi ya da
/// katalog sayfa tavanında) dizin [CalendarIndex.truncated] taşır. Koordinatör ve Üye
/// görünümünde yalnız etkin koordinatörlüğün kayıtları ([calendarScope]); görev bitişleri
/// katalogdan türetilir (takvim ucu yok).

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
  /// durumundadır (kısmi veriyle devam etmez). Kaynaklardan biri kesikse (toplantı listesi ya da
  /// katalog sayfa tavanında) dizin [CalendarIndex.truncated] taşır. Koordinatör ve Üye
  /// görünümünde yalnız etkin koordinatörlüğün kayıtları ([calendarScope]); görev bitişleri
  /// katalogdan türetilir (takvim ucu yok).
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

String _$calendarIndexHash() => r'ac9e3d27ebd3ae04c26cc0bb60d505dbce12c7d9';
