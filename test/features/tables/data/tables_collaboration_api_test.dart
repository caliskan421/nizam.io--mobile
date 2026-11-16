import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/data/tables_api_repository.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../tasks/data/work_fake_dio.dart';
import 'tables_api_repository_test.dart' show receipt;

void main() {
  for (final personal in [true, false]) {
    final l = TableLocation('p1', personal ? '' : 'd1');
    final prefix = personal ? '/v1/personal/tables' : '/v1/tables';
    test('presence seçimi ve ayrılma anahtarsız: $personal', () async {
      final (dio, a) = fakeDio('', status: 204);
      addTearDown(dio.close);
      final repo = ApiTablesRepository(() => dio);
      await repo.presence(l, 't1', row: 'r1', column: 'c1');
      expect(a.last.path, '$prefix/t1/presence');
      expect(a.sentJson, {'row_id': 'r1', 'column_id': 'c1'});
      expect(a.last.headers.containsKey('Idempotency-Key'), isFalse);
      a.seen.clear();
      await repo.presence(l, 't1', leave: true);
      expect(a.last.method, 'DELETE');
      expect(a.last.path, '$prefix/t1/presence');
    });
    test('yorum sayfası, yazar görünürlüğü ve imleç: $personal', () async {
      final (dio, a) = fakeDio({
        'items': [
          {
            'id': 'm1',
            'row_id': 'r1',
            'column_id': null,
            'author': null,
            'mine': false,
            'body': 'Yorum',
            'seq': 9,
            'created_at': '2026-11-16T00:00:00Z',
            'edited_at': null,
          },
        ],
        'next_cursor': '9',
      });
      addTearDown(dio.close);
      final p = await ApiTablesRepository(() => dio)
          .comments(l, 't1', row: 'r1', cursor: '4');
      expect(a.last.path, '$prefix/t1/comments');
      expect(a.last.queryParameters['row_id'], 'r1');
      expect(a.last.queryParameters['cursor'], '4');
      expect(p.items.single.author, isNull);
      expect(p.items.single.body, 'Yorum');
      expect(p.cursor, '9');
    });
    for (final author in [
      null,
      {'id': 'u1', 'name': 'Ayşe Yılmaz'},
    ]) {
      test(
        'hücre yorumu nesne yazar veya gizli yazar ile okunur: $personal $author',
        () async {
          final (dio, a) = fakeDio({
            'items': [
              {
                'id': 'm1',
                'row_id': 'r1',
                'column_id': 'c1',
                'author': author,
                'mine': true,
                'body': 'Teslim doğrulandı.',
                'seq': 9,
                'created_at': '2026-11-16T00:00:00Z',
                'edited_at': '2026-11-16T01:00:00Z',
              },
            ],
            'next_cursor': null,
          });
          addTearDown(dio.close);
          final p = await ApiTablesRepository(() => dio)
              .comments(l, 't1', row: 'r1');
          expect(p.items.single.author, author?['name']);
          expect(p.items.single.column, 'c1');
          expect(p.items.single.mine, isTrue);
          expect(p.items.single.edited, DateTime.utc(2026, 11, 16, 1));
          expect(
            (a.last.extra['openapi'] as Map<String, dynamic>)['operationId'],
            personal ? 'getPersonalTableComments' : 'getTableComments',
          );
        },
      );
    }
    test('bozuk yorum yazarı sessizce gizlenmez: $personal', () async {
      final (dio, _) = fakeDio({
        'items': [
          {
            'id': 'm1',
            'row_id': 'r1',
            'column_id': 'c1',
            'author': 'me',
            'mine': true,
            'body': 'Yorum',
            'seq': 1,
            'created_at': '2026-11-16T00:00:00Z',
            'edited_at': null,
          },
        ],
        'next_cursor': null,
      });
      addTearDown(dio.close);
      await expectLater(
        ApiTablesRepository(() => dio).comments(l, 't1'),
        throwsApiError('client.invalid_response'),
      );
    });
    test(
      'changes tüketilmiş imleci ve more bayrağını korur: $personal',
      () async {
        final (dio, a) = fakeDio({
          'table_id': 't1',
          'changes': [
            {'table_id': 't1', 'seq': 5, 'kind': 'set_cells'},
          ],
          'cursor': 5,
          'sequence': 8,
          'more': true,
        });
        addTearDown(dio.close);
        final p = await ApiTablesRepository(() => dio).changes(l, 't1', 4);
        expect(a.last.path, '$prefix/t1/changes');
        expect(a.last.queryParameters['after'], '4');
        expect(p.cursor, 5);
        expect(p.sequence, 8);
        expect(p.more, isTrue);
        expect(p.items.single.kind, 'set_cells');
      },
    );
    test('SSE ready/changed/presence çerçeveleri ayrılır: $personal', () async {
      const stream =
          'event: ready\ndata: {"table_id":"t1","sequence":1}\n\nevent: presence\ndata: {"table_id":"t1","participants":[{"key":"opaque","account_id":"u1","name":"Kişi","row_id":"r1","column_id":"c1"}]}\n\nevent: changed\ndata: {"table_id":"t1","sequence":3}\n\n';
      final (dio, a) = fakeDio(
        stream,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
      addTearDown(dio.close);
      final events = await ApiTablesRepository(() => dio)
          .watch(l, 't1')
          .toList();
      expect(a.last.path, '$prefix/t1/stream');
      expect(a.last.responseType, ResponseType.stream);
      expect(events.map((e) => e.sequence), [1, null, 3]);
      expect(events[1].participants!.single.name, 'Kişi');
    });
    test(
      'SSE açılışındaki 404 normal hata zarfı olarak korunur: $personal',
      () async {
        final (dio, _) = fakeDio(
          errorEnvelope('tables.not_found'),
          status: 404,
        );
        addTearDown(dio.close);
        await expectLater(
          ApiTablesRepository(() => dio).watch(l, 't1').toList(),
          throwsApiError('tables.not_found'),
        );
      },
    );
    test(
      'ek yükleme hücre sürümünü ve sabit anahtarı gönderir: $personal',
      () async {
        final (dio, a) = fakeDio({...receipt, 'id': 'attachment-id'});
        addTearDown(dio.close);
        final r = await ApiTablesRepository(() => dio).upload(
          l,
          't1',
          row: 'r1',
          column: 'c1',
          version: 7,
          name: 'belge.pdf',
          bytes: Stream.value([1, 2, 3]),
          length: 3,
          key: 'request-key-01234567890',
        );
        expect(a.last.path, '$prefix/t1/attachments');
        expect(a.last.queryParameters, {
          'row_id': 'r1',
          'column_id': 'c1',
          'cell_version': 7,
        });
        expect(a.last.headers['Idempotency-Key'], 'request-key-01234567890');
        final form = a.last.data as FormData;
        expect(form.files.single.value.filename, 'belge.pdf');
        expect(form.files.single.value.length, 3);
        expect(r.id, 'attachment-id');
      },
    );
    test('ek indirme akışlıdır: $personal', () async {
      final (dio, a) = fakeDio('abc');
      addTearDown(dio.close);
      final bytes = await ApiTablesRepository(() => dio)
          .download(l, 't1', 'a1');
      expect(await bytes.expand((b) => b).toList(), [97, 98, 99]);
      expect(a.last.path, '$prefix/t1/attachments/a1');
    });
    for (final action in ['create', 'rename', 'delete']) {
      test('proje komutu $action: $personal', () async {
        final (dio, a) = fakeDio({'id': 'p2', 'replayed': false});
        addTearDown(dio.close);
        final result = await ApiTablesRepository(() => dio).editProject(
          l,
          action == 'create' ? null : 'p2',
          action == 'delete' ? null : 'Proje',
          'request-key-01234567890',
        );
        expect(result, 'p2');
        expect(
          a.last.path,
          personal ? '/v1/personal/table-projects' : '/v1/table-projects',
        );
        expect(a.sentJson, {
          'kind': '${action}_project',
          if (action != 'create') 'id': 'p2',
          if (action != 'delete') 'name': 'Proje',
        });
      });
    }
  }
  test('öneri onayı ve reddi yalnız hedef departman kapsamındadır', () async {
    for (final approve in [true, false]) {
      final (dio, a) = fakeDio({
        'id': 'proposal-id',
        'status': approve ? 'approved' : 'rejected',
        'replayed': false,
        if (approve) 'table_id': 'new-table',
      });
      addTearDown(dio.close);
      final id = await ApiTablesRepository(() => dio).decideProposal(
        const TableLocation('p1', 'd2'),
        'proposal-id',
        approve,
        'request-key-01234567890',
      );
      expect(a.last.path, '/v1/table-proposals/proposal-id/decision');
      expect(a.last.extra.values, contains('d2'));
      expect(a.sentJson, {'decision': approve ? 'approve' : 'reject'});
      expect(id, approve ? 'new-table' : null);
    }
  });
}
