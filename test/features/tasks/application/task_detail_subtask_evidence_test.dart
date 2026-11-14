// Alt görev kanıt bayrağı (WORK-K70, iPad 13): oluştururken `evidence_required`, yönetimde
// sürümlü PATCH, bağlı dosyası olmayan bayraklı alt görevin kapatılması yerel ön denetimle
// `work.subtask_attachment_required` (istek yok).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../task_detail_server.dart';

Future<(Harness, TaskDetailController)> _open(TaskDetailServer server) async {
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
  return (h, c.read(taskDetailControllerProvider('w1').notifier));
}

Map<String, Object?> _body(Harness h, String method) =>
    h.backend.requests.firstWhere((r) => r.method == method).body!
        as Map<String, Object?>;

void main() {
  test(
    'oluştur: zorunlu seçilince evidence_required gövdede; opsiyonelde yok',
    () async {
      final (h, ctl) = await _open(TaskDetailServer());
      final r = await ctl.createSubtask('Vana', evidenceRequired: true);
      expect(r.kind, WriteKind.done);
      expect(_body(h, 'POST'), {'title': 'Vana', 'evidence_required': true});

      final (h2, ctl2) = await _open(TaskDetailServer());
      await ctl2.createSubtask('Vana');
      expect(_body(h2, 'POST'), {'title': 'Vana'});
    },
  );

  test('bayrak değişimi sürümlü PATCH; aynı değer istek göndermez', () async {
    final (h, ctl) = await _open(TaskDetailServer());
    expect(
      (await ctl.setSubtaskEvidence('s1', value: false)).kind,
      WriteKind.unchanged,
    );
    expect(h.backend.requests, isEmpty);
    expect(
      (await ctl.setSubtaskEvidence('s1', value: true)).kind,
      WriteKind.done,
    );
    expect(_body(h, 'PATCH'), {
      'evidence_required': true,
      'expected_revision': 1,
    });
  });

  test(
    'bayraklı ve dosyasız alt görev kapatılamaz: kod döner, istek yok',
    () async {
      final s = TaskDetailServer()
        ..subtasks = [
          {...subtaskWire('s1', done: false), 'evidence_required': true},
        ];
      final (h, ctl) = await _open(s);
      final r = await ctl.toggleSubtask('s1');
      expect(r.kind, WriteKind.failed);
      expect(r.error?.code, 'work.subtask_attachment_required');
      expect(h.backend.requests, isEmpty);
    },
  );
}
