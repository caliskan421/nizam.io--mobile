// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mesajlar kutusu ve sohbet komutları. Örnek kaynakta değişiklikler bellekte kalır (sunucuya
/// yazılmaz); liste ve sohbet ekranı aynı durumu okur.

@ProviderFor(ChatsController)
final chatsControllerProvider = ChatsControllerProvider._();

/// Mesajlar kutusu ve sohbet komutları. Örnek kaynakta değişiklikler bellekte kalır (sunucuya
/// yazılmaz); liste ve sohbet ekranı aynı durumu okur.
final class ChatsControllerProvider
    extends $AsyncNotifierProvider<ChatsController, ChatInbox> {
  /// Mesajlar kutusu ve sohbet komutları. Örnek kaynakta değişiklikler bellekte kalır (sunucuya
  /// yazılmaz); liste ve sohbet ekranı aynı durumu okur.
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

String _$chatsControllerHash() => r'9803a07ccf0202f4e6c07c0e0f6346e2ebebd533';

/// Mesajlar kutusu ve sohbet komutları. Örnek kaynakta değişiklikler bellekte kalır (sunucuya
/// yazılmaz); liste ve sohbet ekranı aynı durumu okur.

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
