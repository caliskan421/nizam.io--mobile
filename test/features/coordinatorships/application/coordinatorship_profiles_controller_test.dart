// CoordinatorshipProfilesController: departman kayıtları sunucudan (`GET /v1/departments`,
// S1 — kapsam başlığı yok), tek istek; keepAlive.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_profiles_controller.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart'
    show DepartmentKind;

import '../../pilot_support.dart';
import '../coord_backend.dart';

void main() {
  test('departman kayıtları tek istekle yüklenir', () async {
    final h = await pilotHarness(CoordBackend(), signedIn: true);
    h.container.listen(coordinatorshipProfilesControllerProvider, (_, _) {});
    final list = await h.container.read(
      coordinatorshipProfilesControllerProvider.future,
    );
    expect(list.map((d) => (d.id, d.kind)), [
      (dAlt, DepartmentKind.coordinatorship),
      (dEle, DepartmentKind.workingGroup),
      (dEgi, DepartmentKind.unknown),
    ]);
    await h.container.read(coordinatorshipProfilesControllerProvider.future);
    expect(h.backend.count('GET', '/v1/departments'), 1);
    final req = h.backend.requests.lastWhere(
      (r) => r.path == '/v1/departments',
    );
    expect(req.header('X-Nizamio-Program'), isNull);
  });
}
