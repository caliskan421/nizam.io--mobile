import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/archive_providers.dart';
import 'data/sample/sample_archive_repository.dart';
import 'domain/archive.dart';

/// archive modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerArchiveModule(GetIt locator) {
  // GEÇİCİ: arşiv backend'de hazır olana kadar geliştirme örneği; gerçek kaynak geldiğinde
  // yalnız bu kayıt değişir.
  locator.registerLazySingleton<ArchiveRepository>(SampleArchiveRepository.new);
}

/// archive'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> archiveOverrides(GetIt locator) => [
  archiveRepositoryProvider.overrideWith((ref) => locator<ArchiveRepository>()),
];
