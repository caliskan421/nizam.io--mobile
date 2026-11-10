// Tablet gezinme değişmezlerinin sahte sunucusu (yalnız test): [CoordBackend] programı
// (departmanlar, ekipler, görevler, toplantılar, arşiv dosyaları) + görev ayrıntısı, Gantt ve
// sohbet ([ChatFixture]) uçları SUNUCU BİÇİMİNDE. Ekranlar gerçek depolar → üretilmiş istemci → bu yanıtlar zinciriyle
// beslenir; örnek (in-memory) görev/koordinatörlük verisi yoktur.
import 'package:dio/dio.dart';

import '../features/coordinatorships/coord_backend.dart';
import '../features/messages/chat_backend.dart';
import '../features/pilot_support.dart';
import 'fake_backend.dart';

class TabletBackend extends CoordBackend {
  final chats = ChatFixture();

  @override
  ResponseBody handle(Seen r) {
    if (chats.handle(r) case final chat?) return chat;
    final key = '${r.method} ${r.path}';
    switch (key) {
      case 'GET /v1/work-items/gantt' ||
          'GET /v1/work-items/gantt/mine' ||
          'GET /v1/work-items/gantt/admin':
        return jsonResponse(200, {
          'tasks': [for (final w in workItems) _ganttTask(w)],
          'links': <Object>[],
        });
      case 'GET /v1/date-change-requests' ||
          'GET /v1/date-change-requests/mine':
        return jsonResponse(200, {'requests': <Object>[], 'total': 0});
    }
    final detail = RegExp(r'^/v1/work-items/([^/]+)(/[a-z-]+)?$')
        .firstMatch(r.path);
    if (r.method == 'GET' && detail != null) {
      final item = workItems
          .where((w) => w['work_item_id'] == detail.group(1))
          .firstOrNull;
      if (item == null) return errorBody(404, 'platform.not_found');
      return switch (detail.group(2)) {
        null => jsonResponse(200, {...item, 'description': ''}),
        '/subtasks' => jsonResponse(200, {'subtasks': <Object>[], 'total': 0}),
        '/notes' => jsonResponse(200, {'notes': <Object>[], 'total': 0}),
        '/files' => jsonResponse(200, {'files': <Object>[]}),
        '/dependencies' => jsonResponse(200, {
          'dependencies': <Object>[],
          'dependents': <Object>[],
        }),
        _ => super.handle(r),
      };
    }
    return super.handle(r);
  }
}

/// Sunucu `GanttTask`: görev kalemindeki gecikme alanları `lateness` altında.
Map<String, Object?> _ganttTask(Map<String, Object?> w) => {
  for (final k in const [
    'work_item_id',
    'title',
    'program_id',
    'department_id',
    'priority',
    'status',
    'start_on',
    'end_on',
    'assignee_account_ids',
  ])
    k: w[k],
  'planned_end_on': w['end_on'],
  'completed_on': w['completed_on'] ?? '',
  'pending_date_request': null,
  'subtask_counts': w['subtask_counts'] ?? {'total': 0, 'done': 0},
  'dates_revision': w['dates_revision'] ?? 1,
  'lateness': {
    for (final k in const [
      'is_overdue',
      'days_overdue',
      'is_completed_late',
      'days_late',
      'is_completed_early',
      'days_early',
    ])
      k: w[k],
  },
};
