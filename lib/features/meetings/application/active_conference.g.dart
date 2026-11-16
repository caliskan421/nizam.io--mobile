// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_conference.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveConferenceController)
final activeConferenceControllerProvider =
    ActiveConferenceControllerProvider._();

final class ActiveConferenceControllerProvider
    extends $NotifierProvider<ActiveConferenceController, ActiveConference> {
  ActiveConferenceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeConferenceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeConferenceControllerHash();

  @$internal
  @override
  ActiveConferenceController create() => ActiveConferenceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveConference value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveConference>(value),
    );
  }
}

String _$activeConferenceControllerHash() =>
    r'45c020be4d879f488df583b456428822c4aa9e8d';

abstract class _$ActiveConferenceController
    extends $Notifier<ActiveConference> {
  ActiveConference build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActiveConference, ActiveConference>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActiveConference, ActiveConference>,
              ActiveConference,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
