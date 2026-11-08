import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/archive_providers.dart';
import 'data/records_api_repository.dart';
import 'domain/archive.dart';

/// archive modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerArchiveModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<ArchiveRepository>(
    () => ApiRecordsRepository(apiDio),
  );
}

/// archive'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> archiveOverrides(GetIt locator) => [
  archiveRepositoryProvider.overrideWith((ref) => locator<ArchiveRepository>()),
];
