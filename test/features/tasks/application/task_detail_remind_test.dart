// "Şimdi hatırlat" (WORK-K90, iPad 8): koordinatör/yönetici → POST …/remind (görevin
// departman başlığıyla), alıcı sayısı döner; üye ve atanansız görevde istek yok.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
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

void main() {
  test(
    'koordinatör: POST remind görevin departmanıyla; 202 alıcı sayısı',
    () async {
      final s = TaskDetailServer()
        ..writes['POST /v1/work-items/w1/remind'] = () =>
            jsonResponse(202, {'recipient_count': 2});
      final (h, ctl) = await _open(s);
      final (r, n) = await ctl.remind();
      expect(r.kind, WriteKind.done);
      expect(n, 2);
      final post = h.backend.requests.firstWhere((x) => x.method == 'POST');
      expect(post.path, '/v1/work-items/w1/remind');
      expect(post.header('X-Nizamio-Department'), 'd1');
    },
  );

  test('yönetici ekip satırı olmadan hatırlatır', () async {
    final s = TaskDetailServer()
      ..admin = true
      ..role = 'yok'
      ..writes['POST /v1/work-items/w1/remind'] = () =>
          jsonResponse(202, {'recipient_count': 1});
    final (_, ctl) = await _open(s);
    expect((await ctl.remind()).$1.kind, WriteKind.done);
  });

  test('üye ya da atanansız görev: istek yok', () async {
    final (h, ctl) = await _open(TaskDetailServer()..role = 'uye');
    expect((await ctl.remind()).$1.kind, WriteKind.invalid);
    final (h2, ctl2) = await _open(TaskDetailServer()..assignees = []);
    expect((await ctl2.remind()).$1.kind, WriteKind.invalid);
    expect([...h.backend.requests, ...h2.backend.requests], isEmpty);
  });
}
