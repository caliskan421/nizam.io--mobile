import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/date_change_request.dart' as api;
import '../../../core/api/generated/models/date_change_request_create.dart';
import '../../../core/api/generated/models/date_change_request_list.dart';
import '../../../core/api/generated/models/review_request.dart';
import '../../../core/api/generated/models/review_request_decision.dart';
import '../../../core/errors/api_error.dart';
import '../domain/task_catalog.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';
import 'work_item_mapping.dart';

/// [DateChangeRequestRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. Açma S3;
/// liste/inceleme/silme S1 (kapsam başlığı gönderilmez — ara katman `operationId`'den bilir).
class ApiDateChangeRequestRepository implements DateChangeRequestRepository {
  ApiDateChangeRequestRepository(Dio dio) : _client = WorkClient(dio);

  /// Sözleşmede "yalnız bekleyenler" süzgecinin tek değeri.
  static const pendingStatus = 'pending';

  final WorkClient _client;

  @override
  Future<DateChangeRequest> request({
    required String workItemId,
    required DateTime start,
    required DateTime due,
    String? reason,
  }) {
    final body = DateChangeRequestCreate(
      workItemId: workItemId,
      newStartOn: day(start),
      newEndOn: day(due),
      reason: reason,
    );
    return apiCall(
      () async =>
          _dateChangeRequest(await _client.requestDateChange(body: body)),
    );
  }

  @override
  Future<CountedList<DateChangeRequest>> list({bool pendingOnly = false}) =>
      apiCall(
        () async => _list(
          await _client.listDateChangeRequests(
            status: pendingOnly ? pendingStatus : null,
          ),
        ),
      );

  @override
  Future<CountedList<DateChangeRequest>> mine() =>
      apiCall(() async => _list(await _client.myDateChangeRequests()));

  @override
  Future<int> review(String requestId, DateRequestDecision decision) => apiCall(
    () async => (await _client.reviewDateChangeRequest(
      id: requestId,
      body: ReviewRequest(
        decision: switch (decision) {
          DateRequestDecision.approve => ReviewRequestDecision.fromJson(
            'approved',
          ),
          DateRequestDecision.reject => ReviewRequestDecision.fromJson(
            'rejected',
          ),
        },
      ),
    )).affectedTasksCount,
  );

  @override
  Future<void> delete(String requestId) =>
      apiCall(() => _client.deleteDateChangeRequest(id: requestId));

  static CountedList<DateChangeRequest> _list(DateChangeRequestList r) =>
      CountedList(
        items: r.requests.map(_dateChangeRequest).toList(),
        total: r.total,
      );
}

DateChangeRequest _dateChangeRequest(api.DateChangeRequest r) =>
    DateChangeRequest(
      id: r.requestId,
      workItemId: r.workItemId,
      oldStart: r.oldStartOn,
      oldDue: r.oldEndOn,
      start: r.newStartOn,
      due: r.newEndOn,
      reason: r.reason ?? '',
      state: dateRequestState(r.status.json),
    );
