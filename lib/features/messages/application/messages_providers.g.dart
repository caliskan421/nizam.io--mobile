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

/// Açık sohbetlerin paylaştığı ucuz sinyal kovası (yazıyor + okundu; [SignalBudget]).

@ProviderFor(chatSignalBudget)
final chatSignalBudgetProvider = ChatSignalBudgetProvider._();

/// Açık sohbetlerin paylaştığı ucuz sinyal kovası (yazıyor + okundu; [SignalBudget]).

final class ChatSignalBudgetProvider
    extends $FunctionalProvider<SignalBudget, SignalBudget, SignalBudget>
    with $Provider<SignalBudget> {
  /// Açık sohbetlerin paylaştığı ucuz sinyal kovası (yazıyor + okundu; [SignalBudget]).
  ChatSignalBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSignalBudgetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSignalBudgetHash();

  @$internal
  @override
  $ProviderElement<SignalBudget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignalBudget create(Ref ref) {
    return chatSignalBudget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignalBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignalBudget>(value),
    );
  }
}

String _$chatSignalBudgetHash() => r'32cd8f829dc2c50273db93d6cdefbcc345156333';

/// Akışın en erken yeniden açılış anı (429 `Retry-After`; yazma bütçesi hesap başınadır). Akış
/// denetleyicisinin ömründen bağımsızdır: ön plana dönüş ve ekranın yeniden açılması da uyar.

@ProviderFor(ChatStreamHold)
final chatStreamHoldProvider = ChatStreamHoldProvider._();

/// Akışın en erken yeniden açılış anı (429 `Retry-After`; yazma bütçesi hesap başınadır). Akış
/// denetleyicisinin ömründen bağımsızdır: ön plana dönüş ve ekranın yeniden açılması da uyar.
final class ChatStreamHoldProvider
    extends
        $NotifierProvider<ChatStreamHold, ({String account, DateTime until})?> {
  /// Akışın en erken yeniden açılış anı (429 `Retry-After`; yazma bütçesi hesap başınadır). Akış
  /// denetleyicisinin ömründen bağımsızdır: ön plana dönüş ve ekranın yeniden açılması da uyar.
  ChatStreamHoldProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatStreamHoldProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatStreamHoldHash();

  @$internal
  @override
  ChatStreamHold create() => ChatStreamHold();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({String account, DateTime until})? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({String account, DateTime until})?>(
        value,
      ),
    );
  }
}

String _$chatStreamHoldHash() => r'f5a739fda5064ab8682b7baa637249a077ea01e9';

/// Akışın en erken yeniden açılış anı (429 `Retry-After`; yazma bütçesi hesap başınadır). Akış
/// denetleyicisinin ömründen bağımsızdır: ön plana dönüş ve ekranın yeniden açılması da uyar.

abstract class _$ChatStreamHold
    extends $Notifier<({String account, DateTime until})?> {
  ({String account, DateTime until})? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({String account, DateTime until})?,
              ({String account, DateTime until})?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({String account, DateTime until})?,
                ({String account, DateTime until})?
              >,
              ({String account, DateTime until})?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
/// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.

@ProviderFor(chatInboxSearch)
final chatInboxSearchProvider = ChatInboxSearchFamily._();

/// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
/// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.

final class ChatInboxSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChatInbox>,
          ChatInbox,
          FutureOr<ChatInbox>
        >
    with $FutureModifier<ChatInbox>, $FutureProvider<ChatInbox> {
  /// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
  /// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.
  ChatInboxSearchProvider._({
    required ChatInboxSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatInboxSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatInboxSearchHash();

  @override
  String toString() {
    return r'chatInboxSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ChatInbox> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ChatInbox> create(Ref ref) {
    final argument = this.argument as String;
    return chatInboxSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatInboxSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatInboxSearchHash() => r'020c780cd2eefe556cf541f04b9ef11f34dfa97b';

/// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
/// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.

final class ChatInboxSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ChatInbox>, String> {
  ChatInboxSearchFamily._()
    : super(
        retry: null,
        name: r'chatInboxSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sunucuda bütün mesaj geçmişini tarayan gelen kutusu araması. Ana ekranın
  /// mevcut yerel filtresinden bağımsızdır; sorgu/program/oturum ayrı istek kimliğidir.

  ChatInboxSearchProvider call(String query) =>
      ChatInboxSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'chatInboxSearchProvider';
}

/// Program seçicisindeki rozetlere hazır programlar arası okunmamış/bahsetme özeti.

@ProviderFor(chatUnreadOverview)
final chatUnreadOverviewProvider = ChatUnreadOverviewProvider._();

/// Program seçicisindeki rozetlere hazır programlar arası okunmamış/bahsetme özeti.

final class ChatUnreadOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatProgramUnread>>,
          List<ChatProgramUnread>,
          FutureOr<List<ChatProgramUnread>>
        >
    with
        $FutureModifier<List<ChatProgramUnread>>,
        $FutureProvider<List<ChatProgramUnread>> {
  /// Program seçicisindeki rozetlere hazır programlar arası okunmamış/bahsetme özeti.
  ChatUnreadOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUnreadOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUnreadOverviewHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatProgramUnread>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatProgramUnread>> create(Ref ref) {
    return chatUnreadOverview(ref);
  }
}

String _$chatUnreadOverviewHash() =>
    r'fad83829686ff1e1a7128995c4188f75a99114bf';
