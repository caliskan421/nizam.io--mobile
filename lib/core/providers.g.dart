// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derleme çeşidi; `app/bootstrap.dart` giriş noktasına göre geçersiz kılar.

@ProviderFor(flavor)
final flavorProvider = FlavorProvider._();

/// Derleme çeşidi; `app/bootstrap.dart` giriş noktasına göre geçersiz kılar.

final class FlavorProvider extends $FunctionalProvider<Flavor, Flavor, Flavor>
    with $Provider<Flavor> {
  /// Derleme çeşidi; `app/bootstrap.dart` giriş noktasına göre geçersiz kılar.
  FlavorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorHash();

  @$internal
  @override
  $ProviderElement<Flavor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Flavor create(Ref ref) {
    return flavor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Flavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Flavor>(value),
    );
  }
}

String _$flavorHash() => r'007a4be4164bcf1913126f462542972ea142b606';

/// Güvenli depo (testte MemorySecureStore ile geçersiz kılınır).

@ProviderFor(secureStore)
final secureStoreProvider = SecureStoreProvider._();

/// Güvenli depo (testte MemorySecureStore ile geçersiz kılınır).

final class SecureStoreProvider
    extends $FunctionalProvider<SecureStore, SecureStore, SecureStore>
    with $Provider<SecureStore> {
  /// Güvenli depo (testte MemorySecureStore ile geçersiz kılınır).
  SecureStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStoreHash();

  @$internal
  @override
  $ProviderElement<SecureStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStore create(Ref ref) {
    return secureStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStore>(value),
    );
  }
}

String _$secureStoreHash() => r'aa467fa993206876a457815842372408ded21ef3';

/// HTTP bağdaştırıcısı; null = dio varsayılanı (IOHttpClientAdapter, platform TLS).

@ProviderFor(httpAdapter)
final httpAdapterProvider = HttpAdapterProvider._();

/// HTTP bağdaştırıcısı; null = dio varsayılanı (IOHttpClientAdapter, platform TLS).

final class HttpAdapterProvider
    extends
        $FunctionalProvider<
          HttpClientAdapter?,
          HttpClientAdapter?,
          HttpClientAdapter?
        >
    with $Provider<HttpClientAdapter?> {
  /// HTTP bağdaştırıcısı; null = dio varsayılanı (IOHttpClientAdapter, platform TLS).
  HttpAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpAdapterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpAdapterHash();

  @$internal
  @override
  $ProviderElement<HttpClientAdapter?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HttpClientAdapter? create(Ref ref) {
    return httpAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClientAdapter? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClientAdapter?>(value),
    );
  }
}

String _$httpAdapterHash() => r'8a40f9ca9de79fe420fa6db688c592e7b3e855b8';

@ProviderFor(scopeController)
final scopeControllerProvider = ScopeControllerProvider._();

final class ScopeControllerProvider
    extends
        $FunctionalProvider<ScopeController, ScopeController, ScopeController>
    with $Provider<ScopeController> {
  ScopeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopeControllerHash();

  @$internal
  @override
  $ProviderElement<ScopeController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScopeController create(Ref ref) {
    return scopeController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScopeController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScopeController>(value),
    );
  }
}

String _$scopeControllerHash() => r'f13afb8aae2d80e404e89ed0c6ed3624ea69ca1f';

@ProviderFor(serverBinding)
final serverBindingProvider = ServerBindingProvider._();

final class ServerBindingProvider
    extends
        $FunctionalProvider<
          ServerBindingController,
          ServerBindingController,
          ServerBindingController
        >
    with $Provider<ServerBindingController> {
  ServerBindingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverBindingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverBindingHash();

  @$internal
  @override
  $ProviderElement<ServerBindingController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerBindingController create(Ref ref) {
    return serverBinding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerBindingController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerBindingController>(value),
    );
  }
}

String _$serverBindingHash() => r'b6762c44eddfc59dbbc47278a5eec100a6fb5abe';

@ProviderFor(sessionController)
final sessionControllerProvider = SessionControllerProvider._();

final class SessionControllerProvider
    extends
        $FunctionalProvider<
          SessionController,
          SessionController,
          SessionController
        >
    with $Provider<SessionController> {
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  $ProviderElement<SessionController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionController create(Ref ref) {
    return sessionController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionController>(value),
    );
  }
}

String _$sessionControllerHash() => r'69ea681eebb94002e3fa4aeb10dffe27d088d446';

@ProviderFor(bindingState)
final bindingStateProvider = BindingStateProvider._();

final class BindingStateProvider
    extends $FunctionalProvider<BindingState, BindingState, BindingState>
    with $Provider<BindingState> {
  BindingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bindingStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bindingStateHash();

  @$internal
  @override
  $ProviderElement<BindingState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BindingState create(Ref ref) {
    return bindingState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BindingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BindingState>(value),
    );
  }
}

String _$bindingStateHash() => r'ffaa656bc60556dd7757bc6d10e658c62a4085ce';

@ProviderFor(sessionState)
final sessionStateProvider = SessionStateProvider._();

final class SessionStateProvider
    extends $FunctionalProvider<SessionState, SessionState, SessionState>
    with $Provider<SessionState> {
  SessionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStateHash();

  @$internal
  @override
  $ProviderElement<SessionState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionState create(Ref ref) {
    return sessionState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$sessionStateHash() => r'9b3dbf1ada4cf936d9324a08db14faf2a72b9040';

@ProviderFor(scopeState)
final scopeStateProvider = ScopeStateProvider._();

final class ScopeStateProvider
    extends $FunctionalProvider<ScopeSelection, ScopeSelection, ScopeSelection>
    with $Provider<ScopeSelection> {
  ScopeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopeStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopeStateHash();

  @$internal
  @override
  $ProviderElement<ScopeSelection> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScopeSelection create(Ref ref) {
    return scopeState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScopeSelection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScopeSelection>(value),
    );
  }
}

String _$scopeStateHash() => r'c21641859d5db8912fdde39e723b79352276b466';

@ProviderFor(appPhase)
final appPhaseProvider = AppPhaseProvider._();

final class AppPhaseProvider
    extends $FunctionalProvider<AppPhase, AppPhase, AppPhase>
    with $Provider<AppPhase> {
  AppPhaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPhaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPhaseHash();

  @$internal
  @override
  $ProviderElement<AppPhase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppPhase create(Ref ref) {
    return appPhase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPhase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPhase>(value),
    );
  }
}

String _$appPhaseHash() => r'81f59e579d6a7f22220b6a9ec7a3a97b9b156708';

/// Doğrulanmış sunucuya API istemcisi; bağ yoksa `null` (istek oluşturulamaz).

@ProviderFor(apiDio)
final apiDioProvider = ApiDioProvider._();

/// Doğrulanmış sunucuya API istemcisi; bağ yoksa `null` (istek oluşturulamaz).

final class ApiDioProvider extends $FunctionalProvider<Dio?, Dio?, Dio?>
    with $Provider<Dio?> {
  /// Doğrulanmış sunucuya API istemcisi; bağ yoksa `null` (istek oluşturulamaz).
  ApiDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiDioHash();

  @$internal
  @override
  $ProviderElement<Dio?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio? create(Ref ref) {
    return apiDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio?>(value),
    );
  }
}

String _$apiDioHash() => r'7da665024b1a5ba43a2aad5ccbb3b82d81aea455';
