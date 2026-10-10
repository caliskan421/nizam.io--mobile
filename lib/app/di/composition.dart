import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/flavor.dart';
import '../../core/preferences/theme_mode_controller.dart';
import '../../core/providers.dart';
import '../../core/scope/scope_controller.dart';
import '../../core/server/server_binding.dart';
import '../../core/session/session_controller.dart';
import '../../core/storage/preference_store.dart';
import '../../core/storage/secure_store.dart';
import '../../features/identity/identity_module.dart';
import 'dependencies.dart';

/// Bileşim kökü: get_it nesne grafiği + onu Riverpod portlarına bağlayan ProviderContainer.
///
/// Global `GetIt.instance` KULLANILMAZ: her bileşim kendi `GetIt.asNewInstance()` örneğine
/// sahiptir (testler birbirinden yalıtık; ADR-0001).
class Composition {
  Composition._(this.locator, this.container);

  final GetIt locator;
  final ProviderContainer container;

  /// [secureStore] / [httpAdapter] / [preferenceStore]: yalnız testler ve cihazsız
  /// entegrasyon.
  factory Composition.create({
    required Flavor flavor,
    SecureStore? secureStore,
    HttpClientAdapter? httpAdapter,
    PreferenceStore? preferenceStore,
  }) {
    final locator = GetIt.asNewInstance();
    configureDependencies(
      locator,
      flavor: flavor,
      secureStore: secureStore,
      httpAdapter: httpAdapter,
      preferenceStore: preferenceStore,
    );
    late final ProviderContainer container;
    // Feature modülleri yalnız buradan kaydedilir (sınır kuralı G2). Reaktif API istemcisi
    // Riverpod'dadır; modül onu yapıcıdan aldığı bir okuyucuyla görür.
    registerIdentityModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    container = ProviderContainer(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        httpAdapterProvider.overrideWithValue(registeredHttpAdapter(locator)),
        scopeControllerProvider.overrideWithValue(locator<ScopeController>()),
        themeModeControllerProvider.overrideWithValue(
          locator<ThemeModeController>(),
        ),
        serverBindingProvider.overrideWithValue(
          locator<ServerBindingController>(),
        ),
        // Oturum denetleyicisi burada (bağ doğrulamasından ÖNCE) kurulur: yeniden bağlanma
        // dinleyicisi her zaman kayıtlıdır (CX-Ö-03).
        sessionControllerProvider.overrideWithValue(
          locator<SessionController>(),
        ),
        ...identityOverrides(locator),
      ],
    );
    return Composition._(locator, container);
  }

  Future<void> dispose() async {
    container.dispose();
    await locator.reset();
  }
}
