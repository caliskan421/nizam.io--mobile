// tasks data katmanı: WorkClient → domain (TaskSummary, TaskTransition, TaskDates …), istek
// gövdeleri, bilinmeyen enum → unknown, hata zarfı → ApiError, imleçli sayfalama.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tasks/data/work_item_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/work_item.dart';

import 'work_fake_dio.dart';

Map<String, Object?> _item({
  String id = 'w1',
  String status = 'devam_ediyor',
  String priority = 'acil',
}) => {
  'work_item_id': id,
  'program_id': 'p1',
  'department_id': 'd1',
  'title': 'Görev',
  'priority': priority,
  'status': status,
  'assignee_account_ids': ['a1', 'a2'],
  'is_overdue': true,
  'days_overdue': 3,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'planned_end_on': '2026-11-10',
  'completion_evidence_required': false,
  'subtask_counts': {'total': 0, 'done': 0},
};

final _dates = {
  'start_on': '2026-11-01',
  'end_on': '2026-11-20',
  'planned_end_on': '2026-11-15',
  'completed_on': '2026-11-18',
  'original_completed_on': '2026-11-19',
  'submitted_on': '2026-11-17',
};

(ApiWorkItemRepository, FakeAdapter) _repo(Object body, {int status = 200}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiWorkItemRepository(dio), adapter);
}

void main() {
  group('list', () {
    test('GET /v1/work-items → TaskSummary + imleç', () async {
      final (repo, a) = _repo({
        'items': [_item()],
        'next_cursor': 'c2',
      });
      final slice = await repo.list(const PageRequest(limit: 20, cursor: 'c1'));
      expect(a.last.method, 'GET');
      expect(a.last.uri.path, '/v1/work-items');
      expect(a.last.uri.queryParameters, {'limit': '20', 'cursor': 'c1'});
      expect(slice.nextCursor, 'c2');
      expect(slice.hasMore, isTrue);
      final t = slice.items.single;
      expect(
        t,
        TaskSummary(
          id: 'w1',
          programId: 'p1',
          departmentId: 'd1',
          title: 'Görev',
          priority: TaskPriority.urgent,
          status: TaskStatus.inProgress,
          assignees: const ['a1', 'a2'],
          lateness: const TaskLateness(isOverdue: true, daysOverdue: 3),
          plannedEnd: DateTime(2026, 11, 10),
        ),
      );
      expect(t.completedAt, isNull);
    });

    test('sayfalama parametresi yoksa sorgu boş; son sayfa', () async {
      final (repo, a) = _repo({'items': <Object>[]});
      final slice = await repo.list();
      expect(a.last.uri.queryParameters, isEmpty);
      expect(slice.items, isEmpty);
      expect(slice.hasMore, isFalse);
    });

    test('bilinmeyen durum/öncelik → unknown', () async {
      final (repo, _) = _repo({
        'items': [_item(status: 'yeni_durum', priority: 'kritik')],
      });
      final t = (await repo.list()).items.single;
      expect(t.status, TaskStatus.unknown);
      expect(t.priority, TaskPriority.unknown);
    });

    test('bütün durum değerleri eşlenir', () async {
      const wire = {
        'baslanmadi': TaskStatus.todo,
        'devam_ediyor': TaskStatus.inProgress,
        'onaya_sunuldu': TaskStatus.review,
        'iade_edildi': TaskStatus.returned,
        'tamamlandi': TaskStatus.done,
      };
      final (repo, _) = _repo({
        'items': [for (final w in wire.keys) _item(status: w)],
      });
      expect(
        (await repo.list()).items.map((t) => t.status).toList(),
        wire.values.toList(),
      );
    });

    test('hata zarfı → ApiError', () async {
      final (repo, _) = _repo(
        errorEnvelope('identity.invalid_cursor'),
        status: 422,
      );
      await expectLater(repo.list(), throwsApiError('identity.invalid_cursor'));
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo({'items': null});
      await expectLater(
        repo.list(),
        throwsApiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  test('create: POST gövdesi ve yanıt eşlemesi', () async {
    final (repo, a) = _repo(_item(status: 'baslanmadi', priority: 'yuksek'));
    final t = await repo.create(
      TaskDraft(
        title: 'Yeni',
        start: DateTime(2026, 11, 1, 15, 30),
        due: DateTime(2026, 11, 9),
        description: 'açıklama',
        priority: TaskPriority.high,
        assignee: 'a1',
      ),
    );
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items');
    final body = a.sentJson! as Map;
    expect(body['title'], 'Yeni');
    expect(body['description'], 'açıklama');
    expect(body['priority'], 'yuksek');
    expect(body['assignee_account_id'], 'a1');
    // Saat atılır; gün biçimi bilinen açık (bkz. sınıf belgesi): yalnız gün öneki doğrulanır.
    expect(body['start_on'] as String, startsWith('2026-11-01'));
    expect(body['end_on'] as String, startsWith('2026-11-09'));
    expect(t.status, TaskStatus.todo);
    expect(t.priority, TaskPriority.high);
  });

  test('create: tanımsız öncelik gönderilmez', () {
    final (repo, a) = _repo(_item());
    expect(
      () => repo.create(
        TaskDraft(
          title: 'x',
          start: DateTime(2026),
          due: DateTime(2026),
          priority: TaskPriority.unknown,
        ),
      ),
      throwsArgumentError,
    );
    expect(a.seen, isEmpty);
  });

  test('update: PATCH yalnız dolu alanlar', () async {
    final (repo, a) = _repo(_item());
    await repo.update(
      'w1',
      TaskPatch(
        title: 'T2',
        priority: TaskPriority.low,
        due: DateTime(2026, 12, 1),
      ),
    );
    expect(a.last.method, 'PATCH');
    expect(a.last.uri.path, '/v1/work-items/w1');
    final body = a.sentJson! as Map;
    expect(body.keys, unorderedEquals(['title', 'priority', 'end_on']));
    expect(body['priority'], 'dusuk');
    expect(body['end_on'] as String, startsWith('2026-12-01'));
  });

  test('delete: DELETE', () async {
    final (repo, a) = _repo({'status': 'deleted'});
    await repo.delete('w1');
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/work-items/w1');
  });

  test('delete: 403 → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_authorized'), status: 403);
    await expectLater(repo.delete('w1'), throwsApiError('work.not_authorized'));
  });

  group('geçişler', () {
    final result = {
      'work_item_id': 'w1',
      'from': 'onaya_sunuldu',
      'to': 'tamamlandi',
      'actor': 'koordinator',
      'end_on': '2026-11-05',
    };

    test('transition: POST /transitions gövdesi ve sonuç', () async {
      final (repo, a) = _repo(result);
      final r = await repo.transition('w1', TaskStatus.done, pullEndDate: true);
      expect(a.last.method, 'POST');
      expect(a.last.uri.path, '/v1/work-items/w1/transitions');
      expect(a.sentJson, {'to': 'tamamlandi', 'pull_end_date': true});
      expect(
        r,
        TaskTransition(
          workItemId: 'w1',
          from: TaskStatus.review,
          to: TaskStatus.done,
          actor: TransitionActor.coordinator,
          due: DateTime(2026, 11, 5),
        ),
      );
    });

    test('setOwnStatus: PATCH /own-status, gerekçe, aktör eşlemesi', () async {
      final (repo, a) = _repo({
        ...result,
        'actor': 'koordinator_kendi_gorevi',
        'end_on': null,
      });
      final r = await repo.setOwnStatus(
        'w1',
        TaskStatus.inProgress,
        reason: 'geri',
      );
      expect(a.last.method, 'PATCH');
      expect(a.last.uri.path, '/v1/work-items/w1/own-status');
      expect(a.sentJson, {'to': 'devam_ediyor', 'reason': 'geri'});
      expect(r.actor, TransitionActor.coordinatorOwnTask);
      expect(r.due, isNull);
    });

    test('bilinmeyen aktör ve durum → unknown', () async {
      final (repo, _) = _repo({...result, 'from': '??', 'actor': 'yeni_rol'});
      final r = await repo.transition('w1', TaskStatus.done);
      expect(r.from, TaskStatus.unknown);
      expect(r.actor, TransitionActor.unknown);
    });

    test('üye aktörü', () async {
      final (repo, _) = _repo({...result, 'actor': 'uye'});
      expect(
        (await repo.setOwnStatus('w1', TaskStatus.review)).actor,
        TransitionActor.member,
      );
    });

    test('tanımsız hedef durum gönderilmez', () {
      final (repo, a) = _repo(result);
      expect(
        () => repo.transition('w1', TaskStatus.unknown),
        throwsArgumentError,
      );
      expect(a.seen, isEmpty);
    });

    test('kural hatası → ApiError', () async {
      final (repo, _) = _repo(
        errorEnvelope('work.transition_not_allowed'),
        status: 422,
      );
      await expectLater(
        repo.transition('w1', TaskStatus.done),
        throwsApiError('work.transition_not_allowed'),
      );
    });
  });

  test('claim / unclaim', () async {
    final (repo, a) = _repo({'status': 'claimed'});
    await repo.claim('w1');
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/claim');
    final (repo2, b) = _repo({'status': 'unclaimed'});
    await repo2.unclaim('w1');
    expect(b.last.method, 'DELETE');
    expect(b.last.uri.path, '/v1/work-items/w1/claim');
  });

  test('unclaim: atanmamış → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_assigned'), status: 403);
    await expectLater(repo.unclaim('w1'), throwsApiError('work.not_assigned'));
  });

  test('addAssignees: POST gövdesi, eklenen sayı', () async {
    final (repo, a) = _repo({'added': 2});
    expect(await repo.addAssignees('w1', ['a1', 'a2']), 2);
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/assignments');
    expect(a.sentJson, {
      'account_ids': ['a1', 'a2'],
    });
  });

  test('removeAssignee: DELETE, kaldırılan sayı', () async {
    final (repo, a) = _repo({'removed': 1});
    expect(await repo.removeAssignee('w1', 'a2'), 1);
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/work-items/w1/assignments/a2');
  });

  test(
    'myTasks: GET /my-tasks → AssignedTask (bilinmeyen durum unknown)',
    () async {
      final (repo, a) = _repo({
        'items': [
          {'work_item_id': 'w1', 'title': 'A', 'status': 'tamamlandi'},
          {'work_item_id': 'w2', 'title': 'B', 'status': 'garip'},
        ],
      });
      final list = await repo.myTasks();
      expect(a.last.uri.path, '/v1/work-items/my-tasks');
      expect(list, const [
        AssignedTask(id: 'w1', title: 'A', status: TaskStatus.done),
        AssignedTask(id: 'w2', title: 'B', status: TaskStatus.unknown),
      ]);
    },
  );

  test('extend: POST gövdesi ve sonuç', () async {
    final (repo, a) = _repo({'cascade_count': 2, 'new_end_on': '2026-11-30'});
    final r = await repo.extend('w1', 5);
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/extend');
    expect(a.sentJson, {'days': 5});
    expect(r, TaskExtension(due: DateTime(2026, 11, 30), cascadeCount: 2));
  });

  test('pullCompletion: POST, gövde ve TaskDates', () async {
    final (repo, a) = _repo(_dates);
    final r = await repo.pullCompletion('w1', DateTime(2026, 11, 18, 9));
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/pull-completion');
    expect(
      (a.sentJson! as Map)['completed_on'] as String,
      startsWith('2026-11-18'),
    );
    expect(
      r,
      TaskDates(
        start: DateTime(2026, 11, 1),
        due: DateTime(2026, 11, 20),
        plannedEnd: DateTime(2026, 11, 15),
        completedAt: DateTime(2026, 11, 18),
        originalCompletedAt: DateTime(2026, 11, 19),
        submittedAt: DateTime(2026, 11, 17),
      ),
    );
  });

  test('pullEndDate: POST, isteğe bağlı tarihler yok', () async {
    final (repo, a) = _repo({'start_on': '2026-11-01', 'end_on': '2026-11-18'});
    final r = await repo.pullEndDate('w1');
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w1/pull-end-date');
    expect(r.plannedEnd, isNull);
    expect(r.completedAt, isNull);
    expect(r.due, DateTime(2026, 11, 18));
  });

  test('setCompletionDate: PATCH /completion-date', () async {
    final (repo, a) = _repo(_dates);
    await repo.setCompletionDate('w1', DateTime(2026, 11, 18));
    expect(a.last.method, 'PATCH');
    expect(a.last.uri.path, '/v1/work-items/w1/completion-date');
    expect(
      (a.sentJson! as Map)['completed_on'] as String,
      startsWith('2026-11-18'),
    );
  });

  test('setCompletionDate: hata → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.input_invalid'), status: 422);
    await expectLater(
      repo.setCompletionDate('w1', DateTime(2026)),
      throwsApiError('work.input_invalid'),
    );
  });
}
