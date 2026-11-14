// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MeetingsViewController)
final meetingsViewControllerProvider = MeetingsViewControllerProvider._();

final class MeetingsViewControllerProvider
    extends $NotifierProvider<MeetingsViewController, MeetingsView> {
  MeetingsViewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingsViewControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingsViewControllerHash();

  @$internal
  @override
  MeetingsViewController create() => MeetingsViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingsView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingsView>(value),
    );
  }
}

String _$meetingsViewControllerHash() =>
    r'0662c71c7f0d96f15743679301712d7001b6ece7';

abstract class _$MeetingsViewController extends $Notifier<MeetingsView> {
  MeetingsView build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MeetingsView, MeetingsView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeetingsView, MeetingsView>,
              MeetingsView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır). İkisi de imleçli; en çok [maxPages] × [pageSize] satır okunur. Kart
/// sayaçları ve konferans durumu satır özetindedir (COLLABORATION-K70; kart başına istek yok).
/// Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka planda tazelenir
/// ([refreshIfStale]). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran [visible]
/// durumunu gösterir (başka hesabın/programın listesi görünmez).

@ProviderFor(MeetingsBoardController)
final meetingsBoardControllerProvider = MeetingsBoardControllerProvider._();

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır). İkisi de imleçli; en çok [maxPages] × [pageSize] satır okunur. Kart
/// sayaçları ve konferans durumu satır özetindedir (COLLABORATION-K70; kart başına istek yok).
/// Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka planda tazelenir
/// ([refreshIfStale]). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran [visible]
/// durumunu gösterir (başka hesabın/programın listesi görünmez).
final class MeetingsBoardControllerProvider
    extends $AsyncNotifierProvider<MeetingsBoardController, MeetingsBoard> {
  /// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
  /// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
  /// silme de bu yoldadır). İkisi de imleçli; en çok [maxPages] × [pageSize] satır okunur. Kart
  /// sayaçları ve konferans durumu satır özetindedir (COLLABORATION-K70; kart başına istek yok).
  /// Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka planda tazelenir
  /// ([refreshIfStale]). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran [visible]
  /// durumunu gösterir (başka hesabın/programın listesi görünmez).
  MeetingsBoardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingsBoardControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingsBoardControllerHash();

  @$internal
  @override
  MeetingsBoardController create() => MeetingsBoardController();
}

String _$meetingsBoardControllerHash() =>
    r'1ceac6ecf7597cca5fc2367976dd5e415465e178';

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır). İkisi de imleçli; en çok [maxPages] × [pageSize] satır okunur. Kart
/// sayaçları ve konferans durumu satır özetindedir (COLLABORATION-K70; kart başına istek yok).
/// Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka planda tazelenir
/// ([refreshIfStale]). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran [visible]
/// durumunu gösterir (başka hesabın/programın listesi görünmez).

abstract class _$MeetingsBoardController extends $AsyncNotifier<MeetingsBoard> {
  FutureOr<MeetingsBoard> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MeetingsBoard>, MeetingsBoard>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MeetingsBoard>, MeetingsBoard>,
              AsyncValue<MeetingsBoard>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
