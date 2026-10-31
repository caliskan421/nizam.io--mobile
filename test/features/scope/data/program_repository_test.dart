// scope data katmanı: üretilmiş DTO → domain Program, liste kesilmesi, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/scope/data/program_repository.dart';
import 'package:nizamio/features/scope/domain/my_department.dart';
import 'package:nizamio/features/scope/domain/program.dart';

/// Tek yanıtlı sahte bağdaştırıcı; isteği kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200, this.headers = const {}]);

  final String body;
  final int status;
  final Map<String, List<String>> headers;
  final List<RequestOptions> seen = [];
  Object? sent;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
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

(ProgramRepository, _Adapter) _repo(
  String body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(body, status, headers);
  return (
    ProgramRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

String _list(int n) => jsonEncode({
  'programs': [
    for (var i = 0; i < n; i++) {'program_id': 'p$i', 'name': 'Program $i'},
  ],
});

void main() {
  group('listPrograms', () {
    test('GET /v1/programs → domain Program listesi', () async {
      final (repo, adapter) = _repo(
        '{"programs":[{"program_id":"p1","name":"Bir"},'
        '{"program_id":"p2","name":"İki","year":2026}]}',
      );
      final slice = await repo.listPrograms();
      expect(slice.items, const [
        Program(id: 'p1', name: 'Bir'),
        Program(id: 'p2', name: 'İki', year: 2026),
      ]);
      expect(slice.truncated, isFalse);
      expect(slice.hasMore, isFalse);
      expect(adapter.seen.single.uri.path, '/v1/programs');
    });

    test('boş liste', () async {
      final (repo, _) = _repo('{"programs":[]}');
      final slice = await repo.listPrograms();
      expect(slice.items, isEmpty);
      expect(slice.truncated, isFalse);
    });

    test('X-Result-Truncated: true → kesilmiş', () async {
      final (repo, _) = _repo(
        _list(3),
        headers: {
          'X-Result-Truncated': ['true'],
        },
      );
      final slice = await repo.listPrograms();
      expect(slice.truncated, isTrue);
      expect(slice.items, hasLength(3));
    });

    test('başlık adı büyük/küçük harf duyarsız', () async {
      final (repo, _) = _repo(
        _list(1),
        headers: {
          'x-result-truncated': ['true'],
        },
      );
      expect((await repo.listPrograms()).truncated, isTrue);
    });

    test('başlık yok: 200 satır bile kesilmiş sayılmaz', () async {
      final (repo, _) = _repo(_list(ProgramRepository.maxRows));
      final slice = await repo.listPrograms();
      expect(slice.items, hasLength(ProgramRepository.maxRows));
      expect(slice.truncated, isFalse);
    });

    test('başlık değeri true değilse kesilmiş sayılmaz', () async {
      for (final value in ['false', 'TRUE', '1', '']) {
        final (repo, _) = _repo(
          _list(2),
          headers: {
            'X-Result-Truncated': [value],
          },
        );
        expect(
          (await repo.listPrograms()).truncated,
          isFalse,
          reason: 'değer "$value"',
        );
      }
    });

    test('başlık birden çok değer taşırsa kesilmiş sayılmaz', () async {
      final (repo, _) = _repo(
        _list(2),
        headers: {
          'X-Result-Truncated': ['true', 'true'],
        },
      );
      expect((await repo.listPrograms()).truncated, isFalse);
    });

    test('program.not_authorized → ApiError', () async {
      final (repo, _) = _repo(
        '{"code":"program.not_authorized","message":"x","request_id":"r"}',
        status: 403,
      );
      await expectLater(
        repo.listPrograms(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'program.not_authorized',
          ),
        ),
      );
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo('{"programs":null}');
      await expectLater(
        repo.listPrograms(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.invalidResponse,
          ),
        ),
      );
    });
  });

  group('readProgram', () {
    test('GET /v1/program → domain Program', () async {
      final (repo, adapter) = _repo(
        '{"program_id":"p1","name":"Bir","year":2026,"description":"d"}',
      );
      expect(
        await repo.readProgram(),
        const Program(id: 'p1', name: 'Bir', year: 2026, description: 'd'),
      );
      expect(adapter.seen.single.uri.path, '/v1/program');
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        '{"code":"platform.not_found","message":"x","request_id":"r"}',
        status: 404,
      );
      await expectLater(repo.readProgram(), throwsA(isA<ApiError>()));
    });
  });

  group('myDepartments', () {
    test('GET /v1/me/departments → MyDepartment; rol eşlemesi', () async {
      final (repo, adapter) = _repo(
        '{"departments":[{"program_id":"p1","program_name":"P","department_id":"d1","display_name":"Altyapı","role":"koordinator"},'
        '{"program_id":"p1","program_name":"P","department_id":"d2","display_name":"Basın","role":"uye"}]}',
      );
      final slice = await repo.myDepartments();
      expect(slice.items, const [
        MyDepartment(
          id: 'd1',
          name: 'Altyapı',
          role: DepartmentRole.coordinator,
        ),
        MyDepartment(id: 'd2', name: 'Basın', role: DepartmentRole.member),
      ]);
      expect(slice.truncated, isFalse);
      expect(adapter.seen.single.method, 'GET');
      expect(adapter.seen.single.uri.path, '/v1/me/departments');
    });

    test('tanımsız rol → unknown (hata yok)', () async {
      final (repo, _) = _repo(
        '{"departments":[{"program_id":"p1","program_name":"P","department_id":"d1","display_name":"A","role":"yonetici"}]}',
      );
      expect(
        (await repo.myDepartments()).items.single.role,
        DepartmentRole.unknown,
      );
    });

    test('departments: null → boş liste; kesilme başlığı okunur', () async {
      final (repo, _) = _repo(
        '{"departments":null}',
        headers: {
          'X-Result-Truncated': ['true'],
        },
      );
      final slice = await repo.myDepartments();
      expect(slice.items, isEmpty);
      expect(slice.truncated, isTrue);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        '{"code":"organization.authority_unavailable","message":"x","request_id":"r"}',
        status: 503,
      );
      await expectLater(
        repo.myDepartments(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'organization.authority_unavailable',
          ),
        ),
      );
    });
  });

  group('linkDepartment', () {
    test('POST /v1/program/departments: gövde ve eşleme', () async {
      final (repo, adapter) = _repo(
        '{"program_id":"p1","department_id":"d1","display_name":"Altyapı","copied_member_count":0}',
      );
      final link = await repo.linkDepartment('d1');
      expect(
        link,
        const ProgramDepartmentLink(programId: 'p1', departmentId: 'd1'),
      );
      expect(adapter.seen.single.method, 'POST');
      expect(adapter.seen.single.uri.path, '/v1/program/departments');
      expect(adapter.sent, {'department_id': 'd1'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        '{"code":"organization.department_not_found","message":"x","request_id":"r"}',
        status: 404,
      );
      await expectLater(
        repo.linkDepartment('d9'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'organization.department_not_found',
          ),
        ),
      );
    });
  });
}
