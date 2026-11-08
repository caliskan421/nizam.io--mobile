// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_members_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
/// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
/// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
/// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
/// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
/// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.

@ProviderFor(ChatMembersController)
final chatMembersControllerProvider = ChatMembersControllerFamily._();

/// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
/// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
/// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
/// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
/// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
/// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.
final class ChatMembersControllerProvider
    extends $AsyncNotifierProvider<ChatMembersController, ChatMembers> {
  /// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
  /// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
  /// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
  /// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
  /// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
  /// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.
  ChatMembersControllerProvider._({
    required ChatMembersControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMembersControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMembersControllerHash();

  @override
  String toString() {
    return r'chatMembersControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatMembersController create() => ChatMembersController();

  @override
  bool operator ==(Object other) {
    return other is ChatMembersControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMembersControllerHash() =>
    r'717191cf66feb6ad2057d6615eb5d9920b543850';

/// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
/// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
/// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
/// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
/// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
/// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.

final class ChatMembersControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatMembersController,
          AsyncValue<ChatMembers>,
          ChatMembers,
          FutureOr<ChatMembers>,
          String
        > {
  ChatMembersControllerFamily._()
    : super(
        retry: null,
        name: r'chatMembersControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
  /// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
  /// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
  /// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
  /// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
  /// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.

  ChatMembersControllerProvider call(String chatId) =>
      ChatMembersControllerProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatMembersControllerProvider';
}

/// Grup üyeleri ve grup ayarları (istemci akışları §10.1): üye listesi (yazıyor adları ve `@`
/// bahsetme önerisi buradan çözülür), üye ekleme/çıkarma, gruptan ayrılma, yöneticilik, ad
/// değişimi ve grubu silme. Liste `member.changed` / `chat.changed` olaylarında en az 1 sn
/// birleştirilip, akış yeniden açılınca hemen yeniden okunur; tazeleme hatası eski listeyi
/// bozmaz. Yazma sonrası liste yeniden okunur (iyimser güncelleme yok). Yetki kararı sunucudadır
/// (K07); ekran eylemleri çağıranın rolünden ([Chat.canManage], [Chat.canModerate]) gösterir.

abstract class _$ChatMembersController extends $AsyncNotifier<ChatMembers> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  FutureOr<ChatMembers> build(String chatId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatMembers>, ChatMembers>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatMembers>, ChatMembers>,
              AsyncValue<ChatMembers>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).

@ProviderFor(chatAddCandidates)
final chatAddCandidatesProvider = ChatAddCandidatesFamily._();

/// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).

final class ChatAddCandidatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChatCandidates>,
          ChatCandidates,
          FutureOr<ChatCandidates>
        >
    with $FutureModifier<ChatCandidates>, $FutureProvider<ChatCandidates> {
  /// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).
  ChatAddCandidatesProvider._({
    required ChatAddCandidatesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatAddCandidatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatAddCandidatesHash();

  @override
  String toString() {
    return r'chatAddCandidatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ChatCandidates> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChatCandidates> create(Ref ref) {
    final argument = this.argument as String;
    return chatAddCandidates(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatAddCandidatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatAddCandidatesHash() => r'fd304b5c1345db6c222f96b35f2ae46af36a60fa';

/// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).

final class ChatAddCandidatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ChatCandidates>, String> {
  ChatAddCandidatesFamily._()
    : super(
        retry: null,
        name: r'chatAddCandidatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gruba eklenebilecek kişiler (`purpose=group&chat_id`; ekleme kuralı sunucuda, K06).

  ChatAddCandidatesProvider call(String chatId) =>
      ChatAddCandidatesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatAddCandidatesProvider';
}
