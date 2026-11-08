part of 'task_catalog_api_repository_test.dart';

// Sunucu yanıtı fikstürleri (sayfa, görev, kimlik, departman, ekip satırı).

Map<String, Object> _page(List<Object> items, [String? next]) => {
  'items': items,
  'next_cursor': ?next,
};

Map<String, Object?> _item(
  String id,
  String dept, {
  bool evidence = false,
  int total = 0,
  int done = 0,
  String? name = 'Ali Veli',
  Map<String, Object?>? pending,
}) => {
  'work_item_id': id,
  'program_id': 'p1',
  'department_id': dept,
  'title': 'Görev $id',
  'priority': 'yuksek',
  'status': 'devam_ediyor',
  'assignee_account_ids': ['u2'],
  'assignees': [
    {'account_id': 'u2', 'full_name': name},
  ],
  'start_on': '2026-10-05',
  'end_on': '2026-10-18',
  'is_overdue': true,
  'days_overdue': 4,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'completion_evidence_required': evidence,
  'subtask_counts': {'total': total, 'done': done},
  'edit_revision': 1,
  'dates_revision': 1,
  'created_at': '2026-10-01T09:00:00Z',
  'created_by_account_id': 'u-creator',
  'created_by_full_name': 'Oluşturan Kişi',
  'planned_end_on': '2026-10-20',
  'pending_date_request': pending,
};

Map<String, Object> _me({bool admin = false}) => {
  'account_id': 'me',
  'email': 'a@b.test',
  'full_name': 'Ayşe Kaya',
  'company_admin': admin,
};

Map<String, Object> _programDepartments(List<(String, String, String?)> rows) =>
    {
      'departments': [
        for (final (id, name, code) in rows)
          {'department_id': id, 'display_name': name, 'code': ?code},
      ],
    };

Map<String, Object> _seats(List<(String, String, String)> rows) => {
  'departments': [
    for (final (program, dept, role) in rows)
      {
        'program_id': program,
        'program_name': 'Program',
        'department_id': dept,
        'display_name': 'Ad $dept',
        'role': role,
      },
  ],
};

const _forbidden = {
  'code': 'work.not_authorized',
  'message': 'x',
  'request_id': 'q',
};

Map<String, Object?> _roster(
  String id,
  String name,
  String role, {
  String status = 'active',
}) => {
  'membership_id': 'm-$id',
  'account_id': id,
  'full_name': name,
  'role': role,
  'status': status,
};

const _adminOnly = [
  '/v1/work-items/gantt/admin',
  '/v1/reports/dashboard/tasks',
  '/v1/reports/dashboard/coordinatorships',
  '/v1/admin/users',
];
