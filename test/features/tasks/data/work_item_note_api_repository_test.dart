// tasks data katmanı: not uçları → TaskNote / CountedList (sunucu total), hata → ApiError.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tasks/data/work_item_note_api_repository.dart';

import 'work_fake_dio.dart';

Map<String, Object?> _note(String id) => {
  'note_id': id,
  'work_item_id': 'w1',
  'author_account_id': 'a1',
  'content': 'metin $id',
  'created_at': '2026-11-01T10:00:00Z',
  'updated_at': '2026-11-02T11:00:00Z',
};

(ApiWorkItemNoteRepository, FakeAdapter) _repo(
  Object body, {
  int status = 200,
}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiWorkItemNoteRepository(dio), adapter);
}

void main() {
  test('list: GET → notlar ve sunucu total', () async {
    final (repo, a) = _repo({
      'notes': [_note('n1'), _note('n2')],
      'total': 5,
    });
    final r = await repo.list('w1');
    expect(a.last.method, 'GET');
    expect(a.last.uri.path, '/v1/work-items/w1/notes');
    expect(r.total, 5, reason: 'total satır sayısından değil sunucudan');
    expect(r.items, hasLength(2));
    final n = r.items.first;
    expect(n.id, 'n1');
    expect(n.workItemId, 'w1');
    expect(n.by, 'a1');
    expect(n.text, 'metin n1');
    expect(n.at, DateTime.utc(2026, 11, 1, 10));
    expect(n.updatedAt, DateTime.utc(2026, 11, 2, 11));
    expect(n.inMemory, isFalse);
  });

  test('list: total yok → client.invalid_response', () async {
    final (repo, _) = _repo({'notes': <Object>[]});
    await expectLater(
      repo.list('w1'),
      throwsApiError(ClientErrorCode.invalidResponse),
    );
  });

  test('add: POST gövdesi → TaskNote', () async {
    final (repo, a) = _repo(_note('n3'));
    final n = await repo.add('w1', 'merhaba');
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/notes');
    expect(a.sentJson, {'content': 'merhaba'});
    expect(n.id, 'n3');
  });

  test('add: ŞY yazamaz → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_authorized'), status: 403);
    await expectLater(
      repo.add('w1', 'x'),
      throwsApiError('work.not_authorized'),
    );
  });

  test('update: PATCH gövdesi', () async {
    final (repo, a) = _repo({'status': 'updated'});
    await repo.update('w1', 'n1', 'yeni');
    expect(a.last.method, 'PATCH');
    expect(a.last.uri.path, '/v1/work-items/w1/notes/n1');
    expect(a.sentJson, {'content': 'yeni'});
  });

  test('delete: DELETE', () async {
    final (repo, a) = _repo({'status': 'deleted'});
    await repo.delete('w1', 'n1');
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/work-items/w1/notes/n1');
  });

  test('delete: hata → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('platform.not_found'), status: 404);
    await expectLater(
      repo.delete('w1', 'n9'),
      throwsApiError('platform.not_found'),
    );
  });
}
