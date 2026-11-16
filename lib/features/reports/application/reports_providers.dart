import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => throw UnimplementedError(),
);

final reportsProvider = FutureProvider((ref) async {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  if (!catalog.viewIn(ref.read(scopeStateProvider)).canAdminister) {
    throw ApiError('reporting.not_authorized');
  }
  final repository = ref.watch(reportsRepositoryProvider);
  final (season, workload, tasks, meetings) = await (
    repository.season(),
    repository.workload(),
    repository.dashboardTasks(),
    repository.dashboardMeetings(),
  ).wait;
  return (season: season, workload: workload, tasks: tasks, meetings: meetings);
});

final reportTaskProvider = FutureProvider.autoDispose.family((ref, String id) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref.watch(reportsRepositoryProvider).taskDetail(id);
});
final reportMeetingProvider = FutureProvider.autoDispose.family((
  ref,
  String id,
) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref.watch(reportsRepositoryProvider).meetingDetail(id);
});
