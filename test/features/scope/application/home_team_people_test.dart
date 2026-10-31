// HomeTeamPeople: ekip kutularının açtığı görev listesi süzgeci (prototip `go.admin/koord/uye`
// kişi kümeleri) ortak görev kataloğundan türetilir.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/scope/application/home_team_people.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/tasks/data/sample/sample_task_catalog_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

void main() {
  test('ekip rolüne göre kümeler; yönetici süzgeci yok (boş)', () async {
    final catalog = await SampleTaskCatalogRepository().load();
    final p = HomeTeamPeople.fromCatalog(catalog);
    expect(p.of(TeamRole.admin), isEmpty);
    expect(p.of(TeamRole.member), ['bk', 'gn', 'mey']);
    // Koordinatör rolündekiler + koordinatörlük yürüten adminler (prototipteki 13 kişi).
    expect(p.of(TeamRole.coordinator).toSet(), {
      'aa',
      'av',
      'ko',
      'my',
      'oh',
      'so',
      'rk',
      'mk',
      'yc',
      'bc',
      'eo',
      'ss',
      'ma',
    });
  });

  test('sağlayıcı katalog yüklenince dolar', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c.listen(homeTeamPeopleProvider, (_, _) {});
    expect(c.read(homeTeamPeopleProvider), isNull);
    await c.read(taskCatalogControllerProvider.future);
    expect(c.read(homeTeamPeopleProvider)?.members, ['bk', 'gn', 'mey']);
  });
}
