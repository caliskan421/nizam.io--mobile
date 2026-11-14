// Ortak görev araması (liste, telefon ve tablet zaman çizelgesi): başlık, görev kodu ve
// atanan adı, koordinatörlük adı; Türkçe küçük harf.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_query.dart';

final _task = TaskItem(
  code: 'w1',
  shortCode: 'ALT-7',
  title: 'Isıtma Hattı',
  coordinatorship: 'd1',
  departmentId: 'd1',
  programId: 'p1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const ['u1'],
);

final _catalog = TaskCatalog(
  today: DateTime(2026, 7, 10),
  me: 'u1',
  tasks: [_task],
  people: const [],
  coordinatorships: const [
    CoordinatorshipRef(
      code: 'd1',
      name: 'Mekanik İşler',
      leads: [],
      members: [],
    ),
  ],
  names: const [PersonName('u1', 'İpek Şahin')],
);

bool _m(String q) => taskMatchesQuery(_task, _catalog, q);

void main() {
  test('boş sorgu her görevi tutar', () => expect(_m('  '), isTrue));

  test('başlık Türkçe küçük harfle eşleşir (I → ı)', () {
    expect(_m('ısıtma'), isTrue);
    expect(_m('HATTI'), isTrue);
  });

  test('görev kodu ve kısa kod eşleşir', () {
    expect(_m('w1'), isTrue);
    expect(_m('alt-7'), isTrue);
  });

  test('atanan kişi adı eşleşir (İ → i)', () => expect(_m('ipek'), isTrue));

  test('koordinatörlük adı eşleşir', () => expect(_m('mekanik'), isTrue));

  test('eşleşmeyen sorgu görevi düşürür', () => expect(_m('boru'), isFalse));

  // Gezinme niyeti görünümü adla taşır (`TaskView.values.byName`); eksik ad açılışta çöker.
  test('her NzTaskView adının TaskView karşılığı var', () {
    expect(
      NzTaskView.values.map((v) => TaskView.values.byName(v.name).name),
      NzTaskView.values.map((v) => v.name),
    );
  });
}
