import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/scope/scope_controller.dart';
import 'application/coordinatorships_providers.dart';
import 'data/coordinatorship_activity_api_repository.dart';
import 'data/coordinatorship_profile_api_repository.dart';
import 'domain/coordinatorship_board.dart';
import 'domain/coordinatorship_profile.dart';

/// coordinatorships modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerCoordinatorshipsModule(
  GetIt locator, {
  required Dio? Function() apiDio,
}) {
  locator
    // Departman kaydı (tür, açıklama): sunucu, yalnız şirket yöneticisinde okunur.
    ..registerLazySingleton<CoordinatorshipProfileRepository>(
      () => ApiCoordinatorshipProfileRepository(apiDio),
    )
    // Toplantı ve arşiv: sunucu (seçili program).
    ..registerLazySingleton<CoordinatorshipActivityRepository>(
      () => ApiCoordinatorshipActivityRepository(
        dio: apiDio,
        programId: () => locator<ScopeController>().current.programId,
      ),
    );
}

/// coordinatorships'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> coordinatorshipsOverrides(GetIt locator) => [
  coordinatorshipProfileRepositoryProvider.overrideWith(
    (ref) => locator<CoordinatorshipProfileRepository>(),
  ),
  coordinatorshipActivityRepositoryProvider.overrideWith(
    (ref) => locator<CoordinatorshipActivityRepository>(),
  ),
];
