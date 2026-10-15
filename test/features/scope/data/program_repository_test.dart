// scope data katmanı: üretilmiş DTO → domain Program, liste kesilmesi, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/scope/data/program_repository.dart';
import 'package:nizamio/features/scope/domain/program.dart';

/// Tek yanıtlı sahte bağdaştırıcı; isteği kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200]);

  final String body;
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
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ProgramRepository, _Adapter) _repo(String body, {int status = 200}) {
  final adapter = _Adapter(body, status);
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

    test('üst sınıra (200) ulaşan liste kesilmiş sayılır', () async {
      final (repo, _) = _repo(_list(ProgramRepository.maxRows));
      expect((await repo.listPrograms()).truncated, isTrue);
      final (below, _) = _repo(_list(ProgramRepository.maxRows - 1));
      expect((await below.listPrograms()).truncated, isFalse);
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
        const Program(id: 'p1', name: 'Bir', year: 2026),
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
}
