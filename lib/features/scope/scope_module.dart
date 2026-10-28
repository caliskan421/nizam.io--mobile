import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/scope/scope_controller.dart';
import '../../core/server/server_binding.dart';
import '../../core/session/session_controller.dart';
import 'application/scope_providers.dart';
import 'application/scope_service.dart';
import 'data/program_repository.dart';
import 'data/sample/sample_home_dashboard_repository.dart';
import 'domain/home_dashboard_repository.dart';

/// scope modülünün kayıt fonksiyonu (ADR-0001, D-0182). YALNIZ bileşim kökünden
/// (`lib/app/di/`) çağrılır (sınır kuralı G2); katmanlar get_it'i görmez — bağımlılıklar
/// yapıcıdan gelir.
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerScopeModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<ScopeService>(
    () => ScopeService(
      binding: locator<ServerBindingController>(),
      session: locator<SessionController>(),
      scope: locator<ScopeController>(),
      repository: () {
        final dio = apiDio();
        return dio == null ? null : ProgramRepository(dio);
      },
    ),
  );
  // GEÇİCİ: ana sayfa özeti backend'de hazır olana kadar geliştirme örneği. Gerçek kaynak
  // geldiğinde yalnız bu kayıt değişir (sunum ve controller aynı kalır).
  locator.registerLazySingleton<HomeDashboardRepository>(
    SampleHomeDashboardRepository.new,
  );
}

/// scope'un Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> scopeOverrides(GetIt locator) => [
  scopeServiceProvider.overrideWith((ref) => locator<ScopeService>()),
  homeDashboardRepositoryProvider.overrideWith(
    (ref) => locator<HomeDashboardRepository>(),
  ),
];
