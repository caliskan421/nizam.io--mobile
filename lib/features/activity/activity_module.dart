import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/activity_providers.dart';
import 'domain/activity_log.dart';

/// activity modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerActivityModule(GetIt locator) {
  locator.registerLazySingleton<ActivityLogRepository>(
    UnavailableActivityLogRepository.new,
  );
}

/// activity'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> activityOverrides(GetIt locator) => [
  activityLogRepositoryProvider.overrideWith(
    (ref) => locator<ActivityLogRepository>(),
  ),
];
