import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_form_controller.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorships_controller.dart';
import 'package:nizamio/features/coordinatorships/domain/department.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

Future<Harness> _harness(CoordBackend backend) async {
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  h.container.listen(coordinatorshipListProvider, (_, _) {});
  await h.read(taskCatalogControllerProvider.future);
  return h;
}

void main() {
  test(
    'restore yanıtı kaybolursa not_deleted ile yalnız bağlamaya ilerler',
    () async {
      final backend = CoordBackend();
      final h = await _harness(backend);
      final serve = h.backend.handler;
      var restoreCount = 0;
      h.backend.handler = (r) {
        if (r.method == 'POST' && r.path == '/v1/departments') {
          return jsonResponse(409, {
            'code': 'organization.department_exists',
            'message': '',
            'request_id': 'r',
            'fields': [
              {
                'field': 'department_id',
                'code': 'organization.existing_department',
                'message': dAlt,
              },
              {
                'field': 'deleted',
                'code': 'organization.existing_department',
                'message': 'true',
              },
            ],
          });
        }
        if (r.method == 'PATCH' &&
            r.path == '/v1/admin/restore/departments/$dAlt') {
          restoreCount++;
          return restoreCount == 1
              ? errorBody(503, 'platform.internal')
              : errorBody(409, 'organization.not_deleted');
        }
        return serve(r);
      };
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      expect(
        await ctl.create(
          const CoordinatorshipDraft(
            name: 'Altyapı',
            kind: DepartmentKind.coordinatorship,
          ),
        ),
        isFalse,
      );
      expect(await ctl.confirmExisting(), isFalse);
      expect(h.backend.count('POST', '/v1/program/departments'), 0);
      expect(await ctl.confirmExisting(), isTrue);
      expect(restoreCount, 2);
      expect(h.backend.count('POST', '/v1/departments'), 1);
      expect(h.backend.count('POST', '/v1/program/departments'), 1);
    },
  );

  test(
    'yazma başarılı ama sonraki okuma hatalıysa yazma başarılı kalır',
    () async {
      final backend = CoordBackend();
      final h = await _harness(backend);
      final serve = h.backend.handler;
      var linked = false;
      h.backend.handler = (r) {
        if (r.method == 'POST' && r.path == '/v1/program/departments') {
          linked = true;
        }
        if (linked && r.method == 'GET' && r.path == '/v1/program/work-items') {
          return errorBody(503, 'platform.internal');
        }
        return serve(r);
      };
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      expect(
        await ctl.create(
          const CoordinatorshipDraft(
            name: 'Saha',
            kind: DepartmentKind.coordinatorship,
          ),
        ),
        isTrue,
      );
      expect(h.backend.count('POST', '/v1/departments'), 1);
      expect(h.backend.count('POST', '/v1/program/departments'), 1);
      expect(h.read(coordinatorshipFormControllerProvider).error, isNull);
      expect(h.read(taskCatalogControllerProvider).hasError, isTrue);
    },
  );

  test(
    'departman kapsamı uçuşta değişirse ikinci istek gitmez ve form sıfırlanır',
    () async {
      final backend = CoordBackend();
      final h = await _harness(backend);
      final reached = Completer<void>();
      final gate = Completer<void>();
      final serve = h.backend.handler;
      h.backend.handler = (r) async {
        if (r.method == 'POST' && r.path == '/v1/departments') {
          reached.complete();
          await gate.future;
        }
        return serve(r);
      };
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      final flight = ctl.create(
        const CoordinatorshipDraft(
          name: 'Saha',
          kind: DepartmentKind.coordinatorship,
        ),
      );
      await reached.future;
      h.read(scopeControllerProvider).selectDepartment(dAlt);
      gate.complete();
      expect(await flight, isFalse);
      expect(h.backend.count('POST', '/v1/departments'), 1);
      expect(h.backend.count('POST', '/v1/program/departments'), 0);
      expect(h.read(coordinatorshipFormControllerProvider).saving, isFalse);
      expect(h.read(coordinatorshipFormControllerProvider).pending, isNull);
    },
  );
}
