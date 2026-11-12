import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/flavor.dart';
import '../../core/config/mobile_release_policy.dart';
import '../../core/config/release_policy_provider.dart';
import '../../core/config/running_release.dart';
import '../../core/config/update_store.dart';
import '../../core/network/connectivity_link.dart';
import '../../core/network/connectivity_monitor.dart';
import '../../core/notifications/push_notifications.dart';
import '../../core/notifications/push_providers.dart';
import '../../core/preferences/app_preferences.dart';
import '../../core/preferences/locale_controller.dart';
import '../../core/preferences/theme_mode_controller.dart';
import '../../core/providers.dart';
import '../../core/scope/scope_controller.dart';
import '../../core/server/server_binding.dart';
import '../../core/session/session_controller.dart';
import '../../core/storage/preference_store.dart';
import '../../core/storage/secure_store.dart';
import '../../core/telemetry/error_reporting.dart';
import '../../core/telemetry/error_reporting_controller.dart';
import '../../features/activity/activity_module.dart';
import '../../features/administration/administration_module.dart';
import '../../features/archive/archive_module.dart';
import '../../features/assistant/assistant_module.dart';
import '../../features/coordinatorships/coordinatorships_module.dart';
import '../../features/identity/identity.dart' show LoginPrefill;
import '../../features/identity/identity_module.dart';
import '../../features/meetings/meetings_module.dart';
import '../../features/messages/messages_module.dart';
import '../../features/notifications/notifications_module.dart';
import '../../features/reports/reports_module.dart';
import '../../features/scope/scope_module.dart';
import '../../features/tasks/tasks_module.dart';
import '../../features/timeline/timeline_module.dart';
import '../config/native_update_store.dart';
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
  /// entegrasyon. [loginPrefill]: yalnız dev (giriş formu ön dolgusu).
  factory Composition.create({
    required Flavor flavor,
    LoginPrefill? loginPrefill,
    SecureStore? secureStore,
    HttpClientAdapter? httpAdapter,
    PreferenceStore? preferenceStore,
    AppPreferences? appPreferences,
    ConnectivityLink? connectivityLink,
    PushNotifications? pushNotifications,
    ReleasePolicySource? releasePolicySource,
    RunningRelease? runningRelease,
    ErrorReporter? errorReporter,
  }) {
    final locator = GetIt.asNewInstance();
    // Native sözleşme ve Firebase dağıtım ayarları hazır olana kadar kapalı port.
    // Burada Firebase başlatılmaz veya sistem izin penceresi gösterilmez.
    locator.registerSingleton<PushNotifications>(
      pushNotifications ?? const DisabledPushNotifications(),
    );
    locator.registerSingleton<ReleasePolicySource>(
      releasePolicySource ?? const DisabledReleasePolicySource(),
    );
    configureDependencies(
      locator,
      flavor: flavor,
      secureStore: secureStore,
      httpAdapter: httpAdapter,
      preferenceStore: preferenceStore,
      appPreferences: appPreferences,
      connectivityLink: connectivityLink,
      runningVersion: runningRelease?.version,
      errorReporter: errorReporter,
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
    registerReportsModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerAssistantModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerAdministrationModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerArchiveModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerCoordinatorshipsModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerMeetingsModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerMessagesModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerNotificationsModule(
      locator,
      apiDio: () => container.read(apiDioProvider),
    );
    registerTasksModule(locator, apiDio: () => container.read(apiDioProvider));
    registerTimelineModule(locator);
    container = ProviderContainer(
      // Otomatik yeniden deneme YOK (A3 / CLAUDE.md): Riverpod 3 varsayılanı hata veren
      // sağlayıcıyı kendiliğinden yeniden çalıştırır; yeniden deneme yalnız kullanıcı dokunuşuyla.
      retry: (_, _) => null,
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        if (runningRelease != null) ...[
          runningReleaseProvider.overrideWithValue(runningRelease),
          updateStoreProvider.overrideWithValue(
            NativeUpdateStore(runningRelease),
          ),
        ],
        releasePolicySourceProvider.overrideWithValue(
          locator<ReleasePolicySource>(),
        ),
        pushNotificationsProvider.overrideWithValue(
          locator<PushNotifications>(),
        ),
        httpAdapterProvider.overrideWithValue(registeredHttpAdapter(locator)),
        scopeControllerProvider.overrideWithValue(locator<ScopeController>()),
        localeControllerProvider.overrideWithValue(locator<LocaleController>()),
        themeModeControllerProvider.overrideWithValue(
          locator<ThemeModeController>(),
        ),
        errorReportingControllerProvider.overrideWithValue(
          locator<ErrorReportingController>(),
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
        ...identityOverrides(locator, loginPrefill: loginPrefill),
        ...scopeOverrides(locator),
        ...activityOverrides(locator),
        ...reportsOverrides(locator),
        ...assistantOverrides(locator),
        ...administrationOverrides(locator),
        ...archiveOverrides(locator),
        ...coordinatorshipsOverrides(
          locator,
          apiDio: () => container.read(apiDioProvider),
        ),
        ...meetingsOverrides(locator),
        ...messagesOverrides(locator),
        ...notificationsOverrides(locator),
        ...tasksOverrides(
          locator,
          apiDio: () => container.read(apiDioProvider),
        ),
        ...timelineOverrides(
          locator,
          apiDio: () => container.read(apiDioProvider),
        ),
      ],
    );
    return Composition._(locator, container);
  }

  Future<void> dispose() async {
    container.dispose();
    await locator.reset();
  }
}
