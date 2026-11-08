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
      case 'GET /v1/meetings':
        if (program != coordProgram) return _scopeMissing();
        return jsonResponse(200, {'items': meetings, 'next_cursor': ''});
      case 'GET /v1/records/archive/attachments':
        final dept = r.header('X-Nizamio-Department');
        if (program != coordProgram || dept == null) return _scopeMissing();
        return jsonResponse(200, {'files': files[dept] ?? const <Object>[]});
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
  'created_by_account_id': 'acc-1',
  'created_by_role': 'admin',
  'created_at': '2026-11-01T17:28:17Z',
  'updated_at': '2026-11-01T17:28:17Z',
  'departments': [
    for (final d in departments) {'department_id': d, 'department_name': d},
  ],
};
