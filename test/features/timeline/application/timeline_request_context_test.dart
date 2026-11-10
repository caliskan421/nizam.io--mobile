import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/application/timeline_controller.dart';

import '../../../support/harness.dart';
import '../../coordinatorships/coord_backend.dart';

class _DelayedDelete extends MemorySecureStore {
  final started = Completer<void>();
  final release = Completer<void>();
  bool hold = false;

  @override
  Future<void> delete(String key) async {
    if (hold && !started.isCompleted) {
      started.complete();
      await release.future;
    }
    await super.delete(key);
  }
}

void main() {
  for (final change in ['program', 'department']) {
    test('$change değişiminden sonra eski POST yenileme başlatmaz', () async {
      final backend = CoordBackend()..admin = false;
      final h = Harness(handler: backend.handle);
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(timelineControllerProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await c.read(ganttScheduleProvider.future);
      final ctrl = c.read(timelineControllerProvider(dAlt).notifier);
      ctrl.select('wi-alt-1');
      ctrl.nudgeEnd(5);
      h.backend.requests.clear();
      final arrived = Completer<void>();
      final release = Completer<void>();
      h.backend.handler = (r) async {
        if (r.method == 'POST' && r.path == '/v1/date-change-requests') {
          final response = backend.handle(r);
          arrived.complete();
          await release.future;
          return response;
        }
        return backend.handle(r);
      };
      final request = ctrl.requestDates();
      await arrived.future;
      final scope = h.read(scopeControllerProvider);
      if (change == 'program') {
        scope.selectProgram('prog-2');
      } else {
        scope.selectDepartment(dEle);
      }
      final readsBefore = h.backend.count('GET', '/v1/program/work-items');
      release.complete();
      await request;
      expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
      expect(h.backend.count('GET', '/v1/program/work-items'), readsBefore);
    });
  }
  test(
    'oturum nesli bildirimden önce değişirse eski POST sonrası okuma yapılmaz',
    () async {
      final store = _DelayedDelete();
      final backend = CoordBackend()..admin = false;
      final h = Harness(handler: backend.handle, store: store);
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(timelineControllerProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await c.read(ganttScheduleProvider.future);
      final ctrl = c.read(timelineControllerProvider(dAlt).notifier);
      ctrl.select('wi-alt-1');
      ctrl.nudgeEnd(5);
      h.backend.requests.clear();
      final arrived = Completer<void>();
      final release = Completer<void>();
      h.backend.handler = (r) async {
        if (r.method == 'POST' && r.path == '/v1/date-change-requests') {
          final response = backend.handle(r);
          arrived.complete();
          await release.future;
          return response;
        }
        return backend.handle(r);
      };
      final request = ctrl.requestDates();
      await arrived.future;
      store.hold = true;
      final clearing = h.read(sessionControllerProvider).clear();
      await store.started.future;
      release.complete();
      expect(await request, isA<TimelineRequestSent>());
      expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
      expect(h.backend.count('GET', '/v1/program/work-items'), 0);
      expect(h.backend.count('GET', '/v1/work-items/gantt'), 0);
      store.release.complete();
      await clearing;
    },
  );
}
