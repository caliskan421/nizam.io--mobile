import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/tables_server.dart';
import 'data/tables_api_repository.dart';
import 'domain/tables_repository.dart';

void registerTablesModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<TablesRepository>(
    () => ApiTablesRepository(apiDio),
  );
}

List<Override> tablesOverrides(GetIt locator) => [
  tablesRepositoryProvider.overrideWith((ref) => locator<TablesRepository>()),
];
