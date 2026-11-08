// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: mesajlaşma uçlarının kaynağı (`messages_module.dart`'ta bağlanır).

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

/// PORT: mesajlaşma uçlarının kaynağı (`messages_module.dart`'ta bağlanır).

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// PORT: mesajlaşma uçlarının kaynağı (`messages_module.dart`'ta bağlanır).
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'96b8e2448bd6d1623973660e41532257c51969c2';

/// Oturumdaki hesap (kendi mesajım ayrımı); oturum yoksa null.

@ProviderFor(chatMe)
final chatMeProvider = ChatMeProvider._();

/// Oturumdaki hesap (kendi mesajım ayrımı); oturum yoksa null.

final class ChatMeProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Oturumdaki hesap (kendi mesajım ayrımı); oturum yoksa null.
  ChatMeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatMeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatMeHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return chatMe(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$chatMeHash() => r'f7614fdec79e393da255c10350861152e526a879';

@ProviderFor(chatSignalBus)
final chatSignalBusProvider = ChatSignalBusProvider._();

final class ChatSignalBusProvider
    extends $FunctionalProvider<ChatSignalBus, ChatSignalBus, ChatSignalBus>
    with $Provider<ChatSignalBus> {
  ChatSignalBusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSignalBusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSignalBusHash();

  @$internal
  @override
  $ProviderElement<ChatSignalBus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatSignalBus create(Ref ref) {
    return chatSignalBus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSignalBus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSignalBus>(value),
    );
  }
}

String _$chatSignalBusHash() => r'bba630f04caebea96afe05b3d50dccbf39f0b672';

/// [failures] ardışık başarısızlıktan sonraki yeniden bağlanma beklemesi (testte değiştirilir).

@ProviderFor(chatReconnectDelay)
final chatReconnectDelayProvider = ChatReconnectDelayProvider._();

/// [failures] ardışık başarısızlıktan sonraki yeniden bağlanma beklemesi (testte değiştirilir).

final class ChatReconnectDelayProvider
    extends
        $FunctionalProvider<
          Duration Function(int failures),
          Duration Function(int failures),
          Duration Function(int failures)
        >
    with $Provider<Duration Function(int failures)> {
  /// [failures] ardışık başarısızlıktan sonraki yeniden bağlanma beklemesi (testte değiştirilir).
  ChatReconnectDelayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatReconnectDelayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatReconnectDelayHash();

  @$internal
  @override
  $ProviderElement<Duration Function(int failures)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Duration Function(int failures) create(Ref ref) {
    return chatReconnectDelay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration Function(int failures) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration Function(int failures)>(
        value,
      ),
    );
  }
}

String _$chatReconnectDelayHash() =>
    r'07ad5da4d7f0dc1992421a4ef9d37599091c953a';

/// Uygulama ön planda mı: akış yalnız ön plandayken açıktır (yaşam döngüsünü sunum katmanındaki
/// akış kapsamı yazar).

@ProviderFor(ChatForeground)
final chatForegroundProvider = ChatForegroundProvider._();

/// Uygulama ön planda mı: akış yalnız ön plandayken açıktır (yaşam döngüsünü sunum katmanındaki
/// akış kapsamı yazar).
final class ChatForegroundProvider
    extends $NotifierProvider<ChatForeground, bool> {
  /// Uygulama ön planda mı: akış yalnız ön plandayken açıktır (yaşam döngüsünü sunum katmanındaki
  /// akış kapsamı yazar).
  ChatForegroundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatForegroundProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatForegroundHash();

  @$internal
  @override
  ChatForeground create() => ChatForeground();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatForegroundHash() => r'736faa792204f0a8ed07b5cda1ad9309049e77f3';

/// Uygulama ön planda mı: akış yalnız ön plandayken açıktır (yaşam döngüsünü sunum katmanındaki
/// akış kapsamı yazar).

abstract class _$ChatForeground extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
