// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sohbet olay akışının (SSE `streamChatEvents`) TEK bağlantı döngüsü. Yalnız onu dinleyen bir
/// mesaj ekranı varken ve uygulama ön plandayken açıktır (dinleyen kalmayınca kapanır: hesap
/// başına 12 akış sınırı, gereksiz akış açılmaz). Açılan her bağlantı ve gelen her olay
/// [ChatSignalBus]'a yayılır; uzlaştırmayı tüketiciler yapar. Yeniden bağlanma §10.5: 0–5 sn
/// jitter + üstel geri çekilme, yetki/oturum hatasında durur (401'de belirteç yenilemesini
/// kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır). 429 `Retry-After`'ın
/// mutlak bitişi [ChatStreamHold]'dadır: arka plandan dönüş ve ekranın yeniden açılışı da o
/// ana kadar akış açmaz.

@ProviderFor(ChatSyncController)
final chatSyncControllerProvider = ChatSyncControllerProvider._();

/// Sohbet olay akışının (SSE `streamChatEvents`) TEK bağlantı döngüsü. Yalnız onu dinleyen bir
/// mesaj ekranı varken ve uygulama ön plandayken açıktır (dinleyen kalmayınca kapanır: hesap
/// başına 12 akış sınırı, gereksiz akış açılmaz). Açılan her bağlantı ve gelen her olay
/// [ChatSignalBus]'a yayılır; uzlaştırmayı tüketiciler yapar. Yeniden bağlanma §10.5: 0–5 sn
/// jitter + üstel geri çekilme, yetki/oturum hatasında durur (401'de belirteç yenilemesini
/// kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır). 429 `Retry-After`'ın
/// mutlak bitişi [ChatStreamHold]'dadır: arka plandan dönüş ve ekranın yeniden açılışı da o
/// ana kadar akış açmaz.
final class ChatSyncControllerProvider
    extends $NotifierProvider<ChatSyncController, ChatSyncStatus> {
  /// Sohbet olay akışının (SSE `streamChatEvents`) TEK bağlantı döngüsü. Yalnız onu dinleyen bir
  /// mesaj ekranı varken ve uygulama ön plandayken açıktır (dinleyen kalmayınca kapanır: hesap
  /// başına 12 akış sınırı, gereksiz akış açılmaz). Açılan her bağlantı ve gelen her olay
  /// [ChatSignalBus]'a yayılır; uzlaştırmayı tüketiciler yapar. Yeniden bağlanma §10.5: 0–5 sn
  /// jitter + üstel geri çekilme, yetki/oturum hatasında durur (401'de belirteç yenilemesini
  /// kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır). 429 `Retry-After`'ın
  /// mutlak bitişi [ChatStreamHold]'dadır: arka plandan dönüş ve ekranın yeniden açılışı da o
  /// ana kadar akış açmaz.
  ChatSyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSyncControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSyncControllerHash();

  @$internal
  @override
  ChatSyncController create() => ChatSyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSyncStatus>(value),
    );
  }
}

String _$chatSyncControllerHash() =>
    r'8c203247a865fb5d2ec42d2116a3a341efd2dffe';

/// Sohbet olay akışının (SSE `streamChatEvents`) TEK bağlantı döngüsü. Yalnız onu dinleyen bir
/// mesaj ekranı varken ve uygulama ön plandayken açıktır (dinleyen kalmayınca kapanır: hesap
/// başına 12 akış sınırı, gereksiz akış açılmaz). Açılan her bağlantı ve gelen her olay
/// [ChatSignalBus]'a yayılır; uzlaştırmayı tüketiciler yapar. Yeniden bağlanma §10.5: 0–5 sn
/// jitter + üstel geri çekilme, yetki/oturum hatasında durur (401'de belirteç yenilemesini
/// kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır). 429 `Retry-After`'ın
/// mutlak bitişi [ChatStreamHold]'dadır: arka plandan dönüş ve ekranın yeniden açılışı da o
/// ana kadar akış açmaz.

abstract class _$ChatSyncController extends $Notifier<ChatSyncStatus> {
  ChatSyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatSyncStatus, ChatSyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatSyncStatus, ChatSyncStatus>,
              ChatSyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
