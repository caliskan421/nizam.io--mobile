// F60 P5 (V3, S02, S12, CX-P0K-04) görev ayrıntısı yazmaları — gerçek bileşim kökü ve HTTP
// yığını, sahte sunucu:
// - fark formun AÇILIŞ tabanından: açık formda katalog tazelense de dokunulmayan alan geri
//   yazılmaz; gönderim tabanın sürümünü taşır;
// - 409 work.edit_conflict: yeniden okuma, taban/yerel/sunucu ayrımı, ayrık alan korunur, aynı
//   alan seçime kalır, seçimden sonra yeni sürümle gönderim; otomatik tekrar yok;
// - not/alt görev metin çakışması: sunucudaki metin döner, taslak state'te;
// - işlem anahtarı: aynı eylem aynı anahtar, yeni eylem yeni anahtar; yükleme imzası geçici
//   yoldan bağımsız (ad + boyut + içerik özeti);
// - sunucu uyum kapısı: eski sunucu sürümünde istek gönderilmez.
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/presentation/task_texts.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

/// Sahte sunucu: görev `w1` (departman `d1`), oturum hesabı `acc-1` koordinatör.
class _Server {
  String title = 'Hidrofor kurulumu';
  String priority = 'orta';
  bool evidence = false;
  int rev = 1;
  int datesRev = 1;
  String noteText = 'Benim notum';
  int noteRev = 1;
  String subTitle = 'Pompa';
  int subRev = 1;
  String serverVersion = '0.11.0';

  /// 'METOT yol' → sıradaki yanıtlar (boşalınca varsayılan). İşlev fırlatırsa (ör. zaman
  /// aşımı) istemci yanıt görmez.
  final Map<String, List<ResponseBody Function()>> queued = {};
  final _pilot = PilotBackend();

  Map<String, Object?> _w1() => {
    'work_item_id': 'w1',
    'title': title,
    'program_id': 'prog-1',
    'department_id': 'd1',
    'priority': priority,
    'status': 'devam_ediyor',
    'assignee_account_ids': ['u2'],
    'assignees': [
      {'account_id': 'u2', 'full_name': null},
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
    'subtask_counts': {'total': 1, 'done': 0},
    'created_at': '2026-10-01T08:00:00Z',
    'created_by_account_id': 'acc-1',
    'created_by_full_name': null,
    'edit_revision': rev,
    'dates_revision': datesRev,
  };

  FutureOr<ResponseBody> handle(Seen r) {
    final key = '${r.method} ${r.path}';
    final q = queued[key];
    if (q != null && q.isNotEmpty) return q.removeAt(0)();
    switch (key) {
      case 'GET /.well-known/nizamio-instance':
        return jsonResponse(200, {
          'product_id': 'nizamio',
          'instance_id': 'inst-1',
          'company_display_name': 'Test',
          'server_version': serverVersion,
          'api_version': 'v1',
          'minimum_mobile_version': '0.0.0',
          'capabilities': null,
        });
      case 'GET /v1/me':
        return jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': false,
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
              'role': 'koordinator',
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
          'subtasks': [
            {
              'subtask_id': 's1',
              'work_item_id': 'w1',
              'title': subTitle,
              'done': false,
              'evidence_required': false,
              'created_by_account_id': 'acc-1',
              'created_at': '2026-10-02T08:00:00Z',
              'updated_at': '2026-10-02T08:00:00Z',
              'edit_revision': subRev,
            },
          ],
          'total': 1,
        });
      case 'GET /v1/work-items/w1/notes':
        return jsonResponse(200, {
          'notes': [
            {
              'note_id': 'n1',
              'work_item_id': 'w1',
              'author_account_id': 'acc-1',
              'content': noteText,
              'created_at': '2026-10-03T09:00:00Z',
              'updated_at': '2026-10-03T09:00:00Z',
              'edit_revision': noteRev,
            },
          ],
          'total': 1,
        });
      case 'GET /v1/work-items/w1/files':
        return jsonResponse(200, {'files': <Object>[]});
      case 'GET /v1/date-change-requests/mine':
        return jsonResponse(200, {'requests': <Object>[], 'total': 0});
      case 'PATCH /v1/work-items/w1':
        return jsonResponse(200, _w1());
      case 'PATCH /v1/work-items/w1/notes/n1':
        return jsonResponse(200, {'status': 'updated', 'edit_revision': 2});
      case 'POST /v1/work-items':
        return jsonResponse(201, {..._w1(), 'work_item_id': 'w-new'});
      case 'POST /v1/work-items/w1/notes':
        return jsonResponse(201, {
          'note_id': 'n9',
          'work_item_id': 'w1',
          'author_account_id': 'acc-1',
          'content': 'yeni',
          'created_at': '2026-10-03T09:00:00Z',
          'updated_at': '2026-10-03T09:00:00Z',
          'edit_revision': 1,
        });
    }
    if (r.method == 'PATCH' &&
        r.path.startsWith('/v1/work-items/w1/subtasks')) {
      return jsonResponse(200, {
        'subtask_id': 's1',
        'work_item_id': 'w1',
        'title': subTitle,
        'done': false,
        'evidence_required': false,
        'created_by_account_id': 'acc-1',
        'created_at': '2026-10-02T08:00:00Z',
        'updated_at': '2026-10-02T08:00:00Z',
        'edit_revision': subRev + 1,
      });
    }
    return _pilot.handle(r);
  }
}

/// 409 `work.edit_conflict`; [field] bayat grubun gövde alanı.
ResponseBody _conflict(String field) => jsonResponse(409, {
  'code': 'work.edit_conflict',
  'message': 'x',
  'request_id': 'r1',
  'fields': [
    {'field': field, 'code': 'work.edit_conflict', 'message': 'x'},
  ],
});

Future<(Harness, ProviderContainer, TaskDetailController)> _open(
  _Server server,
) async {
  final h = await pilotHarness(PilotBackend(), signedIn: true);
  h.backend.handler = server.handle;
  final c = h.container;
  h.read(scopeControllerProvider).selectProgram('prog-1');
  c
    ..listen(taskCatalogControllerProvider, (_, _) {})
    ..listen(taskDetailsProvider('w1'), (_, _) {})
    ..listen(taskDetailControllerProvider('w1'), (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  await c.read(taskDetailsProvider('w1').future);
  h.backend.requests.clear();
  return (h, c, c.read(taskDetailControllerProvider('w1').notifier));
}

Seen _last(Harness h, String method, String path) =>
    h.backend.requests.where((r) => r.method == method && r.path == path).last;

int _writes(Harness h) =>
    h.backend.requests.where((r) => r.method != 'GET').length;

TaskItem _task(ProviderContainer c) =>
    c.read(taskCatalogControllerProvider).value!.task('w1')!;

void main() {
  group('V3 görev formu', () {
    test('fark açılış tabanından: açık formda tazelenen başlık geri yazılmaz '
        '(S02 ayrık alan)', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      expect((await ctl.openEdit()).ok, isTrue);
      // Form açıkken başkası başlığı değiştirdi ve katalog tazelendi.
      s
        ..title = 'Başkasının başlığı'
        ..rev = 2;
      await c.read(taskCatalogControllerProvider.notifier).refresh();
      expect(_task(c).title, 'Başkasının başlığı');
      final d = c.read(taskDetailControllerProvider('w1')).edit!;
      ctl.updateEdit(d.copyWith(priority: TaskPriority.urgent));
      h.backend.requests.clear();
      expect((await ctl.submitEdit()).ok, isTrue);
      expect(_last(h, 'PATCH', '/v1/work-items/w1').body, {
        'priority': 'acil',
        'expected_revision': 1,
      }, reason: 'yalnız dokunulan alan, tabanın sürümüyle');
    });

    test('409 edit_conflict: taban/yerel/sunucu; aynı alan seçime kalır, '
        'ayrık alan korunur, seçimden sonra yeni sürüm', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      await ctl.openEdit();
      final d = c.read(taskDetailControllerProvider('w1')).edit!;
      ctl.updateEdit(
        d.copyWith(title: 'Benim başlığım', priority: TaskPriority.high),
      );
      // Sunucuda başkası başlığı ve kanıt bayrağını değiştirdi.
      s
        ..title = 'Sunucu başlığı'
        ..evidence = true
        ..rev = 2;
      s.queued['PATCH /v1/work-items/w1'] = [
        () => _conflict('expected_revision'),
      ];
      h.backend.requests.clear();
      final r = await ctl.submitEdit();
      expect(r.kind, WriteKind.conflict);
      expect(r.error?.code, 'work.edit_conflict');
      expect(
        h.backend.count('GET', '/v1/work-items/w1'),
        greaterThan(0),
        reason: 'görev yeniden okundu',
      );
      expect(_writes(h), 1, reason: 'otomatik tekrar yok');
      var e = c.read(taskDetailControllerProvider('w1')).edit!;
      expect(e.conflicts.keys, [EditField.title]);
      final x = e.conflicts[EditField.title]!;
      expect(
        (x.base, x.local, x.server),
        ('Hidrofor kurulumu', 'Benim başlığım', 'Sunucu başlığı'),
      );
      expect(e.priority, TaskPriority.high, reason: 'yalnız yerelde değişen');
      expect(e.evidenceRequired, isTrue, reason: 'dokunulmayan sunucudan');
      expect(e.base!.editRevision, 2);

      // Seçim yapılmadan gönderilmez.
      h.backend.requests.clear();
      expect((await ctl.submitEdit()).kind, WriteKind.conflict);
      expect(_writes(h), 0);

      ctl.resolveConflict(EditField.title, useServer: false);
      e = c.read(taskDetailControllerProvider('w1')).edit!;
      expect(e.conflicts, isEmpty);
      expect((await ctl.submitEdit()).ok, isTrue);
      expect(_last(h, 'PATCH', '/v1/work-items/w1').body, {
        'title': 'Benim başlığım',
        'priority': 'yuksek',
        'expected_revision': 2,
      });
    });

    test('sunucudakini seçmek: değişiklik kalmazsa istek yok', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      await ctl.openEdit();
      final d = c.read(taskDetailControllerProvider('w1')).edit!;
      ctl.updateEdit(d.copyWith(due: DateTime(2026, 11, 20)));
      s
        ..datesRev = 3
        ..rev = 1;
      s.queued['PATCH /v1/work-items/w1'] = [
        () => _conflict('expected_dates_revision'),
      ];
      // Tarih sunucuda başka güne çekildi.
      s.queued['GET /v1/work-items/w1'] = [
        () => jsonResponse(200, {
          ...s._w1(),
          'end_on': '2026-11-15',
          'description': 'Pompa odası',
        }),
      ];
      expect((await ctl.submitEdit()).kind, WriteKind.conflict);
      final e = c.read(taskDetailControllerProvider('w1')).edit!;
      expect(e.conflicts.keys, [EditField.due]);
      ctl.resolveConflict(EditField.due, useServer: true);
      h.backend.requests.clear();
      expect((await ctl.submitEdit()).kind, WriteKind.unchanged);
      expect(_writes(h), 0);
    });
  });

  group('V3 metin çakışması (not, alt görev)', () {
    test('not: 409 → sunucudaki metin; taslak state\'te; sizinki yeni '
        'sürümle', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      final note = _task(c).noteEntries.single;
      s
        ..noteText = 'Başkasının düzeltmesi'
        ..noteRev = 2;
      s.queued['PATCH /v1/work-items/w1/notes/n1'] = [
        () => _conflict('expected_revision'),
      ];
      final r = await ctl.editNote(note, 'Benim düzeltmem');
      expect(r.kind, WriteKind.conflict);
      expect(r.serverText, 'Başkasının düzeltmesi');
      expect(ctl.noteEditDraft(note), 'Benim düzeltmem');
      final fresh = _task(c).noteEntries.single;
      expect(fresh.editRevision, 2);
      expect((await ctl.editNote(fresh, 'Benim düzeltmem')).ok, isTrue);
      expect(_last(h, 'PATCH', '/v1/work-items/w1/notes/n1').body, {
        'content': 'Benim düzeltmem',
        'expected_revision': 2,
      });
      expect(ctl.noteEditDraft(fresh), isNull, reason: 'başarıda düşer');
    });

    test('alt görev adı: 409 → sunucudaki ad; sunucudakini seçmek taslağı '
        'bırakır', () async {
      final s = _Server();
      final (_, _, ctl) = await _open(s);
      s
        ..subTitle = 'Pompa (yeni)'
        ..subRev = 2;
      s.queued['PATCH /v1/work-items/w1/subtasks/s1'] = [
        () => _conflict('expected_revision'),
      ];
      final r = await ctl.renameSubtask('s1', 'Pompa montajı');
      expect(r.kind, WriteKind.conflict);
      expect(r.serverText, 'Pompa (yeni)');
      expect(ctl.subtaskRenameDraft('s1'), 'Pompa montajı');
      ctl.discardTextDraft((TextTarget.subtask, 's1'));
      expect(ctl.subtaskRenameDraft('s1'), isNull);
    });
  });

  group('S12 işlem anahtarı ve sonuç bilinmiyor', () {
    String? key(Harness h, String path) =>
        _last(h, 'POST', path).header('Idempotency-Key');

    test('503: sonuç bilinmiyor; taslak korunur; tekrar AYNI anahtar; başarıda '
        'temizlenir; yeni eylem yeni anahtar', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      const path = '/v1/work-items/w1/notes';
      s.queued['POST $path'] = [() => envelope(503, 'platform.unavailable')];
      ctl.setNoteDraft('Kontrol yapıldı');
      final r = await ctl.sendNote();
      expect(r.kind, WriteKind.unknown);
      expect(r.error?.code, ClientErrorCode.outcomeUnknown);
      expect(
        c.read(taskDetailControllerProvider('w1')).noteDraft,
        'Kontrol yapıldı',
      );
      final first = key(h, path);
      expect(first, matches(RegExp(r'^[A-Za-z0-9_-]{22}$')));
      expect((await ctl.sendNote()).ok, isTrue);
      expect(key(h, path), first, reason: 'aynı eylemin tekrarı aynı anahtar');
      expect(c.read(taskDetailControllerProvider('w1')).noteDraft, '');
      ctl.setNoteDraft('Kontrol yapıldı');
      await ctl.sendNote();
      expect(key(h, path), isNot(first), reason: 'yeni eylem yeni anahtar');
    });

    test('zaman aşımı ve ağ kopması da sonuç bilinmiyor', () async {
      final s = _Server();
      final (h, _, ctl) = await _open(s);
      s.queued['POST /v1/work-items/w1/subtasks'] = [() => timeout(null)];
      final r = await ctl.createSubtask('Vana');
      expect(r.kind, WriteKind.unknown);
      expect(ctl.pendingSubtaskTitle, 'Vana', reason: 'diyalog adla açılır');
      expect(h.backend.count('POST', '/v1/work-items/w1/subtasks'), 1);
    });

    // Codex tur 3 / N5: sunucu yükleme tekrarını gövde okumadan metadata'dan tanır (§8); A
    // kaydedilip yanıtı kaybolduktan sonra aynı ad/boyutlu farklı içerikli B yeni anahtar alır.
    test(
      'yükleme: aynı içeriğin yeniden seçimi (yeni geçici yol) aynı anahtar; '
      'farklı ad, boyut ya da aynı ad/boyutta farklı içerik yeni anahtar',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        const path = '/v1/work-items/w1/files';
        s.queued['POST $path'] = [
          for (var i = 0; i < 5; i++) () => timeout(null),
        ];
        final dir = Directory.systemTemp.createTempSync('nz_f60_');
        addTearDown(() => dir.deleteSync(recursive: true));
        Future<String?> submit(
          String sub,
          String name, {
          int size = 4,
          List<int> content = const [37, 80],
        }) async {
          final f = File('${dir.path}/$sub-$name')..writeAsBytesSync(content);
          final up = UploadSource(path: f.path, name: name, sizeBytes: size);
          final d = c.read(taskDetailControllerProvider('w1')).upload!;
          ctl.updateUpload(d.copyWith(file: () => up));
          expect((await ctl.submitUpload()).kind, WriteKind.unknown);
          return key(h, path);
        }

        expect(ctl.openUpload(), isTrue);
        final first = await submit('1', 'rapor.pdf');
        expect(await submit('2', 'rapor.pdf'), first, reason: 'yeni yol');
        // A kaydedildi, yanıt kayboldu; aynı ad/boyutta farklı içerikli B seçildi.
        final b = await submit('b', 'rapor.pdf', content: const [37, 81]);
        expect(b, isNot(first), reason: 'farklı içerik');
        expect(await submit('3', 'rapor.pdf', size: 5), isNot(first));
        final other = await submit('4', 'plan.pdf');
        expect(other, isNot(first));
      },
    );

    test('409 conflict_retry: aynı anahtarla tek otomatik tekrar', () async {
      final s = _Server();
      final (h, _, ctl) = await _open(s);
      const path = '/v1/work-items/w1/notes';
      s.queued['POST $path'] = [() => envelope(409, 'platform.conflict_retry')];
      ctl.setNoteDraft('Yarış');
      expect((await ctl.sendNote()).ok, isTrue);
      final posts = h.backend.requests
          .where((r) => r.method == 'POST' && r.path == path)
          .toList();
      expect(posts, hasLength(2));
      expect(
        posts.map((r) => r.header('Idempotency-Key')).toSet(),
        hasLength(1),
      );
    });

    test(
      'idempotency_key_reused: "tekrar gönderilemedi"; sonraki gönderim yeni '
      'anahtar',
      () async {
        final s = _Server();
        final (h, _, ctl) = await _open(s);
        const path = '/v1/work-items/w1/notes';
        s.queued['POST $path'] = [
          () => envelope(409, 'work.idempotency_key_reused'),
        ];
        ctl.setNoteDraft('Not');
        final r = await ctl.sendNote();
        expect(r.kind, WriteKind.failed);
        expect(r.error?.code, ClientErrorCode.requestNotResent);
        final first = key(h, path);
        expect((await ctl.sendNote()).ok, isTrue);
        expect(key(h, path), isNot(first));
        expect(h.backend.count('POST', path), 2, reason: 'otomatik tekrar yok');
      },
    );

    test('429: Retry-After metinde, otomatik tekrar yok', () async {
      final s = _Server();
      final (h, _, ctl) = await _open(s);
      const path = '/v1/work-items/w1/notes';
      s.queued['POST $path'] = [
        () => envelope(
          429,
          'platform.rate_limited',
          headers: {
            'retry-after': ['30'],
          },
        ),
      ];
      ctl.setNoteDraft('Not');
      final r = await ctl.sendNote();
      expect(r.kind, WriteKind.failed);
      expect(r.error?.retryAfter, const Duration(seconds: 30));
      expect(h.backend.count('POST', path), 1);
      final text = AppLocalizationsTr().writeErrorText(r.error!);
      expect(text, contains('30'));
      expect(
        AppLocalizationsTr().writeErrorText(ApiError('platform.rate_limited')),
        isNot(contains('sn')),
      );
    });

    test(
      'yeni görev: sonuç bilinmiyor → taslak ve anahtar korunur; tekrar aynı '
      'anahtar; oturum nesli değişince taslak sıfırlanır',
      () async {
        final s = _Server();
        final (h, c, _) = await _open(s);
        c.listen(newTaskFormControllerProvider, (_, _) {});
        final form = c.read(newTaskFormControllerProvider.notifier)
          ..prepare(coordinatorship: 'd1')
          ..setTitle('Pano montajı');
        s.queued['POST /v1/work-items'] = [() => timeout(null)];
        expect(await form.submit(), isNull);
        var f = c.read(newTaskFormControllerProvider);
        expect(f.failure?.code, ClientErrorCode.outcomeUnknown);
        expect(f.title, 'Pano montajı');
        final first = key(h, '/v1/work-items');
        expect(await form.submit(), isNotNull);
        expect(key(h, '/v1/work-items'), first);

        form
          ..prepare(coordinatorship: 'd1')
          ..setTitle('Yarım kalan');
        await h.identity.logout();
        f = c.read(newTaskFormControllerProvider);
        expect(f.title, '', reason: 'önceki oturumun taslağı taşınmaz');
      },
    );
  });

  group('sunucu uyum kapısı (CX-P0K-04)', () {
    test('keşif server_version 0.10 → yazma gönderilmez', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.serverVersion = '0.10.0';
      await h.read(serverBindingProvider).verify(testUrl);
      h.backend.requests.clear();
      ctl.setNoteDraft('Not');
      final r = await ctl.sendNote();
      expect(r.kind, WriteKind.failed);
      expect(r.error?.code, ClientErrorCode.serverOutdated);
      expect(
        (await ctl.setPriority(TaskPriority.high)).error?.code,
        ClientErrorCode.serverOutdated,
      );
      expect(h.backend.requests, isEmpty);
      expect(c.read(taskDetailControllerProvider('w1')).noteDraft, 'Not');
    });
  });
}
