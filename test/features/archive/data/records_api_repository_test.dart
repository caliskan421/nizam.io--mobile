// archive data katmanı: records uçları → domain (RecordFile, ArchiveFolder, ArchiveTaskSummary),
// bilinmeyen etiket → unknown, imleç, ikili indirme, hata zarfı → ApiError.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/archive/data/records_api_repository.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';

/// Tek yanıtlı sahte bağdaştırıcı; isteği ve gövde baytlarını kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  ResponseBody Function(RequestOptions o) respond;
  final List<RequestOptions> seen = [];
  final List<List<int>> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    bodies.add(
      requestStream == null
          ? const []
          : await requestStream.expand((c) => c).toList(),
    );
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

ResponseBody _bin(List<int> bytes) => ResponseBody.fromBytes(
  bytes,
  200,
  headers: {
    Headers.contentTypeHeader: ['application/zip'],
  },
);

ResponseBody _err(int status, String code) =>
    _json({'code': code, 'message': 'x', 'request_id': 'req-1'}, status);

(ApiRecordsRepository, _Adapter) _repo(
  ResponseBody Function(RequestOptions o) respond,
) {
  final adapter = _Adapter(respond);
  return (
    ApiRecordsRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

Map<String, Object?> _record({String tag = 'plan'}) => {
  'file_id': 'f1',
  'work_item_id': 'w1',
  'display_name': 'Rapor.pdf',
  'content_type': 'application/pdf',
  'size_bytes': 2097152,
  'tag': tag,
};

Map<String, Object?> _item({String tag = 'ister', String id = 'f1'}) => {
  ..._record(tag: tag),
  'file_id': id,
  'uploaded_by_account_id': 'a1',
};

void main() {
  group('attachFile', () {
    late Directory dir;
    late String path;
    setUp(() {
      dir = Directory.systemTemp.createTempSync('records_test');
      path = '${dir.path}/kanit.pdf';
      File(path).writeAsStringSync('icerik');
    });
    tearDown(() => dir.deleteSync(recursive: true));

    test('multipart POST + tag sorgusu → RecordFile', () async {
      final (repo, a) = _repo((_) => _json(_record(tag: 'cikti')));
      final f = await repo.attachFile(
        workItemId: 'w1',
        tag: RecordTag.cikti,
        filePath: path,
      );
      final o = a.seen.single;
      expect(o.method, 'POST');
      expect(o.uri.path, '/v1/work-items/w1/files');
      expect(o.uri.queryParameters['tag'], 'cikti');
      expect(o.contentType, startsWith('multipart/form-data'));
      final body = latin1.decode(a.bodies.single);
      expect(body, contains('name="file"'));
      expect(body, contains('filename="kanit.pdf"'));
      // Parça türü bildirilir (sunucu türü buradan okur; octet-stream değil).
      expect(body, contains('content-type: application/pdf'));
      expect(body, isNot(contains('application/octet-stream')));
      expect(body, contains('icerik'));
      expect(f.id, 'f1');
      expect(f.workItemId, 'w1');
      expect(f.displayName, 'Rapor.pdf');
      expect(f.tag, RecordTag.cikti);
      expect(f.uploaderId, isNull);
      expect(f.kind, ArchiveFileKind.pdf);
      expect(f.sizeMb, 2.0);
    });

    test(
      'izinli küme dışı uzantı: istek yok, records.content_rejected',
      () async {
        final (repo, a) = _repo((_) => _json(_record()));
        final txt = '${dir.path}/not.txt';
        File(txt).writeAsStringSync('x');
        await expectLater(
          repo.attachFile(workItemId: 'w1', tag: RecordTag.plan, filePath: txt),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              'records.content_rejected',
            ),
          ),
        );
        expect(a.seen, isEmpty);
      },
    );

    test('nesne olmayan gövde → client.invalid_response', () async {
      final (repo, _) = _repo((_) => _json(<Object>[]));
      await expectLater(
        repo.attachFile(workItemId: 'w1', tag: RecordTag.plan, filePath: path),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.invalidResponse,
          ),
        ),
      );
    });

    test('unknown etiket gönderilemez (istek yok)', () async {
      final (repo, a) = _repo((_) => _json(_record()));
      await expectLater(
        repo.attachFile(
          workItemId: 'w1',
          tag: RecordTag.unknown,
          filePath: path,
        ),
        throwsArgumentError,
      );
      expect(a.seen, isEmpty);
    });

    test('422 records.tag_invalid → ApiError', () async {
      final (repo, _) = _repo((_) => _err(422, 'records.tag_invalid'));
      await expectLater(
        repo.attachFile(workItemId: 'w1', tag: RecordTag.plan, filePath: path),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'records.tag_invalid')
              .having((e) => e.status, 'status', 422),
        ),
      );
    });
  });

  test(
    'listWorkItemFiles → RecordFile listesi; bilinmeyen etiket unknown',
    () async {
      final (repo, a) = _repo(
        (_) => _json({
          'files': [_item(), _item(tag: 'yeni_etiket', id: 'f2')],
        }),
      );
      final files = await repo.listWorkItemFiles('w9');
      expect(a.seen.single.uri.path, '/v1/work-items/w9/files');
      expect(files.map((f) => f.tag), [RecordTag.ister, RecordTag.unknown]);
      expect(files.first.uploaderId, 'a1');
    },
  );

  test('renameFile → PATCH gövde display_name', () async {
    final (repo, a) = _repo((_) => _json(_record(tag: 'bilinmez')));
    final f = await repo.renameFile('f1', 'Yeni.pdf');
    final o = a.seen.single;
    expect(o.method, 'PATCH');
    expect(o.uri.path, '/v1/files/f1/name');
    expect(jsonDecode(utf8.decode(a.bodies.single)), {
      'display_name': 'Yeni.pdf',
    });
    expect(f.tag, RecordTag.unknown);
  });

  test('deleteFile → DELETE; 404 → ApiError', () async {
    final (repo, a) = _repo((_) => ResponseBody.fromString('', 204));
    await repo.deleteFile('f1');
    expect(a.seen.single.method, 'DELETE');
    expect(a.seen.single.uri.path, '/v1/files/f1');

    final (repo2, _) = _repo((_) => _err(404, 'records.file_not_found'));
    await expectLater(
      repo2.deleteFile('f1'),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'records.file_not_found'),
      ),
    );
  });

  group('archiveAttachments', () {
    test('süzgeçler sorguya, imleç dilime', () async {
      final (repo, a) = _repo(
        (_) => _json({
          'files': [_item()],
          'next_cursor': 'c2',
        }),
      );
      final slice = await repo.archiveAttachments(
        filter: ArchiveAttachmentFilter(
          mimeCategory: ArchiveMimeCategory.gorsel,
          tag: RecordTag.sonuc,
          workItemId: 'w1',
          uploaderId: 'a1',
          from: DateTime.utc(2026, 10, 1),
          to: DateTime.utc(2026, 10, 31, 23, 59),
          search: 'rapor',
          sort: ArchiveSort.size,
        ),
        page: const PageRequest(limit: 20, cursor: 'c1'),
      );
      final q = a.seen.single.uri.queryParameters;
      expect(a.seen.single.uri.path, '/v1/records/archive/attachments');
      expect(q, {
        'mime_category': 'gorsel',
        'tag': 'sonuc',
        'work_item_id': 'w1',
        'uploader_id': 'a1',
        'from': '2026-10-01T00:00:00.000Z',
        'to': '2026-10-31T23:59:00.000Z',
        'search': 'rapor',
        'sort': 'size',
        'limit': '20',
        'cursor': 'c1',
      });
      expect(slice.items.single.id, 'f1');
      expect(slice.nextCursor, 'c2');
      expect(slice.hasMore, isTrue);
    });

    test('varsayılan: sorgu boş; next_cursor yok/boş → son sayfa', () async {
      for (final body in [
        {'files': <Object>[]},
        {'files': <Object>[], 'next_cursor': ''},
      ]) {
        final (repo, a) = _repo((_) => _json(body));
        final slice = await repo.archiveAttachments();
        expect(a.seen.single.uri.queryParameters, isEmpty);
        expect(slice.items, isEmpty);
        expect(slice.hasMore, isFalse);
      }
    });

    test('ArchiveSort.name → sort=name', () async {
      final (repo, a) = _repo((_) => _json({'files': <Object>[]}));
      await repo.archiveAttachments(
        filter: const ArchiveAttachmentFilter(sort: ArchiveSort.name),
      );
      expect(a.seen.single.uri.queryParameters['sort'], 'name');
    });

    test('422 records.invalid_cursor → ApiError', () async {
      final (repo, _) = _repo((_) => _err(422, 'records.invalid_cursor'));
      await expectLater(
        repo.archiveAttachments(page: const PageRequest(cursor: 'eski')),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'records.invalid_cursor',
          ),
        ),
      );
    });
  });

  test('loadFolders → ArchiveFolder (folder_id → code, is_virtual)', () async {
    final (repo, a) = _repo(
      (_) => _json({
        'folders': [
          {
            'folder_id': 'd1',
            'name': 'Mekanik',
            'file_count': 4,
            'is_virtual': false,
          },
          {
            'folder_id': 'me',
            'name': 'Görevlerim',
            'file_count': 1,
            'is_virtual': true,
          },
        ],
      }),
    );
    final folders = await repo.loadFolders();
    expect(a.seen.single.uri.path, '/v1/records/archive/folders');
    expect(folders.map((f) => (f.code, f.name, f.files, f.isVirtual)), [
      ('d1', 'Mekanik', 4, false),
      ('me', 'Görevlerim', 1, true),
    ]);
    expect(folders.first.leads, isEmpty);
    expect(folders.first.lastUploadDays, isNull);
  });

  test('archiveTasks → ArchiveTaskSummary', () async {
    final (repo, a) = _repo(
      (_) => _json({
        'tasks': [
          {'work_item_id': 'w1', 'title': 'Saha', 'file_count': 3},
        ],
      }),
    );
    final t = (await repo.archiveTasks()).single;
    expect(a.seen.single.uri.path, '/v1/records/archive/tasks');
    expect((t.workItemId, t.title, t.fileCount), ('w1', 'Saha', 3));
  });

  test('archiveUploaders → kimlik listesi', () async {
    final (repo, a) = _repo(
      (_) => _json({
        'uploaders': ['a1', 'a2'],
      }),
    );
    expect(await repo.archiveUploaders(), ['a1', 'a2']);
    expect(a.seen.single.uri.path, '/v1/records/archive/uploaders');
  });

  test('bozuk gövde → client.invalid_response', () async {
    final (repo, _) = _repo((_) => _json({'folders': 'x'}));
    await expectLater(
      repo.loadFolders(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.invalidResponse,
        ),
      ),
    );
  });

  group('indirmeler (ikili; UTF-8 olmayan bayt bozulmaz)', () {
    const bytes = [0x50, 0x4b, 0x03, 0x04, 0xff, 0xfe, 0x00, 0x80];

    test('downloadFile', () async {
      final (repo, a) = _repo((_) => _bin(bytes));
      expect(await repo.downloadFile('f1'), bytes);
      final o = a.seen.single;
      expect(o.method, 'GET');
      expect(o.uri.path, '/v1/files/f1/download');
      expect((o.extra['openapi'] as Map)['operationId'], 'downloadFile');
    });

    test('downloadFolderZip', () async {
      final (repo, a) = _repo((_) => _bin(bytes));
      expect(await repo.downloadFolderZip('d1'), bytes);
      expect(
        a.seen.single.uri.path,
        '/v1/records/archive/folders/d1/download-zip',
      );
      expect(
        (a.seen.single.extra['openapi'] as Map)['operationId'],
        'archiveFolderZip',
      );
    });

    test('downloadSelectionZip: file_ids virgüllü', () async {
      final (repo, a) = _repo((_) => _bin(bytes));
      expect(await repo.downloadSelectionZip(['f1', 'f2']), bytes);
      final o = a.seen.single;
      expect(o.uri.path, '/v1/records/archive/files/download-zip');
      expect(o.uri.queryParameters['file_ids'], 'f1,f2');
      expect((o.extra['openapi'] as Map)['operationId'], 'archiveSelectionZip');
    });

    test(
      'downloadSelectionZip: 0 ya da 100+ kimlik → ArgumentError, istek yok',
      () async {
        final (repo, a) = _repo((_) => _bin(bytes));
        expect(() => repo.downloadSelectionZip([]), throwsArgumentError);
        expect(
          () =>
              repo.downloadSelectionZip([for (var i = 0; i < 101; i++) 'f$i']),
          throwsArgumentError,
        );
        expect(a.seen, isEmpty);
      },
    );

    test('downloadPeriodZip', () async {
      final (repo, a) = _repo((_) => _bin(bytes));
      expect(await repo.downloadPeriodZip(), bytes);
      expect(a.seen.single.uri.path, '/v1/records/archive/period/download-zip');
      expect(
        (a.seen.single.extra['openapi'] as Map)['operationId'],
        'archiveFullZip',
      );
    });

    test('hata zarfı → ApiError (429 kota)', () async {
      final (repo, _) = _repo((_) => _err(429, 'records.busy'));
      await expectLater(
        repo.downloadPeriodZip(),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 429)),
      );
    });
  });

  group('RecordsDownloadTargets (bilet hedefi)', () {
    test('yollar', () {
      expect(RecordsDownloadTargets.file('f1'), '/v1/files/f1/download');
      expect(
        RecordsDownloadTargets.folderZip('d 1'),
        '/v1/records/archive/folders/d%201/download-zip',
      );
      expect(
        RecordsDownloadTargets.selectionZip(['f1', 'f2']),
        '/v1/records/archive/files/download-zip?file_ids=f1,f2',
      );
      expect(
        RecordsDownloadTargets.periodZip,
        '/v1/records/archive/period/download-zip',
      );
    });

    test('seçim sınırı', () {
      expect(
        () => RecordsDownloadTargets.selectionZip([]),
        throwsArgumentError,
      );
      expect(
        RecordsDownloadTargets.selectionZip([
          for (var i = 0; i < 100; i++) 'f$i',
        ]),
        contains('f99'),
      );
    });
  });

  test('RecordFile.kind content_type\'tan', () {
    RecordFile f(String t) => RecordFile(
      id: 'x',
      workItemId: 'w',
      displayName: 'n',
      contentType: t,
      sizeBytes: 0,
      tag: RecordTag.plan,
    );
    expect(f('image/png').kind, ArchiveFileKind.image);
    expect(f('application/pdf').kind, ArchiveFileKind.pdf);
    expect(f('text/plain').kind, ArchiveFileKind.document);
  });
}
