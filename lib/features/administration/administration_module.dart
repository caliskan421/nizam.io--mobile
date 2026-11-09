import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/errors/api_error.dart';
import '../../core/providers.dart';
import 'application/admin_controller.dart';
import 'data/organization_admin_api_repository.dart';
import 'data/program_admin_api_repository.dart';
import 'domain/organization_admin_repository.dart';
import 'domain/program_admin_repository.dart';

void registerAdministrationModule(
  GetIt locator, {
  required Dio? Function() apiDio,
}) {
  Dio current() {
    final dio = apiDio();
    if (dio == null) throw ApiError('client.scope_missing');
    return dio;
  }

  locator.registerFactory<OrganizationAdminRepository>(
    () => ApiOrganizationAdminRepository(current()),
  );
  locator.registerFactory<ProgramAdminRepository>(
    () => ApiProgramAdminRepository(current()),
  );
}

List<Override> administrationOverrides(GetIt locator) => [
  organizationAdminRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return locator<OrganizationAdminRepository>();
  }),
  programAdminRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return locator<ProgramAdminRepository>();
  }),
];
