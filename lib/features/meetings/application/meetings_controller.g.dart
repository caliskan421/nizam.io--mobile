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
    r'a084be8780ee79fc920fe98397a7e49d7a8edb14';

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
/// silme de bu yoldadır): `/v1/meetings/deleted` istemci kapısında `/v1/meetings/{id}` ile
/// belirsiz eşleşir ve fail-closed reddedilir. İkisi de imleçli; en çok [maxPages] × [pageSize]
/// satır okunur. Seçili program değişince yeniden yüklenir.

@ProviderFor(MeetingsBoardController)
final meetingsBoardControllerProvider = MeetingsBoardControllerProvider._();

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır): `/v1/meetings/deleted` istemci kapısında `/v1/meetings/{id}` ile
/// belirsiz eşleşir ve fail-closed reddedilir. İkisi de imleçli; en çok [maxPages] × [pageSize]
/// satır okunur. Seçili program değişince yeniden yüklenir.
final class MeetingsBoardControllerProvider
    extends $AsyncNotifierProvider<MeetingsBoardController, MeetingsBoard> {
  /// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
  /// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
  /// silme de bu yoldadır): `/v1/meetings/deleted` istemci kapısında `/v1/meetings/{id}` ile
  /// belirsiz eşleşir ve fail-closed reddedilir. İkisi de imleçli; en çok [maxPages] × [pageSize]
  /// satır okunur. Seçili program değişince yeniden yüklenir.
  MeetingsBoardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingsBoardControllerProvider',
        isAutoDispose: true,
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
    r'e5e8353a1a94dcdb5061120d2f3bd3600448c660';

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır): `/v1/meetings/deleted` istemci kapısında `/v1/meetings/{id}` ile
/// belirsiz eşleşir ve fail-closed reddedilir. İkisi de imleçli; en çok [maxPages] × [pageSize]
/// satır okunur. Seçili program değişince yeniden yüklenir.

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
