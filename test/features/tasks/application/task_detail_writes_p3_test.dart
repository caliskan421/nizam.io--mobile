// TaskDetailController + NewTaskFormController sunucu yazmaları (F57 P3) — gerçek bileşim kökü
// ve HTTP yığını, sahte bağdaştırıcı: olgu → eylem (istek yok/var), uç seçimi, görevin KENDİ
// departman başlığı, gövde (PATCH yalnız değişen alanlar; atama farkı; tarih talebi; karar;
// multipart + tag), yazma sonrası yeniden okuma (liste + ayrıntı / yalnız ayrıntı), 409'da
// yeniden okuma ve otomatik tekrar yok, uçuş kilidi, yerel ön denetim (tür/boyut/tavan → kod).
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

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
      case 'GET /v1/work-items':
        return jsonResponse(200, {
          'items': [
            _item('w1', assignees: assignees, status: status),
            ...extraItems,
          ],
        });
      case 'GET /v1/work-items/w1':
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

class _Sink implements DownloadSink {
  final saved = <String, Uint8List>{};

  @override
  Future<String> save(String name, Uint8List bytes) async {
    saved[name] = bytes;
    return '/indirilenler/$name';
  }
}

Future<(Harness, ProviderContainer, TaskDetailController)> _open(
  _Server server, {
  DownloadSink? sink,
  UploadPicker? picker,
}) async {
  final h = await pilotHarness(PilotBackend(), signedIn: true);
  h.backend.handler = server.handle;
  if (sink != null) {
    h.composition.locator
      ..unregister<DownloadSink>()
      ..registerSingleton<DownloadSink>(sink);
  }
  if (picker != null) {
    h.composition.locator
      ..unregister<UploadPicker>()
      ..registerSingleton<UploadPicker>(picker);
  }
  final c = h.container;
  h.read(scopeControllerProvider)
    ..selectProgram('prog-1')
    // Ekip satırı olmayan yöneticinin departmanı seçimle gelir (liste tek departman).
    ..selectDepartment('d1');
  c
    ..listen(taskCatalogControllerProvider, (_, _) {})
    ..listen(taskDetailsProvider('w1'), (_, _) {})
    ..listen(taskDetailControllerProvider('w1'), (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  await c.read(taskDetailsProvider('w1').future);
  h.backend.requests.clear();
  return (h, c, c.read(taskDetailControllerProvider('w1').notifier));
}

List<String> _log(Harness h) => [
  for (final r in h.backend.requests) '${r.method} ${r.path}',
];

Seen _only(Harness h, String method, String path) => h.backend.requests
    .where((r) => r.method == method && r.path == path)
    .single;

TaskItem _task(ProviderContainer c) =>
    c.read(taskCatalogControllerProvider).value!.task('w1')!;

void main() {
  group('görev düzenle / öncelik / sil / kopyala', () {
    test('düzenle: PATCH yalnız değişen alanlar, ardından atama farkı; katalog + ayrıntı okunur', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      expect((await ctl.openEdit()).ok, isTrue);
      expect(_log(h), [
        'GET /v1/work-items/w1',
      ], reason: 'form taze okumayla açılır');
      h.backend.requests.clear();
      final d = c.read(taskDetailControllerProvider('w1')).edit!;
      ctl
        ..updateEdit(
          d.copyWith(priority: TaskPriority.urgent, evidenceRequired: false),
        )
        ..editToggleAssignee('u2') // çıkar
        ..editToggleAssignee('u3'); // ekle
      final r = await ctl.submitEdit();
      expect(r.kind, WriteKind.done);
      final log = _log(h);
      expect(log.take(3), [
        'PATCH /v1/work-items/w1',
        'POST /v1/work-items/w1/assignments',
        'DELETE /v1/work-items/w1/assignments/u2',
      ]);
      final patch = _only(h, 'PATCH', '/v1/work-items/w1');
      expect(patch.body, {
        'priority': 'acil',
        'completion_evidence_required': false,
      });
      expect(patch.header('X-Nizamio-Department'), 'd1');
      expect(_only(h, 'POST', '/v1/work-items/w1/assignments').body, {
        'account_ids': ['u3'],
      });
      expect(
        log.indexOf('GET /v1/work-items/w1'),
        greaterThan(2),
        reason: 'yazmalardan sonra kalem tekil okunur',
      );
      expect(log, contains('GET /v1/work-items/w1/files'));
      expect(log, isNot(contains('GET /v1/work-items')), reason: 'liste yok');
      expect(c.read(taskDetailControllerProvider('w1')).edit, isNull);
    });

    test('düzenle: değişiklik yoksa istek yok', () async {
      final (h, _, ctl) = await _open(_Server());
      await ctl.openEdit();
      h.backend.requests.clear();
      expect((await ctl.submitEdit()).kind, WriteKind.unchanged);
      expect(h.backend.requests, isEmpty);
    });

    test(
      'yönetici (koordinatör değil): düzenler ama atama farkı gönderilmez',
      () async {
        final s = _Server()
          ..admin = true
          ..role = 'yok';
        final (h, c, ctl) = await _open(s);
        expect(ctl.permissions.canAssign, isFalse);
        await ctl.openEdit();
        final d = c.read(taskDetailControllerProvider('w1')).edit!;
        ctl
          ..updateEdit(d.copyWith(title: 'Yeni ad'))
          ..editToggleAssignee('u3');
        expect((await ctl.submitEdit()).kind, WriteKind.done);
        expect(_only(h, 'PATCH', '/v1/work-items/w1').body, {
          'title': 'Yeni ad',
        });
        expect(_log(h).where((l) => l.contains('assignments')), isEmpty);
      },
    );

    test('çok adımlı düzenlemede hata: yine yeniden okunur', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.writes['POST /v1/work-items/w1/assignments'] = () =>
          envelope(422, 'work.assignee_not_member');
      await ctl.openEdit();
      final d = c.read(taskDetailControllerProvider('w1')).edit!;
      ctl
        ..updateEdit(d.copyWith(title: 'Yeni ad'))
        ..editToggleAssignee('u3');
      final r = await ctl.submitEdit();
      expect(r.kind, WriteKind.failed);
      expect(r.error!.code, 'work.assignee_not_member');
      expect(_log(h), contains('GET /v1/work-items/w1'));
      expect(c.read(taskDetailControllerProvider('w1')).edit, isNotNull);
    });

    test('üye: düzenle/öncelik/sil/kopyala istek göndermez', () async {
      final s = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (h, _, ctl) = await _open(s);
      expect(
        (await ctl.setPriority(TaskPriority.high)).kind,
        WriteKind.invalid,
      );
      expect((await ctl.delete()).kind, WriteKind.invalid);
      expect((await ctl.copy('(kopya)')).$1.kind, WriteKind.invalid);
      await ctl.openEdit();
      expect((await ctl.submitEdit()).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);
    });

    test('öncelik: PATCH yalnız priority; yalnız kalem yeniden okunur ve katalogda değişir', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.priority = 'yuksek';
      expect((await ctl.setPriority(TaskPriority.high)).ok, isTrue);
      expect(_only(h, 'PATCH', '/v1/work-items/w1').body, {
        'priority': 'yuksek',
      });
      expect(_log(h).where((l) => l == 'GET /v1/work-items/w1'), hasLength(1));
      expect(_log(h), isNot(contains('GET /v1/work-items')));
      final t = c.read(taskCatalogControllerProvider).value!.task('w1')!;
      expect(t.priority, TaskPriority.high, reason: 'tekil okumadan');
      expect(t.description, 'Pompa odası', reason: 'açıklama getWorkItem\'dan');
      expect(
        t.shortCode,
        'Altyapı',
        reason: 'kısa anahtar korunur (koordinatör: ekip satırı adı, kod yok)',
      );
    });

    test('sil: DELETE + katalog; geri alma sunucuda yok', () async {
      final (h, c, ctl) = await _open(_Server());
      expect((await ctl.delete()).ok, isTrue);
      expect(_log(h).first, 'DELETE /v1/work-items/w1');
      expect(_log(h), contains('GET /v1/work-items'));
      expect(c.read(taskDetailControllerProvider('w1')).deleted, isNotNull);
      ctl.undoDelete();
      expect(c.read(taskDetailControllerProvider('w1')).deleted, isNotNull);
    });

    test(
      'kopyala: createWorkItem (aynı departman, ilk atanan); sunucu kimliği',
      () async {
        final s = _Server();
        final (h, _, ctl) = await _open(s);
        s.extraItems = [_item('w2')];
        final (r, id) = await ctl.copy('(kopya)');
        expect(r.ok, isTrue);
        expect(id, 'w2');
        final post = _only(h, 'POST', '/v1/work-items');
        expect(post.header('X-Nizamio-Department'), 'd1');
        expect((post.body! as Map)['title'], 'Hidrofor kurulumu (kopya)');
        expect((post.body! as Map)['assignee_account_id'], 'u2');
      },
    );
  });

  group('atama: üstlen / bırak', () {
    test('koordinatör atamasız görevi üstlenir', () async {
      final s = _Server()..assignees = [];
      final (h, _, ctl) = await _open(s);
      expect(ctl.permissions.canClaim(_task(h.container)), isTrue);
      expect((await ctl.claim()).ok, isTrue);
      expect(_log(h).first, 'POST /v1/work-items/w1/claim');
      expect((await ctl.unclaim()).kind, WriteKind.invalid);
    });

    test('kendi görevini bırakır; yönetici üstlenemez', () async {
      final s = _Server()..assignees = ['acc-1'];
      final (h, _, ctl) = await _open(s);
      expect((await ctl.unclaim()).ok, isTrue);
      expect(_log(h).first, 'DELETE /v1/work-items/w1/claim');

      final a = _Server()
        ..admin = true
        ..role = 'yok'
        ..assignees = [];
      final (h2, _, ctl2) = await _open(a);
      expect((await ctl2.claim()).kind, WriteKind.invalid);
      expect(h2.backend.requests, isEmpty);
    });
  });

  group('tarih talebi', () {
    test('koordinatör talep açar (görevin departmanı); yalnız ayrıntı yeniden okunur', () async {
      final (h, c, ctl) = await _open(_Server());
      expect(ctl.openDateRequest(), isTrue);
      final d = c.read(taskDetailControllerProvider('w1')).dateDraft!;
      ctl.updateDateDraft(d.copyWith(reason: '  Tedarik  '));
      expect((await ctl.submitDateRequest()).ok, isTrue);
      final post = _only(h, 'POST', '/v1/date-change-requests');
      expect(post.header('X-Nizamio-Department'), 'd1');
      expect((post.body! as Map)['work_item_id'], 'w1');
      expect((post.body! as Map)['reason'], 'Tedarik');
      expect(_log(h), isNot(contains('GET /v1/work-items')));
      expect(_log(h), contains('GET /v1/date-change-requests/mine'));
      expect(c.read(taskDetailControllerProvider('w1')).dateDraft, isNull);
    });

    test(
      'bekleyen varken 409 → yeniden okunur, tekrar yok, form açık',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        s.writes['POST /v1/date-change-requests'] = () =>
            envelope(409, 'work.date_request_pending_exists');
        ctl.openDateRequest();
        final r = await ctl.submitDateRequest();
        expect(r.error!.code, 'work.date_request_pending_exists');
        expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
        expect(_log(h), contains('GET /v1/date-change-requests/mine'));
        expect(c.read(taskDetailControllerProvider('w1')).dateDraft, isNotNull);
      },
    );

    test('üye ve tek başına yönetici talep açamaz', () async {
      final m = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (_, _, ctl) = await _open(m);
      expect(ctl.openDateRequest(), isFalse);
      expect((await ctl.submitDateRequest()).kind, WriteKind.invalid);

      final a = _Server()
        ..admin = true
        ..role = 'yok';
      final (_, _, ctl2) = await _open(a);
      expect(ctl2.openDateRequest(), isFalse);
    });

    test('yönetici kararı: review (S1) + katalog ve ayrıntı; koordinatör karar veremez', () async {
      final s = _Server()
        ..admin = true
        ..role = 'yok'
        ..pendingRequest = _request();
      final (h, _, ctl) = await _open(s);
      expect((await ctl.approveRequest()).ok, isTrue);
      final post = _only(h, 'POST', '/v1/date-change-requests/r1/review');
      expect(post.body, {'decision': 'approved'});
      expect(post.header('X-Nizamio-Department'), isNull);
      expect(_log(h), contains('GET /v1/work-items'));

      final k = _Server()..pendingRequest = _request();
      final (h2, _, ctl2) = await _open(k);
      expect((await ctl2.rejectRequest()).kind, WriteKind.invalid);
      expect(h2.backend.requests, isEmpty);
    });
  });

  group('dosya', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('nz_p3c_'));
    tearDown(() => dir.deleteSync(recursive: true));

    UploadSource src(String name, {int size = 4}) {
      final f = File('${dir.path}/$name')..writeAsBytesSync([37, 80, 68, 70]);
      return UploadSource(path: f.path, name: name, sizeBytes: size);
    }

    test('yükle: multipart (file parçası, bildirilen tür), tag + subtask_id sorguda; yalnız ayrıntı okunur', () async {
      final (h, c, ctl) = await _open(_Server());
      expect(ctl.openUpload(), isTrue);
      final d = c.read(taskDetailControllerProvider('w1')).upload!;
      expect(d.tag, EvidenceTag.outcome);
      ctl.updateUpload(
        d.copyWith(file: () => src('rapor.pdf'), tag: EvidenceTag.plan),
      );
      expect((await ctl.submitUpload()).ok, isTrue);
      final post = _only(h, 'POST', '/v1/work-items/w1/files');
      expect(post.query, {'tag': 'plan'});
      expect(post.header('X-Nizamio-Department'), 'd1');
      final body = post.body! as String;
      expect(body, contains('name="file"; filename="rapor.pdf"'));
      expect(body, contains('content-type: application/pdf'));
      expect(_log(h), isNot(contains('GET /v1/work-items')));
      expect(_log(h), contains('GET /v1/work-items/w1/files'));
      final st = c.read(taskDetailControllerProvider('w1'));
      expect(st.upload, isNull);
      expect(st.tab, TaskDetailTab.files);
    });

    test('yerel ön denetim: istek yok, kod metni', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      ctl.openUpload();
      expect((await ctl.submitUpload()).kind, WriteKind.invalid); // dosya yok
      expect(c.read(taskDetailControllerProvider('w1')).showErrors, isTrue);
      final d = c.read(taskDetailControllerProvider('w1')).upload!;
      ctl.updateUpload(d.copyWith(file: () => src('foto.jpeg')));
      expect(
        (await ctl.submitUpload()).error!.code,
        'records.content_rejected',
      );
      ctl.updateUpload(
        d.copyWith(file: () => src('a.pdf', size: uploadMaxBytes)),
      );
      expect((await ctl.submitUpload()).error!.code, 'records.too_large');
      expect(h.backend.requests, isEmpty);
    });

    test('yönetici yükleyemez (koordinatör satırı olsa da)', () async {
      final s = _Server()..admin = true;
      final (h, _, ctl) = await _open(s);
      expect(ctl.openUpload(), isFalse);
      expect((await ctl.submitUpload()).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);
    });

    test('bileşim kökü sistem seçicisini bağlar', () async {
      final (_, c, _) = await _open(_Server());
      expect(c.read(uploadPickerProvider).available, isTrue);
    });

    test('seçici yok: pickUploadFile false, istek yok', () async {
      final (h, _, ctl) = await _open(
        _Server(),
        picker: const UnavailableUploadPicker(),
      );
      ctl.openUpload();
      expect(await ctl.pickUploadFile(), isFalse);
      expect(h.backend.requests, isEmpty);
    });

    test(
      'yeniden adlandır / sil: yetki ve uç; yalnız yükleyen siler',
      () async {
        final (h, c, ctl) = await _open(_Server());
        final files = _task(c).fileEntries;
        final mine = files.firstWhere((f) => f.id == 'f1');
        final other = files.firstWhere((f) => f.id == 'f2');
        expect((await ctl.renameFile(other, 'yeni.pdf')).ok, isTrue);
        expect(_only(h, 'PATCH', '/v1/files/f2/name').body, {
          'display_name': 'yeni.pdf',
        });
        h.backend.requests.clear();
        expect((await ctl.deleteFile(other)).kind, WriteKind.invalid);
        expect(h.backend.requests, isEmpty);
        expect((await ctl.deleteFile(mine)).ok, isTrue);
        final del = _only(h, 'DELETE', '/v1/files/f1');
        expect(del.header('X-Nizamio-Department'), 'd1');
        expect(_log(h), contains('GET /v1/work-items/w1/files'));
      },
    );

    test('indir: baytlar kayda gider; yeniden okuma yok', () async {
      final sink = _Sink();
      final (h, c, ctl) = await _open(_Server(), sink: sink);
      final f = _task(c).fileEntries.firstWhere((f) => f.id == 'f1');
      final (r, path) = await ctl.downloadFile(f);
      expect(r.ok, isTrue);
      expect(path, '/indirilenler/rapor.pdf');
      expect(sink.saved['rapor.pdf'], [1, 2, 3]);
      expect(_log(h), ['GET /v1/files/f1/download']);
    });

    test('uçuş kilidi: çift dokunma tek istek', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      final f = _task(c).fileEntries.firstWhere((f) => f.id == 'f1');
      s.hold = Completer<void>();
      final first = ctl.deleteFile(f);
      expect((await ctl.deleteFile(f)).kind, WriteKind.busy);
      s.hold!.complete();
      expect((await first).ok, isTrue);
      expect(h.backend.count('DELETE', '/v1/files/f1'), 1);
    });
  });

  group('yeni görev (hızlı form)', () {
    test('koordinatör: createWorkItem (tek atanan, kanıt varsayılan açık); sunucu kimliği; katalog okunur', () async {
      final s = _Server();
      final (h, c, _) = await _open(s);
      final ctl = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(coordinatorship: 'd1');
      expect(c.read(newTaskFormControllerProvider).evidenceRequired, isTrue);
      ctl
        ..setTitle('Basınç testi')
        ..toggleAssignee('u2')
        ..toggleAssignee('u3'); // sunucuda tek atanan: yer değiştirir
      expect(c.read(newTaskFormControllerProvider).assignees, ['u3']);
      s.extraItems = [_item('w2')];
      final r = await ctl.submit();
      expect(r, isNotNull);
      final post = _only(h, 'POST', '/v1/work-items');
      expect(post.header('X-Nizamio-Department'), 'd1');
      final body = post.body! as Map;
      expect(body['title'], 'Basınç testi');
      expect(body['assignee_account_id'], 'u3');
      expect(body['completion_evidence_required'], true);
      expect(body['priority'], 'orta');
      expect(body.keys, containsAll(['start_on', 'end_on']));
      expect(_log(h).last, isNot('POST /v1/work-items'));
      expect(_log(h), contains('GET /v1/work-items'));
    });

    test('üye: istek yok, yetki hatası koddan', () async {
      final s = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (h, c, _) = await _open(s);
      final ctl = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(coordinatorship: 'd1')
        ..setTitle('X');
      expect(await ctl.submit(), isNull);
      expect(
        c.read(newTaskFormControllerProvider).failure!.code,
        'work.not_authorized',
      );
      expect(h.backend.requests, isEmpty);
    });

    test('sunucu hatası formda kalır; otomatik tekrar yok', () async {
      final s = _Server();
      final (h, c, _) = await _open(s);
      s.writes['POST /v1/work-items'] = () =>
          envelope(422, 'work.assignee_not_member');
      final ctl = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(coordinatorship: 'd1')
        ..setTitle('X');
      expect(await ctl.submit(), isNull);
      final f = c.read(newTaskFormControllerProvider);
      expect(f.failure!.code, 'work.assignee_not_member');
      expect(f.busy, isFalse);
      expect(f.title, 'X');
      expect(h.backend.count('POST', '/v1/work-items'), 1);
    });
  });

  test('ekip: listMembers (S2, departman yolda)', () async {
    final (h, c, _) = await _open(_Server());
    final team = await c.read(taskTeamProvider('d1').future);
    expect(team.single.name, 'Ali Kaya');
    final get = _only(h, 'GET', '/v1/departments/d1/members');
    expect(get.header('X-Nizamio-Program'), 'prog-1');
  });

  group('F57 D2', () {
    // Codex 1 / Fable B1: üye için yeni görev girişi kapalı; ekip (`listMembers`) istenmez.
    test('üye: yeni görev kapalı, ekip okunmaz (listMembers 0)', () async {
      final s = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (h, c, _) = await _open(s);
      expect(c.read(canCreateTaskProvider), isFalse);
      await expectLater(
        c.read(taskTeamProvider('d1').future),
        throwsA(
          isA<ApiError>().having((e) => e.code, 'code', 'work.not_authorized'),
        ),
      );
      expect(h.backend.count('GET', '/v1/departments/d1/members'), 0);
    });

    test('koordinatör ve yönetici: yeni görev açık', () async {
      final (_, c, _) = await _open(_Server());
      expect(c.read(canCreateTaskProvider), isTrue);
      final (_, a, _) = await _open(
        _Server()
          ..admin = true
          ..role = 'yok',
      );
      expect(a.read(canCreateTaskProvider), isTrue);
    });

    // Codex 2: düzenleme formu açılmadan görev taze okunur; taslak okunan değerden kurulur.
    test('düzenle: form taze getWorkItem okumasından sonra açılır', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.priority = 'acil'; // başka biri değiştirdi
      final r = await ctl.openEdit();
      expect(r.ok, isTrue);
      expect(_log(h), ['GET /v1/work-items/w1']);
      final edit = c.read(taskDetailControllerProvider('w1')).edit!;
      expect(
        edit.priority,
        TaskPriority.urgent,
        reason: 'taslak taze okumadan',
      );
      expect(_task(c).priority, TaskPriority.urgent);
      expect(
        _task(c).fileEntries,
        hasLength(2),
        reason: 'ayrıntı parçaları korunur',
      );
    });

    test(
      'düzenle: taze okuma hatası → form açılmaz, hata kodu döner',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        final old = h.backend.handler;
        h.backend.handler = (r) => r.path == '/v1/work-items/w1'
            ? envelope(404, 'work.item_not_found')
            : old(r);
        final r = await ctl.openEdit();
        expect(r.kind, WriteKind.failed);
        expect(r.error!.code, 'work.item_not_found');
        expect(c.read(taskDetailControllerProvider('w1')).edit, isNull);
        expect(c.read(taskDetailControllerProvider('w1')).busy, isFalse);
        expect(_log(h), ['GET /v1/work-items/w1']);
      },
    );

    // Codex 3: 403 sonrası rol olguları da yenilenir (TaskAccess yeniden hesaplanır).
    test(
      '403: koordinatörlüğü kaldırılmış hesapta yönetim eylemleri gizlenir',
      () async {
        final s = _Server()..assignees = ['acc-1'];
        final (h, c, ctl) = await _open(s);
        expect(ctl.permissions.canManageTask, isTrue);
        expect(ctl.permissions.canAssign, isTrue);
        // Sunucuda koordinatörlük kaldırıldı; hesap atanmış üye olarak kaldı.
        s
          ..role = 'uye'
          ..writes['PATCH /v1/work-items/w1'] = () =>
              envelope(403, 'work.not_authorized');
        final r = await ctl.setPriority(TaskPriority.high);
        expect(r.kind, WriteKind.failed);
        expect(r.error!.code, 'work.not_authorized');
        expect(
          h.backend.count('PATCH', '/v1/work-items/w1'),
          1,
          reason: 'tekrar yok',
        );
        expect(_log(h), containsAll(['GET /v1/me', 'GET /v1/me/departments']));
        await c.read(taskDetailsProvider('w1').future);
        expect(ctl.permissions.canManageTask, isFalse);
        expect(ctl.permissions.canAssign, isFalse);
        expect(ctl.permissions.canManageSubtasks, isFalse);
        expect(c.read(canCreateTaskProvider), isFalse);
        expect(
          (await ctl.setPriority(TaskPriority.urgent)).kind,
          WriteKind.invalid,
        );
        expect(h.backend.count('PATCH', '/v1/work-items/w1'), 1);
      },
    );

    // Codex 5: çok adımlı yazmada adımlar arasında kapsam değişirse kalan adımlar gitmez.
    test(
      'düzenle: PATCH sonrası kapsam değişti → atama adımı gönderilmez',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        await ctl.openEdit();
        s.writes['PATCH /v1/work-items/w1'] = () {
          h.read(scopeControllerProvider).selectDepartment('d2');
          return jsonResponse(200, _item('w1'));
        };
        h.backend.requests.clear();
        final d = c.read(taskDetailControllerProvider('w1')).edit!;
        ctl
          ..updateEdit(d.copyWith(title: 'Yeni ad'))
          ..editToggleAssignee('u3');
        final r = await ctl.submitEdit();
        expect(r.kind, WriteKind.failed);
        expect(r.error!.code, 'client.scope_changed');
        expect(h.backend.count('PATCH', '/v1/work-items/w1'), 1);
        expect(h.backend.count('POST', '/v1/work-items/w1/assignments'), 0);
        final patch = _only(h, 'PATCH', '/v1/work-items/w1');
        expect(patch.header('X-Nizamio-Program'), 'prog-1');
        expect(patch.header('X-Nizamio-Department'), 'd1');
      },
    );

    test(
      'düzenle: adımlar arasında oturum değişti → kalan adımlar gitmez',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        await ctl.openEdit();
        s.writes['PATCH /v1/work-items/w1'] = () {
          unawaited(h.read(sessionControllerProvider).clear());
          return jsonResponse(200, _item('w1'));
        };
        h.backend.requests.clear();
        final d = c.read(taskDetailControllerProvider('w1')).edit!;
        ctl
          ..updateEdit(d.copyWith(title: 'Yeni ad'))
          ..editToggleAssignee('u3');
        final r = await ctl.submitEdit();
        expect(r.kind, WriteKind.failed);
        expect(h.backend.count('POST', '/v1/work-items/w1/assignments'), 0);
      },
    );

    // Codex 6: oluşturma 409/403 → kapsam kataloğu ve yetki olguları yeniden okunur.
    for (final (status, code) in [
      (403, 'work.not_authorized'),
      (409, 'platform.conflict_retry'),
    ]) {
      test(
        'yeni görev $status → katalog + rol olguları okunur, tekrar yok',
        () async {
          final s = _Server();
          final (h, c, _) = await _open(s);
          s.writes['POST /v1/work-items'] = () => envelope(status, code);
          if (status == 403) s.role = 'uye';
          final ctl = c.read(newTaskFormControllerProvider.notifier)
            ..prepare(coordinatorship: 'd1')
            ..setTitle('X');
          expect(await ctl.submit(), isNull);
          final f = c.read(newTaskFormControllerProvider);
          expect(f.failure!.code, code);
          expect(f.title, 'X', reason: 'taslak korunur');
          expect(h.backend.count('POST', '/v1/work-items'), 1);
          final log = _log(h);
          expect(
            log.indexOf('GET /v1/me'),
            greaterThan(log.indexOf('POST /v1/work-items')),
          );
          expect(
            log,
            containsAll(['GET /v1/me/departments', 'GET /v1/work-items']),
          );
          expect(c.read(canCreateTaskProvider), status != 403);
        },
      );
    }

    test('yeni görev 422 → yeniden okuma yok', () async {
      final s = _Server();
      final (h, c, _) = await _open(s);
      s.writes['POST /v1/work-items'] = () =>
          envelope(422, 'work.assignee_not_member');
      final ctl = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(coordinatorship: 'd1')
        ..setTitle('X');
      expect(await ctl.submit(), isNull);
      expect(_log(h), ['POST /v1/work-items']);
    });
  });
}
