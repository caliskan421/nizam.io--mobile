// HomeDashboardSource: sunucu programı seçiliyse sunucu kaynağı, örnek kapsamda örnek;
// bağ yoksa server_not_verified.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/scope/application/home_dashboard_source.dart';
import 'package:nizamio/features/scope/data/sample/sample_home_dashboard_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_repository.dart';

class _Server implements HomeDashboardRepository {
  var loads = 0;

  @override
  Future<HomeDashboard> load() async {
    loads++;
    return const HomeDashboard(
      greetingName: 'Sunucu',
      tasks: TaskTotals(
        total: 0,
        done: 0,
        inProgress: 0,
        late: 0,
        awaitingApproval: 0,
      ),
      team: TeamTotals(admins: 0, coordinators: 0, members: 0),
      coordinatorships: [],
      pending: [],
      counts: ModuleCounts(
        lateTasks: 0,
        tasksAwaitingApproval: 0,
        unreadMessages: 0,
        pendingRequests: 0,
      ),
    );
  }

  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async => const TeamDashboardExtras(unreadMessages: 0);
}

void main() {
  late ScopeController scope;
  late _Server server;
  var bound = true;

  HomeDashboardSource source() => HomeDashboardSource(
    scope: scope,
    server: () => bound ? server : null,
    sample: SampleHomeDashboardRepository(),
  );

  setUp(() {
    scope = ScopeController();
    server = _Server();
    bound = true;
  });

  test('sunucu programı seçiliyse sunucu kaynağı', () async {
    scope.selectProgram('p1');
    final d = await source().load();
    expect(d.greetingName, 'Sunucu');
    expect(server.loads, 1);
  });

  test('örnek kapsamda örnek kaynak; sunucuya gidilmez', () async {
    scope.selectSample();
    final d = await source().load();
    expect(d.demoProgramName, isNotNull);
    expect(server.loads, 0);
  });

  test('kapsam yoksa örnek kaynak', () async {
    final d = await source().load();
    expect(d.demoProgramName, isNotNull);
    expect(server.loads, 0);
  });

  test('bağ yoksa server_not_verified', () async {
    scope.selectProgram('p1');
    bound = false;
    await expectLater(
      source().load(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.serverNotVerified,
        ),
      ),
    );
  });
}
