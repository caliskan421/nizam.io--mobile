// CoordinatorshipDetailController: sekme ve üye listesi durumu (kod başına); ayrıntı türetimi
// (katalog + ek bilgiler), bilinmeyen kod null.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_detail_controller.dart';

import '../../pilot_support.dart';

void main() {
  test('sekme ve üye listesi kod başına; varsayılan Genel, kapalı', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    final alt = coordinatorshipDetailControllerProvider('ALT');
    c.listen(alt, (_, _) {});
    expect(c.read(alt).tab, CoordinatorshipTab.general);
    c.read(alt.notifier)
      ..selectTab(CoordinatorshipTab.team)
      ..toggleMembers();
    expect(c.read(alt).tab, CoordinatorshipTab.team);
    expect(c.read(alt).membersOpen, isTrue);
    c.read(alt.notifier).selectTab(CoordinatorshipTab.about);
    expect(c.read(alt).membersOpen, isTrue, reason: 'sekme değişimi korur');
    expect(
      c.read(coordinatorshipDetailControllerProvider('MEK')).tab,
      CoordinatorshipTab.general,
    );
  });

  test('ayrıntı: özet, dikkat gerektirenler, ekip, etkinlik', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(coordinatorshipDetailProvider('ALT'), (_, _) {});
    final d = (await c.read(coordinatorshipDetailProvider('ALT').future))!;
    expect((d.stats.open, d.stats.late), (4, 3));
    expect(d.attention.map((a) => (a.code, a.overdueDays)), [
      ('ALT-5', 98),
      ('ALT-7', 41),
      ('ALT-10', 21),
    ]);
    expect(d.attention.first.assignee, 'Kerem Özdal');
    expect(d.leads.map((m) => (m.name, m.unit)), [
      ('Deniz Aydemir', 'Arıtma tesisi'),
      ('Kaan Erol', 'Su ve atıksu hatları'),
    ]);
    // Katalog üyesi + 6 örnek üye.
    expect(d.members, hasLength(7));
    expect(d.members.first.name, 'Kerem Özdal');
    expect(d.members.first.unit, 'Depolama ve hidrofor');
    expect(d.people, 9);
    expect(d.feed.first.who, 'Kerem Özdal');
    expect(d.others, hasLength(11));
    expect(d.profile.chatId, 'hid');

    c.listen(coordinatorshipDetailProvider('YOK'), (_, _) {});
    expect(await c.read(coordinatorshipDetailProvider('YOK').future), isNull);
  });

  test('koordinatörsüz: lider yok, üye katalogdan', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(coordinatorshipDetailProvider('İDA'), (_, _) {});
    final d = (await c.read(coordinatorshipDetailProvider('İDA').future))!;
    expect(d.leads, isEmpty);
    expect(d.members.map((m) => m.name), ['Bengü Kılınç']);
    expect(d.people, 1);
  });
}
