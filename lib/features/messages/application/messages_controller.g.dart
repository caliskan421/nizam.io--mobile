// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessagesController)
final messagesControllerProvider = MessagesControllerProvider._();

final class MessagesControllerProvider
    extends $NotifierProvider<MessagesController, MessagesViewState> {
  MessagesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesControllerHash();

  @$internal
  @override
  MessagesController create() => MessagesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagesViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagesViewState>(value),
    );
  }
}

String _$messagesControllerHash() =>
    r'99cb9b35d0ef0416c962db68db8d18e0a436df30';

abstract class _$MessagesController extends $Notifier<MessagesViewState> {
  MessagesViewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MessagesViewState, MessagesViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessagesViewState, MessagesViewState>,
              MessagesViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
