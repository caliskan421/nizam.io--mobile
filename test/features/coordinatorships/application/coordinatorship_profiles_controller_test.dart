// CoordinatorshipProfilesController: bileşim kökündeki örnek kaynaktan ek bilgiler.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_profiles_controller.dart';

import '../../pilot_support.dart';

void main() {
  test('her koordinatörlük için ek bilgi yüklenir', () async {
    final h = await pilotHarness(PilotBackend());
    h.container.listen(coordinatorshipProfilesControllerProvider, (_, _) {});
    final p = await h.container.read(
      coordinatorshipProfilesControllerProvider.future,
    );
    expect(p.map((e) => e.code).toSet(), hasLength(11));
    expect(p.firstWhere((e) => e.code == 'ALT').units, hasLength(3));
  });
}
