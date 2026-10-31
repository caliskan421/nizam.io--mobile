// coordinatorships data katmanı: organization departman/üyelik uçları → domain, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/coordinatorships/data/department_api_repository.dart';
import 'package:nizamio/features/coordinatorships/domain/department.dart';
import 'package:nizamio/features/scope/scope.dart' show DepartmentRole;

/// Tek yanıtlı sahte bağdaştırıcı; isteği ve JSON gövdesini kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, this.status, this.headers);

  final String body;
  final int status;
  final Map<String, List<String>> headers;
  RequestOptions? seen;
  Object? sent;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen = options;
    if (requestStream != null) {
      final bytes = await requestStream.expand((c) => c).toList();
      if (bytes.isNotEmpty) sent = jsonDecode(utf8.decode(bytes));
    }
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

(ApiDepartmentRepository, _Adapter) _repo(
  String body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(body, status, headers);
  return (
    ApiDepartmentRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

const _truncated = {
  'X-Result-Truncated': ['true'],
};

Matcher _apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

String _err(String code) => '{"code":"$code","message":"x","request_id":"r"}';

const _change = '{"membership_id":"m1","unassigned_tasks":2,"warning":true}';

void main() {
  group('listDepartments', () {
    test('GET /v1/departments → Department; tür eşlemesi', () async {
      final (repo, a) = _repo(
        '{"departments":[{"department_id":"d1","name":"Altyapı",'
        '"kind":"koordinatorluk","code":"ALT","description":"açıklama"},'
        '{"department_id":"d2","name":"Grup","kind":"calisma_grubu"}]}',
      );
      final slice = await repo.listDepartments();
      expect(slice.items, const [
        Department(
          id: 'd1',
          name: 'Altyapı',
          kind: DepartmentKind.coordinatorship,
          code: 'ALT',
          description: 'açıklama',
        ),
        Department(id: 'd2', name: 'Grup', kind: DepartmentKind.workingGroup),
      ]);
      expect(slice.truncated, isFalse);
      expect(a.seen!.method, 'GET');
      expect(a.seen!.uri.path, '/v1/departments');
    });

    test('tanımsız tür → unknown; kesilme başlığı', () async {
      final (repo, _) = _repo(
        '{"departments":[{"department_id":"d1","name":"A","kind":"yeni"}]}',
        headers: _truncated,
      );
      final slice = await repo.listDepartments();
      expect(slice.items.single.kind, DepartmentKind.unknown);
      expect(slice.truncated, isTrue);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.not_authorized'), status: 403);
      await expectLater(
        repo.listDepartments(),
        _apiError('organization.not_authorized'),
      );
    });
  });

  group('createDepartment', () {
    test('POST /v1/departments: gövde ve eşleme', () async {
      final (repo, a) = _repo(
        '{"department_id":"d1","name":"Altyapı","kind":"calisma_grubu"}',
      );
      final d = await repo.createDepartment(
        name: 'Altyapı',
        kind: DepartmentKind.workingGroup,
        code: 'ALT',
      );
      expect(d.id, 'd1');
      expect(d.kind, DepartmentKind.workingGroup);
      expect(a.seen!.method, 'POST');
      expect(a.sent, {
        'name': 'Altyapı',
        'kind': 'calisma_grubu',
        'code': 'ALT',
      });
    });

    test('unknown tür gönderilmez (ArgumentError, istek yok)', () async {
      final (repo, a) = _repo('{}');
      await expectLater(
        repo.createDepartment(name: 'x', kind: DepartmentKind.unknown),
        throwsArgumentError,
      );
      expect(a.seen, isNull);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.input_invalid'), status: 422);
      await expectLater(
        repo.createDepartment(name: '', kind: DepartmentKind.coordinatorship),
        _apiError('organization.input_invalid'),
      );
    });
  });

  group('updateDepartment', () {
    test('PATCH /v1/departments/{id}: yalnız verilen alanlar', () async {
      final (repo, a) = _repo(
        '{"department_id":"d1","name":"Yeni","kind":"koordinatorluk"}',
      );
      final d = await repo.updateDepartment(
        'd1',
        name: 'Yeni',
        kind: DepartmentKind.coordinatorship,
      );
      expect(d.name, 'Yeni');
      expect(a.seen!.method, 'PATCH');
      expect(a.seen!.uri.path, '/v1/departments/d1');
      expect(a.sent, {'name': 'Yeni', 'kind': 'koordinatorluk'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.department_not_found'),
        status: 404,
      );
      await expectLater(
        repo.updateDepartment('d9', name: 'x'),
        _apiError('organization.department_not_found'),
      );
    });
  });

  group('deleteDepartment', () {
    test('DELETE /v1/departments/{id} → deleted', () async {
      final (repo, a) = _repo('{"department_id":"d1","deleted":true}');
      expect(await repo.deleteDepartment('d1'), isTrue);
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/departments/d1');
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.conflict'), status: 409);
      await expectLater(
        repo.deleteDepartment('d1'),
        _apiError('organization.conflict'),
      );
    });
  });

  group('listMembers', () {
    test('GET members → TeamMember (rol, durum, lead)', () async {
      final (repo, a) = _repo(
        '{"members":[{"membership_id":"m1","account_id":"a1","full_name":"Ayşe",'
        '"role":"koordinator","status":"active"},'
        '{"membership_id":"m2","account_id":"a2","full_name":"Bora",'
        '"role":"uye","status":"deleted"}]}',
      );
      final slice = await repo.listMembers('d1');
      expect(a.seen!.uri.path, '/v1/departments/d1/members');
      final [lead, member] = slice.items;
      expect(lead.name, 'Ayşe');
      expect(lead.lead, isTrue);
      expect(lead.accountId, 'a1');
      expect(lead.membershipId, 'm1');
      expect(lead.role, DepartmentRole.coordinator);
      expect(lead.status, MemberStatus.active);
      expect(lead.unit, '');
      expect(member.lead, isFalse);
      expect(member.role, DepartmentRole.member);
      expect(member.status, MemberStatus.deleted);
    });

    test('bilinmeyen rol/durum → unknown; null liste; kesilme', () async {
      final (repo, _) = _repo(
        '{"members":[{"membership_id":"m1","account_id":"a1","full_name":"A",'
        '"role":"x","status":"suspended"}]}',
        headers: _truncated,
      );
      final slice = await repo.listMembers('d1');
      expect(slice.items.single.role, DepartmentRole.unknown);
      expect(slice.items.single.status, MemberStatus.unknown);
      expect(slice.items.single.lead, isFalse);
      expect(slice.truncated, isTrue);

      final (empty, _) = _repo('{"members":null}');
      expect((await empty.listMembers('d1')).items, isEmpty);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.not_authorized'), status: 403);
      await expectLater(
        repo.listMembers('d1'),
        _apiError('organization.not_authorized'),
      );
    });
  });

  group('assignMembership', () {
    test('POST memberships: gövde ve eşleme', () async {
      final (repo, a) = _repo(
        '{"membership_id":"m1","program_id":"p1","department_id":"d1","account_id":"a1","role":"uye"}',
      );
      final m = await repo.assignMembership(
        'd1',
        accountId: 'a1',
        role: DepartmentRole.member,
      );
      expect(
        m,
        const Membership(
          membershipId: 'm1',
          departmentId: 'd1',
          accountId: 'a1',
          role: DepartmentRole.member,
        ),
      );
      expect(a.seen!.uri.path, '/v1/departments/d1/memberships');
      expect(a.sent, {'account_id': 'a1', 'role': 'uye'});
    });

    test('unknown rol gönderilmez', () async {
      final (repo, a) = _repo('{}');
      await expectLater(
        repo.assignMembership(
          'd1',
          accountId: 'a1',
          role: DepartmentRole.unknown,
        ),
        throwsArgumentError,
      );
      expect(a.seen, isNull);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.membership_exists'),
        status: 409,
      );
      await expectLater(
        repo.assignMembership(
          'd1',
          accountId: 'a1',
          role: DepartmentRole.member,
        ),
        _apiError('organization.membership_exists'),
      );
    });
  });

  group('changeMembershipRole', () {
    test('PATCH: rol + onay gövdede; sonuç eşlemesi', () async {
      final (repo, a) = _repo(_change);
      final c = await repo.changeMembershipRole(
        'd1',
        'a1',
        role: DepartmentRole.coordinator,
        confirm: true,
      );
      expect(
        c,
        const MembershipChange(
          membershipId: 'm1',
          unassignedTasks: 2,
          warning: true,
        ),
      );
      expect(a.seen!.method, 'PATCH');
      expect(a.seen!.uri.path, '/v1/departments/d1/memberships/a1');
      expect(a.sent, {'role': 'koordinator', 'confirm': true});
    });

    test('onaysız: confirm gönderilmez', () async {
      final (repo, a) = _repo(_change);
      await repo.changeMembershipRole('d1', 'a1', role: DepartmentRole.member);
      expect(a.sent, {'role': 'uye'});
    });

    test('409 confirmation_required → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.confirmation_required'),
        status: 409,
      );
      await expectLater(
        repo.changeMembershipRole('d1', 'a1', role: DepartmentRole.member),
        _apiError('organization.confirmation_required'),
      );
    });
  });

  group('removeMember', () {
    test('DELETE: confirm=true sorguda', () async {
      final (repo, a) = _repo(_change);
      final c = await repo.removeMember('d1', 'a1', confirm: true);
      expect(c.unassignedTasks, 2);
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/departments/d1/memberships/a1');
      expect(a.seen!.uri.queryParameters, {'confirm': 'true'});
    });

    test('onaysız: sorgu yok', () async {
      final (repo, a) = _repo(_change);
      await repo.removeMember('d1', 'a1');
      expect(a.seen!.uri.queryParameters, isEmpty);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.confirmation_required'),
        status: 409,
      );
      await expectLater(
        repo.removeMember('d1', 'a1'),
        _apiError('organization.confirmation_required'),
      );
    });
  });

  group('listAssignable', () {
    test('GET assignable → AssignableAccount; null roller boş', () async {
      final (repo, a) = _repo(
        '{"accounts":[{"account_id":"a1","full_name":"Ayşe","roles":["Basın:uye"]},'
        '{"account_id":"a2","full_name":"Bora","roles":null}]}',
        headers: _truncated,
      );
      final slice = await repo.listAssignable('d1');
      expect(a.seen!.uri.path, '/v1/departments/d1/assignable');
      expect(slice.items.first.accountId, 'a1');
      expect(slice.items.first.fullName, 'Ayşe');
      expect(slice.items.first.roles, ['Basın:uye']);
      expect(slice.items.last.roles, isEmpty);
      expect(slice.truncated, isTrue);
    });

    test('accounts: null → boş', () async {
      final (repo, _) = _repo('{"accounts":null}');
      expect((await repo.listAssignable('d1')).items, isEmpty);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.not_authorized'), status: 403);
      await expectLater(
        repo.listAssignable('d1'),
        _apiError('organization.not_authorized'),
      );
    });
  });

  group('assignCoordinator', () {
    test('POST coordinator: gövde; changed taşınır', () async {
      final (repo, a) = _repo(
        '{"membership_id":"m1","department_id":"d1","account_id":"a1",'
        '"role":"koordinator","changed":false}',
      );
      final m = await repo.assignCoordinator('d1', 'a1');
      expect(m.role, DepartmentRole.coordinator);
      expect(m.changed, isFalse);
      expect(a.seen!.uri.path, '/v1/departments/d1/coordinator');
      expect(a.sent, {'account_id': 'a1'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.account_not_found'),
        status: 404,
      );
      await expectLater(
        repo.assignCoordinator('d1', 'a9'),
        _apiError('organization.account_not_found'),
      );
    });
  });

  group('removeCoordinator', () {
    test('DELETE coordinator/{accountId}: confirm sorguda', () async {
      final (repo, a) = _repo(_change);
      final c = await repo.removeCoordinator('d1', 'a1', confirm: true);
      expect(c.warning, isTrue);
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/departments/d1/coordinator/a1');
      expect(a.seen!.uri.queryParameters, {'confirm': 'true'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.confirmation_required'),
        status: 409,
      );
      await expectLater(
        repo.removeCoordinator('d1', 'a1'),
        _apiError('organization.confirmation_required'),
      );
    });
  });

  group('taskSummary', () {
    test('GET task-summary → DepartmentTaskSummary', () async {
      final (repo, a) = _repo(
        '{"department_id":"d1","active_items":4,"completed_items":6}',
      );
      expect(
        await repo.taskSummary('d1'),
        const DepartmentTaskSummary(
          departmentId: 'd1',
          activeItems: 4,
          completedItems: 6,
        ),
      );
      expect(a.seen!.uri.path, '/v1/departments/d1/task-summary');
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo('{"department_id":"d1"}');
      await expectLater(
        repo.taskSummary('d1'),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });
}
