// tasks data katmanı: tarih talebi uçları → DateChangeRequest / CountedList, karar gövdesi,
// bilinmeyen durum → unknown, hata → ApiError.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/date_change_request_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

import 'work_fake_dio.dart';

Map<String, Object?> _req(
  String id, {
  String status = 'pending',
  String? reason,
}) => {
  'request_id': id,
  'work_item_id': 'w1',
  'status': status,
  'old_start_on': '2026-11-01',
  'new_start_on': '2026-11-03',
  'old_end_on': '2026-11-10',
  'new_end_on': '2026-11-20',
  'reason': ?reason,
};

(ApiDateChangeRequestRepository, FakeAdapter) _repo(
  Object body, {
  int status = 200,
}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiDateChangeRequestRepository(dio), adapter);
}

void main() {
  test('request: POST gövdesi → DateChangeRequest', () async {
    final (repo, a) = _repo(_req('r1', reason: 'gecikme'));
    final r = await repo.request(
      workItemId: 'w1',
      start: DateTime(2026, 11, 3),
      due: DateTime(2026, 11, 20),
      reason: 'gecikme',
    );
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/date-change-requests');
    final body = a.sentJson! as Map;
    expect(body['work_item_id'], 'w1');
    expect(body['reason'], 'gecikme');
    expect(body['new_start_on'] as String, startsWith('2026-11-03'));
    expect(body['new_end_on'] as String, startsWith('2026-11-20'));
    expect(r.id, 'r1');
    expect(r.workItemId, 'w1');
    expect(r.oldStart, DateTime(2026, 11, 1));
    expect(r.oldDue, DateTime(2026, 11, 10));
    expect(r.start, DateTime(2026, 11, 3));
    expect(r.due, DateTime(2026, 11, 20));
    expect(r.reason, 'gecikme');
    expect(r.state, DateRequestState.pending);
    expect(r.by, isNull);
    expect(r.at, isNull);
  });

  test('request: yalnız K → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_authorized'), status: 403);
    await expectLater(
      repo.request(
        workItemId: 'w1',
        start: DateTime(2026),
        due: DateTime(2026),
      ),
      throwsApiError('work.not_authorized'),
    );
  });

  test('list: pendingOnly → status=pending; total sunucudan', () async {
    final (repo, a) = _repo({
      'requests': [_req('r1'), _req('r2', status: 'approved')],
      'total': 7,
    });
    final r = await repo.list(pendingOnly: true);
    expect(a.last.method, 'GET');
    expect(a.last.uri.path, '/v1/date-change-requests');
    expect(a.last.uri.queryParameters, {'status': 'pending'});
    expect(r.total, 7);
    expect(r.items.map((x) => x.state), [
      DateRequestState.pending,
      DateRequestState.approved,
    ]);
    expect(r.items.first.reason, '', reason: 'reason yoksa boş dize');
  });

  test('list: süzgeçsiz sorgu boş; bilinmeyen durum → unknown', () async {
    final (repo, a) = _repo({
      'requests': [
        _req('r1', status: 'expired'),
        _req('r2', status: 'rejected'),
      ],
      'total': 2,
    });
    final r = await repo.list();
    expect(a.last.uri.queryParameters, isEmpty);
    expect(r.items.map((x) => x.state), [
      DateRequestState.unknown,
      DateRequestState.rejected,
    ]);
  });

  test('mine: GET /mine', () async {
    final (repo, a) = _repo({'requests': <Object>[], 'total': 0});
    final r = await repo.mine();
    expect(a.last.uri.path, '/v1/date-change-requests/mine');
    expect(r.items, isEmpty);
    expect(r.total, 0);
  });

  test('review: karar gövdesi, etkilenen görev sayısı', () async {
    for (final (decision, wire) in [
      (DateRequestDecision.approve, 'approved'),
      (DateRequestDecision.reject, 'rejected'),
    ]) {
      final (repo, a) = _repo({'affected_tasks_count': 3});
      expect(await repo.review('r1', decision), 3);
      expect(a.last.method, 'POST');
      expect(a.last.uri.path, '/v1/date-change-requests/r1/review');
      expect(a.sentJson, {'decision': wire});
    }
  });

  test('review: hata → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.conflict'), status: 409);
    await expectLater(
      repo.review('r1', DateRequestDecision.approve),
      throwsApiError('work.conflict'),
    );
  });

  test('delete: DELETE', () async {
    final (repo, a) = _repo({'status': 'deleted'});
    await repo.delete('r1');
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/date-change-requests/r1');
  });
}
