// ApiTaskWriteRepository P3 yazmaları: uç + yöntem, görevin KENDİ departmanı (S3 extras'ı),
// gövde biçimi (oluşturma zorunlu alanları ve kanıt bayrağı, PATCH yalnız değişen alanlar,
// atama `account_ids`, tarih talebi, inceleme kararı), multipart (tek `file` parçası,
// bildirilen tür, `tag` zorunlu + `subtask_id`), ekip kaynağı `listMembers` (silinmiş üye
// atanamaz), indirme baytları; hata zarfı ApiError.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/task_write_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

import 'work_fake_dio.dart';

TaskItem _task() => TaskItem(
  code: 'w1',
  title: 'Hidrofor',
  coordinatorship: 'd9',
  departmentId: 'd9',
  programId: 'p1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const ['u2'],
  evidenceRequired: true,
);

const _item = {
  'work_item_id': 'w-new',
  'title': 'Yeni',
  'program_id': 'p1',
  'department_id': 'd9',
  'priority': 'acil',
  'status': 'baslanmadi',
  'assignee_account_ids': ['u2'],
  'is_overdue': false,
  'days_overdue': 0,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'completion_evidence_required': true,
  'subtask_counts': {'total': 0, 'done': 0},
};

void main() {
  test('createWorkItem: gövde, departman başlığı, sunucu kimliği', () async {
    final (dio, a) = fakeDio(_item, status: 201);
    final id = await ApiTaskWriteRepository(dio).createWorkItem(
      WorkItemDraft(
        departmentId: 'd9',
        title: 'Yeni',
        start: DateTime(2026, 11, 2, 15),
        end: DateTime(2026, 11, 20),
        priority: TaskPriority.urgent,
        assignee: 'u2',
      ),
    );
    expect(id, 'w-new');
    expect('${a.last.method} ${a.last.path}', 'POST /v1/work-items');
    expect(a.sentJson, {
      'title': 'Yeni',
      'start_on': '2026-11-02',
      'end_on': '2026-11-20',
      'priority': 'acil',
      'assignee_account_id': 'u2',
      'completion_evidence_required': true,
    });
    expect(a.last.extra.values, contains('d9'));
  });

  test('createWorkItem: atamasız + kanıt kapalı gönderilir', () async {
    final (dio, a) = fakeDio(_item, status: 201);
    await ApiTaskWriteRepository(dio).createWorkItem(
      WorkItemDraft(
        departmentId: 'd9',
        title: 'Yeni',
        start: DateTime(2026, 11, 2),
        end: DateTime(2026, 11, 2),
        evidenceRequired: false,
      ),
    );
    expect(a.sentJson, {
      'title': 'Yeni',
      'start_on': '2026-11-02',
      'end_on': '2026-11-02',
      'completion_evidence_required': false,
    });
  });

  test('updateWorkItem: PATCH yalnız değişen alanlar', () async {
    final t = _task();
    final patch = WorkItemPatch.diff(
      t,
      title: 'Hidrofor',
      priority: TaskPriority.high,
      start: DateTime(2026, 7, 2, 18),
      end: DateTime(2026, 9, 25),
      evidenceRequired: false,
    );
    final (dio, a) = fakeDio(_item);
    await ApiTaskWriteRepository(dio).updateWorkItem(t, patch);
    expect('${a.last.method} ${a.last.path}', 'PATCH /v1/work-items/w1');
    expect(a.sentJson, {
      'priority': 'yuksek',
      'end_on': '2026-09-25',
      'completion_evidence_required': false,
    });
    expect(a.last.extra.values, contains('d9'));
    expect(
      WorkItemPatch.diff(t, title: 'Hidrofor', start: t.start).isEmpty,
      isTrue,
    );
  });

  test('deleteWorkItem, claim, unclaim, atama ekle/kaldır', () async {
    var (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).deleteWorkItem(_task());
    expect('${a.last.method} ${a.last.path}', 'DELETE /v1/work-items/w1');
    expect(a.last.extra.values, contains('d9'));

    (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).claim(_task());
    expect('${a.last.method} ${a.last.path}', 'POST /v1/work-items/w1/claim');

    (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).unclaim(_task());
    expect('${a.last.method} ${a.last.path}', 'DELETE /v1/work-items/w1/claim');

    (dio, a) = fakeDio({'added': 2});
    await ApiTaskWriteRepository(dio).addAssignments(_task(), ['u3', 'u4']);
    expect(
      '${a.last.method} ${a.last.path}',
      'POST /v1/work-items/w1/assignments',
    );
    expect(a.sentJson, {
      'account_ids': ['u3', 'u4'],
    });
    expect(a.last.extra.values, contains('d9'));

    (dio, a) = fakeDio({'removed': 1});
    await ApiTaskWriteRepository(dio).removeAssignment(_task(), 'u2');
    expect(
      '${a.last.method} ${a.last.path}',
      'DELETE /v1/work-items/w1/assignments/u2',
    );
  });

  test(
    'listTeam: listMembers (listAssignable değil); silinmiş üye yok',
    () async {
      final (dio, a) = fakeDio({
        'members': [
          {
            'membership_id': 'm1',
            'account_id': 'u2',
            'full_name': 'Ali Kaya',
            'role': 'koordinator',
            'status': 'active',
          },
          {
            'membership_id': 'm2',
            'account_id': 'u3',
            'full_name': 'Eski Üye',
            'role': 'uye',
            'status': 'deleted',
          },
        ],
      });
      final team = await ApiTaskWriteRepository(dio).listTeam('d9');
      expect(
        '${a.last.method} ${a.last.path}',
        'GET /v1/departments/d9/members',
      );
      expect(team.map((m) => (m.accountId, m.name, m.coordinator)), [
        ('u2', 'Ali Kaya', true),
      ]);
    },
  );

  test('tarih talebi: aç (S3) / karar / sil (S1)', () async {
    var (dio, a) = fakeDio({
      'request_id': 'r1',
      'work_item_id': 'w1',
      'old_start_on': '2026-07-02',
      'old_end_on': '2026-09-20',
      'new_start_on': '2026-07-02',
      'new_end_on': '2026-10-04',
      'status': 'pending',
    }, status: 201);
    await ApiTaskWriteRepository(dio).requestDateChange(
      _task(),
      DateTime(2026, 7, 2),
      DateTime(2026, 10, 4),
      reason: 'Tedarik',
    );
    expect('${a.last.method} ${a.last.path}', 'POST /v1/date-change-requests');
    expect(a.sentJson, {
      'work_item_id': 'w1',
      'new_start_on': '2026-07-02',
      'new_end_on': '2026-10-04',
      'reason': 'Tedarik',
    });
    expect(a.last.extra.values, contains('d9'));

    (dio, a) = fakeDio({'affected_tasks_count': 1});
    await ApiTaskWriteRepository(dio).reviewDateChange('r1', approve: true);
    expect(
      '${a.last.method} ${a.last.path}',
      'POST /v1/date-change-requests/r1/review',
    );
    expect(a.sentJson, {'decision': 'approved'});

    (dio, a) = fakeDio({'affected_tasks_count': 0});
    await ApiTaskWriteRepository(dio).reviewDateChange('r1', approve: false);
    expect(a.sentJson, {'decision': 'rejected'});

    (dio, a) = fakeDio({'status': 'ok'});
    await ApiTaskWriteRepository(dio).deleteDateChange('r1');
    expect(
      '${a.last.method} ${a.last.path}',
      'DELETE /v1/date-change-requests/r1',
    );
  });

  group('dosya', () {
    late Directory dir;
    late File file;
    setUp(() {
      dir = Directory.systemTemp.createTempSync('nz_p3_');
      file = File('${dir.path}/rapor.pdf')..writeAsBytesSync([37, 80, 68, 70]);
    });
    tearDown(() => dir.deleteSync(recursive: true));

    test('attachFile: multipart tek file parçası, bildirilen tür, tag + subtask_id', () async {
      final (dio, a) = fakeDio({
        'file_id': 'f1',
        'work_item_id': 'w1',
        'display_name': 'rapor.pdf',
        'content_type': 'application/pdf',
        'size_bytes': 4,
        'tag': 'sonuc',
      }, status: 201);
      await ApiTaskWriteRepository(dio).attachFile(
        _task(),
        UploadSource(path: file.path, name: 'rapor.pdf', sizeBytes: 4),
        EvidenceTag.outcome,
        subtaskId: 's1',
      );
      final o = a.last;
      expect('${o.method} ${o.path}', 'POST /v1/work-items/w1/files');
      expect(o.queryParameters, {'tag': 'sonuc', 'subtask_id': 's1'});
      expect(o.extra.values, contains('d9'));
      expect((o.extra['openapi'] as Map)['operationId'], 'attachFile');
      final form = o.data as FormData;
      expect(form.fields, isEmpty);
      expect(form.files.map((e) => e.key), ['file']);
      final part = form.files.single.value;
      expect(part.filename, 'rapor.pdf');
      expect(part.contentType.toString(), 'application/pdf');
    });

    test('attachFile: subtask_id yoksa gönderilmez', () async {
      final (dio, a) = fakeDio({
        'file_id': 'f1',
        'work_item_id': 'w1',
        'display_name': 'rapor.pdf',
        'content_type': 'application/pdf',
        'size_bytes': 4,
        'tag': 'ister',
      }, status: 201);
      await ApiTaskWriteRepository(dio).attachFile(
        _task(),
        UploadSource(path: file.path, name: 'rapor.pdf', sizeBytes: 4),
        EvidenceTag.requirement,
      );
      expect(a.last.queryParameters, {'tag': 'ister'});
    });

    test('yeniden adlandır / sil / indir: görevin departmanı', () async {
      var (dio, a) = fakeDio({
        'file_id': 'f1',
        'work_item_id': 'w1',
        'display_name': 'yeni.pdf',
        'content_type': 'application/pdf',
        'size_bytes': 4,
        'tag': 'sonuc',
      });
      await ApiTaskWriteRepository(dio).renameFile(_task(), 'f1', 'yeni.pdf');
      expect('${a.last.method} ${a.last.path}', 'PATCH /v1/files/f1/name');
      expect(a.sentJson, {'display_name': 'yeni.pdf'});
      expect(a.last.extra.values, contains('d9'));

      (dio, a) = fakeDio('');
      await ApiTaskWriteRepository(dio).deleteFile(_task(), 'f1');
      expect('${a.last.method} ${a.last.path}', 'DELETE /v1/files/f1');
      expect(a.last.extra.values, contains('d9'));
    });

    test('hata zarfı ApiError olur (too_large)', () async {
      final (dio, _) = fakeDio(errorEnvelope('records.too_large'), status: 422);
      await expectLater(
        ApiTaskWriteRepository(dio).attachFile(
          _task(),
          UploadSource(path: file.path, name: 'rapor.pdf', sizeBytes: 4),
          EvidenceTag.outcome,
        ),
        throwsApiError('records.too_large'),
      );
    });
  });

  test('UploadSource: izinli tür, jpeg reddi, sınır', () {
    const ok = UploadSource(path: '/x', name: 'Plan.DOCX', sizeBytes: 1);
    expect(ok.contentType, startsWith('application/vnd.openxml'));
    expect(
      const UploadSource(path: '/x', name: 'a.jpeg', sizeBytes: 1).contentType,
      isNull,
    );
    expect(
      const UploadSource(path: '/x', name: 'a', sizeBytes: 1).contentType,
      isNull,
    );
    expect(
      const UploadSource(
        path: '/x',
        name: 'a.pdf',
        sizeBytes: uploadMaxBytes,
      ).tooLarge,
      isTrue,
    );
    expect(
      const UploadSource(
        path: '/x',
        name: 'a.pdf',
        sizeBytes: uploadMaxBytes - 1,
      ).tooLarge,
      isFalse,
    );
  });
}
