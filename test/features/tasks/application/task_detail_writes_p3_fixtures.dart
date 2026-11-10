part of 'task_detail_writes_p3_test.dart';

// Ayarlanabilir sahte sunucu ve sunucu yanıtı fikstürleri (görev, kanıt dosyası).

Map<String, Object?> _item(
  String id, {
  List<String> assignees = const ['u2'],
  String priority = 'orta',
  String status = 'devam_ediyor',
  bool evidence = true,
}) => {
  'work_item_id': id,
  'title': 'Hidrofor kurulumu',
  'program_id': 'prog-1',
  'department_id': 'd1',
  'priority': priority,
  'status': status,
  'assignee_account_ids': assignees,
  'assignees': [
    for (final a in assignees) {'account_id': a, 'full_name': 'Ad $a'},
  ],
  'start_on': '2026-11-01',
  'end_on': '2026-11-10',
  'is_overdue': false,
  'days_overdue': 0,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'completion_evidence_required': evidence,
  'subtask_counts': {'total': 0, 'done': 0},
  'edit_revision': 1,
  'dates_revision': 1,
  'created_at': '2026-10-01T09:00:00Z',
  'created_by_account_id': 'u-creator',
  'created_by_full_name': 'Oluşturan Kişi',
};

Map<String, Object?> _file(String id, String by) => {
  'file_id': id,
  'work_item_id': 'w1',
  'display_name': 'rapor.pdf',
  'content_type': 'application/pdf',
  'size_bytes': 2048,
  'tag': 'sonuc',
  'uploaded_by_account_id': by,
  'uploaded_at': '2026-10-03T09:00:00Z',
};

/// Ayarlanabilir sahte sunucu (görev `w1`, departman `d1`, oturum hesabı `acc-1`).
class _Server {
  bool admin = false;
  String role = 'koordinator';
  List<String> assignees = ['u2'];
  String status = 'devam_ediyor';
  String priority = 'orta';
  List<Map<String, Object?>> files = [_file('f1', 'acc-1'), _file('f2', 'u2')];
  List<Map<String, Object?>> extraItems = [];
  Map<String, Object?>? pendingRequest;
  bool failDetails = false;

  final Map<String, ResponseBody Function()> writes = {};
  Completer<void>? hold;
  final _pilot = PilotBackend();

  static bool _isWrite(Seen r) =>
      r.method != 'GET' &&
      (r.path.startsWith('/v1/work-items') ||
          r.path.startsWith('/v1/files/') ||
          r.path.startsWith('/v1/date-change-requests'));

  FutureOr<ResponseBody> handle(Seen r) async {
    final key = '${r.method} ${r.path}';
    if (_isWrite(r)) {
      await hold?.future;
      final custom = writes[key];
      if (custom != null) return custom();
      return jsonResponse(r.method == 'POST' ? 201 : 200, _writeBody(r));
    }
    switch (key) {
      case 'GET /v1/me':
        return jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': admin,
        });
      case 'GET /v1/program/departments':
        return jsonResponse(200, {
          'departments': [
            {'department_id': 'd1', 'display_name': 'Altyapı', 'code': 'ALT'},
          ],
        });
      case 'GET /v1/me/departments':
        return jsonResponse(200, {
          'departments': [
            if (role != 'yok')
              {
                'program_id': 'prog-1',
                'program_name': 'Program Bir',
                'department_id': 'd1',
                'display_name': 'Altyapı',
                'role': role,
              },
          ],
        });
      case 'GET /v1/program/work-items':
        return jsonResponse(200, {
          'items': [
            _item('w1', assignees: assignees, status: status),
            ...extraItems,
          ],
        });
      case 'GET /v1/work-items/w1':
        if (failDetails) return envelope(500, 'platform.internal');
        return jsonResponse(200, {
          ..._item(
            'w1',
            assignees: assignees,
            status: status,
            priority: priority,
          ),
          'description': 'Pompa odası',
        });
      case 'GET /v1/work-items/w1/subtasks':
        return jsonResponse(200, {'subtasks': <Object>[], 'total': 0});
      case 'GET /v1/work-items/w1/notes':
        return jsonResponse(200, {'notes': <Object>[], 'total': 0});
      case 'GET /v1/work-items/w1/files':
        return jsonResponse(200, {'files': files});
      case 'GET /v1/date-change-requests' ||
          'GET /v1/date-change-requests/mine':
        return jsonResponse(200, {
          'requests': [?pendingRequest],
          'total': pendingRequest == null ? 0 : 1,
        });
      case 'GET /v1/departments/d1/members':
        return jsonResponse(200, {
          'members': [
            {
              'membership_id': 'm1',
              'account_id': 'u2',
              'full_name': 'Ali Kaya',
              'role': 'uye',
              'status': 'active',
            },
          ],
        });
      case 'GET /v1/files/f1/download':
        return ResponseBody.fromBytes([1, 2, 3], 200);
    }
    return _pilot.handle(r);
  }

  Object _writeBody(Seen r) {
    final p = r.path;
    if (p == '/v1/work-items' && r.method == 'POST') return _item('w2');
    if (p == '/v1/work-items/w1' && r.method == 'PATCH') return _item('w1');
    if (p.endsWith('/assignments')) return {'added': 1};
    if (p.contains('/assignments/')) return {'removed': 1};
    if (p == '/v1/date-change-requests') {
      return {
        'request_id': 'r9',
        'work_item_id': 'w1',
        'status': 'pending',
        'old_start_on': '2026-10-01',
        'old_end_on': '2026-10-20',
        'new_start_on': '2026-10-01',
        'new_end_on': '2026-11-03',
      };
    }
    if (p.endsWith('/review')) return {'affected_tasks_count': 1};
    if (p.endsWith('/files') && r.method == 'POST') return _file('f9', 'acc-1');
    if (p.endsWith('/name')) return _file('f1', 'acc-1');
    return {'status': 'ok'};
  }
}

Map<String, Object?> _request() => {
  'request_id': 'r1',
  'work_item_id': 'w1',
  'status': 'pending',
  'old_start_on': '2026-10-01',
  'old_end_on': '2026-10-20',
  'new_start_on': '2026-10-01',
  'new_end_on': '2026-11-03',
  'reason': 'Tedarik',
};
