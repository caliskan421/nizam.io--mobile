import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/tables_providers.dart';
import 'data/table_api_repository.dart';
import 'data/table_reference_api_repository.dart';
import 'domain/table_reference_sources.dart';
import 'domain/tables_repository.dart';

/// tables modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerTablesModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<TablesRepository>(
    () => ApiTablesRepository(apiDio),
  );
  locator.registerLazySingleton<TableReferenceSources>(
    () => ApiTableReferenceSources(apiDio),
  );
}

/// tables'ın Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> tablesOverrides(GetIt locator) => [
  tablesRepositoryProvider.overrideWith((ref) => locator<TablesRepository>()),
  tableReferenceSourcesProvider.overrideWith(
    (ref) => locator<TableReferenceSources>(),
  ),
];
