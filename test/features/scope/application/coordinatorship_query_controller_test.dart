// CoordinatorshipQueryController: filtre, ölçüt döngüsü, yön, tümünü göster (görünüm durumu).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/scope/application/coordinatorship_query_controller.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';

CoordinatorshipSummary _c(
  String name, {
  int late = 0,
  int done = 1,
  int todo = 1,
  List<String> leads = const ['X'],
}) => CoordinatorshipSummary(
  code: name.substring(0, 2),
  name: name,
  leads: leads,
  todo: todo,
  inProgress: 0,
  inReview: 0,
  done: done,
  late: late,
);

final _all = [
  _c('Fuar', late: 1, done: 3),
  _c('İdari', late: 4, done: 0, leads: const []),
  _c('Çevre', done: 9, todo: 1),
  _c('Bütçe', late: 1, done: 1, todo: 3),
  _c('Ulaşım'),
];

List<String> _names(List<CoordinatorshipSummary> l) => [
  for (final c in l) c.name,
];

void main() {
  test('varsayılan: gecikme, büyükten küçüğe; eşitlikte ad A→Z; ilk 4', () {
    const q = CoordinatorshipQuery();
    expect(_names(q.filtered(_all)), [
      'İdari',
      'Bütçe',
      'Fuar',
      'Çevre',
      'Ulaşım',
    ]);
    expect(q.visible(_all), hasLength(CoordinatorshipQuery.collapsedCount));
    expect(q.copyWith(expanded: true).visible(_all), hasLength(5));
  });

  test(
    'gecikme eşitliği yönle döner (küçükten büyüğe: Z→A); ilerleme kararlı',
    () {
      const asc = CoordinatorshipQuery(descending: false);
      expect(_names(asc.filtered(_all)), [
        'Ulaşım',
        'Çevre',
        'Fuar',
        'Bütçe',
        'İdari',
      ]);
      // İlerleme eşitleri gelen (sunucu) sırasını korur.
      final same = [_c('Zeta'), _c('Alfa'), _c('Mavi')];
      const prog = CoordinatorshipQuery(sort: CoordinatorshipSort.progress);
      expect(_names(prog.filtered(same)), ['Zeta', 'Alfa', 'Mavi']);
      expect(_names(prog.copyWith(descending: false).filtered(same)), [
        'Zeta',
        'Alfa',
        'Mavi',
      ]);
    },
  );

  test('filtreler sunucu sayılarına bakar', () {
    int n(CoordinatorshipFilter f) =>
        _all.where((c) => CoordinatorshipQuery.matches(f, c)).length;
    expect(n(CoordinatorshipFilter.all), 5);
    expect(n(CoordinatorshipFilter.late), 3);
    expect(n(CoordinatorshipFilter.onTrack), 2);
    expect(n(CoordinatorshipFilter.unassigned), 1);
  });

  test('ilerleme ve ad (Türkçe sıra) ölçütleri; yön çevrilir', () {
    const q = CoordinatorshipQuery(sort: CoordinatorshipSort.progress);
    expect(_names(q.filtered(_all)).first, 'Çevre');
    const byName = CoordinatorshipQuery(
      sort: CoordinatorshipSort.name,
      descending: false,
    );
    expect(_names(byName.filtered(_all)), [
      'Bütçe',
      'Çevre',
      'Fuar',
      'İdari',
      'Ulaşım',
    ]);
    expect(_names(byName.copyWith(descending: true).filtered(_all)), [
      'Ulaşım',
      'İdari',
      'Fuar',
      'Çevre',
      'Bütçe',
    ]);
  });

  test('komutlar: döngü, yön, filtre daraltır, eşitlik', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final ctl = c.read(coordinatorshipQueryControllerProvider.notifier);
    CoordinatorshipQuery q() => c.read(coordinatorshipQueryControllerProvider);
    ctl.toggleExpanded();
    expect(q().expanded, isTrue);
    ctl.selectFilter(CoordinatorshipFilter.late);
    expect((q().filter, q().expanded), (CoordinatorshipFilter.late, false));
    ctl.cycleSort();
    expect((q().sort, q().descending), (CoordinatorshipSort.progress, true));
    ctl.cycleSort();
    expect((q().sort, q().descending), (CoordinatorshipSort.name, false));
    ctl.flipDirection();
    expect(q().descending, isTrue);
    ctl.cycleSort();
    expect(q().sort, CoordinatorshipSort.late);
    expect(const CoordinatorshipQuery(), const CoordinatorshipQuery());
    expect(
      const CoordinatorshipQuery().hashCode,
      const CoordinatorshipQuery().hashCode,
    );
  });
}
