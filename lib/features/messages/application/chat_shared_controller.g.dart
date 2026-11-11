// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_shared_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.

@ProviderFor(ChatSharedController)
final chatSharedControllerProvider = ChatSharedControllerFamily._();

/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.
final class ChatSharedControllerProvider
    extends $AsyncNotifierProvider<ChatSharedController, ChatSharedState> {
  /// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
  /// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
  /// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.
  ChatSharedControllerProvider._({
    required ChatSharedControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatSharedControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatSharedControllerHash();

  @override
  String toString() {
    return r'chatSharedControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatSharedController create() => ChatSharedController();

  @override
  bool operator ==(Object other) {
    return other is ChatSharedControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatSharedControllerHash() =>
    r'e980c5af00894335b7258ec56bd93d5a631bab2c';

/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.

final class ChatSharedControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatSharedController,
          AsyncValue<ChatSharedState>,
          ChatSharedState,
          FutureOr<ChatSharedState>,
          String
        > {
  ChatSharedControllerFamily._()
    : super(
        retry: null,
        name: r'chatSharedControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
  /// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
  /// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.

  ChatSharedControllerProvider call(String chatId) =>
      ChatSharedControllerProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatSharedControllerProvider';
}

/// Paylaşılanlar (`listChatRefs`, en yeniden eskiye, imleçli; §10.8). Satır statiktir; kart
/// [chatRefCardProvider] ile okunur. Biçimi geçerli ama bilinmeyen imleç (ör. imlecin mesajı
/// sayfalar arasında silindi) boş sayfa ve null imleç döner: liste baştan okunur.

abstract class _$ChatSharedController extends $AsyncNotifier<ChatSharedState> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  FutureOr<ChatSharedState> build(String chatId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatSharedState>, ChatSharedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatSharedState>, ChatSharedState>,
              AsyncValue<ChatSharedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
/// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).

@ProviderFor(chatRefCard)
final chatRefCardProvider = ChatRefCardFamily._();

/// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
/// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).

final class ChatRefCardProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChatRefCard>,
          ChatRefCard,
          FutureOr<ChatRefCard>
        >
    with $FutureModifier<ChatRefCard>, $FutureProvider<ChatRefCard> {
  /// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
  /// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).
  ChatRefCardProvider._({
    required ChatRefCardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRefCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRefCardHash();

  @override
  String toString() {
    return r'chatRefCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ChatRefCard> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChatRefCard> create(Ref ref) {
    final argument = this.argument as String;
    return chatRefCard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRefCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRefCardHash() => r'82d1501d4132153cda7d1ef3cb743c666ab159ce';

/// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
/// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).

final class ChatRefCardFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ChatRefCard>, String> {
  ChatRefCardFamily._()
    : super(
        retry: null,
        name: r'chatRefCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Referans kartı (`getChatRefSummary`): ekran açıkken önbellekte, sohbet yeniden açılınca
  /// yeniden okunur. 404 `ref_not_found` hata olarak döner (mesaj silinmiş ya da sohbette değilim).

  ChatRefCardProvider call(String refId) =>
      ChatRefCardProvider._(argument: refId, from: this);

  @override
  String toString() => r'chatRefCardProvider';
}
