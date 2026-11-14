import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/extend_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../tasks/tasks.dart';
import '../domain/timeline_dates.dart';

/// [TimelineDateRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. DTO'lar bu
/// katmanda kalır (A1); yanıt (yeni bitiş, sürüm) okunmaz, çağıran kataloğu yeniden okur.
class ApiTimelineDateRepository implements TimelineDateRepository {
  ApiTimelineDateRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  static String _program(TaskItem task) => task.programId ?? '';
  static String _dept(TaskItem task) => task.departmentId ?? '';

  @override
  Future<void> extend(TaskItem task, int days, {required String requestKey}) =>
      apiCall(
        () => _client.extendWorkItem(
          id: task.id,
          body: ExtendRequest(
            days: days,
            expectedDatesRevision: task.datesRevision,
          ),
          idempotencyKey: requestKey,
          extras: withScope(
            WorkClient.extendWorkItemOpenapiExtras,
            _program(task),
            _dept(task),
          ),
        ),
      );

  @override
  Future<void> pullEndDate(TaskItem task) => apiCall(
    () => _client.pullEndDate(
      id: task.id,
      extras: withScope(
        WorkClient.pullEndDateOpenapiExtras,
        _program(task),
        _dept(task),
      ),
    ),
  );
}
