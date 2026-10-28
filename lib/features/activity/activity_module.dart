import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/activity_providers.dart';
import 'data/sample/sample_activity_log_repository.dart';
import 'domain/activity_log.dart';

/// activity modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerActivityModule(GetIt locator) {
  // GEÇİCİ: işlem geçmişi backend'de hazır olana kadar geliştirme örneği.
  locator.registerLazySingleton<ActivityLogRepository>(
    SampleActivityLogRepository.new,
  );
}

/// activity'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> activityOverrides(GetIt locator) => [
  activityLogRepositoryProvider.overrideWith(
    (ref) => locator<ActivityLogRepository>(),
  ),
];
