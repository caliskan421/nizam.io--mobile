// coordinatorships data: silme etki önizlemesi (`GET /v1/departments/{id}/delete-impact`)
// → DepartmentDeleteImpact (program satırları, engeller), hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/coordinatorships/data/department_api_repository.dart';

import '../../tasks/data/work_fake_dio.dart';

(ApiDepartmentRepository, FakeAdapter) _repo(Object body, {int status = 200}) {
  final adapter = FakeAdapter(jsonEncode(body), status);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (ApiDepartmentRepository(() => dio), adapter);
}

void main() {
  test('etki önizlemesi domaine eşlenir', () async {
    final (repo, a) = _repo({
      'department_id': 'd1',
      'name': 'Altyapı',
      'deleted': true,
      'programs': [
        {
          'program_id': 'p1',
          'program_name': null,
          'department_name': null,
          'linked': false,
          'active_items': 0,
          'completed_items': 0,
          'deleted_items': 4,
          'deleted_with_department': 3,
        },
      ],
      'active_items': 0,
      'completed_items': 0,
      'deleted_items': 4,
      'deleted_with_department': 3,
      'file_count': 2,
      'member_count': 5,
      'meeting_count': 1,
      'permanent_blockers': {
        'tables': 1,
        'projects': 0,
        'pending_proposals': 2,
      },
      'permanent_blocked': true,
    });
    final i = await repo.deleteImpact('d1');
    expect(a.last.method, 'GET');
    expect(a.last.uri.path, '/v1/departments/d1/delete-impact');
    expect((i.departmentId, i.name, i.deleted), ('d1', 'Altyapı', true));
    final p = i.programs.single;
    expect((p.programId, p.programName, p.linked), ('p1', null, false));
    expect((p.deletedItems, p.deletedWithDepartment), (4, 3));
    expect((i.fileCount, i.memberCount, i.meetingCount), (2, 5, 1));
    expect(
      (i.blockers.tables, i.blockers.projects, i.blockers.pendingProposals),
      (1, 0, 2),
    );
    expect(i.permanentBlocked, isTrue);
    expect(i.allItems, 4);
  });

  test('hata → ApiError', () async {
    final (repo, _) = _repo({
      'code': 'organization.not_authorized',
      'message': 'x',
      'request_id': 'r',
    }, status: 403);
    await expectLater(
      repo.deleteImpact('d1'),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          'organization.not_authorized',
        ),
      ),
    );
  });
}
