part of 'meetings_api_repository_test.dart';

// Sunucu yanıtı fikstürleri (toplantı, gündem, not, konferans).

const _t = '2026-11-03T07:00:00Z';

Map<String, Object?> _meeting({
  String role = 'coordinator',
  String id = 'm1',
}) => {
  'meeting_id': id,
  'program_id': 'p1',
  'owner_department_id': 'd1',
  'title': 'Haftalık',
  'meeting_date': _t,
  'members_included': true,
  'invite_mode': 'coordinatorship',
  'place': null,
  'created_by_account_id': 'a1',
  'created_by_role': role,
  'created_at': _t,
  'updated_at': _t,
  'departments': [
    {'department_id': 'd1', 'department_name': 'Mekanik'},
    {'department_id': 'd2', 'department_name': 'Yazılım'},
  ],
};

Map<String, Object?> _agenda({bool checked = false}) => {
  'agenda_item_id': 'g1',
  'meeting_id': 'm1',
  'title': 'Bütçe',
  'sort_order': 1,
  'is_checked': checked,
  'checked_at': checked ? _t : null,
  'checked_by_account_id': checked ? 'a2' : null,
  'created_at': _t,
};

Map<String, Object?> _note({Object? role = 'member'}) => {
  'note_id': 'n1',
  'meeting_id': 'm1',
  'author_account_id': null,
  'author_name': 'Ayşe',
  'author_role': role,
  'content': 'Not',
  'converted_to_work_item_id': null,
  'created_at': _t,
  'updated_at': _t,
  'edit_revision': 1,
};

Map<String, Object?> _conference({String status = 'live'}) => {
  'id': 'c1',
  'status': status,
  'started_at': _t,
  'started_by_account_id': 'a1',
  'connected': {'count': 0, 'account_ids': <String>[], 'observed_at': null},
};

const _effects = {'failed_messages': 2, 'event_failed': true};
