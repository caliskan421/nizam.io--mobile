import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api/generated/clients/identity_client.dart';
import 'api/generated/models/refresh_request.dart';
import 'app_phase.dart';
import 'config/flavor.dart';
import 'errors/api_error.dart';
import 'http/dio_factory.dart';
import 'i18n/generated/client_error_codes.gen.dart';
import 'scope/scope_controller.dart';
import 'server/server_binding.dart';
import 'session/session_controller.dart';
import 'session/session_state.dart';
import 'session/token_store.dart';
import 'storage/flutter_secure_store.dart';
import 'storage/secure_store.dart';

part 'providers.g.dart';

/// Derleme çeşidi; `app/bootstrap.dart` giriş noktasına göre geçersiz kılar.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) =>
    throw UnimplementedError('flavorProvider bootstrap\'ta verilir');

/// Güvenli depo (testte MemorySecureStore ile geçersiz kılınır).
@Riverpod(keepAlive: true)
SecureStore secureStore(Ref ref) => FlutterSecureStore();

/// HTTP bağdaştırıcısı; null = dio varsayılanı (IOHttpClientAdapter, platform TLS).
@Riverpod(keepAlive: true)
HttpClientAdapter? httpAdapter(Ref ref) => null;

@Riverpod(keepAlive: true)
ScopeController scopeController(Ref ref) => ScopeController();

@Riverpod(keepAlive: true)
ServerBindingController serverBinding(Ref ref) => ServerBindingController(
  flavor: ref.watch(flavorProvider),
  store: ref.watch(secureStoreProvider),
  adapter: ref.watch(httpAdapterProvider),
);

@Riverpod(keepAlive: true)
SessionController sessionController(Ref ref) {
  final binding = ref.watch(serverBindingProvider);
  final scope = ref.watch(scopeControllerProvider);
  final controller = SessionController(
    TokenStore(ref.watch(secureStoreProvider)),
    (refreshToken, instanceId) {
      final b = binding.current;
      // Yenileme yalnız çiftin ait olduğu kuruluma gider (CX-r1-Ö-01).
      if (b is! BindingVerified || b.info.instanceId != instanceId) {
        throw ApiError(ClientErrorCode.serverNotVerified);
      }
      final dio = createPublicDio(
        server: b.info.address,
        flavor: ref.read(flavorProvider),
        adapter: ref.read(httpAdapterProvider),
      );
      return apiCall(
        () =>
            IdentityClient(dio)
                .refresh(body: RefreshRequest(refreshToken: refreshToken)),
      );
    },
  );
  // Farklı sunucu/kuruluma yeniden bağlanma: yerel oturum ve kapsam temizlenir (bağ
  // denetleyicisi oturumu bilmez; yön tek: oturum → bağ).
  binding.addRebindListener(() async {
    scope.clear();
    await controller.clear();
  });
  // Kapsam oturuma aittir: oturum etkin değilse (çıkış, yeniden giriş gerekli) temizlenir.
  void onSession() {
    if (controller.state.value is! SessionActive) scope.clear();
  }

  controller.state.addListener(onSession);
  ref.onDispose(() => controller.state.removeListener(onSession));
  return controller;
}

T _listen<T>(Ref ref, ValueListenable<T> listenable) {
  void onChange() => ref.invalidateSelf();
  listenable.addListener(onChange);
  ref.onDispose(() => listenable.removeListener(onChange));
  return listenable.value;
}

@Riverpod(keepAlive: true)
BindingState bindingState(Ref ref) =>
    _listen(ref, ref.watch(serverBindingProvider).state);

@Riverpod(keepAlive: true)
SessionState sessionState(Ref ref) =>
    _listen(ref, ref.watch(sessionControllerProvider).state);

@Riverpod(keepAlive: true)
ScopeSelection scopeState(Ref ref) =>
    _listen(ref, ref.watch(scopeControllerProvider).state);

@Riverpod(keepAlive: true)
AppPhase appPhase(Ref ref) => deriveAppPhase(
  ref.watch(bindingStateProvider),
  ref.watch(sessionStateProvider),
  ref.watch(scopeStateProvider),
);

/// Doğrulanmış sunucuya API istemcisi; bağ yoksa `null` (istek oluşturulamaz).
@Riverpod(keepAlive: true)
Dio? apiDio(Ref ref) {
  final b = ref.watch(bindingStateProvider);
  if (b is! BindingVerified) return null;
  final dio = createApiDio(
    server: b.info.address,
    flavor: ref.watch(flavorProvider),
    session: ref.watch(sessionControllerProvider),
    instanceId: b.info.instanceId,
    scope: ref.watch(scopeControllerProvider),
    adapter: ref.watch(httpAdapterProvider),
  );
  ref.onDispose(dio.close);
  return dio;
}
