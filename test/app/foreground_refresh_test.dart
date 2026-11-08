// V10 (F60): uygulama ön plana dönünce okunmuş görev kataloğu bayatsa yeniden okunur; hiç
// okunmamış katalog için okuma başlatılmaz; taze katalog yeniden okunmaz (yoklama yok).
// Kabukta `resumed` geçişi bu işlevi çağırır (widget testi).
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/foreground_refresh.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../features/pilot_support.dart';
import '../support/fake_backend.dart';
import '../support/harness.dart';

const _list = '/v1/program/work-items';

Future<Harness> _signedIn() async {
  final pilot = PilotBackend();
  final h = await pilotHarness(pilot, signedIn: true);
  h.backend.handler = (r) => switch ('${r.method} ${r.path}') {
    'GET /v1/me' => jsonResponse(200, {
      'account_id': 'acc-1',
      'email': 'a@b.test',
      'full_name': 'Ayşe Yılmaz',
      'company_admin': true,
    }),
    'GET /v1/program/departments' ||
    'GET /v1/me/departments' => jsonResponse(200, {'departments': <Object>[]}),
    'GET $_list' => jsonResponse(200, {'items': <Object>[]}),
    _ => pilot.handle(r),
  };
  h.read(scopeControllerProvider).selectProgram('prog-1');
  return h;
}

void main() {
  test('okunmamış katalog: okuma başlatılmaz', () async {
    final h = await _signedIn();
    h.backend.requests.clear();
    await refreshStaleTasks(h.container, maxAge: Duration.zero);
    expect(h.container.exists(taskCatalogControllerProvider), isFalse);
    expect(h.backend.count('GET', _list), 0);
  });

  test('bayat katalog yeniden okunur; taze katalog okunmaz', () async {
    final h = await _signedIn();
    h.container.listen(taskCatalogControllerProvider, (_, _) {});
    await h.container.read(taskCatalogControllerProvider.future);
    h.backend.requests.clear();
    await refreshStaleTasks(h.container);
    expect(h.backend.count('GET', _list), 0, reason: '30 sn içinde taze');
    await refreshStaleTasks(h.container, maxAge: Duration.zero);
    expect(h.backend.count('GET', _list), 1);
  });

  testWidgets('kabuk: resumed geçişi dinlenir; katalog okunmamışken okuma '
      'başlatmaz', (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const ForegroundRefresh(child: SizedBox()),
      ),
    );
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(c.exists(taskCatalogControllerProvider), isFalse);
  });
}
