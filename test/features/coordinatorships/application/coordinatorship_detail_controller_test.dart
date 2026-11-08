// CoordinatorshipDetailController: bölüm ve görev süzgeci durumu (kod başına); ayrıntı türetimi
// (sunucu kataloğu + ek bilgiler), bilinmeyen kimlik null.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_detail_controller.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_profiles_controller.dart';
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_board.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';
import '../coord_backend.dart';

/// Kaynaklar (katalog + ek bilgiler) yüklenince ayrıntı eşzamanlı okunur.
Future<void> _ready(ProviderContainer c) async {
  await c.read(taskCatalogControllerProvider.future);
  await c.read(coordinatorshipProfilesControllerProvider.future);
}

void main() {
  test(
    'bölüm ve görev süzgeci kod başına; kişi süzgeci Görevler bölümünü açar',
    () async {
      final h = await pilotHarness(PilotBackend());
      final c = h.container;
      final alt = coordinatorshipDetailControllerProvider('ALT');
      c.listen(alt, (_, _) {});
      expect(c.read(alt).tab, CoordinatorshipTab.general);
      expect(c.read(alt).filtered, isFalse);
      c.read(alt.notifier).showTasks(CoordTaskFilter.late, person: 'ko');
      expect(c.read(alt).tab, CoordinatorshipTab.tasks);
      expect(
        (c.read(alt).filter, c.read(alt).person),
        (CoordTaskFilter.late, 'ko'),
      );
      c.read(alt.notifier).selectTab(CoordinatorshipTab.members);
      expect(
        c.read(alt).filter,
        CoordTaskFilter.late,
        reason: 'bölüm değişimi korur',
      );
      c.read(alt.notifier).clearFilter();
      expect(c.read(alt).filtered, isFalse);
      expect(
        c.read(coordinatorshipDetailControllerProvider('MEK')).tab,
        CoordinatorshipTab.general,
      );
    },
  );

  test('ayrıntı sunucu verisinden: özet, dikkat gerektirenler, ekip; bilinmeyen kimlik null', () async {
    final backend = CoordBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    final c = h.container;
    c.listen(coordinatorshipDetailProvider(dAlt), (_, _) {});
    expect(c.read(coordinatorshipDetailProvider(dAlt)).isLoading, isTrue);
    await _ready(c);
    final d = c.read(coordinatorshipDetailProvider(dAlt)).requireValue!;
    expect(d.stats.shortCode, 'ALT');
    expect((d.stats.open, d.stats.late, d.stats.total), (2, 2, 4));
    // Sunucu kaydının ek bilgisi yok (rapor yok): sezon oranı program görevlerinden, 5/9.
    expect(d.profile.reported, isNull);
    expect(d.seasonRatio, 5 / 9);
    // Geciken görevler sunucunun `days_overdue` değeriyle, en çok gecikenden; ekranda
    // kimlik değil departman kodu.
    expect(d.attention.map((a) => (a.code, a.label, a.overdueDays)), [
      (tAltLate30, 'ALT', 30),
      (tAltLate12, 'ALT', 12),
    ]);
    expect(d.attention.map((a) => a.assignee), ['Kadir Özbek', 'Ali Avcı']);
    expect(d.leads.map((m) => (m.name, m.lead)), [
      ('Abdullah Ateş', true),
      ('Ali Avcı', true),
    ]);
    // Silinmiş üyelik ekipte yok.
    expect(d.members.map((m) => m.name), ['Kadir Özbek']);
    expect(d.people, 3);
    expect(d.feed, isEmpty);
    expect(d.others.map((s) => s.code), [dAlt, dEgi, dEle, dIda]);

    final ida = c.read(coordinatorshipDetailProvider(dIda)).requireValue!;
    expect((ida.stats.shortCode, ida.stats.name), (null, 'İdari işler'));
    expect((ida.stats.total, ida.attention.length, ida.people), (0, 0, 0));

    // Örnek ek bilgilerin kodu ('ALT') sunucu kimliği değildir: ayrıntı açılmaz.
    for (final code in ['ALT', 'YOK']) {
      c.listen(coordinatorshipDetailProvider(code), (_, _) {});
      expect(
        c.read(coordinatorshipDetailProvider(code)).requireValue,
        isNull,
        reason: code,
      );
    }
    expect(backend.unhandled, isEmpty);
  });
}
