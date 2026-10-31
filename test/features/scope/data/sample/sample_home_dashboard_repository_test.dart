// HomeDashboardRepository: bugünkü tek gerçekleştirme geliştirme örneğidir; tutarlı sayılar,
// prototip adları, saate göre "bugün" tarihleri.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/scope/data/sample/sample_home_dashboard_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_repository.dart';

void main() {
  test(
    'örnek kaynak sözleşmeyi uygular; sayılar kendi içinde tutarlı',
    () async {
      final HomeDashboardRepository repo = SampleHomeDashboardRepository(
        now: () => DateTime(2026, 10, 21, 9),
      );
      final d = await repo.load();
      expect(d.tasks.open, d.tasks.total - d.tasks.done);
      // Prototip fikstürü: ekip satırı 18 kullanıcı, rol kutuları 2 · 15 · 3.
      expect(d.team!.users, 18);
      expect(
        (d.team!.admins, d.team!.coordinators, d.team!.members),
        (2, 15, 3),
      );
      expect(d.coordinatorships.map((c) => c.code).toSet(), hasLength(11));
      expect(d.coordinatorships.where((c) => !c.hasLead), hasLength(1));
      expect(d.lastActivity!.at, DateTime(2026, 10, 21, 14, 27));
      final date = d.pending.firstWhere(
        (p) => p.kind == PendingKind.dateChange,
      );
      expect(date.requestedDate, DateTime(2026, 12, 11));
      expect(
        d.pending.where((p) => p.kind == PendingKind.approval),
        hasLength(3),
      );
    },
  );

  test('koordinatörlük yüzdesi ve toplamı sayılardan', () {
    const c = CoordinatorshipSummary(
      code: 'X',
      name: 'X',
      leads: [],
      todo: 2,
      inProgress: 6,
      inReview: 2,
      done: 1,
      late: 4,
    );
    expect((c.total, c.donePercent, c.hasLead), (11, 9, false));
    const empty = CoordinatorshipSummary(
      code: 'Y',
      name: 'Y',
      leads: ['a'],
      todo: 0,
      inProgress: 0,
      inReview: 0,
      done: 0,
      late: 0,
    );
    expect(empty.donePercent, 0);
  });
}
