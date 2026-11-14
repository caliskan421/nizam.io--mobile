// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'0edef6dcfee3f32a34610811c82ca1d1be412fa7';

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
