// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerFamily._();

/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).
final class ChatControllerProvider
    extends $NotifierProvider<ChatController, ChatViewState> {
  /// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).
  ChatControllerProvider._({
    required ChatControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @override
  String toString() {
    return r'chatControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatControllerHash() => r'579e63a43374dbdf5e9de25f661cf1063e119242';

/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).

final class ChatControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatController,
          ChatViewState,
          ChatViewState,
          ChatViewState,
          String
        > {
  ChatControllerFamily._()
    : super(
        retry: null,
        name: r'chatControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).

  ChatControllerProvider call(String id) =>
      ChatControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'chatControllerProvider';
}

/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).

abstract class _$ChatController extends $Notifier<ChatViewState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  ChatViewState build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatViewState, ChatViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatViewState, ChatViewState>,
              ChatViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
