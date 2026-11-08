// coordinatorships data: ApiCoordinatorshipActivityRepository — toplantılar (listMeetings, S2)
// ve arşiv dosyaları (archiveAttachments, S3) → CoordMeeting / CoordFile; departman ve görev
// süzgeci, silinmiş toplantı, imleçli sayfalama, kapsam kapısı ve hata zarfı.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/coordinatorships/data/coordinatorship_activity_api_repository.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_board.dart';

import '../../tasks/data/work_fake_dio.dart' show errorEnvelope, throwsApiError;

/// Sırayla yanıt veren sahte bağdaştırıcı (sayfa başına bir gövde).
class _Pages implements HttpClientAdapter {
  _Pages(this.bodies, [this.status = 200]);

  final List<Object> bodies;
  final int status;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    final b = bodies[seen.length - 1];
    return ResponseBody.fromString(
      b is String ? b : jsonEncode(b),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiCoordinatorshipActivityRepository, _Pages) _repo(
  List<Object> bodies, {
  int status = 200,
  String? program = 'p1',
  bool bound = true,
}) {
  final a = _Pages(bodies, status);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = a;
  return (
    ApiCoordinatorshipActivityRepository(
      dio: () => bound ? dio : null,
      programId: () => program,
    ),
    a,
  );
}

Map<String, Object?> _meeting(
  String id,
  List<String> departments, {
  String owner = 'd1',
  String? deletedAt,
}) => {
  'meeting_id': id,
  'program_id': 'p1',
  'owner_department_id': owner,
  'title': 'Toplantı $id',
  'meeting_date': '2026-11-20T07:00:00Z',
  'members_included': true,
  'created_by_account_id': 'a1',
  'created_by_role': 'admin',
  'created_at': '2026-11-01T08:00:00Z',
  'updated_at': '2026-11-01T08:00:00Z',
  'deleted_at': ?deletedAt,
  'departments': [
    for (final d in departments) {'department_id': d, 'department_name': d},
  ],
};

Map<String, Object?> _file(String id, String workItem, String type) => {
  'file_id': id,
  'work_item_id': workItem,
  'display_name': '$id.bin',
  'content_type': type,
  'size_bytes': 1024,
  'tag': 'cikti',
  'uploaded_by_account_id': 'a2',
};

String? _extra(RequestOptions o, String key) => o.extra[key] as String?;

void main() {
  group('meetings', () {
    test(
      'departmanın katıldığı, silinmemiş toplantılar → CoordMeeting',
      () async {
        final (repo, a) = _repo([
          {
            'items': [
              _meeting('m1', ['d1', 'd2']),
              _meeting('m2', ['d2', 'd1'], owner: 'd2'),
              _meeting('m3', ['d2'], owner: 'd2'),
              _meeting('m4', ['d1'], deletedAt: '2026-11-02T08:00:00Z'),
            ],
            'next_cursor': '',
          },
        ]);
        final list = await repo.meetings('d1');
        expect(list.map((m) => m.id), ['m1', 'm2']);
        final m1 = list.first;
        expect(m1.title, 'Toplantı m1');
        expect(m1.at, DateTime.utc(2026, 11, 20, 7).toLocal());
        expect(m1.owner, isTrue);
        expect(m1.departments, 2);
        expect(list.last.owner, isFalse, reason: 'davetli departman');
        final o = a.seen.single;
        expect(o.uri.path, '/v1/meetings');
        expect(o.uri.queryParameters['limit'], '200');
        expect(_extra(o, 'nizamio.program'), 'p1', reason: 'S2: program açık');
        expect(_extra(o, 'nizamio.department'), isNull);
      },
    );

    test('imleç boşalana dek sayfalar okunur', () async {
      final (repo, a) = _repo([
        {
          'items': [
            _meeting('m1', ['d1']),
          ],
          'next_cursor': 'c2',
        },
        {
          'items': [
            _meeting('m2', ['d1']),
          ],
          'next_cursor': '',
        },
      ]);
      final list = await repo.meetings('d1');
      expect(list.map((m) => m.id), ['m1', 'm2']);
      expect(a.seen, hasLength(2));
      expect(a.seen.last.uri.queryParameters['cursor'], 'c2');
    });
  });

  group('files', () {
    test('yalnız verilen görevlerin dosyaları; tür içerik tipinden', () async {
      final (repo, a) = _repo([
        {
          'files': [
            _file('f1', 'w1', 'application/pdf'),
            _file('f2', 'w9', 'application/pdf'),
            _file('f3', 'w2', 'image/png'),
            _file('f4', 'w2', 'application/zip'),
          ],
        },
      ]);
      final list = await repo.files('d1', {'w1', 'w2'});
      expect(list.map((f) => f.id), ['f1', 'f3', 'f4']);
      expect(list.map((f) => f.kind), [
        CoordFileKind.pdf,
        CoordFileKind.image,
        CoordFileKind.document,
      ]);
      final f1 = list.first;
      expect(f1.name, 'f1.bin');
      expect(f1.sizeBytes, 1024);
      expect(f1.workItemId, 'w1');
      expect(f1.uploaderId, 'a2');
      final o = a.seen.single;
      expect(o.uri.path, '/v1/records/archive/attachments');
      expect(_extra(o, 'nizamio.program'), 'p1');
      expect(
        _extra(o, 'nizamio.department'),
        'd1',
        reason: 'S3: departman açık',
      );
    });

    test('imleç yok ya da boşsa okuma biter', () async {
      final (repo, a) = _repo([
        {
          'files': [_file('f1', 'w1', 'image/jpeg')],
          'next_cursor': 'c2',
        },
        {
          'files': [_file('f2', 'w1', 'image/jpeg')],
        },
      ]);
      expect((await repo.files('d1', {'w1'})).map((f) => f.id), ['f1', 'f2']);
      expect(a.seen.last.uri.queryParameters['cursor'], 'c2');
    });
  });

  group('kapsam ve hata', () {
    test('program seçili değilse istek gitmez: scope_missing', () async {
      final (repo, a) = _repo([], program: null);
      await expectLater(
        repo.meetings('d1'),
        throwsApiError(ClientErrorCode.scopeMissing),
      );
      await expectLater(
        repo.files('d1', {'w1'}),
        throwsApiError(ClientErrorCode.scopeMissing),
      );
      expect(a.seen, isEmpty);
    });

    test('bağ doğrulanmamışsa istek gitmez: server_not_verified', () async {
      final (repo, a) = _repo([], bound: false);
      await expectLater(
        repo.meetings('d1'),
        throwsApiError(ClientErrorCode.serverNotVerified),
      );
      expect(a.seen, isEmpty);
    });

    test('sunucu hata zarfı ApiError koduna çevrilir', () async {
      final (repo, _) = _repo([
        errorEnvelope('platform.not_authorized'),
      ], status: 403);
      await expectLater(
        repo.files('d1', {'w1'}),
        throwsApiError('platform.not_authorized'),
      );
    });
  });
}
