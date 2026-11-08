// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
/// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
/// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz.

@ProviderFor(ChatsController)
final chatsControllerProvider = ChatsControllerProvider._();

/// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
/// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
/// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz.
final class ChatsControllerProvider
    extends $AsyncNotifierProvider<ChatsController, ChatInbox> {
  /// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
  /// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
  /// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz.
  ChatsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsControllerHash();

  @$internal
  @override
  ChatsController create() => ChatsController();
}

String _$chatsControllerHash() => r'4722b657224fdfc7dc3fad1f7913dc5dad4b4bd5';

/// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
/// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
/// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz.

abstract class _$ChatsController extends $AsyncNotifier<ChatInbox> {
  FutureOr<ChatInbox> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatInbox>, ChatInbox>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatInbox>, ChatInbox>,
              AsyncValue<ChatInbox>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
