import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/server/server_binding.dart';
import '../../core/session/session_controller.dart';
import 'application/identity_providers.dart';
import 'application/identity_service.dart';
import 'data/identity_repository.dart';

/// identity modülünün kayıt fonksiyonu (ADR-0001, D-0182). YALNIZ bileşim kökünden
/// (`lib/app/di/`) çağrılır (sınır kuralı G2); katmanlar get_it'i görmez — bağımlılıklar
/// yapıcıdan gelir.
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerIdentityModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<IdentityService>(
    () => IdentityService(
      binding: locator<ServerBindingController>(),
      session: locator<SessionController>(),
      repository: () {
        final dio = apiDio();
        return dio == null ? null : IdentityRepository(dio);
      },
    ),
  );
}

/// identity'nin Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> identityOverrides(GetIt locator) => [
  identityServiceProvider.overrideWith((ref) => locator<IdentityService>()),
];
