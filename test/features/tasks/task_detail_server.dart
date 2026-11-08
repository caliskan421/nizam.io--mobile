// Görev ayrıntısı sahte sunucusu (görev `w1`, departman `d1`, oturum hesabı `acc-1`): yazma
// testleri ve alt görev sayfa testi ortak kullanır.
import 'dart:async';

import 'package:dio/dio.dart';

import '../../support/fake_backend.dart';
import '../pilot_support.dart';

/// Ayarlanabilir sahte sunucu (görev `w1`, departman `d1`, oturum hesabı `acc-1`).
class TaskDetailServer {
  bool admin = false;
  String role = 'koordinator';
  List<String> assignees = ['u2'];
  String status = 'devam_ediyor';
  List<Map<String, Object?>> subtasks = [
    subtaskWire('s1', done: false),
    subtaskWire('s2', done: false, assignee: 'u2'),
  ];
  List<Map<String, Object?>> notes = [
    taskNoteWire('n1', 'acc-1', 'Benim notum'),
    taskNoteWire('n2', 'u2', 'Başkasının notu'),
  ];

  /// 'METOT yol' → yanıt; verilmeyen yazma için geçerli varsayılan gövde.
  final Map<String, ResponseBody Function()> writes = {};

  /// Doluysa yazma yanıtı bu tamamlanana dek bekler (uçuştaki istek).
  Completer<void>? hold;

  final _pilot = PilotBackend();

  Map<String, Object?> _w1() => {
    'work_item_id': 'w1',
    'title': 'Hidrofor kurulumu',
    'program_id': 'prog-1',
    'department_id': 'd1',
    'priority': 'orta',
    'status': status,
    'assignee_account_ids': assignees,
    'assignees': [
      for (final a in assignees) {'account_id': a, 'full_name': null},
    ],
    'start_on': '2026-11-01',
    'end_on': '2026-11-10',
    'is_overdue': false,
    'days_overdue': 0,
    'is_completed_late': false,
    'days_late': 0,
    'is_completed_early': false,
    'days_early': 0,
    'completion_evidence_required': false,
    'subtask_counts': {'total': subtasks.length, 'done': 0},
    'edit_revision': 1,
    'dates_revision': 1,
    'created_at': '2026-10-01T09:00:00Z',
    'created_by_account_id': 'u-creator',
    'created_by_full_name': 'Oluşturan Kişi',
  };

  FutureOr<ResponseBody> handle(Seen r) async {
    final key = '${r.method} ${r.path}';
    if (r.method != 'GET' && r.path.startsWith('/v1/work-items/')) {
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
          'items': [_w1()],
        });
      case 'GET /v1/work-items/w1':
        return jsonResponse(200, {..._w1(), 'description': 'Pompa odası'});
      case 'GET /v1/work-items/w1/subtasks':
        return jsonResponse(200, {
          'subtasks': subtasks,
          'total': subtasks.length,
        });
      case 'GET /v1/work-items/w1/notes':
        return jsonResponse(200, {'notes': notes, 'total': notes.length});
      case 'GET /v1/work-items/w1/files':
        return jsonResponse(200, {'files': <Object>[]});
      case 'GET /v1/date-change-requests' ||
          'GET /v1/date-change-requests/mine':
        return jsonResponse(200, {'requests': <Object>[], 'total': 0});
    }
    return _pilot.handle(r);
  }

  Object _writeBody(Seen r) {
    if (r.path.endsWith('/transitions') || r.path.endsWith('/own-status')) {
      final to = (r.body! as Map)['to'];
      return {
        'work_item_id': 'w1',
        'from': status,
        'to': to,
        'actor': 'koordinator',
      };
    }
    if (r.path.endsWith('/notes') && r.method == 'POST') {
      return taskNoteWire('n9', 'acc-1', 'yeni');
    }
    if (r.path.endsWith('/subtasks') && r.method == 'POST') {
      return subtaskWire('s9', done: false);
    }
    if (r.path.contains('/subtasks/') && r.method == 'PATCH') {
      return subtaskWire('s1', done: true);
    }
    if (r.path.contains('/notes/') && r.method == 'PATCH') {
      return {'status': 'updated', 'edit_revision': 2};
    }
    return {'status': 'ok'};
  }
}

Map<String, Object?> subtaskWire(
  String id, {
  required bool done,
  String? assignee,
}) => {
  'subtask_id': id,
  'work_item_id': 'w1',
  'title': 'Alt $id',
  'done': done,
  'created_by_account_id': 'acc-1',
  'created_at': '2026-10-02T08:00:00Z',
  'updated_at': '2026-10-02T08:00:00Z',
  'edit_revision': 1,
  'assignee_account_id': ?assignee,
};

Map<String, Object?> taskNoteWire(String id, String by, String text) => {
  'note_id': id,
  'work_item_id': 'w1',
  'author_account_id': by,
  'content': text,
  'created_at': '2026-10-03T09:00:00Z',
  'updated_at': '2026-10-03T09:00:00Z',
  'edit_revision': 1,
};
