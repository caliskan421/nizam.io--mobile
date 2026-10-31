// administration data katmanı: program yönetim ve aktarım uçları → domain, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/administration/data/program_admin_api_repository.dart';
import 'package:nizamio/features/administration/domain/program_admin.dart';
import 'package:nizamio/features/scope/scope.dart' show Program;

/// Tek yanıtlı sahte bağdaştırıcı; isteği ve JSON gövdesini kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, this.status);

  final String body;
  final int status;
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
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiProgramAdminRepository, _Adapter) _repo(String body, {int status = 200}) {
  final adapter = _Adapter(body, status);
  return (
    ApiProgramAdminRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

Matcher _apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

String _err(String code) => '{"code":"$code","message":"x","request_id":"r"}';

const _result =
    '{"transfer_id":"t1","moved_work_item_ids":["w1"],"moved_file_count":2,'
    '"cut_dependency_count":1,"restored_dependency_count":0,'
    '"granted_links":["g"],"revoked_links":[],"retained_links":["k"],'
    '"granted_memberships":[],"replayed":false}';

const _record =
    '{"transfer_id":"t1","source_program_id":"p1","target_program_id":"p2",'
    '"department_id":"d1","work_item_ids":["w1","w2"],"moved_item_count":2,'
    '"moved_file_count":3,"cut_dependency_count":1,"restored_dependency_count":0,'
    '"granted_memberships":[],'
    '"created_at":"2026-10-20T12:00:00Z","reverses_transfer_id":"t0"}';

void main() {
  group('createProgram', () {
    test('POST /v1/programs: yeni kayıt', () async {
      final (repo, a) = _repo(
        '{"program_id":"p1","name":"2027","year":2027,"created":true}',
      );
      final r = await repo.createProgram(name: '2027', year: 2027);
      expect(a.seen!.method, 'POST');
      expect(a.seen!.uri.path, '/v1/programs');
      expect(a.sent, {'name': '2027', 'year': 2027});
      expect(
        r,
        const ProgramCreation(
          program: Program(id: 'p1', name: '2027', year: 2027),
          created: true,
        ),
      );
    });

    test('aynı ad: created yok → false', () async {
      final (repo, _) = _repo('{"program_id":"p1","name":"2027"}');
      expect((await repo.createProgram(name: '2027')).created, isFalse);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('program.input_invalid'), status: 422);
      await expectLater(
        repo.createProgram(name: ''),
        _apiError('program.input_invalid'),
      );
    });
  });

  group('updateProgram', () {
    test('PATCH /v1/programs/{id}', () async {
      final (repo, a) = _repo(
        '{"program_id":"p1","name":"Yeni","description":"d"}',
      );
      expect(
        await repo.updateProgram('p1', name: 'Yeni', description: 'd'),
        const Program(id: 'p1', name: 'Yeni', description: 'd'),
      );
      expect(a.seen!.method, 'PATCH');
      expect(a.seen!.uri.path, '/v1/programs/p1');
      expect(a.sent, {'name': 'Yeni', 'description': 'd'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('program.not_found'), status: 404);
      await expectLater(
        repo.updateProgram('p9', name: 'x'),
        _apiError('program.not_found'),
      );
    });
  });

  group('deleteProgram / resetProgram', () {
    test('DELETE /v1/programs/{id}: parola gövdede', () async {
      final (repo, a) = _repo('');
      await repo.deleteProgram('p1', password: 'gizli-p');
      expect(a.seen!.method, 'DELETE');
      expect(a.seen!.uri.path, '/v1/programs/p1');
      expect(a.sent, {'password': 'gizli-p'});
    });

    test('POST /v1/programs/{id}/reset → ProgramReset', () async {
      final (repo, a) = _repo(
        '{"program_id":"p1","tasks":5,"files":4,"messages":3,"meetings":2}',
      );
      expect(
        await repo.resetProgram('p1', password: 'gizli-p'),
        const ProgramReset(
          programId: 'p1',
          tasks: 5,
          files: 4,
          messages: 3,
          meetings: 2,
        ),
      );
      expect(a.seen!.uri.path, '/v1/programs/p1/reset');
      expect(a.sent, {'password': 'gizli-p'});
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(
        _err('identity.credentials_invalid'),
        status: 401,
      );
      await expectLater(
        repo.deleteProgram('p1', password: 'yanlış'),
        _apiError('identity.credentials_invalid'),
      );
      final (repo2, _) = _repo(
        _err('identity.credentials_invalid'),
        status: 401,
      );
      await expectLater(
        repo2.resetProgram('p1', password: 'yanlış'),
        _apiError('identity.credentials_invalid'),
      );
    });
  });

  group('previewTransfer', () {
    test('POST /v1/program-transfers/preview: gövde ve eşleme', () async {
      final (repo, a) = _repo(
        '{"resolved_work_item_ids":["w1"],"file_count":2,"file_total_bytes":10,'
        '"preserved_dependency_count":1,"missing_access":true,'
        '"blockers":[],"warnings":["program.transfer_cut_dependency"],'
        '"can_execute":true,"preview_fingerprint":"fp",'
        '"cut_dependency_ids":["dep1"],"granted_memberships":[]}',
      );
      final p = await repo.previewTransfer(
        sourceProgramId: 'p1',
        targetProgramId: 'p2',
        departmentId: 'd1',
        workItemIds: ['w1'],
      );
      expect(a.seen!.uri.path, '/v1/program-transfers/preview');
      expect(a.sent, {
        'source_program_id': 'p1',
        'target_program_id': 'p2',
        'department_id': 'd1',
        'work_item_ids': ['w1'],
      });
      expect(p.resolvedWorkItemIds, ['w1']);
      expect(p.fileCount, 2);
      expect(p.fileTotalBytes, 10);
      expect(p.preservedDependencyCount, 1);
      expect(p.missingAccess, isTrue);
      expect(p.blockers, isEmpty);
      expect(p.warnings, ['program.transfer_cut_dependency']);
      expect(p.canExecute, isTrue);
      expect(p.fingerprint, 'fp');
      expect(p.cutDependencyIds, ['dep1']);
      expect(p.unresolvedWorkItemIds, isEmpty);
      expect(p.missingFileIds, isEmpty);
      expect(p.cycleWorkItemIds, isEmpty);
    });

    test('resolved null → boş', () async {
      final (repo, _) = _repo(
        '{"resolved_work_item_ids":null,"file_count":0,"file_total_bytes":0,'
        '"preserved_dependency_count":0,"missing_access":false,'
        '"blockers":["x"],"warnings":[],"can_execute":false,'
        '"preview_fingerprint":"fp","granted_memberships":[]}',
      );
      final p = await repo.previewTransfer(
        sourceProgramId: 'p1',
        targetProgramId: 'p2',
        departmentId: 'd1',
        workItemIds: const [],
      );
      expect(p.resolvedWorkItemIds, isEmpty);
      expect(p.canExecute, isFalse);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_err('platform.rate_limited'), status: 429);
      await expectLater(
        repo.previewTransfer(
          sourceProgramId: 'p1',
          targetProgramId: 'p2',
          departmentId: 'd1',
          workItemIds: const ['w1'],
        ),
        _apiError('platform.rate_limited'),
      );
    });
  });

  group('transfer / reverseTransfer', () {
    test('ileri aktarım: Idempotency-Key başlığı ve gövde', () async {
      final (repo, a) = _repo(_result);
      final r = await repo.transfer(
        idempotencyKey: 'k1',
        sourceProgramId: 'p1',
        targetProgramId: 'p2',
        departmentId: 'd1',
        workItemIds: ['w1'],
        previewFingerprint: 'fp',
        addMissingAccess: true,
      );
      expect(a.seen!.method, 'POST');
      expect(a.seen!.uri.path, '/v1/program-transfers');
      expect(a.seen!.headers['Idempotency-Key'], 'k1');
      expect(a.sent, {
        'source_program_id': 'p1',
        'target_program_id': 'p2',
        'department_id': 'd1',
        'work_item_ids': ['w1'],
        'preview_fingerprint': 'fp',
        'add_missing_access': true,
      });
      expect(r.transferId, 't1');
      expect(r.movedWorkItemIds, ['w1']);
      expect(r.movedFileCount, 2);
      expect(r.cutDependencyCount, 1);
      expect(r.grantedLinks, ['g']);
      expect(r.revokedLinks, isEmpty);
      expect(r.retainedLinks, ['k']);
      expect(r.replayed, isFalse);
      expect(r.skippedWorkItemIds, isEmpty);
    });

    test('ters aktarım: yalnız reverses_transfer_id', () async {
      final (repo, a) = _repo(_result.replaceFirst('false', 'true'));
      final r = await repo.reverseTransfer(
        idempotencyKey: 'k2',
        transferId: 't0',
      );
      expect(a.seen!.headers['Idempotency-Key'], 'k2');
      expect(a.sent, {'reverses_transfer_id': 't0'});
      expect(r.replayed, isTrue);
    });

    test('409 idempotency_key_reused → ApiError', () async {
      final (repo, _) = _repo(
        _err('program.idempotency_key_reused'),
        status: 409,
      );
      await expectLater(
        repo.reverseTransfer(idempotencyKey: 'k', transferId: 't0'),
        _apiError('program.idempotency_key_reused'),
      );
    });
  });

  group('listTransfers / readTransfer', () {
    test('GET /v1/program-transfers: imleç ve eşleme', () async {
      final (repo, a) = _repo('{"transfers":[$_record],"next_cursor":"n"}');
      final slice = await repo.listTransfers(
        page: const PageRequest(limit: 10, cursor: 'c'),
      );
      expect(a.seen!.uri.path, '/v1/program-transfers');
      expect(a.seen!.uri.queryParameters, {'limit': '10', 'cursor': 'c'});
      final t = slice.items.single;
      expect(t.transferId, 't1');
      expect(t.sourceProgramId, 'p1');
      expect(t.targetProgramId, 'p2');
      expect(t.departmentId, 'd1');
      expect(t.workItemIds, ['w1', 'w2']);
      expect(t.movedItemCount, 2);
      expect(t.movedFileCount, 3);
      expect(t.cutDependencyCount, 1);
      expect(t.restoredDependencyCount, 0);
      expect(t.createdAt, DateTime.utc(2026, 10, 20, 12));
      expect(t.reversesTransferId, 't0');
      expect(t.skippedWorkItemIds, isEmpty);
      expect(slice.nextCursor, 'n');
    });

    test('GET /v1/program-transfers/{id}; work_item_ids null → boş', () async {
      final (repo, a) = _repo(_record.replaceFirst('["w1","w2"]', 'null'));
      final t = await repo.readTransfer('t1');
      expect(a.seen!.uri.path, '/v1/program-transfers/t1');
      expect(t.workItemIds, isEmpty);
    });

    test('hata ve ayrıştırılamayan yanıt', () async {
      final (repo, _) = _repo(_err('program.transfer_not_found'), status: 404);
      await expectLater(
        repo.readTransfer('t9'),
        _apiError('program.transfer_not_found'),
      );
      final (repo2, _) = _repo('{"transfers":null}');
      await expectLater(
        repo2.listTransfers(),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });
}
