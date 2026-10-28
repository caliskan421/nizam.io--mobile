// TaskCatalogController: bileşim kökündeki örnek kaynaktan katalog; arama yardımcıları.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

void main() {
  test('örnek katalog: 76 görev, 11 koordinatörlük, kurmaca kişiler', () async {
    final h = await pilotHarness(PilotBackend());
    h.container.listen(taskCatalogControllerProvider, (_, _) {});
    final c = await h.container.read(taskCatalogControllerProvider.future);
    expect(c.tasks, hasLength(76));
    expect(c.coordinatorships, hasLength(11));
    expect(c.person(c.me)?.name, 'Elif Nur Karaağaçlı');
    expect(c.task('ALT-7')?.coordinatorship, 'ALT');
    expect(c.coordinatorship('ALT')?.leads, ['aa', 'av']);
    expect(c.tasksOf('ALT'), hasLength(13));
    expect(c.tasks.where((t) => t.isOverdue), isNotEmpty);
    expect(c.task('YOK'), isNull);
  });
}
