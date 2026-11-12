// Koordinatörlük testlerinin sahte backend'i (yalnız test): PilotBackend + programın
// departmanları, ekipleri, görevleri, toplantıları ve arşiv dosyaları SUNUCU BİÇİMİNDE
// (pin `v0.9.0-api` şemaları; alan adları ve değer biçimleri yerel dev backend'in gerçek
// yanıtlarından). Ekranlar gerçek depolar → üretilmiş istemci → bu yanıtlar zinciriyle beslenir;
// domain nesnesi elle kurulmaz. Kapsam başlıkları gerçek sunucu gibi denetlenir: eksik program
// (ve dosyalarda departman) → 422 `platform.scope_missing`.
import 'package:dio/dio.dart';

import '../../support/fake_backend.dart';
import '../pilot_support.dart';

/// Fikstür programı (PilotBackend'in ilk programı).
const coordProgram = 'prog-1';

/// Departman kimlikleri (sunucu `department_id`; ekranda gösterilmez).
const dAlt = 'dep-alt';
const dEle = 'dep-ele';
const dEgi = 'dep-egi';
const dIda = 'dep-ida';

/// Kişi kimlikleri (`account_id`).
const pAbdullah = 'acc-abdullah';
const pAli = 'acc-ali';
const pKadir = 'acc-kadir';
const pBurak = 'acc-burak';
const pBahar = 'acc-bahar';
const pEski = 'acc-eski';

/// Görev kimlikleri (`work_item_id`).
const tAltLate30 = 'wi-alt-1';
const tAltLate12 = 'wi-alt-2';

class CoordBackend extends PilotBackend {
  /// `GET /v1/program/departments`: sunucunun döndürdüğü sırayla (bayt sırası; Türkçe değil —
  /// "Elektrik" "Eğitim"den önce gelir, istemci Türkçe sıralar). İdari işlerin kodu yok.
  List<Map<String, Object?>> departments = [
    {
      'department_id': dAlt,
      'display_name': 'Altyapı ve tesisat',
      'code': 'ALT',
    },
    {
      'department_id': dEle,
      'display_name': 'Elektrik ve enerji',
      'code': 'ELE',
    },
    {'department_id': dEgi, 'display_name': 'Eğitim ve Arge', 'code': 'EGI'},
    {'department_id': dIda, 'display_name': 'İdari işler'},
  ];

  /// `GET /v1/departments` satırları (S1, yalnız şirket yöneticisi; tür serbest dizge). İdari
  /// işler listede yok (kesilmiş liste gibi).
  List<Map<String, Object?>> companyDepartments = [
    {
      'department_id': dAlt,
      'name': 'Altyapı ve tesisat',
      'kind': 'koordinatorluk',
      'code': 'ALT',
      'description': 'Su ve yapı işleri',
    },
    {
      'department_id': dEle,
      'name': 'Elektrik ve enerji',
      'kind': 'calisma_grubu',
      'code': 'ELE',
    },
    {'department_id': dEgi, 'name': 'Eğitim ve Arge', 'kind': 'yeni_tur'},
  ];

  /// false → oturumdaki hesap şirket yöneticisi değil, programda ALT koordinatörü
  /// (`/v1/me`, `/v1/me/departments`); `GET /v1/departments` 403 döner.
  bool admin = true;

  /// Doluysa `GET /v1/departments` bu kodla (HTTP 503) düşer.
  String? departmentsError;

  /// `GET /v1/departments/{id}/members` satırları, departmana göre.
  Map<String, List<Map<String, Object?>>> rosters = {
    dAlt: [
      _member('m1', pAbdullah, 'Abdullah Ateş', 'koordinator'),
      _member('m2', pAli, 'Ali Avcı', 'koordinator'),
      _member('m3', pKadir, 'Kadir Özbek', 'uye'),
      // Silinmiş üyelik: ekipte görünmez.
      _member('m4', pEski, 'Eski Üye', 'uye', status: 'deleted'),
    ],
    dEle: [_member('m5', pBurak, 'Burak Er', 'koordinator')],
    dEgi: [_member('m6', pBahar, 'Bahar Kılıç', 'uye')],
    dIda: [],
  };

  /// `GET /v1/program/work-items` kalemleri. ALT 2/4 (2 geciken), ELE 2/2, EGI 1/3 (1 geciken),
  /// İdari görevsiz: program geneli 5/9.
  List<Map<String, Object?>> workItems = [
    workItem(tAltLate12, dAlt, 'Hidrofor montajı', 'devam_ediyor', [
      (pAli, 'Ali Avcı'),
    ], overdue: 12),
    workItem(tAltLate30, dAlt, 'İletim hattı yapımı', 'baslanmadi', [
      (pKadir, 'Kadir Özbek'),
    ], overdue: 30),
    workItem('wi-alt-3', dAlt, 'Arıtma devreye alma', 'tamamlandi', [
      (pAbdullah, 'Abdullah Ateş'),
    ]),
    workItem('wi-alt-4', dAlt, 'Depo temeli', 'tamamlandi', [
      (pKadir, 'Kadir Özbek'),
    ]),
    workItem('wi-ele-1', dEle, 'Trafo bağlantısı', 'tamamlandi', [
      (pBurak, 'Burak Er'),
    ]),
    workItem('wi-ele-2', dEle, 'Aydınlatma', 'tamamlandi', []),
    workItem('wi-egi-1', dEgi, 'Gönüllü eğitimi', 'onaya_sunuldu', [
      (pBahar, 'Bahar Kılıç'),
    ], overdue: 5),
    workItem('wi-egi-2', dEgi, 'Arge sunumu', 'devam_ediyor', []),
    workItem('wi-egi-3', dEgi, 'Atölye planı', 'tamamlandi', []),
  ];

  /// `GET /v1/meetings` kalemleri (program geneli; istemci departmana göre süzer).
  List<Map<String, Object?>> meetings = [
    _meeting('mt-1', 'Saha keşfi', '2026-11-20T07:00:00Z', dAlt, [dAlt, dEle]),
    _meeting('mt-2', 'Enerji planı', '2026-11-25T09:30:00Z', dEle, [dEle]),
  ];

  /// `GET /v1/records/archive/attachments` dosyaları, departmana göre (S3 başlığı).
  Map<String, List<Map<String, Object?>>> files = {
    dAlt: [
      {
        'file_id': 'f-1',
        'work_item_id': 'wi-alt-3',
        'display_name': 'Teslim_tutanagi.pdf',
        'content_type': 'application/pdf',
        'size_bytes': 38,
        'tag': 'cikti',
        'uploaded_by_account_id': pAbdullah,
      },
    ],
  };

  /// Fikstürün yanıtlamadığı (PilotBackend'e düşen) istekler: ekranın beklenmedik bir uca
  /// gittiğini görünür kılar.
  final unhandled = <String>[];

  /// Yazma istekleri (`YÖNTEM yol`) ve gövdeleri, geliş sırasıyla.
  final writes = <(String, Object?)>[];

  /// Doluysa `POST /v1/program/departments` bu kodla (HTTP 503) düşer.
  String? linkError;

  /// true → `POST /v1/program/departments` bağı kurar ama yanıt kaybolur (HTTP 503).
  bool linkLost = false;

  @override
  ResponseBody handle(Seen r) {
    final program = r.header('X-Nizamio-Program');
    final key = '${r.method} ${r.path}';
    switch (key) {
      case 'GET /v1/me' when !admin:
        return jsonResponse(200, {
          'account_id': pAli,
          'email': 'ali@b.test',
          'full_name': 'Ali Avcı',
          'company_admin': false,
        });
      case 'GET /v1/me/departments' when !admin:
        return jsonResponse(200, {
          'departments': [
            {
              'program_id': coordProgram,
              'program_name': 'Program Bir',
              'department_id': dAlt,
              'display_name': 'Altyapı ve tesisat',
              'role': 'koordinator',
            },
          ],
        });
      case 'GET /v1/departments':
        if (!admin) return errorBody(403, 'organization.not_authorized');
        final err = departmentsError;
        if (err != null) return errorBody(503, err);
        return jsonResponse(200, {'departments': companyDepartments});
      case 'GET /v1/program/departments':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {'departments': departments});
      case 'GET /v1/program/work-items':
        if (program != coordProgram) return _scopeMissing();
        final dept = r.query['department_id'];
        return jsonResponse(200, {
          'items': [
            for (final w in workItems)
              if (dept == null || w['department_id'] == dept) w,
          ],
        });
      case 'GET /v1/work-items/gantt/admin':
      case 'GET /v1/work-items/gantt':
      case 'GET /v1/work-items/gantt/mine':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {
          'tasks': [
            for (final w in workItems)
              if (admin ||
                  w['department_id'] == r.header('X-Nizamio-Department'))
                {
                  ...w,
                  'pending_date_request': w['pending_date_request'],
                  'subtask_counts':
                      w['subtask_counts'] ?? {'total': 0, 'done': 0},
                  'dates_revision': w['dates_revision'] ?? 1,
                  'planned_end_on': '',
                  'completed_on': w['completed_on'] ?? '',
                  'lateness': {
                    for (final field in [
                      'is_overdue',
                      'days_overdue',
                      'is_completed_late',
                      'days_late',
                      'is_completed_early',
                      'days_early',
                    ])
                      field: w[field],
                  },
                },
          ],
          'links': <Object>[],
        });
      case 'GET /v1/reports/dashboard/coordinatorships':
        if (!admin) return errorBody(403, 'reporting.not_authorized');
        return jsonResponse(200, {
          'coordinatorships': [
            for (final d in departments)
              {
                'department_id': d['department_id'],
                'name': d['display_name'],
                'kind': 'koordinatorluk',
                'coordinators': [
                  for (final m
                      in rosters[d['department_id']] ??
                          const <Map<String, Object?>>[])
                    if (m['role'] == 'koordinator' && m['status'] == 'active')
                      {
                        'account_id': m['account_id'],
                        'full_name': m['full_name'],
                      },
                ],
                'total_tasks': workItems
                    .where((w) => w['department_id'] == d['department_id'])
                    .length,
                'completed_tasks': workItems
                    .where(
                      (w) =>
                          w['department_id'] == d['department_id'] &&
                          w['status'] == 'tamamlandi',
                    )
                    .length,
                'overdue_tasks': workItems
                    .where(
                      (w) =>
                          w['department_id'] == d['department_id'] &&
                          w['is_overdue'] == true,
                    )
                    .length,
                'in_progress_tasks': 0,
                'not_started_tasks': 0,
                'completion_rate': 0.0,
                'member_count': 0,
                'meeting_count': 0,
                'last_activity_at': null,
              },
          ],
        });
      case 'GET /v1/admin/deleted/meetings':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {'items': <Object>[], 'next_cursor': ''});
      case 'GET /v1/meetings':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {'items': meetings, 'next_cursor': ''});
      case 'GET /v1/records/archive/attachments':
        final dept = r.header('X-Nizamio-Department');
        if (program != coordProgram || dept == null) return _scopeMissing();
        return jsonResponse(200, {'files': files[dept] ?? const <Object>[]});
      // Arşiv özetleri yönetici görünümüyle (dönem geneli; RECORDS-K18/K21).
      case 'GET /v1/records/archive/folders':
        if (program != coordProgram ||
            r.header('X-Nizamio-Department') == null) {
          return _scopeMissing();
        }
        return jsonResponse(200, {
          'folders': [
            for (final d in departments)
              {
                'folder_id': d['department_id'],
                'name': d['display_name'],
                'file_count': files[d['department_id']]?.length ?? 0,
                'is_virtual': false,
              },
          ],
        });
      case 'GET /v1/records/archive/tasks':
        if (program != coordProgram) return _scopeMissing();
        final all = [for (final rows in files.values) ...rows];
        return jsonResponse(200, {
          'tasks': [
            for (final w in workItems)
              if (all.any((f) => f['work_item_id'] == w['work_item_id']))
                {
                  'work_item_id': w['work_item_id'],
                  'title': w['title'],
                  'file_count': all
                      .where((f) => f['work_item_id'] == w['work_item_id'])
                      .length,
                },
          ],
        });
      case 'GET /v1/records/archive/uploaders':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {
          'uploaders': {
            for (final rows in files.values)
              for (final f in rows) f['uploaded_by_account_id'],
          }.toList(),
        });
    }
    final work = RegExp(r'^/v1/work-items/([^/]+)$').firstMatch(r.path);
    if (work != null && (r.method == 'GET' || r.method == 'PATCH')) {
      final item = workItems.firstWhere(
        (w) => w['work_item_id'] == work.group(1),
      );
      if (r.method == 'PATCH') {
        final body = r.body! as Map<String, Object?>;
        if (body['expected_dates_revision'] != item['dates_revision']) {
          return errorBody(409, 'work.edit_conflict');
        }
        for (final field in ['start_on', 'end_on']) {
          if (body.containsKey(field)) item[field] = body[field];
        }
        item['dates_revision'] = (item['dates_revision']! as int) + 1;
        writes.add((key, r.body));
      }
      return jsonResponse(200, {...item, 'description': ''});
    }
    if (key == 'POST /v1/date-change-requests') {
      writes.add((key, r.body));
      final body = r.body! as Map<String, Object?>;
      final item = workItems.firstWhere(
        (w) => w['work_item_id'] == body['work_item_id'],
      );
      item['pending_date_request'] = {
        'request_id': 'request',
        'new_start_on': body['new_start_on'],
        'new_end_on': body['new_end_on'],
      };
      return jsonResponse(201, {
        'request_id': 'request',
        'work_item_id': body['work_item_id'],
        'status': 'pending',
        'old_start_on': item['start_on'],
        'old_end_on': item['end_on'],
        'new_start_on': body['new_start_on'],
        'new_end_on': body['new_end_on'],
      });
    }
    if (r.method != 'GET') {
      if (_write(r, key, program) case final res?) return res;
    }
    final detail = RegExp(r'^/v1/program/departments/([^/]+)$')
        .firstMatch(r.path);
    if (r.method == 'GET' && detail != null) {
      if (program != coordProgram) return _scopeMissing();
      if (departmentsError case final error?) return errorBody(503, error);
      final id = detail.group(1);
      final links = departments.where((d) => d['department_id'] == id);
      if (links.isEmpty) return errorBody(404, 'program.department_not_found');
      final rows = companyDepartments.where((d) => d['department_id'] == id);
      final row = rows.firstOrNull;
      return jsonResponse(200, {
        ...links.single,
        'kind': row?['kind'] ?? 'koordinatorluk',
        'description': ?row?['description'],
      });
    }
    final members = RegExp(r'^/v1/departments/([^/]+)/members$')
        .firstMatch(r.path);
    if (r.method == 'GET' && members != null) {
      if (program != coordProgram) return _scopeMissing();
      final rows = rosters[members.group(1)];
      if (rows == null) return errorBody(404, 'platform.not_found');
      return jsonResponse(200, {'members': rows});
    }
    final res = super.handle(r);
    if (res.statusCode == 404) unhandled.add(key);
    return res;
  }

  /// Departman yazmaları (şirket yöneticisi): oluştur (ad küresel tekil), düzenle, programa
  /// bağla (bağ varsa var olanı döndürür), programdaki adı değiştir.
  ResponseBody? _write(Seen r, String key, String? program) {
    final body = (r.body as Map<String, Object?>?) ?? const {};
    final dept = RegExp(r'^/v1/departments/([^/]+)$').firstMatch(r.path);
    final link = RegExp(r'^/v1/program/departments/([^/]+)$')
        .firstMatch(r.path);
    final known =
        key == 'POST /v1/departments' ||
        key == 'POST /v1/program/departments' ||
        (r.method == 'PATCH' && (dept != null || link != null));
    if (!known) return null;
    writes.add((key, r.body));
    if (!admin) {
      return errorBody(
        403,
        r.path.startsWith('/v1/program')
            ? 'program.not_authorized'
            : 'organization.not_authorized',
      );
    }
    if (r.path.startsWith('/v1/program') && program != coordProgram) {
      return _scopeMissing();
    }
    Map<String, Object?> link_(String id) {
      final row = departments.firstWhere((d) => d['department_id'] == id);
      return {
        'program_id': coordProgram,
        'department_id': id,
        'display_name': row['display_name'],
        'copied_member_count': 0,
      };
    }

    if (key == 'POST /v1/departments') {
      final name = body['name']! as String;
      if (companyDepartments.any(
        (d) => (d['name']! as String).toLowerCase() == name.toLowerCase(),
      )) {
        return errorBody(409, 'organization.department_exists');
      }
      final row = <String, Object?>{
        'department_id': 'dep-new-${companyDepartments.length}',
        'name': name,
        'kind': body['kind'],
        'description': ?body['description'],
      };
      companyDepartments.add(row);
      return jsonResponse(201, row);
    }
    if (key == 'POST /v1/program/departments') {
      final err = linkError;
      if (err != null) return errorBody(503, err);
      final id = body['department_id']! as String;
      final catalog = companyDepartments.firstWhere(
        (d) => d['department_id'] == id,
      );
      if (!departments.any((d) => d['department_id'] == id)) {
        departments.add({
          'department_id': id,
          'display_name': body['display_name'] ?? catalog['name'],
        });
        rosters[id] = [];
      }
      if (linkLost) return errorBody(503, 'platform.internal');
      return jsonResponse(201, link_(id));
    }
    if (link != null) {
      final id = link.group(1)!;
      departments.firstWhere((d) => d['department_id'] == id)['display_name'] =
          body['display_name'];
      return jsonResponse(200, link_(id));
    }
    final row = companyDepartments.firstWhere(
      (d) => d['department_id'] == dept!.group(1),
    )..addAll(body);
    return jsonResponse(200, row);
  }

  static ResponseBody _scopeMissing() =>
      errorBody(422, 'platform.scope_missing');
}

Map<String, Object?> _member(
  String membership,
  String account,
  String name,
  String role, {
  String status = 'active',
}) => {
  'membership_id': membership,
  'account_id': account,
  'full_name': name,
  'role': role,
  'status': status,
};

/// Sunucu `WorkItem` kalemi; gecikme alanları sunucu değerleridir ([overdue] gün).
Map<String, Object?> workItem(
  String id,
  String department,
  String title,
  String status,
  List<(String, String)> assignees, {
  int overdue = 0,
}) => {
  'work_item_id': id,
  'program_id': coordProgram,
  'department_id': department,
  'title': title,
  'priority': 'orta',
  'status': status,
  'assignee_account_ids': [for (final (a, _) in assignees) a],
  'assignees': [
    for (final (a, n) in assignees) {'account_id': a, 'full_name': n},
  ],
  'start_on': '2026-09-01',
  'end_on': '2026-10-20',
  'completed_on': status == 'tamamlandi' ? '2026-10-15' : null,
  'completion_evidence_required': false,
  'subtask_counts': {'total': 0, 'done': 0},
  'edit_revision': 1,
  'dates_revision': 1,
  'pending_date_request': null,
  'created_at': '2026-08-20T09:00:00Z',
  'created_by_account_id': 'acc-1',
  'created_by_full_name': 'Ayşe Yılmaz',
  'is_overdue': overdue > 0,
  'days_overdue': overdue,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
};

Map<String, Object?> _meeting(
  String id,
  String title,
  String at,
  String owner,
  List<String> departments,
) => {
  'meeting_id': id,
  'program_id': coordProgram,
  'owner_department_id': owner,
  'title': title,
  'meeting_date': at,
  'members_included': true,
  'invite_mode': 'coordinatorship',
  'place': null,
  'created_by_account_id': 'acc-1',
  'created_by_role': 'admin',
  'created_at': '2026-11-01T17:28:17Z',
  'updated_at': '2026-11-01T17:28:17Z',
  'departments': [
    for (final d in departments) {'department_id': d, 'department_name': d},
  ],
};
