import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/errors/api_error.dart';
import '../../core/providers.dart';
import 'application/gantt_provider.dart';
import 'data/gantt_api_repository.dart';
import 'data/timeline_dates_api_repository.dart';

/// timeline modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerTimelineModule(GetIt locator) {}

/// timeline'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> timelineOverrides(
  GetIt locator, {
  required Dio? Function() apiDio,
}) => [
  ganttRepositoryProvider.overrideWith((ref, scope) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    final dio = apiDio();
    if (dio == null) throw ApiError('client.scope_missing');
    return ApiGanttRepository(
      dio,
      programId: scope.program,
      departmentId: scope.department,
    );
  }),
  timelineDateRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    final dio = apiDio();
    if (dio == null) throw ApiError('client.scope_missing');
    return ApiTimelineDateRepository(dio);
  }),
];
