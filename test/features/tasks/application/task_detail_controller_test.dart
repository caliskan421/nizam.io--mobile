// TaskDetailController — yazma testlerinde (task_detail_writes*_test, task_detail_f60_test)
// kapsanmayan yerel durum geçişleri ve ön denetimler: sekme, tarih talebi formu (+14 gün
// önerisi), formları kapatma, alt görev aç/kapa, alt görev BİTİŞİ ile tarih eşitleme, talepsiz
// görevde talep silme (istek yok). Sunucu: TaskDetailServer (görev `w1`, departman `d1`).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../task_detail_server.dart';

Future<(Harness, ProviderContainer, TaskDetailController)> _open(
  TaskDetailServer server,
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

void main() {
  test('sekme ve alt görev açık/kapalı yerel durumdur (istek yok)', () async {
    final (h, c, ctl) = await _open(TaskDetailServer());
    TaskDetailState st() => c.read(taskDetailControllerProvider('w1'));
    expect(st().tab, TaskDetailTab.summary);
    ctl.selectTab(TaskDetailTab.notes);
    expect(st().tab, TaskDetailTab.notes);
    ctl
      ..toggleSubtaskOpen('s1')
      ..toggleSubtaskOpen('s2');
    expect(st().openSubtasks, {'s1', 's2'});
    ctl.toggleSubtaskOpen('s1');
    expect(st().openSubtasks, {'s2'});
    expect(h.backend.requests, isEmpty);
  });

  test('tarih talebi formu: bitiş +14 gün önerilir; closeForms tüm formları kapatır', () async {
    final (h, c, ctl) = await _open(TaskDetailServer());
    TaskDetailState st() => c.read(taskDetailControllerProvider('w1'));
    expect(ctl.openDateRequest(), isTrue);
    final d = st().dateDraft!;
    expect(d.start, DateTime(2026, 11));
    expect(d.due, DateTime(2026, 11, 24));
    ctl.updateDateDraft(
      DateRequestDraft(start: d.start, due: d.due, reason: 'Malzeme'),
    );
    expect(st().dateDraft!.reason, 'Malzeme');
    expect(ctl.openUpload(), isTrue, reason: 'koordinatör yükleyebilir');
    expect(st().upload, isNotNull);

    ctl.closeForms();
    expect(st().dateDraft, isNull);
    expect(st().upload, isNull);
    expect(st().edit, isNull);
    expect(st().showErrors, isFalse);
    expect(h.backend.requests, isEmpty);
  });

  test('yetkisi olmayan hesapta talep formu açılmaz', () async {
    final (_, c, ctl) = await _open(
      TaskDetailServer()
        ..role = 'uye'
        ..assignees = ['acc-1'],
    );
    expect(ctl.openDateRequest(), isFalse);
    expect(c.read(taskDetailControllerProvider('w1')).dateDraft, isNull);
  });

  test('alt görev bitişi: başlangıç yoksa bitiş gününe eşitlenir; tarihsizde kaldırma '
      'değişiklik değil', () async {
    final (h, _, ctl) = await _open(TaskDetailServer());
    expect(
      (await ctl.setSubtaskEnd('s1', DateTime(2026, 11, 5))).kind,
      WriteKind.done,
    );
    final patch = h.backend.requests.where((r) => r.method == 'PATCH').single;
    expect(patch.path, '/v1/work-items/w1/subtasks/s1');
    expect(patch.body, {
      'start_on': '2026-11-05',
      'end_on': '2026-11-05',
      'expected_revision': 1,
    });
    h.backend.requests.clear();
    expect((await ctl.setSubtaskEnd('s2', null)).kind, WriteKind.unchanged);
    expect(
      (await ctl.setSubtaskEnd('yok', DateTime(2026, 11))).kind,
      WriteKind.invalid,
    );
    expect(h.backend.requests, isEmpty);
  });

  test('talebi olmayan görevde talep silme: istek gönderilmez', () async {
    final (h, _, ctl) = await _open(TaskDetailServer()..admin = true);
    expect((await ctl.deleteDateRequest()).kind, WriteKind.invalid);
    expect(h.backend.requests, isEmpty);
  });
}
