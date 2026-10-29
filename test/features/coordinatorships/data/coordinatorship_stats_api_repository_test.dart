// coordinatorships: CoordinatorshipStat DTO → CoordinatorshipStats eşleyicisi.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/coordinatorships/data/coordinatorship_stats_api_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200, this.headers = const {}]);

  final String body;
  final int status;
  final Map<String, List<String>> headers;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiCoordinatorshipStatsRepository, _Adapter) _repo(
  Object body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(jsonEncode(body), status, headers);
  return (
    ApiCoordinatorshipStatsRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

const _stat = {
  'department_id': 'd1',
  'name': 'Altyapı',
  'kind': 'koordinatorluk',
  'coordinators': [
    {'account_id': 'a1', 'full_name': 'Ayşe Kaya'},
  ],
  'total_tasks': 10,
  'completed_tasks': 4,
  'in_progress_tasks': 3,
  'not_started_tasks': 1,
  'overdue_tasks': 2,
  'completion_rate': 40.0,
  'member_count': 5,
  'meeting_count': 2,
  'last_activity_at': null,
};

void main() {
  test('GET …/coordinatorships → CoordinatorshipStats', () async {
    final (repo, adapter) = _repo({
      'coordinatorships': [_stat],
    });
    final slice = await repo.load();
    expect(
      adapter.seen.single.uri.path,
      '/v1/reports/dashboard/coordinatorships',
    );
    final s = slice.items.single;
    expect(s.code, 'd1');
    expect(s.name, 'Altyapı');
    expect(s.done, 4);
    expect(s.total, 10);
    expect(s.late, 2);
    expect(s.leads.single.id, 'a1');
    expect(s.leads.single.name, 'Ayşe Kaya');
    expect(s.leads.single.role, PersonRole.coordinator);
    expect(s.members, isEmpty, reason: 'sunucu yalnız member_count verir');
    expect(slice.truncated, isFalse);
  });

  test('X-Result-Truncated: true → kesilmiş', () async {
    final (repo, _) = _repo(
      {'coordinatorships': <Object>[]},
      headers: {
        'X-Result-Truncated': ['true'],
      },
    );
    final slice = await repo.load();
    expect(slice.items, isEmpty);
    expect(slice.truncated, isTrue);
  });

  test('reporting.not_authorized → ApiError', () async {
    final (repo, _) = _repo({
      'code': 'reporting.not_authorized',
      'message': 'x',
      'request_id': 'r',
    }, status: 403);
    await expectLater(
      repo.load(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          'reporting.not_authorized',
        ),
      ),
    );
  });
}
