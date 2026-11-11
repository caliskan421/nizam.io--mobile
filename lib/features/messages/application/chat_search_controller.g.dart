// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
/// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
/// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).

@ProviderFor(ChatSearchController)
final chatSearchControllerProvider = ChatSearchControllerFamily._();

/// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
/// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
/// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).
final class ChatSearchControllerProvider
    extends $NotifierProvider<ChatSearchController, ChatSearchState> {
  /// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
  /// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
  /// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).
  ChatSearchControllerProvider._({
    required ChatSearchControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatSearchControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatSearchControllerHash();

  @override
  String toString() {
    return r'chatSearchControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatSearchController create() => ChatSearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSearchState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatSearchControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatSearchControllerHash() =>
    r'a81371ebc0e7b50aceba4b0b18bdbdbde3254d0e';

/// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
/// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
/// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).

final class ChatSearchControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatSearchController,
          ChatSearchState,
          ChatSearchState,
          ChatSearchState,
          String
        > {
  ChatSearchControllerFamily._()
    : super(
        retry: null,
        name: r'chatSearchControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
  /// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
  /// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).

  ChatSearchControllerProvider call(String chatId) =>
      ChatSearchControllerProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatSearchControllerProvider';
}

/// Sohbet içi arama (`listChatMessages?q=`, §10.10): sonuç en yeniden eskiye sayfa, sonraki sayfa
/// `before=<en küçük seq>`. Sorgu en çok [maxQuery] karakter; Türkçe katlama sunucuda yok
/// (GAP-213). Sonuçtan mesaja `around` ile gidilir (ekran [ChatRoomController.reveal]).

abstract class _$ChatSearchController extends $Notifier<ChatSearchState> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  ChatSearchState build(String chatId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatSearchState, ChatSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatSearchState, ChatSearchState>,
              ChatSearchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
