import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/activity_providers.dart';
import 'data/audit_api_repository.dart';
import 'domain/activity_log.dart';

/// activity modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerActivityModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<ActivityLogRepository>(
    () => ApiActivityLogRepository(apiDio),
  );
}

/// activity'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> activityOverrides(GetIt locator) => [
  activityLogRepositoryProvider.overrideWith(
    (ref) => locator<ActivityLogRepository>(),
  ),
];
