import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_phase.dart';
import 'config/flavor.dart';
import 'http/dio_factory.dart';
import 'network/connectivity_monitor.dart';
import 'preferences/locale_controller.dart';
import 'preferences/theme_mode_controller.dart';
import 'scope/scope_controller.dart';
import 'server/server_binding.dart';
import 'session/session_controller.dart';
import 'session/session_state.dart';

part 'providers.g.dart';

// Riverpod = reaktif durum ve sunuma açılan yüz (ADR-0001, D-0182).
//
// Aşağıdaki ilk altı sağlayıcı PORTTUR: altyapı tekillerinin kendisi ve kablolaması bileşim
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

@Riverpod(keepAlive: true)
ThemeModeController themeModeController(Ref ref) =>
    _unbound('themeModeControllerProvider');

@Riverpod(keepAlive: true)
ConnectivityMonitor connectivityMonitor(Ref ref) =>
    _unbound('connectivityMonitorProvider');

@Riverpod(keepAlive: true)
LocaleController localeController(Ref ref) =>
    _unbound('localeControllerProvider');

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

/// Kalıcı tema modu (sistem/açık/koyu); değiştirmek için `themeModeControllerProvider.set`.
@Riverpod(keepAlive: true)
ThemeMode themeMode(Ref ref) =>
    _listen(ref, ref.watch(themeModeControllerProvider).state);

/// Sunucuya erişim durumu (çevrimiçi/çevrimdışı/bilinmiyor); yalnız durum yayar.
@Riverpod(keepAlive: true)
ConnectivityState connectivityState(Ref ref) =>
    _listen(ref, ref.watch(connectivityMonitorProvider).state);

/// Kalıcı uygulama dili (altyapı; yalnız `tr`); değiştirmek için `localeControllerProvider.set`.
@Riverpod(keepAlive: true)
Locale locale(Ref ref) =>
    _listen(ref, ref.watch(localeControllerProvider).state);

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
    connectivity: ref.watch(connectivityMonitorProvider),
    adapter: ref.watch(httpAdapterProvider),
  );
  ref.onDispose(dio.close);
  return dio;
}
