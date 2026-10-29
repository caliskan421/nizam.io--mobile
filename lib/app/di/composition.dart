import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/flavor.dart';
import '../../core/network/connectivity_link.dart';
import '../../core/network/connectivity_monitor.dart';
import '../../core/preferences/locale_controller.dart';
import '../../core/preferences/theme_mode_controller.dart';
import '../../core/providers.dart';
import '../../core/scope/scope_controller.dart';
import '../../core/server/server_binding.dart';
import '../../core/session/session_controller.dart';
import '../../core/storage/preference_store.dart';
import '../../core/storage/secure_store.dart';
import '../../features/activity/activity_module.dart';
import '../../features/archive/archive_module.dart';
import '../../features/calendar/calendar_module.dart';
import '../../features/coordinatorships/coordinatorships_module.dart';
import '../../features/identity/identity_module.dart';
import '../../features/messages/messages_module.dart';
import '../../features/scope/scope_module.dart';
import '../../features/tasks/tasks_module.dart';
import '../../features/timeline/timeline_module.dart';
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
  ///
  /// [prototype]: prototip modu (yalnız dev; `prototypeModeProvider`).
  factory Composition.create({
    required Flavor flavor,
    bool prototype = false,
    SecureStore? secureStore,
    HttpClientAdapter? httpAdapter,
    PreferenceStore? preferenceStore,
    ConnectivityLink? connectivityLink,
  }) {
    if (prototype && flavor != Flavor.dev) {
      throw ArgumentError.value(prototype, 'prototype', 'yalnız dev flavor');
    }
    final locator = GetIt.asNewInstance();
    configureDependencies(
      locator,
      flavor: flavor,
      secureStore: secureStore,
      httpAdapter: httpAdapter,
      preferenceStore: preferenceStore,
      connectivityLink: connectivityLink,
    );
    late final ProviderContainer container;
    // Feature modülleri yalnız buradan kaydedilir (sınır kuralı G2). Reaktif API istemcisi
    // Riverpod'dadır; modül onu yapıcıdan aldığı bir okuyucuyla görür.
    registerIdentityModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerScopeModule(locator, apiDio: () => container.read(apiDioProvider));
    registerActivityModule(locator);
    registerArchiveModule(locator);
    registerCalendarModule(locator);
    registerCoordinatorshipsModule(locator);
    registerMessagesModule(locator);
    registerTasksModule(locator);
    registerTimelineModule(locator);
    container = ProviderContainer(
      // Otomatik yeniden deneme YOK (A3 / CLAUDE.md): Riverpod 3 varsayılanı hata veren
      // sağlayıcıyı kendiliğinden yeniden çalıştırır; yeniden deneme yalnız kullanıcı dokunuşuyla.
      retry: (_, _) => null,
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        prototypeModeProvider.overrideWithValue(prototype),
        httpAdapterProvider.overrideWithValue(registeredHttpAdapter(locator)),
        scopeControllerProvider.overrideWithValue(locator<ScopeController>()),
        localeControllerProvider.overrideWithValue(locator<LocaleController>()),
        themeModeControllerProvider.overrideWithValue(
          locator<ThemeModeController>(),
        ),
        connectivityMonitorProvider.overrideWithValue(
          locator<ConnectivityMonitor>(),
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
        ...scopeOverrides(locator),
        ...activityOverrides(locator),
        ...archiveOverrides(locator),
        ...calendarOverrides(locator),
        ...coordinatorshipsOverrides(locator),
        ...messagesOverrides(locator),
        ...tasksOverrides(locator),
        ...timelineOverrides(locator),
      ],
    );
    return Composition._(locator, container);
  }

  Future<void> dispose() async {
    container.dispose();
    await locator.reset();
  }
}
