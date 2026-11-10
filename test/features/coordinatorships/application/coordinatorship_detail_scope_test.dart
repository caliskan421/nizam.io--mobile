import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

class _GatedStore extends MemorySecureStore {
  Completer<void>? hold;

  @override
  Future<void> delete(String key) async {
    await hold?.future;
    return super.delete(key);
  }
}

void main() {
  test('başarılı okuma sonrası 403 ve 404 önceki değeri göstermez', () async {
    for (final status in [403, 404]) {
      final backend = CoordBackend();
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      final detail = coordinatorshipDetailProvider(dAlt);
      c.listen(detail, (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await c.read(programDepartmentProvider(dAlt).future);
      expect(
        c.read(detail).value?.department?.description,
        'Su ve yapı işleri',
      );
      final serve = h.backend.handler;
      h.backend.handler = (r) =>
          r.method == 'GET' && r.path == '/v1/program/departments/$dAlt'
          ? errorBody(
              status,
              status == 403
                  ? 'program.not_authorized'
                  : 'program.department_not_found',
            )
          : serve(r);
      c.invalidate(programDepartmentProvider(dAlt));
      await expectLater(
        c.read(programDepartmentProvider(dAlt).future),
        throwsA(anything),
      );
      expect(c.read(detail).hasError, isTrue);
      expect(c.read(detail).value, isNull);
      expect(h.backend.count('GET', '/v1/program/departments/$dAlt'), 2);
    }
  });

  test('aynı departman kimliğiyle program değişiminde bekleyen eski yanıt kullanılmaz', () async {
    final backend = CoordBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await h.read(taskCatalogControllerProvider.future);
    final reached = Completer<void>();
    final gate = Completer<void>();
    final oldResponseDelivered = Completer<void>();
    final serve = h.backend.handler;
    h.backend.handler = (r) async {
      final program = r.header('X-Nizamio-Program');
      if (r.method == 'GET' && r.path == '/v1/program/departments/$dAlt') {
        if (program == coordProgram) {
          reached.complete();
          await gate.future;
          oldResponseDelivered.complete();
          return jsonResponse(200, {
            'department_id': dAlt,
            'display_name': 'Eski',
            'kind': 'koordinatorluk',
            'description': 'Eski kapsam',
          });
        }
        return jsonResponse(200, {
          'department_id': dAlt,
          'display_name': 'Yeni',
          'kind': 'calisma_grubu',
          'description': 'Yeni kapsam',
        });
      }
      if (program == 'prog-2') {
        return serve(
          Seen(
            r.method,
            r.path,
            {
              for (final e in r.headers.entries)
                if (e.key.toLowerCase() != 'x-nizamio-program') e.key: e.value,
              'X-Nizamio-Program': coordProgram,
            },
            r.body,
            query: r.query,
          ),
        );
      }
      return serve(r);
    };
    final c = h.container;
    final detail = coordinatorshipDetailProvider(dAlt);
    c.listen(detail, (_, _) {});
    final oldFuture = c.read(programDepartmentProvider(dAlt).future);
    await reached.future;
    h.read(scopeControllerProvider).selectProgram('prog-2');
    await c.read(taskCatalogControllerProvider.future);
    await c.read(programDepartmentProvider(dAlt).future);
    expect(c.read(detail).value?.department?.description, 'Yeni kapsam');
    gate.complete();
    await oldResponseDelivered.future;
    final result = await oldFuture;
    await Future<void>.delayed(Duration.zero);
    expect(result.program, 'prog-2');
    expect(result.session, h.read(sessionControllerProvider).generation);
    expect(result.department.description, 'Yeni kapsam');
    expect(c.read(programDepartmentProvider(dAlt)).value?.program, 'prog-2');
    expect(
      c.read(programDepartmentProvider(dAlt)).value?.department.description,
      'Yeni kapsam',
    );
    expect(c.read(detail).value?.department?.description, 'Yeni kapsam');
    expect(h.backend.count('GET', '/v1/program/departments/$dAlt'), 2);
  });

  test(
    'aynı departmanda hesap değişince önceki yanıt yeni hesaba taşınmaz',
    () async {
      final backend = CoordBackend();
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      await h.read(taskCatalogControllerProvider.future);
      final reached = Completer<void>();
      final gate = Completer<void>();
      final serve = h.backend.handler;
      var detailCalls = 0;
      h.backend.handler = (r) async {
        if (r.method == 'POST' && r.path == '/v1/auth/login') {
          return jsonResponse(200, loginBody('1')..['account_id'] = 'acc-2');
        }
        if (r.method == 'GET' && r.path == '/v1/program/departments/$dAlt') {
          detailCalls++;
          if (detailCalls == 1) {
            reached.complete();
            await gate.future;
            return jsonResponse(200, {
              'department_id': dAlt,
              'display_name': 'Eski',
              'kind': 'koordinatorluk',
              'description': 'Eski hesap',
            });
          }
          return jsonResponse(200, {
            'department_id': dAlt,
            'display_name': 'Yeni',
            'kind': 'calisma_grubu',
            'description': 'Yeni hesap',
          });
        }
        return serve(r);
      };
      final c = h.container;
      final detail = coordinatorshipDetailProvider(dAlt);
      c.listen(detail, (_, _) {});
      final oldFuture = c.read(programDepartmentProvider(dAlt).future);
      await reached.future;
      await h.identity.logout();
      await h.identity.login(email: 'b@b.test', password: 'p');
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      await c.read(taskCatalogControllerProvider.future);
      await c.read(programDepartmentProvider(dAlt).future);
      expect(c.read(detail).value?.department?.description, 'Yeni hesap');
      gate.complete();
      await expectLater(oldFuture, throwsA(anything));
      expect(c.read(detail).value?.department?.description, 'Yeni hesap');
      expect(detailCalls, 2);
    },
  );

  test(
    'oturum nesli bildirimden önce değişince bekleyen okuma kullanılmaz',
    () async {
      final backend = CoordBackend();
      final store = _GatedStore();
      final h = Harness(handler: backend.handle, store: store);
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      await h.read(taskCatalogControllerProvider.future);
      final reached = Completer<void>();
      final gate = Completer<void>();
      final serve = h.backend.handler;
      h.backend.handler = (r) async {
        if (r.method == 'GET' && r.path == '/v1/program/departments/$dAlt') {
          reached.complete();
          await gate.future;
        }
        return serve(r);
      };
      final c = h.container;
      final detail = coordinatorshipDetailProvider(dAlt);
      c.listen(detail, (_, _) {});
      final future = c.read(programDepartmentProvider(dAlt).future);
      await reached.future;
      final session = h.read(sessionControllerProvider);
      store.hold = Completer<void>();
      final cleared = session.clear();
      gate.complete();
      await expectLater(future, throwsA(anything));
      expect(session.state.value, isA<SessionActive>());
      expect(c.read(detail).value, isNull);
      expect(h.backend.count('GET', '/v1/program/departments/$dAlt'), 1);
      store.hold!.complete();
      await cleared;
    },
  );
}
