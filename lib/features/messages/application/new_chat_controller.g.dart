// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
/// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
/// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.

@ProviderFor(NewChatController)
final newChatControllerProvider = NewChatControllerFamily._();

/// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
/// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
/// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.
final class NewChatControllerProvider
    extends $AsyncNotifierProvider<NewChatController, ChatCandidates> {
  /// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
  /// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
  /// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.
  NewChatControllerProvider._({
    required NewChatControllerFamily super.from,
    required ChatCandidatePurpose super.argument,
  }) : super(
         retry: null,
         name: r'newChatControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newChatControllerHash();

  @override
  String toString() {
    return r'newChatControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NewChatController create() => NewChatController();

  @override
  bool operator ==(Object other) {
    return other is NewChatControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newChatControllerHash() => r'9304aef367993aa08e6cb6c17d9234885a3a6c71';

/// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
/// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
/// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.

final class NewChatControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          NewChatController,
          AsyncValue<ChatCandidates>,
          ChatCandidates,
          FutureOr<ChatCandidates>,
          ChatCandidatePurpose
        > {
  NewChatControllerFamily._()
    : super(
        retry: null,
        name: r'newChatControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
  /// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
  /// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.

  NewChatControllerProvider call(ChatCandidatePurpose purpose) =>
      NewChatControllerProvider._(argument: purpose, from: this);

  @override
  String toString() => r'newChatControllerProvider';
}

/// Yeni sohbet: aday listesi (`purpose` zorunlu; §10.6), birebir açma ve grup kurma. Grup
/// kurma `Idempotency-Key` taşır: aynı taslak aynı anahtarla gider (sonucu bilinmeyen isteğin
/// tekrarı), taslak değişince yeni anahtar; `conflict_retry` aynı anahtarla bir kez tekrarlanır.

abstract class _$NewChatController extends $AsyncNotifier<ChatCandidates> {
  late final _$args = ref.$arg as ChatCandidatePurpose;
  ChatCandidatePurpose get purpose => _$args;

  FutureOr<ChatCandidates> build(ChatCandidatePurpose purpose);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatCandidates>, ChatCandidates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatCandidates>, ChatCandidates>,
              AsyncValue<ChatCandidates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
