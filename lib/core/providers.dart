import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_phase.dart';
import 'config/flavor.dart';
import 'http/dio_factory.dart';
import 'scope/scope_controller.dart';
import 'server/server_binding.dart';
import 'session/session_controller.dart';
import 'session/session_state.dart';

part 'providers.g.dart';

// Riverpod = reaktif durum ve sunuma açılan yüz (ADR-0001, D-0182).
//
// Aşağıdaki ilk beş sağlayıcı PORTTUR: altyapı tekillerinin kendisi ve kablolaması bileşim
// kökündedir (`lib/app/di/`, get_it). Bootstrap bu portları get_it'teki örneklerle geçersiz
// kılar; core get_it'i import etmez (sınır kuralı G1). Port geçersiz kılınmadan okunursa
// UnimplementedError — sessiz varsayılan örnek yoktur.

Never _unbound(String name) =>
    throw UnimplementedError('$name bileşim kökünde (lib/app/di) bağlanır');

/// Derleme çeşidi.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) => _unbound('flavorProvider');

/// HTTP bağdaştırıcısı; null = dio varsayılanı (IOHttpClientAdapter, platform TLS).
@Riverpod(keepAlive: true)
HttpClientAdapter? httpAdapter(Ref ref) => _unbound('httpAdapterProvider');

@Riverpod(keepAlive: true)
ScopeController scopeController(Ref ref) => _unbound('scopeControllerProvider');

@Riverpod(keepAlive: true)
ServerBindingController serverBinding(Ref ref) =>
    _unbound('serverBindingProvider');

@Riverpod(keepAlive: true)
SessionController sessionController(Ref ref) =>
    _unbound('sessionControllerProvider');

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
