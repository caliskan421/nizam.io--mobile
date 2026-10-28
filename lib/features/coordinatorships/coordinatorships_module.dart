import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/coordinatorships_providers.dart';
import 'data/sample/sample_coordinatorship_profile_repository.dart';
import 'domain/coordinatorship_profile.dart';

/// coordinatorships modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerCoordinatorshipsModule(GetIt locator) {
  // GEÇİCİ: koordinatörlük ek bilgileri backend'de hazır olana kadar geliştirme örneği.
  locator.registerLazySingleton<CoordinatorshipProfileRepository>(
    SampleCoordinatorshipProfileRepository.new,
  );
}

/// coordinatorships'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> coordinatorshipsOverrides(GetIt locator) => [
  coordinatorshipProfileRepositoryProvider.overrideWith(
    (ref) => locator<CoordinatorshipProfileRepository>(),
  ),
];
