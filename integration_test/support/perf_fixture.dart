// Ölçüm fikstürü (yalnız test): sunucu sözleşmesi biçiminde (`api-pin.json` etiketi,
// openapi `WorkItem`, `WorkItemDetail`, `ProgramDepartment`…) belirleyici görev kümesi.
// Tarihler bugüne göre ±60 gün dağılır; rastgelelik yok (sabit tohumlu doğrusal üreteç).
// Pilot sahte backend ([PilotBackend]) üstüne yalnız görev uçları eklenir; örnek mod yoktur.
// Zaman çizelgesi görevleri liste ucundan (`GET /v1/program/work-items`) okur; bağımlılık
// bağları bu yolda okunmaz (Gantt ucu arayüzde kullanılmıyor), fikstürde yer almaz.
import 'package:dio/dio.dart';

import '../../test/features/pilot_support.dart' show PilotBackend;
import '../../test/support/fake_backend.dart';

/// Fikstürdeki görev sayısı (hedef ≥150).
const perfTaskCount = 160;
const perfProgramId = 'prog-1';

const _departments = [
  ('dep-1', 'Altyapı ve tesisat', 'ALT'),
  ('dep-2', 'Elektrik', 'ELK'),
  ('dep-3', 'İnşaat', 'INS'),
  ('dep-4', 'Peyzaj', 'PEY'),
  ('dep-5', 'Satın alma', 'SAT'),
  ('dep-6', 'Güvenlik', 'GUV'),
];

const _people = [
  ('acc-1', 'Ayşe Yılmaz'),
  ('acc-2', 'Mehmet Demir'),
  ('acc-3', 'Zeynep Kaya'),
  ('acc-4', 'Can Aydın'),
  ('acc-5', 'Elif Şahin'),
];

const _statuses = [
  'baslanmadi',
  'devam_ediyor',
  'devam_ediyor',
  'onaya_sunuldu',
  'iade_edildi',
  'tamamlandi',
];
const _priorities = ['dusuk', 'orta', 'orta', 'yuksek', 'acil'];
const _titles = [
  'Temel kazısı',
  'Kablo çekimi',
  'Kalıp işleri',
  'Fidan dikimi',
  'Malzeme teklifi',
  'Kamera kurulumu',
  'Su hattı testi',
  'Pano montajı',
];

String _day(DateTime t) =>
    '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-'
    '${t.day.toString().padLeft(2, '0')}';

class PerfBackend {
  PerfBackend({DateTime? now})
    : today = DateTime(
        (now ?? DateTime.now()).year,
        (now ?? DateTime.now()).month,
        (now ?? DateTime.now()).day,
      ),
      _pilot = PilotBackend() {
    var seed = 20261105;
    int next(int n) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return (seed >> 8) % n;
    }

    for (var i = 0; i < perfTaskCount; i++) {
      final dep = _departments[i % _departments.length];
      final status = _statuses[next(_statuses.length)];
      final start = today.add(Duration(days: next(111) - 60));
      final end = start.add(Duration(days: 3 + next(28)));
      final done = status == 'tamamlandi';
      final overdue = !done && end.isBefore(today);
      final people = [
        for (var k = 0; k < 1 + next(3); k++) _people[(i + k) % _people.length],
      ];
      final id = 'wi-${(i + 1).toString().padLeft(3, '0')}';
      items.add({
        'work_item_id': id,
        'program_id': perfProgramId,
        'department_id': dep.$1,
        'title': '${dep.$3}-${i + 1} ${_titles[i % _titles.length]}',
        'priority': _priorities[next(_priorities.length)],
        'status': status,
        'assignee_account_ids': [for (final p in people) p.$1],
        'assignees': [
          for (final p in people) {'account_id': p.$1, 'full_name': p.$2},
        ],
        'start_on': _day(start),
        'end_on': _day(end),
        'is_overdue': overdue,
        'days_overdue': overdue ? today.difference(end).inDays : 0,
        'is_completed_late': false,
        'days_late': 0,
        'is_completed_early': done && i % 3 == 0,
        'days_early': done && i % 3 == 0 ? 2 : 0,
        'completion_evidence_required': i % 7 == 0,
        'created_at': '2026-10-01T08:00:00Z',
        'created_by_account_id': 'acc-1',
        'created_by_full_name': 'Ayşe Yılmaz',
        'subtask_counts': {'total': i % 4, 'done': i % 4 == 0 ? 0 : i % 2},
        if (i % 9 == 0)
          'planned_end_on': _day(end.subtract(const Duration(days: 4))),
        if (done) 'completed_on': _day(end),
      });
    }
  }

  final DateTime today;
  final PilotBackend _pilot;
  final List<Map<String, Object?>> items = [];

  ResponseBody handle(Seen r) {
    if (r.method == 'GET') {
      switch (r.path) {
        case '/v1/program/work-items':
          final dep = r.query['department_id'];
          return jsonResponse(200, {
            'items': [
              for (final i in items)
                if (dep == null || i['department_id'] == dep) i,
            ],
          });
        case '/v1/program/departments':
          return jsonResponse(200, {
            'departments': [
              for (final d in _departments)
                {'department_id': d.$1, 'display_name': d.$2, 'code': d.$3},
            ],
          });
      }
      final m = RegExp(r'^/v1/work-items/(wi-\d+)(/[a-z]+)?$')
          .firstMatch(r.path);
      if (m != null) {
        final item = items.firstWhere((i) => i['work_item_id'] == m[1]);
        final subtasks = (item['subtask_counts']! as Map)['total']! as int;
        switch (m[2]) {
          case null:
            return jsonResponse(200, {
              ...item,
              'description': 'Ölçüm fikstürü açıklaması. ' * 3,
            });
          case '/subtasks':
            return jsonResponse(200, {
              'subtasks': [
                for (var k = 0; k < subtasks; k++)
                  {
                    'subtask_id': '${m[1]}-s$k',
                    'work_item_id': m[1],
                    'title': 'Alt görev ${k + 1}',
                    'done': k.isEven,
                    'evidence_required': false,
                    'created_by_account_id': 'acc-1',
                    'created_at': '2026-10-01T08:00:00Z',
                    'updated_at': '2026-10-02T08:00:00Z',
                    'assignee_full_name': null,
                    'done_by_full_name': null,
                    'created_by_full_name': 'Ayşe Yılmaz',
                  },
              ],
              'total': subtasks,
            });
          case '/notes':
            return jsonResponse(200, {
              'notes': [
                {
                  'note_id': '${m[1]}-n1',
                  'work_item_id': m[1],
                  'author_account_id': 'acc-2',
                  'author_full_name': 'Mehmet Demir',
                  'content': 'Saha ziyareti yapıldı.',
                  'created_at': '2026-10-03T08:00:00Z',
                  'updated_at': '2026-10-03T08:00:00Z',
                },
              ],
              'total': 1,
            });
          case '/files':
            return jsonResponse(200, {'files': <Object>[]});
        }
      }
    }
    return _pilot.handle(r);
  }
}
