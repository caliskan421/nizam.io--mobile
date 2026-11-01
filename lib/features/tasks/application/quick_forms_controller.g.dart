// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_forms_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Yeni görev formunun koordinatörlük seçenekleri: örnek katalogda hepsi; sunucu kataloğunda
/// yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
/// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).

@ProviderFor(newTaskCoordinatorships)
final newTaskCoordinatorshipsProvider = NewTaskCoordinatorshipsProvider._();

/// Yeni görev formunun koordinatörlük seçenekleri: örnek katalogda hepsi; sunucu kataloğunda
/// yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
/// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).

final class NewTaskCoordinatorshipsProvider
    extends
        $FunctionalProvider<
          List<CoordinatorshipRef>,
          List<CoordinatorshipRef>,
          List<CoordinatorshipRef>
        >
    with $Provider<List<CoordinatorshipRef>> {
  /// Yeni görev formunun koordinatörlük seçenekleri: örnek katalogda hepsi; sunucu kataloğunda
  /// yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
  /// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).
  NewTaskCoordinatorshipsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTaskCoordinatorshipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTaskCoordinatorshipsHash();

  @$internal
  @override
  $ProviderElement<List<CoordinatorshipRef>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CoordinatorshipRef> create(Ref ref) {
    return newTaskCoordinatorships(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CoordinatorshipRef> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CoordinatorshipRef>>(value),
    );
  }
}

String _$newTaskCoordinatorshipsHash() =>
    r'13b15bc62f307fc2353df2d0bd0b1465008ebb57';

@ProviderFor(NewTaskFormController)
final newTaskFormControllerProvider = NewTaskFormControllerProvider._();

final class NewTaskFormControllerProvider
    extends $NotifierProvider<NewTaskFormController, NewTaskForm> {
  NewTaskFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTaskFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTaskFormControllerHash();

  @$internal
  @override
  NewTaskFormController create() => NewTaskFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewTaskForm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewTaskForm>(value),
    );
  }
}

String _$newTaskFormControllerHash() =>
    r'0ffc096fababfc0adcedcbc084bb9aaf069d539a';

abstract class _$NewTaskFormController extends $Notifier<NewTaskForm> {
  NewTaskForm build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NewTaskForm, NewTaskForm>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewTaskForm, NewTaskForm>,
              NewTaskForm,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MeetingFormController)
final meetingFormControllerProvider = MeetingFormControllerProvider._();

final class MeetingFormControllerProvider
    extends $NotifierProvider<MeetingFormController, MeetingForm> {
  MeetingFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingFormControllerHash();

  @$internal
  @override
  MeetingFormController create() => MeetingFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingForm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingForm>(value),
    );
  }
}

String _$meetingFormControllerHash() =>
    r'53ffacdd9f681f8a057290381f9feb97b8340b9f';

abstract class _$MeetingFormController extends $Notifier<MeetingForm> {
  MeetingForm build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MeetingForm, MeetingForm>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeetingForm, MeetingForm>,
              MeetingForm,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(InviteFormController)
final inviteFormControllerProvider = InviteFormControllerProvider._();

final class InviteFormControllerProvider
    extends $NotifierProvider<InviteFormController, InviteForm> {
  InviteFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteFormControllerHash();

  @$internal
  @override
  InviteFormController create() => InviteFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InviteForm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InviteForm>(value),
    );
  }
}

String _$inviteFormControllerHash() =>
    r'0f97afdc6d3ee04b7a3ba1bf49598630c385f14a';

abstract class _$InviteFormController extends $Notifier<InviteForm> {
  InviteForm build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InviteForm, InviteForm>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InviteForm, InviteForm>,
              InviteForm,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
