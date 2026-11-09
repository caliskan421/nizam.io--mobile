// CoordinatorshipDetailController: bölüm ve görev süzgeci durumu (kod başına); ayrıntı türetimi
// (sunucu kataloğu + departman kaydı), bilinmeyen kimlik null; departman kaydı yalnız şirket
// yöneticisinde okunur.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_detail_controller.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_profiles_controller.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart'
    show DepartmentKind;
import 'package:nizamio/features/coordinatorships/domain/coordinatorship_board.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';
import '../coord_backend.dart';

/// Kaynaklar (katalog + departman kaydı) yüklenince ayrıntı eşzamanlı okunur.
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
    // Departman kaydı `GET /v1/departments`'tan (tek istek): tür ve açıklama.
    expect(d.department?.kind, DepartmentKind.coordinatorship);
    expect(d.department?.description, 'Su ve yapı işleri');
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
    expect(d.others.map((s) => s.code), [dAlt, dEgi, dEle, dIda]);

    final ida = c.read(coordinatorshipDetailProvider(dIda)).requireValue!;
    expect((ida.stats.shortCode, ida.stats.name), (null, 'İdari işler'));
    expect((ida.stats.total, ida.attention.length, ida.people), (0, 0, 0));
    // Departman listesinde olmayan kayıt: tür yok (ayrıntı yine açılır).
    expect(ida.department, isNull);
    final ele = c.read(coordinatorshipDetailProvider(dEle)).requireValue!;
    expect(ele.department?.kind, DepartmentKind.workingGroup);
    c.listen(coordinatorshipDetailProvider(dEgi), (_, _) {});
    expect(
      c
          .read(coordinatorshipDetailProvider(dEgi))
          .requireValue!
          .department
          ?.kind,
      DepartmentKind.unknown,
    );
    expect(h.backend.count('GET', '/v1/departments'), 1);

    // Kısa kod ('ALT') sunucu kimliği (`department_id`) değildir: ayrıntı açılmaz.
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

  test(
    'yönetici olmayan: departman kaydı istenmez, ayrıntı katalogdan açılır',
    () async {
      final backend = CoordBackend()..admin = false;
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(coordinatorshipDetailProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      final d = c.read(coordinatorshipDetailProvider(dAlt)).requireValue!;
      expect(d.stats.name, 'Altyapı ve tesisat');
      expect(d.department, isNull);
      expect(d.leads.map((m) => m.name), ['Abdullah Ateş', 'Ali Avcı']);
      expect(h.backend.count('GET', '/v1/departments'), 0);
      expect(backend.unhandled, isEmpty);
    },
  );

  test(
    'departman kaydı okunamazsa ayrıntı hata durumunda; boş liste hata değil',
    () async {
      final backend = CoordBackend()
        ..departmentsError = 'organization.authority_unavailable';
      final h = await pilotHarness(backend, signedIn: true);
      h.read(scopeControllerProvider).selectProgram(coordProgram);
      final c = h.container;
      c.listen(coordinatorshipDetailProvider(dAlt), (_, _) {});
      await c.read(taskCatalogControllerProvider.future);
      await expectLater(
        c.read(coordinatorshipProfilesControllerProvider.future),
        throwsA(isA<ApiError>()),
      );
      final failed = c.read(coordinatorshipDetailProvider(dAlt));
      expect(
        (failed.error as ApiError?)?.code,
        'organization.authority_unavailable',
      );

      // Kullanıcı yeniden dener; sunucu boş liste döner: kayıt yok, ayrıntı açılır.
      backend
        ..departmentsError = null
        ..companyDepartments = [];
      c.invalidate(coordinatorshipProfilesControllerProvider);
      await _ready(c);
      final d = c.read(coordinatorshipDetailProvider(dAlt)).requireValue!;
      expect(d.department, isNull);
    },
  );
}
