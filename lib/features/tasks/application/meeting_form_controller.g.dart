// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'ea09eeb6e225b16014b4b7dec694ceae35716b9c';

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
