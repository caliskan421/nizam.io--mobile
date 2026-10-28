// CoordinatorshipsController: sıralama ölçütü (ad / gecikme / ilerleme) ve katalogdan türetilen
// liste; alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorships_controller.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_overview.dart';

import '../../pilot_support.dart';

void main() {
  test(
    'varsayılan ada göre; ölçüt değişince liste yeniden sıralanır',
    () async {
      final h = await pilotHarness(PilotBackend());
      final c = h.container;
      c.listen(coordinatorshipListProvider, (_, _) {});
      expect(
        c.read(coordinatorshipsControllerProvider),
        CoordinatorshipSort.name,
      );
      var list = await c.read(coordinatorshipListProvider.future);
      expect(list, hasLength(11));
      // Türkçe A→Z: Altyapı, Eğitim, Elektrik, Fuar, İdari…
      expect(list.take(5).map((s) => s.code), [
        'ALT',
        'EĞİ',
        'ELE',
        'FUA',
        'İDA',
      ]);
      final alt = list.first;
      expect((alt.done, alt.total, alt.late), (9, 13, 3));
      expect(alt.leads.map((p) => p.name), ['Deniz Aydemir', 'Kaan Erol']);
      expect(alt.members.map((p) => p.name), ['Kerem Özdal']);

      c
          .read(coordinatorshipsControllerProvider.notifier)
          .sortBy(CoordinatorshipSort.late);
      list = await c.read(coordinatorshipListProvider.future);
      // İdari 4; Altyapı ve Ulaşım 3 (eşitlikte ad).
      expect(list.take(3).map((s) => s.code), ['İDA', 'ALT', 'ULA']);

      c
          .read(coordinatorshipsControllerProvider.notifier)
          .sortBy(CoordinatorshipSort.progress);
      list = await c.read(coordinatorshipListProvider.future);
      expect(list.first.code, 'MEK'); // 7/8
      expect(list.last.code, 'İDA'); // 1/11
    },
  );

  test('alt menü alt yazısı katalog yüklenince "11 koordinatörlük"', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(coordinatorshipsNavCaptionProvider, (_, _) {});
    expect(c.read(coordinatorshipsNavCaptionProvider), isNull);
    await c.read(coordinatorshipListProvider.future);
    expect(c.read(coordinatorshipsNavCaptionProvider), '11 koordinatörlük');
  });
}
