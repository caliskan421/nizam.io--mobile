// HomeDashboardController: özet bileşim kökündeki kaynaktan (bugün geliştirme örneği) okunur;
// kapsam değişince yeniden okunur; ağ isteği atılmaz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_controller.dart';
import 'package:nizamio/features/scope/application/scope_providers.dart';
import 'package:nizamio/features/scope/data/sample/sample_home_dashboard_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_repository.dart';

import '../../pilot_support.dart';

class _Counting implements HomeDashboardRepository {
  var loads = 0;
  final _inner = SampleHomeDashboardRepository();

  @override
  Future<HomeDashboard> load() {
    loads++;
    return _inner.load();
  }
}

void main() {
  test('bileşim kökündeki örnek kaynak bağlı; ağ isteği yok', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    final before = h.backend.requests.length;
    h.container.listen(homeDashboardControllerProvider, (_, _) {});
    final d = await h.container.read(homeDashboardControllerProvider.future);
    expect(d.coordinatorships, hasLength(11));
    expect(h.backend.requests.length, before);
  });

  test('kapsam değişince yeniden okunur', () async {
    final repo = _Counting();
    var program = 0;
    final c = ProviderContainer(
      overrides: [
        homeDashboardRepositoryProvider.overrideWithValue(repo),
        scopeStateProvider.overrideWith(
          (ref) => ScopeSelection(programId: 'p${program++}'),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(homeDashboardControllerProvider, (_, _) {});
    await c.read(homeDashboardControllerProvider.future);
    expect(repo.loads, 1);
    c.invalidate(scopeStateProvider);
    await c.read(homeDashboardControllerProvider.future);
    expect(repo.loads, 2);
  });
}
