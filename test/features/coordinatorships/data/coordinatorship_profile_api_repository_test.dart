// ApiCoordinatorshipProfileRepository: `GET /v1/departments` → [Department] listesi (tür,
// kod, açıklama; tanımsız tür unknown); bağ yoksa istek atılmaz; sunucu hatası ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart'
    show Department, DepartmentKind;
import 'package:nizamio/features/coordinatorships/data/coordinatorship_profile_api_repository.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200]);

  final Object body;
  final int status;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiCoordinatorshipProfileRepository, _Adapter) _repo(
  Object body, [
  int status = 200,
]) {
  final adapter = _Adapter(body, status);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (ApiCoordinatorshipProfileRepository(() => dio), adapter);
}

void main() {
  test(
    'departmanlar eşlenir: tür, kod, açıklama; tanımsız tür unknown',
    () async {
      final (repo, a) = _repo({
        'departments': [
          {
            'department_id': 'd1',
            'name': 'Altyapı',
            'kind': 'koordinatorluk',
            'code': 'ALT',
            'description': 'Su ve yapı',
          },
          {'department_id': 'd2', 'name': 'Gönüllü', 'kind': 'calisma_grubu'},
          {'department_id': 'd3', 'name': 'Yeni', 'kind': 'baska'},
        ],
      });
      final list = await repo.load();
      expect(a.seen.single.method, 'GET');
      expect(a.seen.single.uri.path, '/v1/departments');
      expect(list, const [
        Department(
          id: 'd1',
          name: 'Altyapı',
          kind: DepartmentKind.coordinatorship,
          code: 'ALT',
          description: 'Su ve yapı',
        ),
        Department(
          id: 'd2',
          name: 'Gönüllü',
          kind: DepartmentKind.workingGroup,
        ),
        Department(id: 'd3', name: 'Yeni', kind: DepartmentKind.unknown),
      ]);
    },
  );

  test('boş liste boş döner', () async {
    final (repo, _) = _repo({'departments': <Object>[]});
    expect(await repo.load(), isEmpty);
  });

  test('bağ yoksa istek atılmadan server_not_verified', () async {
    final repo = ApiCoordinatorshipProfileRepository(() => null);
    await expectLater(
      repo.load(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.serverNotVerified,
        ),
      ),
    );
  });

  test('yetkisiz (yönetici olmayan) 403 → ApiError', () async {
    final (repo, _) = _repo({
      'code': 'organization.not_authorized',
      'message': 'x',
      'request_id': 'r1',
    }, 403);
    await expectLater(
      repo.load(),
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
