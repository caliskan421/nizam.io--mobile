import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/surfaces/surfaces.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/presentation/admin_user_hero.dart';
import 'package:nizamio/features/administration/presentation/admin_user_identity.dart';
import 'package:nizamio/features/identity/presentation/profile_identity.dart';
import 'package:nizamio/features/identity/presentation/profile_work.dart';
import 'package:nizamio/features/scope/scope.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/recording_app_nav.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();
final _access = TaskAccess(
  accountId: 'me',
  companyAdmin: true,
  seats: const [
    TeamSeat(
      programId: 'p',
      departmentId: 'a',
      departmentName: 'Tasarım',
      role: SeatRole.coordinator,
    ),
    TeamSeat(
      programId: 'p',
      departmentId: 'b',
      departmentName: 'Yazılım',
      role: SeatRole.member,
    ),
    TeamSeat(
      programId: 'other',
      departmentId: 'c',
      departmentName: 'Başka programın ekibi',
      role: SeatRole.coordinator,
    ),
  ],
);
TaskItem _task(String id, String department, List<String> assignees) =>
    TaskItem(
      code: id,
      title: id,
      programId: 'p',
      departmentId: department,
      coordinatorship: department,
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      start: DateTime(2026),
      due: DateTime(2027),
      assignees: assignees,
    );
TaskCatalog _catalog({bool truncated = false}) => TaskCatalog(
  today: DateTime(2026),
  me: 'me',
  access: _access,
  truncated: truncated,
  people: const [],
  coordinatorships: const [],
  tasks: [
    _task('own-a', 'a', ['me']),
    _task('other-a', 'a', ['other']),
    _task('own-b', 'b', ['me']),
  ],
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testScreens(
    'roller yalnız ait oldukları programdaki ekip satırlarında gösterilir',
    (tester, screen) async {
      useScreen(tester, screen);
      final h = await real(
        tester,
        () => pilotHarness(PilotBackend(), signedIn: true),
      );
      await pumpScreen(
        tester,
        h,
        SingleChildScrollView(
          child: ProfileMemberships(
            program: const Program(id: 'p', name: 'Program'),
            catalog: _catalog(),
          ),
        ),
      );
      expect(find.text('Tasarım'), findsOneWidget);
      expect(find.text('Yazılım'), findsOneWidget);
      expect(find.text(_l.uiUsersCoordinator), findsOneWidget);
      expect(find.text(_l.uiUsersMember), findsOneWidget);
      expect(find.text('Başka programın ekibi'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'kişi profili koordinatörlük ve rolü eşler, diğer programın rolünü gizler',
    (tester) async {
      final h = await real(
        tester,
        () => pilotHarness(PilotBackend(), signedIn: true),
      );
      final user = KnownUser(
        accountId: 'person',
        fullName: 'Deniz Örnek',
        memberships: const [],
        teams: const [
          UserMembership(
            programId: 'p',
            departmentId: 'a',
            displayName: 'Tasarım',
            role: DepartmentRole.member,
          ),
          UserMembership(
            programId: 'other',
            departmentId: 'c',
            displayName: 'Diğer ekip',
            role: DepartmentRole.coordinator,
          ),
        ],
      );
      await pumpScreen(
        tester,
        h,
        AdminUserHero(
          identity: AdminUserIdentity(user, companyAdmin: false),
          catalog: _catalog(),
          programId: 'p',
          nameKey: GlobalKey(),
        ),
      );
      expect(find.text('Tasarım · ${_l.uiUsersMember}'), findsOneWidget);
      expect(find.text(_l.uiUsersCoordinator), findsNothing);
      expect(find.textContaining('Diğer ekip'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final role in EffectiveRole.values) {
    testWidgets(
      '$role: iş özeti etkin görünümü korur ve doğru filtreye gider',
      (tester) async {
        final h = await real(
          tester,
          () => pilotHarness(PilotBackend(), signedIn: true),
        );
        final nav = RecordingAppNav();
        final view = EffectiveAccess.of(
          _access,
          ScopeSelection(
            programId: 'p',
            role: role,
            departmentId: role == EffectiveRole.member ? 'b' : 'a',
          ),
        );
        await pumpScreen(
          tester,
          h,
          ProviderScope(
            overrides: [effectiveAccessProvider.overrideWithValue(view)],
            child: SingleChildScrollView(
              child: ProfileWork(catalog: _catalog(truncated: true)),
            ),
          ),
          nav: nav,
        );
        expect(find.text(_l.uiIdentityProfilePartial), findsOneWidget);
        expect(
          find.byType(NzKpiTile),
          findsNWidgets(role == EffectiveRole.coordinator ? 8 : 4),
        );
        expect(
          find.text(_l.uiHomeModuleUsers),
          role == EffectiveRole.admin ? findsOneWidget : findsNothing,
        );
        final tile = tester.widget<NzKpiTile>(find.byType(NzKpiTile).first);
        expect(tile.value, role == EffectiveRole.admin ? '2+' : '1+');
        await tester.tap(find.byType(NzKpiTile).first);
        expect(nav.calls, ['tasks:all:me']);
        if (role == EffectiveRole.coordinator) {
          final teamTile = find.byType(NzKpiTile).at(4);
          expect(tester.widget<NzKpiTile>(teamTile).value, '2+');
          await tester.ensureVisible(teamTile);
          await tester.tap(teamTile);
          expect(nav.calls.last, 'tasks:all:a');
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testScreens('büyük yazıda iş özeti taşmaz', (tester, screen) async {
    useScreen(tester, screen);
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(
      tester,
      h,
      ProviderScope(
        overrides: [
          effectiveAccessProvider.overrideWithValue(
            EffectiveAccess.of(
              _access,
              const ScopeSelection(
                programId: 'p',
                role: EffectiveRole.coordinator,
                departmentId: 'a',
              ),
            ),
          ),
        ],
        child: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SingleChildScrollView(child: ProfileWork(catalog: _catalog())),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
