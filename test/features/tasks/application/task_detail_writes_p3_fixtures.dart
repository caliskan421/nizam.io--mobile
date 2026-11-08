part of 'task_detail_writes_p3_test.dart';

// Sunucu yanıtı fikstürleri (görev, kanıt dosyası).

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
