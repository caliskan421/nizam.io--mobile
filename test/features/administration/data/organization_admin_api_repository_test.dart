// administration data katmanı: organization yönetim uçları → domain, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/administration/data/organization_admin_api_repository.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart'
    show DepartmentKind;
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

(ApiOrganizationAdminRepository, _Adapter) _repo(
  String body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(body, status, headers);
  return (
    ApiOrganizationAdminRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

Matcher _apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

String _err(String code) => '{"code":"$code","message":"x","request_id":"r"}';

void main() {
  group('listUsers', () {
    test('GET /v1/admin/users: süzgeç/sıralama/sayfa sorguda; imleç', () async {
      final (repo, a) = _repo(
        '{"users":[{"account_id":"a1","full_name":"Ayşe","memberships":["Basın:uye"]},'
        '{"account_id":"a2","full_name":"Bora","memberships":null}],'
        '"next_cursor":"c2"}',
      );
      final slice = await repo.listUsers(
        page: const PageRequest(limit: 20, cursor: 'c1'),
        role: DepartmentRole.coordinator,
        search: 'ay',
        sortBy: UserSortField.createdAt,
        sortOrder: SortDirection.desc,
      );
      expect(a.seen!.uri.path, '/v1/admin/users');
      expect(a.seen!.uri.queryParameters, {
        'role': 'koordinator',
        'search': 'ay',
        'sort_by': 'created_at',
        'sort_order': 'desc',
        'limit': '20',
        'cursor': 'c1',
      });
      expect(slice.items.first.accountId, 'a1');
      expect(slice.items.first.fullName, 'Ayşe');
      expect(slice.items.first.memberships, ['Basın:uye']);
      expect(slice.items.last.memberships, isEmpty);
      expect(slice.nextCursor, 'c2');
      expect(slice.hasMore, isTrue);
      expect(slice.truncated, isFalse);
    });

    test('süzgeçsiz: sorgu boş; users null → boş; son sayfa', () async {
      final (repo, a) = _repo('{"users":null}');
      final slice = await repo.listUsers();
      expect(a.seen!.uri.queryParameters, isEmpty);
      expect(slice.items, isEmpty);
      expect(slice.hasMore, isFalse);
    });

    test('unknown rol gönderilmez', () async {
      final (repo, a) = _repo('{}');
      await expectLater(
        repo.listUsers(role: DepartmentRole.unknown),
        throwsArgumentError,
      );
      expect(a.seen, isNull);
    });

    test('geçersiz imleç → ApiError', () async {
      final (repo, _) = _repo(_err('identity.invalid_cursor'), status: 422);
      await expectLater(
        repo.listUsers(page: const PageRequest(cursor: 'eski')),
        _apiError('identity.invalid_cursor'),
      );
    });
  });

  group('createUser', () {
    test('POST /v1/admin/users: gövde; eksik alanlar varsayılan', () async {
      final (repo, a) = _repo('{"account_id":"a1","created":true}');
      final r = await repo.createUser(
        email: 'a@b.c',
        programId: 'p1',
        departmentId: 'd1',
        fullName: 'Ayşe',
        role: DepartmentRole.member,
        companyAdmin: false,
      );
      expect(a.seen!.method, 'POST');
      expect(a.sent, {
        'email': 'a@b.c',
        'program_id': 'p1',
        'department_id': 'd1',
        'full_name': 'Ayşe',
        'role': 'uye',
        'company_admin': false,
      });
      expect(r.accountId, 'a1');
      expect(r.created, isTrue);
      expect(r.transferred, isFalse);
      expect(r.membershipId, isNull);
      expect(r.changedFields, isEmpty);
      expect(r.revokedSessions, 0);
    });

    test('aktarım: transfer_account_id gider', () async {
      final (repo, a) = _repo(
        '{"account_id":"a1","membership_id":"m1","transferred":true}',
      );
      final r = await repo.createUser(
        email: 'a@b.c',
        programId: 'p1',
        departmentId: 'd1',
        transferAccountId: 'a1',
      );
      expect(a.sent, {
        'email': 'a@b.c',
        'program_id': 'p1',
        'department_id': 'd1',
        'transfer_account_id': 'a1',
      });
      expect(r.transferred, isTrue);
      expect(r.membershipId, 'm1');
    });

    test('unknown rol gönderilmez', () async {
      final (repo, a) = _repo('{}');
      await expectLater(
        repo.createUser(
          email: 'a@b.c',
          programId: 'p1',
          departmentId: 'd1',
          role: DepartmentRole.unknown,
        ),
        throwsArgumentError,
      );
      expect(a.seen, isNull);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('identity.account_exists'), status: 409);
      await expectLater(
        repo.createUser(email: 'a@b.c', programId: 'p1', departmentId: 'd1'),
        _apiError('identity.account_exists'),
      );
    });
  });

  group('updateUser', () {
    test('PATCH /v1/admin/users/{id}: değişen alanlar ve oturumlar', () async {
      final (repo, a) = _repo(
        '{"account_id":"a1","changed_fields":["email"],"revoked_sessions":2}',
      );
      final r = await repo.updateUser(
        'a1',
        email: 'y@b.c',
        resetPassword: true,
      );
      expect(a.seen!.method, 'PATCH');
      expect(a.seen!.uri.path, '/v1/admin/users/a1');
      expect(a.sent, {'email': 'y@b.c', 'reset_password': true});
      expect(r.changedFields, ['email']);
      expect(r.revokedSessions, 2);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.account_not_found'),
        status: 404,
      );
      await expectLater(
        repo.updateUser('a9', fullName: 'x'),
        _apiError('organization.account_not_found'),
      );
    });
  });

  group('deleteUser', () {
    test('DELETE /v1/admin/users/{id}', () async {
      final (repo, a) = _repo('{"account_id":"a1"}');
      expect((await repo.deleteUser('a1')).accountId, 'a1');
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/admin/users/a1');
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.not_authorized'), status: 403);
      await expectLater(
        repo.deleteUser('a1'),
        _apiError('organization.not_authorized'),
      );
    });
  });

  group('openAccount', () {
    test('POST /v1/admin/accounts: parola yalnız gövdede', () async {
      final (repo, a) = _repo('{"account_id":"a1"}');
      final r = await repo.openAccount(
        email: 'a@b.c',
        password: 'gizli-p',
        forcePasswordChange: true,
      );
      expect(a.seen!.uri.path, '/v1/admin/accounts');
      expect(a.sent, {
        'email': 'a@b.c',
        'password': 'gizli-p',
        'force_password_change': true,
      });
      expect(r, const AccountChange(accountId: 'a1'));
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('identity.account_exists'), status: 409);
      await expectLater(
        repo.openAccount(email: 'a@b.c', password: 'p'),
        _apiError('identity.account_exists'),
      );
    });
  });

  group('updateAccount', () {
    test('PATCH /v1/admin/accounts/{id} → revoked_sessions', () async {
      final (repo, a) = _repo('{"account_id":"a1","revoked_sessions":3}');
      final r = await repo.updateAccount('a1', password: 'yeni-p');
      expect(a.seen!.method, 'PATCH');
      expect(a.seen!.uri.path, '/v1/admin/accounts/a1');
      expect(a.sent, {'password': 'yeni-p'});
      expect(r, const AccountChange(accountId: 'a1', revokedSessions: 3));
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.account_not_found'),
        status: 404,
      );
      await expectLater(
        repo.updateAccount('a9', fullName: 'x'),
        _apiError('organization.account_not_found'),
      );
    });
  });

  group('deleteAccount / unlockAccount', () {
    test('DELETE /v1/admin/accounts/{id}', () async {
      final (repo, a) = _repo('{"account_id":"a1","revoked_sessions":1}');
      expect(
        await repo.deleteAccount('a1'),
        const AccountChange(accountId: 'a1', revokedSessions: 1),
      );
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/admin/accounts/a1');
    });

    test('POST /v1/admin/accounts/{id}/unlock', () async {
      final (repo, a) = _repo('{"account_id":"a1"}');
      expect(
        await repo.unlockAccount('a1'),
        const AccountChange(accountId: 'a1'),
      );
      expect(a.seen!.method, 'POST');
      expect(a.seen!.uri.path, '/v1/admin/accounts/a1/unlock');
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('organization.not_authorized'), status: 403);
      await expectLater(
        repo.unlockAccount('a1'),
        _apiError('organization.not_authorized'),
      );
      final (repo2, _) = _repo(
        _err('organization.account_not_found'),
        status: 404,
      );
      await expectLater(
        repo2.deleteAccount('a1'),
        _apiError('organization.account_not_found'),
      );
    });
  });

  group('resetLockouts', () {
    test('POST /v1/admin/security/reset-lockouts', () async {
      final (repo, a) = _repo('{"accounts_reset":2,"attempts_cleared":9}');
      expect(
        await repo.resetLockouts(),
        const LockoutReset(accountsReset: 2, attemptsCleared: 9),
      );
      expect(a.seen!.uri.path, '/v1/admin/security/reset-lockouts');
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo('{"accounts_reset":2}');
      await expectLater(
        repo.resetLockouts(),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  group('silinmiş departmanlar', () {
    test('GET /v1/admin/deleted/departments: eşleme, imleç', () async {
      final (repo, a) = _repo(
        '{"departments":[{"department_id":"d1","name":"Altyapı",'
        '"kind":"koordinatorluk","deleted_at":"2026-10-01T08:00:00Z","code":"ALT"},'
        '{"department_id":"d2","name":"X","kind":"??","deleted_at":""}],'
        '"next_cursor":"n"}',
      );
      final slice = await repo.listDeletedDepartments(
        page: const PageRequest(limit: 5),
      );
      expect(a.seen!.uri.path, '/v1/admin/deleted/departments');
      expect(a.seen!.uri.queryParameters, {'limit': '5'});
      expect(
        slice.items.first,
        DeletedDepartment(
          departmentId: 'd1',
          name: 'Altyapı',
          kind: DepartmentKind.coordinatorship,
          deletedAt: DateTime.utc(2026, 10, 1, 8),
          code: 'ALT',
        ),
      );
      expect(slice.items.last.kind, DepartmentKind.unknown);
      expect(slice.items.last.deletedAt, isNull);
      expect(slice.nextCursor, 'n');
    });

    test(
      'restore → restored; permanent → purged; bilinmeyen → unknown',
      () async {
        final (r1, a1) = _repo('{"department_id":"d1","status":"restored"}');
        expect(await r1.restoreDepartment('d1'), LifecycleStatus.restored);
        expect(a1.seen!.method, 'PATCH');
        expect(a1.seen!.uri.path, '/v1/admin/restore/departments/d1');

        final (r2, a2) = _repo('{"department_id":"d1","status":"purged"}');
        expect(
          await r2.permanentDeleteDepartment('d1'),
          LifecycleStatus.purged,
        );
        expect(a2.seen!.method, 'DELETE');
        expect(a2.seen!.uri.path, '/v1/admin/permanent/departments/d1');

        final (r3, _) = _repo('{"department_id":"d1","status":"archived"}');
        expect(await r3.restoreDepartment('d1'), LifecycleStatus.unknown);
      },
    );

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.department_not_found'),
        status: 404,
      );
      await expectLater(
        repo.permanentDeleteDepartment('d9'),
        _apiError('organization.department_not_found'),
      );
      final (repo2, _) = _repo(_err('identity.invalid_cursor'), status: 422);
      await expectLater(
        repo2.listDeletedDepartments(),
        _apiError('identity.invalid_cursor'),
      );
    });
  });

  group('silinmiş hesaplar', () {
    test('GET /v1/admin/deleted/accounts: eşleme, son sayfa', () async {
      final (repo, a) = _repo(
        '{"accounts":[{"account_id":"a1","full_name":"Ayşe"}]}',
      );
      final slice = await repo.listDeletedAccounts(
        page: const PageRequest(cursor: 'c'),
      );
      expect(a.seen!.uri.path, '/v1/admin/deleted/accounts');
      expect(a.seen!.uri.queryParameters, {'cursor': 'c'});
      expect(slice.items, const [
        DeletedAccount(accountId: 'a1', fullName: 'Ayşe'),
      ]);
      expect(slice.hasMore, isFalse);
    });

    test('restore / permanent', () async {
      final (r1, a1) = _repo('{"account_id":"a1","status":"restored"}');
      expect(await r1.restoreAccount('a1'), LifecycleStatus.restored);
      expect(a1.seen!.method, 'PATCH');
      expect(a1.seen!.uri.path, '/v1/admin/restore/accounts/a1');

      final (r2, a2) = _repo('{"account_id":"a1","status":"purged"}');
      expect(await r2.permanentDeleteAccount('a1'), LifecycleStatus.purged);
      expect(a2.seen!.method, 'DELETE');
      expect(a2.seen!.uri.path, '/v1/admin/permanent/accounts/a1');
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('organization.account_not_found'),
        status: 404,
      );
      await expectLater(
        repo.restoreAccount('a9'),
        _apiError('organization.account_not_found'),
      );
    });
  });
}
