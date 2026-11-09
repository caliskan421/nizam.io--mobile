// TaskDetailController + NewTaskFormController sunucu yazmaları (F57 P3) — gerçek bileşim kökü
// ve HTTP yığını, sahte bağdaştırıcı: olgu → eylem (istek yok/var), uç seçimi, görevin KENDİ
// departman başlığı, gövde (PATCH yalnız değişen alanlar; atama farkı; tarih talebi; karar;
// multipart + tag), yazma sonrası yeniden okuma (liste + ayrıntı / yalnız ayrıntı), 409'da
// yeniden okuma ve otomatik tekrar yok, uçuş kilidi, yerel ön denetim (tür/boyut/tavan → kod).
import 'dart:async';
import 'dart:io';

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

part 'task_detail_writes_p3_fixtures.dart';

class _Sink implements DownloadSink {
  final saved = <String, List<int>>{};

  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    saved[name] = [await for (final chunk in bytes) ...chunk];
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
    // Kapsam departmanı listeyi etkilemez (program bağlamı); yazma bağlamı denetimi için.
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
        'expected_revision': 1,
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
      expect(
        log,
        isNot(contains('GET /v1/program/work-items')),
        reason: 'liste yok',
      );
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
          'expected_revision': 1,
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
        'expected_revision': 1,
      });
      expect(_log(h).where((l) => l == 'GET /v1/work-items/w1'), hasLength(1));
      expect(_log(h), isNot(contains('GET /v1/program/work-items')));
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
      expect(_log(h), contains('GET /v1/program/work-items'));
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
      expect(_log(h), isNot(contains('GET /v1/program/work-items')));
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
      expect(_log(h), contains('GET /v1/program/work-items'));

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
      expect(_log(h), isNot(contains('GET /v1/program/work-items')));
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

    test('yönetici ekip satırı olmadan yükler, yalnız kendi dosyasını siler (ADR-0030)', () async {
      final s = _Server()
        ..admin = true
        ..role = 'yok';
      final (h, c, ctl) = await _open(s);
      expect(ctl.openUpload(), isTrue);
      final d = c.read(taskDetailControllerProvider('w1')).upload!;
      ctl.updateUpload(d.copyWith(file: () => src('rapor.pdf')));
      expect((await ctl.submitUpload()).ok, isTrue);
      _only(h, 'POST', '/v1/work-items/w1/files');
      h.backend.requests.clear();
      final files = _task(c).fileEntries;
      final other = files.firstWhere((f) => f.id == 'f2');
      expect((await ctl.deleteFile(other)).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);
      expect(
        (await ctl.deleteFile(files.firstWhere((f) => f.id == 'f1'))).ok,
        isTrue,
      );
      _only(h, 'DELETE', '/v1/files/f1');
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
      expect((await ctl.pickUploadFile(UploadOrigin.files)).ok, isFalse);
      expect(h.backend.requests, isEmpty);
    });

    test('seçim: kaynak seçiciye geçer; vazgeçme taslağı korur', () async {
      final p = _Picker(src('foto.jpg'));
      final (h, c, ctl) = await _open(_Server(), picker: p);
      String? name() => c.read(taskDetailControllerProvider('w1')).upload?.name;
      ctl.openUpload();
      expect((await ctl.pickUploadFile(UploadOrigin.photos)).ok, isTrue);
      expect(name(), 'foto.jpg');
      p.next = null;
      expect((await ctl.pickUploadFile(UploadOrigin.files)).ok, isFalse);
      expect(p.origins, [UploadOrigin.photos, UploadOrigin.files]);
      expect(name(), 'foto.jpg');
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
      final get = _only(h, 'GET', '/v1/files/f1/download');
      expect(get.header('X-Nizamio-Program'), 'prog-1');
      expect(get.header('X-Nizamio-Department'), 'd1');
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
      expect(_log(h), contains('GET /v1/program/work-items'));
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
      // conflict_retry (F60, ADR-0027): aynı anahtarla tek otomatik tekrar; sonra tekrar yok.
      final sends = code == 'platform.conflict_retry' ? 2 : 1;
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
          expect(h.backend.count('POST', '/v1/work-items'), sends);
          final log = _log(h);
          expect(
            log.indexOf('GET /v1/me'),
            greaterThan(log.indexOf('POST /v1/work-items')),
          );
          expect(
            log,
            containsAll([
              'GET /v1/me/departments',
              'GET /v1/program/work-items',
            ]),
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

    // Fable B2: bitiş/başlangıç değişince bağımlılar ötelenebilir → liste de okunur.
    test(
      'düzenle: tarih değişti → PATCH sonrası liste de yeniden okunur',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        await ctl.openEdit();
        h.backend.requests.clear();
        final d = c.read(taskDetailControllerProvider('w1')).edit!;
        ctl.updateEdit(d.copyWith(due: d.due.add(const Duration(days: 5))));
        expect((await ctl.submitEdit()).ok, isTrue);
        final log = _log(h);
        expect(log.first, 'PATCH /v1/work-items/w1');
        expect((_only(h, 'PATCH', '/v1/work-items/w1').body! as Map).keys, [
          'end_on',
          'expected_dates_revision',
        ]);
        expect(log, contains('GET /v1/program/work-items'));
        expect(log, contains('GET /v1/work-items/w1'));
      },
    );
  });
}

/// Seçilen kaynağı kaydeden seçici; [next] null → vazgeçme.
final class _Picker implements UploadPicker {
  _Picker(this.next);
  UploadSource? next;
  final origins = <UploadOrigin>[];

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    origins.add(origin);
    return next;
  }
}
