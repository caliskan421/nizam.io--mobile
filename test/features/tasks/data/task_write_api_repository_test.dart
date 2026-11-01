// ApiTaskWriteRepository: her yazma görevin KENDİ departmanıyla (açık departman extras'ı) ve
// doğru uca gider; aktör ucu (transitions / own-status), gövdeler (reason, close_subtasks,
// alt görev atama kaldırma '' ve tarihler YYYY-AA-GG birlikte); departmansız görev boş kimlik
// taşır (kapı reddeder); hata ApiError. Başlığa çevirme ara katman testindedir (interceptors).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/task_write_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_permissions.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

import 'work_fake_dio.dart';

TaskItem _task({String? department = 'd9'}) => TaskItem(
  code: 'w1',
  title: 'Hidrofor',
  coordinatorship: 'd9',
  departmentId: department,
  programId: 'p1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const [],
);

const _transition = {
  'work_item_id': 'w1',
  'from': 'devam_ediyor',
  'to': 'tamamlandi',
  'actor': 'koordinator',
};

const _subtask = {
  'subtask_id': 's1',
  'work_item_id': 'w1',
  'title': 'Pompa',
  'done': true,
  'created_by_account_id': 'u1',
  'created_at': '2026-07-02T08:00:00Z',
  'updated_at': '2026-07-02T08:00:00Z',
};

void main() {
  test('durum: transitions ve own-status; gövde; görevin departmanı', () async {
    var (dio, a) = fakeDio(_transition);
    await ApiTaskWriteRepository(dio).changeStatus(
      _task(),
      StatusEndpoint.transition,
      TaskStatus.done,
      closeSubtasks: true,
    );
    expect(a.last.method, 'POST');
    expect(a.last.path, '/v1/work-items/w1/transitions');
    expect(a.sentJson, {'to': 'tamamlandi', 'close_subtasks': true});
    expect(a.last.extra.values, contains('d9'));

    (dio, a) = fakeDio(_transition);
    await ApiTaskWriteRepository(dio).changeStatus(
      _task(),
      StatusEndpoint.ownStatus,
      TaskStatus.inProgress,
      reason: 'Eksik iş',
    );
    expect(a.last.method, 'PATCH');
    expect(a.last.path, '/v1/work-items/w1/own-status');
    expect(a.sentJson, {'to': 'devam_ediyor', 'reason': 'Eksik iş'});
    expect(a.last.extra.values, contains('d9'));
  });

  test('notlar: ekle / düzenle / sil', () async {
    var (dio, a) = fakeDio({
      'note_id': 'n1',
      'work_item_id': 'w1',
      'author_account_id': 'u1',
      'content': 'x',
      'created_at': '2026-10-03T09:00:00Z',
      'updated_at': '2026-10-03T09:00:00Z',
    });
    await ApiTaskWriteRepository(dio).addNote(_task(), 'Not');
    expect('${a.last.method} ${a.last.path}', 'POST /v1/work-items/w1/notes');
    expect(a.sentJson, {'content': 'Not'});
    expect(a.last.extra.values, contains('d9'));

    (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).updateNote(_task(), 'n1', 'Yeni');
    expect(
      '${a.last.method} ${a.last.path}',
      'PATCH /v1/work-items/w1/notes/n1',
    );
    expect(a.sentJson, {'content': 'Yeni'});

    (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).deleteNote(_task(), 'n1');
    expect(
      '${a.last.method} ${a.last.path}',
      'DELETE /v1/work-items/w1/notes/n1',
    );
    expect(a.last.extra.values, contains('d9'));
  });

  test(
    'alt görev: oluştur / değiştir (atama kaldırma, tarihler) / sil',
    () async {
      var (dio, a) = fakeDio(_subtask);
      await ApiTaskWriteRepository(dio).createSubtask(_task(), 'Pompa');
      expect(
        '${a.last.method} ${a.last.path}',
        'POST /v1/work-items/w1/subtasks',
      );
      expect(a.sentJson, {'title': 'Pompa'});

      (dio, a) = fakeDio(_subtask);
      await ApiTaskWriteRepository(dio).updateSubtask(
        _task(),
        's1',
        SubtaskPatch(
          assignee: (id: null),
          dates: (start: DateTime(2026, 7, 2), end: DateTime(2026, 7, 9)),
          done: true,
        ),
      );
      expect(
        '${a.last.method} ${a.last.path}',
        'PATCH /v1/work-items/w1/subtasks/s1',
      );
      expect(a.sentJson, {
        'assignee_account_id': '',
        'start_on': '2026-07-02',
        'end_on': '2026-07-09',
        'done': true,
      });

      (dio, a) = fakeDio(_subtask);
      await ApiTaskWriteRepository(dio).updateSubtask(
        _task(),
        's1',
        const SubtaskPatch(dates: (start: null, end: null)),
      );
      expect(a.sentJson, {'start_on': '', 'end_on': ''});

      (dio, a) = fakeDio({'status': 'ok'});
      await ApiTaskWriteRepository(dio).deleteSubtask(_task(), 's1');
      expect(
        '${a.last.method} ${a.last.path}',
        'DELETE /v1/work-items/w1/subtasks/s1',
      );
    },
  );

  test(
    'departmansız görev boş kimlik taşır (seçili departmana düşmez)',
    () async {
      final (dio, a) = fakeDio({'status': 'ok'});
      await ApiTaskWriteRepository(dio)
          .deleteNote(_task(department: null), 'n1');
      expect(a.last.extra.values, contains(''));
    },
  );

  test('hata zarfı ApiError olur', () async {
    final (dio, _) = fakeDio(errorEnvelope('work.subtasks_open'), status: 409);
    await expectLater(
      ApiTaskWriteRepository(dio)
          .changeStatus(_task(), StatusEndpoint.transition, TaskStatus.done),
      throwsApiError('work.subtasks_open'),
    );
  });
}
