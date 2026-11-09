import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/errors/api_error.dart';
import '../../core/providers.dart';
import 'application/assistant_controller.dart';
import 'data/assistant_api_repository.dart';
import 'domain/assistant_repository.dart';

void registerAssistantModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerFactory<AssistantRepository>(() {
    final dio = apiDio();
    if (dio == null) throw ApiError('client.scope_missing');
    return ApiAssistantRepository(dio);
  });
}

List<Override> assistantOverrides(GetIt locator) => [
  assistantRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return locator<AssistantRepository>();
  }),
];
