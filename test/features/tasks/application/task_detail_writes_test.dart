// TaskDetailController sunucu yazmaları (F57 P2) — gerçek bileşim kökü ve HTTP yığını, sahte
// bağdaştırıcı: aktör → uç seçimi (transitions / own-status), görevin KENDİ departman başlığı,
// gövde (reason, close_subtasks), 409 subtasks_open → kullanıcı kararıyla close_subtasks,
// uçuştaki istek kilidi (çift dokunma = tek istek), yazma sonrası yeniden okuma ve sırası
// (liste etkilenince katalog + ayrıntı, yalnız not ise ayrıntı), 409'da yeniden okuma ve
// otomatik tekrar yok, yetkisiz eylemde istek yok, hata kodu → ileti.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

/// Ayarlanabilir sahte sunucu (görev `w1`, departman `d1`, oturum hesabı `acc-1`).
class _Server {
  bool admin = false;
  String role = 'koordinator';
  List<String> assignees = ['u2'];
  String status = 'devam_ediyor';
  List<Map<String, Object?>> subtasks = [
    _sub('s1', done: false),
    _sub('s2', done: false, assignee: 'u2'),
  ];
  List<Map<String, Object?>> notes = [
    _note('n1', 'acc-1', 'Benim notum'),
    _note('n2', 'u2', 'Başkasının notu'),
  ];

  /// 'METOT yol' → yanıt; verilmeyen yazma için geçerli varsayılan gövde.
  final Map<String, ResponseBody Function()> writes = {};

  /// Doluysa yazma yanıtı bu tamamlanana dek bekler (uçuştaki istek).
  Completer<void>? hold;

  final _pilot = PilotBackend();

  FutureOr<ResponseBody> handle(Seen r) async {
    final key = '${r.method} ${r.path}';
    if (r.method != 'GET' && r.path.startsWith('/v1/work-items/')) {
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
      case 'GET /v1/me/departments':
        return jsonResponse(200, {
          'departments': [
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
            {
              'work_item_id': 'w1',
              'title': 'Hidrofor kurulumu',
              'program_id': 'prog-1',
              'department_id': 'd1',
              'priority': 'orta',
              'status': status,
              'assignee_account_ids': assignees,
              'is_overdue': false,
              'days_overdue': 0,
              'is_completed_late': false,
              'days_late': 0,
              'is_completed_early': false,
              'days_early': 0,
              'completion_evidence_required': false,
              'subtask_counts': {'total': subtasks.length, 'done': 0},
            },
          ],
        });
      case 'GET /v1/work-items/w1/subtasks':
        return jsonResponse(200, {
          'subtasks': subtasks,
          'total': subtasks.length,
        });
      case 'GET /v1/work-items/w1/notes':
        return jsonResponse(200, {'notes': notes, 'total': notes.length});
      case 'GET /v1/work-items/w1/files':
        return jsonResponse(200, {'files': <Object>[]});
      case 'GET /v1/date-change-requests' ||
          'GET /v1/date-change-requests/mine':
        return jsonResponse(200, {'requests': <Object>[], 'total': 0});
    }
    return _pilot.handle(r);
  }

  Object _writeBody(Seen r) {
    if (r.path.endsWith('/transitions') || r.path.endsWith('/own-status')) {
      final to = (r.body! as Map)['to'];
      return {
        'work_item_id': 'w1',
        'from': status,
        'to': to,
        'actor': 'koordinator',
      };
    }
    if (r.path.endsWith('/notes') && r.method == 'POST') {
      return _note('n9', 'acc-1', 'yeni');
    }
    if (r.path.endsWith('/subtasks') && r.method == 'POST') {
      return _sub('s9', done: false);
    }
    if (r.path.contains('/subtasks/') && r.method == 'PATCH') {
      return _sub('s1', done: true);
    }
    return {'status': 'ok'};
  }
}

Map<String, Object?> _sub(String id, {required bool done, String? assignee}) =>
    {
      'subtask_id': id,
      'work_item_id': 'w1',
      'title': 'Alt $id',
      'done': done,
      'created_by_account_id': 'acc-1',
      'created_at': '2026-10-02T08:00:00Z',
      'updated_at': '2026-10-02T08:00:00Z',
      'assignee_account_id': ?assignee,
    };

Map<String, Object?> _note(String id, String by, String text) => {
  'note_id': id,
  'work_item_id': 'w1',
  'author_account_id': by,
  'content': text,
  'created_at': '2026-10-03T09:00:00Z',
  'updated_at': '2026-10-03T09:00:00Z',
};

/// Oturum açık, sunucu programı seçili; katalog ve ayrıntı okunmuş.
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

List<String> _log(Harness h) => [
  for (final r in h.backend.requests) '${r.method} ${r.path}',
];

Seen _only(Harness h, String method, String path) => h.backend.requests
    .where((r) => r.method == method && r.path == path)
    .single;

const _detailReads = [
  'GET /v1/work-items/w1/subtasks',
  'GET /v1/work-items/w1/notes',
  'GET /v1/work-items/w1/files',
];

void main() {
  group('durum geçişi', () {
    test('koordinatör → POST transitions (görevin departmanı); sonra katalog + ayrıntı yeniden okunur', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.status = 'tamamlandi';
      final r = await ctl.setStatus(TaskStatus.done);
      expect(r.kind, WriteKind.done);
      final log = _log(h);
      expect(log.first, 'POST /v1/work-items/w1/transitions');
      final post = _only(h, 'POST', '/v1/work-items/w1/transitions');
      expect(post.header('X-Nizamio-Department'), 'd1');
      expect(post.header('X-Nizamio-Program'), 'prog-1');
      expect(post.body, {'to': 'tamamlandi'});
      // Yeniden okuma yazmadan SONRA: liste, ardından ayrıntı.
      final list = log.indexOf('GET /v1/work-items');
      expect(list, greaterThan(0));
      for (final d in _detailReads) {
        expect(log.indexOf(d), greaterThan(list), reason: d);
      }
      expect(
        c.read(taskCatalogControllerProvider).value!.task('w1')!.status,
        TaskStatus.done,
        reason: 'durum sunucudan okundu (iyimser güncelleme yok)',
      );
      expect(c.read(taskDetailControllerProvider('w1')).busy, isFalse);
    });

    test('yalnız atanmış üye → PATCH own-status', () async {
      final s = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (h, _, ctl) = await _open(s);
      expect((await ctl.setStatus(TaskStatus.review)).kind, WriteKind.done);
      final patch = _only(h, 'PATCH', '/v1/work-items/w1/own-status');
      expect(patch.body, {'to': 'onaya_sunuldu'});
      expect(h.backend.count('POST', '/v1/work-items/w1/transitions'), 0);
    });

    test('matris dışı hedef ve aktörsüz yönetici: istek yok', () async {
      final s = _Server()
        ..role = 'uye'
        ..assignees = ['acc-1'];
      final (h, _, ctl) = await _open(s);
      expect((await ctl.setStatus(TaskStatus.done)).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);

      final a = _Server()..admin = true;
      final (h2, _, ctl2) = await _open(a..role = 'yok');
      expect(ctl2.permissions.statusTargets(TaskStatus.inProgress), isEmpty);
      expect((await ctl2.setStatus(TaskStatus.done)).kind, WriteKind.invalid);
      expect(h2.backend.requests, isEmpty);
    });

    test(
      'tamamlandı çıkışı ≥3 karakter gerekçe ister; gerekçe gövdede',
      () async {
        final s = _Server()..status = 'tamamlandi';
        final (h, _, ctl) = await _open(s);
        expect(
          (await ctl.setStatus(TaskStatus.inProgress)).kind,
          WriteKind.reasonRequired,
        );
        expect(
          (await ctl.setStatus(TaskStatus.inProgress, reason: ' ab ')).kind,
          WriteKind.reasonRequired,
        );
        expect(h.backend.requests, isEmpty);
        expect(
          (await ctl.setStatus(
            TaskStatus.inProgress,
            reason: ' Eksik iş ',
          )).kind,
          WriteKind.done,
        );
        expect(_only(h, 'POST', '/v1/work-items/w1/transitions').body, {
          'to': 'devam_ediyor',
          'reason': 'Eksik iş',
        });
      },
    );

    test('409 subtasks_open → yeniden oku + soru; kullanıcı onaylarsa close_subtasks ile tek yeni istek', () async {
      final s = _Server();
      final (h, _, ctl) = await _open(s);
      s.writes['POST /v1/work-items/w1/transitions'] = () =>
          envelope(409, 'work.subtasks_open');
      final r = await ctl.setStatus(TaskStatus.done);
      expect(r.kind, WriteKind.subtasksOpen);
      expect(r.error!.code, 'work.subtasks_open');
      expect(
        h.backend.count('POST', '/v1/work-items/w1/transitions'),
        1,
        reason: 'otomatik tekrar yok',
      );
      expect(
        _log(h),
        contains('GET /v1/work-items'),
        reason: '409 → yeniden okuma',
      );

      s.writes.clear();
      h.backend.requests.clear();
      expect(
        (await ctl.setStatus(TaskStatus.done, closeSubtasks: true)).kind,
        WriteKind.done,
      );
      expect(_only(h, 'POST', '/v1/work-items/w1/transitions').body, {
        'to': 'tamamlandi',
        'close_subtasks': true,
      });
    });

    test(
      '409 stale_transition → yeniden oku, hata döner, otomatik tekrar yok',
      () async {
        final s = _Server();
        final (h, _, ctl) = await _open(s);
        s.writes['POST /v1/work-items/w1/transitions'] = () =>
            envelope(409, 'work.stale_transition');
        final r = await ctl.setStatus(TaskStatus.todo);
        expect(r.kind, WriteKind.failed);
        expect(r.error!.code, 'work.stale_transition');
        expect(h.backend.count('POST', '/v1/work-items/w1/transitions'), 1);
        expect(_log(h), containsAll(['GET /v1/work-items', ..._detailReads]));
      },
    );

    test(
      '422 attachment_required → hata; 409 olmadığından yeniden okuma yok',
      () async {
        final s = _Server();
        final (h, _, ctl) = await _open(s);
        s.writes['POST /v1/work-items/w1/transitions'] = () =>
            envelope(422, 'work.attachment_required');
        final r = await ctl.setStatus(TaskStatus.done);
        expect(r.error!.code, 'work.attachment_required');
        expect(_log(h), ['POST /v1/work-items/w1/transitions']);
      },
    );

    test('uçuştaki istek kilidi: çift dokunma tek istek', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      s.hold = Completer<void>();
      final first = ctl.setStatus(TaskStatus.done);
      await pumpEventQueue();
      expect(c.read(taskDetailControllerProvider('w1')).busy, isTrue);
      expect((await ctl.setStatus(TaskStatus.done)).kind, WriteKind.busy);
      expect((await ctl.toggleSubtask('s1')).kind, WriteKind.busy);
      s.hold!.complete();
      expect((await first).kind, WriteKind.done);
      expect(h.backend.count('POST', '/v1/work-items/w1/transitions'), 1);
      expect(h.backend.count('PATCH', '/v1/work-items/w1/subtasks/s1'), 0);
      expect(c.read(taskDetailControllerProvider('w1')).busy, isFalse);
    });
  });

  group('notlar', () {
    test('ekle → POST (departman başlığı); yalnız ayrıntı yeniden okunur; taslak temizlenir', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      ctl.setNoteDraft('  Saha kontrol edildi ');
      expect((await ctl.sendNote()).kind, WriteKind.done);
      final post = _only(h, 'POST', '/v1/work-items/w1/notes');
      expect(post.body, {'content': 'Saha kontrol edildi'});
      expect(post.header('X-Nizamio-Department'), 'd1');
      expect(_log(h), contains('GET /v1/work-items/w1/notes'));
      expect(
        _log(h),
        isNot(contains('GET /v1/work-items')),
        reason: 'liste etkilenmez',
      );
      expect(c.read(taskDetailControllerProvider('w1')).noteDraft, '');
    });

    test('yönetici (koordinatör de olsa) not yazamaz: istek yok', () async {
      final s = _Server()..admin = true;
      final (h, _, ctl) = await _open(s);
      ctl.setNoteDraft('Yönetici notu');
      expect((await ctl.sendNote()).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);
    });

    test('düzenle/sil yalnız yazar', () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      final notes = c
          .read(taskCatalogControllerProvider)
          .value!
          .task('w1')!
          .noteEntries;
      final mine = notes.firstWhere((n) => n.id == 'n1');
      final other = notes.firstWhere((n) => n.id == 'n2');
      expect((await ctl.editNote(other, 'x')).kind, WriteKind.invalid);
      expect((await ctl.deleteNote(other)).kind, WriteKind.invalid);
      expect(h.backend.requests, isEmpty);

      expect((await ctl.editNote(mine, 'Düzeltildi')).kind, WriteKind.done);
      expect(_only(h, 'PATCH', '/v1/work-items/w1/notes/n1').body, {
        'content': 'Düzeltildi',
      });
      expect((await ctl.deleteNote(mine)).kind, WriteKind.done);
      expect(h.backend.count('DELETE', '/v1/work-items/w1/notes/n1'), 1);
    });
  });

  group('alt görevler', () {
    test('oluştur/işaretle/sil → istek + katalog yeniden okuma', () async {
      final s = _Server();
      final (h, _, ctl) = await _open(s);
      expect((await ctl.createSubtask('  Vana ')).kind, WriteKind.done);
      expect(_only(h, 'POST', '/v1/work-items/w1/subtasks').body, {
        'title': 'Vana',
      });
      expect(_log(h), contains('GET /v1/work-items'));

      h.backend.requests.clear();
      expect((await ctl.toggleSubtask('s1')).kind, WriteKind.done);
      final patch = _only(h, 'PATCH', '/v1/work-items/w1/subtasks/s1');
      expect(patch.body, {'done': true});
      expect(patch.header('X-Nizamio-Department'), 'd1');
      expect(_log(h).indexOf('GET /v1/work-items'), greaterThan(0));

      h.backend.requests.clear();
      expect((await ctl.removeSubtask('s2')).$1.kind, WriteKind.done);
      expect(h.backend.count('DELETE', '/v1/work-items/w1/subtasks/s2'), 1);
    });

    test('kişi ve tarih: atama kaldırma boş dize; tarihler birlikte gider', () async {
      final s = _Server()..assignees = ['u2', 'acc-1'];
      final (h, _, ctl) = await _open(s);
      await ctl.setSubtaskAssignee('s1', 'u2');
      await ctl.setSubtaskAssignee('s2', null);
      await ctl.setSubtaskStart('s1', DateTime(2026, 10, 25));
      await ctl.clearSubtaskDates('s2');
      final bodies = [
        for (final r in h.backend.requests)
          if (r.method == 'PATCH') r.body,
      ];
      expect(
        bodies,
        [
          {'assignee_account_id': 'u2'},
          {'assignee_account_id': ''},
          {'start_on': '2026-10-25', 'end_on': '2026-10-25'},
        ],
        reason:
            'tarihsiz alt görevde tarih kaldırma değişiklik değil (istek yok)',
      );
    });

    test(
      'atanmış üye: yönetemez; başkasına atanmış alt görevi işaretleyemez',
      () async {
        final s = _Server()
          ..role = 'uye'
          ..assignees = ['acc-1'];
        final (h, _, ctl) = await _open(s);
        expect((await ctl.createSubtask('Yeni')).kind, WriteKind.invalid);
        expect((await ctl.toggleSubtask('s2')).kind, WriteKind.invalid);
        expect((await ctl.removeSubtask('s1')).$1.kind, WriteKind.invalid);
        expect(h.backend.requests, isEmpty);
        expect((await ctl.toggleSubtask('s1')).kind, WriteKind.done);
      },
    );

    test(
      'tamamlanmış görevde 409 item_completed → yeniden oku + hata',
      () async {
        final s = _Server();
        final (h, _, ctl) = await _open(s);
        s.writes['POST /v1/work-items/w1/subtasks'] = () =>
            envelope(409, 'work.item_completed');
        final r = await ctl.createSubtask('Yeni');
        expect(r.error!.code, 'work.item_completed');
        expect(_log(h), contains('GET /v1/work-items'));
      },
    );
  });

  test('hata kodu → ileti (genel metne düşmez)', () {
    final l = AppLocalizationsTr();
    final generic = errorText(l, ApiError('platform.internal'));
    for (final code in [
      'work.subtasks_open',
      'work.attachment_required',
      'work.stale_transition',
      'work.stale_completion',
      'platform.conflict_retry',
      'work.dependency_not_completed',
      'work.item_completed',
      'work.not_authorized',
      'work.note_not_yours',
      'work.subtask_assignee_not_assigned',
    ]) {
      expect(errorText(l, ApiError(code)), isNot(generic), reason: code);
    }
  });
}
