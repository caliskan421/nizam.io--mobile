// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).

@ProviderFor(MeetingDetailViewController)
final meetingDetailViewControllerProvider =
    MeetingDetailViewControllerFamily._();

/// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).
final class MeetingDetailViewControllerProvider
    extends $NotifierProvider<MeetingDetailViewController, MeetingDetailView> {
  /// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).
  MeetingDetailViewControllerProvider._({
    required MeetingDetailViewControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'meetingDetailViewControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$meetingDetailViewControllerHash();

  @override
  String toString() {
    return r'meetingDetailViewControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MeetingDetailViewController create() => MeetingDetailViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingDetailView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingDetailView>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MeetingDetailViewControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$meetingDetailViewControllerHash() =>
    r'63f5209b0002ac07e6bb7377c8ba89709c23a6e9';

/// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).

final class MeetingDetailViewControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MeetingDetailViewController,
          MeetingDetailView,
          MeetingDetailView,
          MeetingDetailView,
          String
        > {
  MeetingDetailViewControllerFamily._()
    : super(
        retry: null,
        name: r'meetingDetailViewControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).

  MeetingDetailViewControllerProvider call(String id) =>
      MeetingDetailViewControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'meetingDetailViewControllerProvider';
}

/// Toplantı başına görünüm durumu (başka toplantıya geçince Gündem'den başlar).

abstract class _$MeetingDetailViewController
    extends $Notifier<MeetingDetailView> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  MeetingDetailView build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MeetingDetailView, MeetingDetailView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeetingDetailView, MeetingDetailView>,
              MeetingDetailView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
/// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.

@ProviderFor(MeetingRoomController)
final meetingRoomControllerProvider = MeetingRoomControllerFamily._();

/// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
/// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.
final class MeetingRoomControllerProvider
    extends $AsyncNotifierProvider<MeetingRoomController, MeetingRoom> {
  /// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
  /// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.
  MeetingRoomControllerProvider._({
    required MeetingRoomControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'meetingRoomControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$meetingRoomControllerHash();

  @override
  String toString() {
    return r'meetingRoomControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MeetingRoomController create() => MeetingRoomController();

  @override
  bool operator ==(Object other) {
    return other is MeetingRoomControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$meetingRoomControllerHash() =>
    r'8c15442aa2326d7e39691b7c6f304f960f5dba0c';

/// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
/// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.

final class MeetingRoomControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MeetingRoomController,
          AsyncValue<MeetingRoom>,
          MeetingRoom,
          FutureOr<MeetingRoom>,
          String
        > {
  MeetingRoomControllerFamily._()
    : super(
        retry: null,
        name: r'meetingRoomControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
  /// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.

  MeetingRoomControllerProvider call(String id) =>
      MeetingRoomControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'meetingRoomControllerProvider';
}

/// Toplantı ayrıntısı ve yazmaları. Komutlar sunucu yanıtıyla durumu günceller ve hata kodunu
/// döner (null → başarı); gündem işareti ve silmeler iyimserdir, hatada geri alınır.

abstract class _$MeetingRoomController extends $AsyncNotifier<MeetingRoom> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<MeetingRoom> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MeetingRoom>, MeetingRoom>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MeetingRoom>, MeetingRoom>,
              AsyncValue<MeetingRoom>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
