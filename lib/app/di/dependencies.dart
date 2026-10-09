import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/api/generated/clients/identity_client.dart';
import '../../core/api/generated/models/refresh_request.dart';
import '../../core/config/flavor.dart';
import '../../core/errors/api_error.dart';
import '../../core/http/dio_factory.dart';
import '../../core/i18n/generated/client_error_codes.gen.dart';
import '../../core/preferences/app_preferences.dart';
import '../../core/preferences/theme_mode_controller.dart';
import '../../core/scope/scope_controller.dart';
import '../../core/server/server_binding.dart';
import '../../core/session/refresh_grant.dart';
import '../../core/session/session_controller.dart';
import '../../core/session/session_state.dart';
import '../../core/session/token_store.dart';
import '../../core/storage/flutter_secure_store.dart';
import '../../core/storage/preference_store.dart';
import '../../core/storage/secure_store.dart';
import '../../core/storage/shared_preference_store.dart';

/// Altyapı nesne grafiği (ADR-0001, D-0182): bütün altyapı tekilleri ve aralarındaki
/// KABLOLAMA yalnız burada kaydedilir; ömür (tembel tekil, `dispose`) get_it'tedir.
///
/// Kablolar (davranış değişmezleri — `test/app/composition_test.dart` sabitler):
/// - Yenileme çağrısı yalnız çiftin ait olduğu kurulum güncel doğrulanmış bağsa ağa çıkar
///   (CX-r1-Ö-01).
/// - Farklı sunucu/kuruluma yeniden bağlanma oturumu ve kapsamı temizler (bağ denetleyicisi
///   oturumu bilmez; yön tek: oturum → bağ).
/// - Oturum etkin değilse (çıkış, yeniden giriş gerekli) kapsam temizlenir.
///
/// [secureStore] / [httpAdapter] / [preferenceStore] yalnız testler ve cihazsız entegrasyon
/// içindir; verilmezse flutter_secure_storage, dio'nun varsayılan bağdaştırıcısı (platform
/// TLS) ve shared_preferences kullanılır.
void configureDependencies(
  GetIt locator, {
  required Flavor flavor,
  SecureStore? secureStore,
  HttpClientAdapter? httpAdapter,
  PreferenceStore? preferenceStore,
}) {
  locator
    ..registerSingleton<Flavor>(flavor)
    ..registerLazySingleton<SecureStore>(
      () => secureStore ?? FlutterSecureStore(),
    )
    ..registerLazySingleton<TokenStore>(
      () => TokenStore(locator<SecureStore>()),
    )
    ..registerLazySingleton<PreferenceStore>(
      () => preferenceStore ?? SharedPreferenceStore(),
    )
    ..registerLazySingleton<AppPreferences>(
      () => AppPreferences(locator<PreferenceStore>()),
    )
    ..registerLazySingleton<ThemeModeController>(
      () => ThemeModeController(locator<AppPreferences>()),
      dispose: (c) => c.dispose(),
    )
    ..registerLazySingleton<ScopeController>(ScopeController.new)
    ..registerLazySingleton<ServerBindingController>(
      () => ServerBindingController(
        flavor: flavor,
        store: locator<SecureStore>(),
        adapter: httpAdapter,
      ),
    );
  if (httpAdapter != null) {
    locator.registerSingleton<HttpClientAdapter>(httpAdapter);
  }

  // Kablo sökücüleri: SessionController atılırken (locator.reset) hem oturum→kapsam hem
  // bağ→oturum (yeniden bağlanma) dinleyicileri sökülür; eski bağ nesnesi tutulsa ya da
  // doğrulaması sürse bile eski grafik çalışmaz (CX-g-K-01). İdempotent.
  final detach = <void Function()>[];
  locator.registerLazySingleton<SessionController>(
    () {
      final binding = locator<ServerBindingController>();
      final scope = locator<ScopeController>();
      final controller = SessionController(locator<TokenStore>(), (
        refreshToken,
        instanceId,
      ) {
        final b = binding.current;
        if (b is! BindingVerified || b.info.instanceId != instanceId) {
          throw ApiError(ClientErrorCode.serverNotVerified);
        }
        final dio = createPublicDio(
          server: b.info.address,
          flavor: flavor,
          adapter: httpAdapter,
        );
        // DTO → RefreshGrant eşlemesi apiCall içinde: hata sınıflaması (ayrıştırma hatası →
        // belirsiz, K-05) değişmez.
        return apiCall(() async {
          final r = await IdentityClient(dio)
              .refresh(body: RefreshRequest(refreshToken: refreshToken));
          return RefreshGrant(
            accountId: r.accountId,
            accessToken: r.accessToken,
            accessExpiresAt: r.expiresAt,
            refreshToken: r.refreshToken,
            refreshExpiresAt: r.refreshExpiresAt,
          );
        });
      });
      detach.add(
        binding.addRebindListener(() async {
          scope.clear();
          await controller.clear();
        }),
      );
      void onSession() {
        if (controller.state.value is! SessionActive) scope.clear();
      }

      controller.state.addListener(onSession);
      detach.add(() => controller.state.removeListener(onSession));
      return controller;
    },
    dispose: (_) {
      for (final d in detach) {
        d();
      }
      detach.clear();
    },
  );
}

/// Bileşim kökünün kayıtlı HTTP bağdaştırıcısı (yoksa null = platform varsayılanı).
HttpClientAdapter? registeredHttpAdapter(GetIt locator) =>
    locator.isRegistered<HttpClientAdapter>()
    ? locator<HttpClientAdapter>()
    : null;
