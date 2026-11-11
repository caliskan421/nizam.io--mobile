// CoordinatorshipsController: sıralama ölçütü (ad / gecikme / ilerleme) ve sunucu verisinden
// (departmanlar, ekipler, görevler) türetilen liste.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorships_controller.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_overview.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';
import '../coord_backend.dart';

void main() {
  test('görev ve üye sayısı sıralaması yön değiştirebilir', () {
    CoordinatorshipStats item(String name, int tasks, int members) =>
        CoordinatorshipStats(
          code: name,
          name: name,
          done: 0,
          total: tasks,
          late: 0,
          leads: const [],
          members: const [],
          memberCount: members,
        );
    final items = [item('A', 5, 1), item('B', 2, 4), item('C', 3, 2)];
    expect(
      sortCoordinatorships(items, CoordinatorshipSort.tasks).map((c) => c.code),
      ['A', 'C', 'B'],
    );
    expect(
      sortCoordinatorships(
        items,
        CoordinatorshipSort.members,
      ).map((c) => c.code),
      ['B', 'C', 'A'],
    );
    expect(
      sortCoordinatorships(
        items,
        CoordinatorshipSort.members,
        descending: false,
      ).map((c) => c.code),
      ['A', 'C', 'B'],
    );
  });

  test('sunucu departmanları ve görevlerinden liste; ölçüt değişince yeniden sıralanır', () async {
    final backend = CoordBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    final c = h.container;
    c.listen(coordinatorshipListProvider, (_, _) {});
    expect(
      c.read(coordinatorshipsControllerProvider),
      CoordinatorshipSort.tasks,
    );
    await c.read(taskCatalogControllerProvider.future);
    await c.read(serverCoordinatorshipStatsProvider.future);
    // Eşzamanlı türetim: katalog hazırken liste aynı karede dolu.
    var list = c.read(coordinatorshipListProvider).requireValue;
    // Türkçe A→Z (sunucu "Elektrik"i "Eğitim"den önce verir).
    expect(list.map((s) => s.code), [dAlt, dEgi, dEle, dIda]);
    expect(list.map((s) => s.shortCode), ['ALT', 'EGI', 'ELE', null]);

    final alt = list.first;
    expect(alt.name, 'Altyapı ve tesisat');
    expect((alt.done, alt.total, alt.late), (2, 4, 2));
    // Ekip `listMembers`'tan: koordinatör rolü ayrılır, silinmiş üyelik görünmez.
    expect(alt.leads.map((p) => p.name), ['Abdullah Ateş', 'Ali Avcı']);
    expect(alt.members.map((p) => p.name), ['Kadir Özbek']);
    final egi = list[1];
    expect((egi.done, egi.total, egi.late, egi.hasLead), (1, 3, 1, false));
    final ida = list.last;
    expect((ida.total, ida.ratio), (0, 0.0));
    expect([...ida.leads, ...ida.members], isEmpty);

    c
        .read(coordinatorshipsControllerProvider.notifier)
        .sortBy(CoordinatorshipSort.late);
    list = c.read(coordinatorshipListProvider).requireValue;
    // ALT 2, EGI 1; eşitlikte (0) ada göre: Elektrik, İdari.
    expect(list.map((s) => s.code), [dAlt, dEgi, dEle, dIda]);

    c
        .read(coordinatorshipsControllerProvider.notifier)
        .sortBy(CoordinatorshipSort.progress);
    list = c.read(coordinatorshipListProvider).requireValue;
    // ELE 2/2, ALT 2/4, EGI 1/3, İdari görevsiz (0).
    expect(list.map((s) => s.code), [dEle, dAlt, dEgi, dIda]);
    final reports = h.backend.count(
      'GET',
      '/v1/reports/dashboard/coordinatorships',
    );
    final catalogs = h.backend.count('GET', '/v1/program/work-items');
    await c.read(coordinatorshipsControllerProvider.notifier).refresh();
    expect(
      h.backend.count('GET', '/v1/reports/dashboard/coordinatorships'),
      reports + 1,
    );
    expect(h.backend.count('GET', '/v1/program/work-items'), catalogs + 1);
    expect(c.read(serverCoordinatorshipStatsProvider).isLoading, isFalse);
    expect(backend.unhandled, isEmpty);
  });
}
