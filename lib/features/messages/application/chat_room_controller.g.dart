// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
/// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
/// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
/// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
/// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
/// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.

@ProviderFor(ChatRoomController)
final chatRoomControllerProvider = ChatRoomControllerFamily._();

/// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
/// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
/// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
/// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
/// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
/// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.
final class ChatRoomControllerProvider
    extends $AsyncNotifierProvider<ChatRoomController, ChatRoom> {
  /// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
  /// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
  /// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
  /// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
  /// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
  /// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
  /// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.
  ChatRoomControllerProvider._({
    required ChatRoomControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomControllerHash();

  @override
  String toString() {
    return r'chatRoomControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomController create() => ChatRoomController();

  @override
  bool operator ==(Object other) {
    return other is ChatRoomControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomControllerHash() =>
    r'21da300dcf12083e32f105288860c4697b2df7cd';

/// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
/// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
/// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
/// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
/// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
/// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.

final class ChatRoomControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatRoomController,
          AsyncValue<ChatRoom>,
          ChatRoom,
          FutureOr<ChatRoom>,
          String
        > {
  ChatRoomControllerFamily._()
    : super(
        retry: null,
        name: r'chatRoomControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
  /// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
  /// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
  /// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
  /// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
  /// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
  /// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.

  ChatRoomControllerProvider call(String id) =>
      ChatRoomControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'chatRoomControllerProvider';
}

/// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
/// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
/// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
/// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
/// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
/// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.

abstract class _$ChatRoomController extends $AsyncNotifier<ChatRoom> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<ChatRoom> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatRoom>, ChatRoom>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatRoom>, ChatRoom>,
              AsyncValue<ChatRoom>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
