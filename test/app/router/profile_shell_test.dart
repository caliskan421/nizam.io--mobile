import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/navigation.dart';
import 'package:nizamio/features/identity/application/current_account_controller.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/scope/scope.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';

class _Account extends CurrentAccountController {
  _Account(this.role);
  final EffectiveRole role;

  @override
  Future<CurrentAccount> build() async => CurrentAccount(
    accountId: 'me',
    email: 'profile@nizam.local',
    fullName: 'Profil Kullanıcısı',
    companyAdmin: role == EffectiveRole.admin,
  );
}

EffectiveAccess _view(EffectiveRole role) => EffectiveAccess.of(
  TaskAccess(
    accountId: 'me',
    companyAdmin: role == EffectiveRole.admin,
    seats: [
      TeamSeat(
        programId: 'p',
        departmentId: 'd',
        departmentName: 'Ekip',
        role: role == EffectiveRole.coordinator
            ? SeatRole.coordinator
            : SeatRole.member,
      ),
    ],
  ),
  ScopeSelection(programId: 'p', role: role, departmentId: 'd'),
);

void main() {
  setUpFonts();

  for (final role in EffectiveRole.values) {
    for (final width in [360.0, 1100.0]) {
      testWidgets('$role / $width: profil kabuk ve gezinmeyi korur', (
        tester,
      ) async {
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        if (width == 360) {
          tester.platformDispatcher.textScaleFactorTestValue = 2;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        }
        final router = await pumpRouter(
          tester,
          phase,
          width: width,
          height: 900,
          overrides: [
            effectiveAccessProvider.overrideWith((ref) => _view(role)),
            currentAccountControllerProvider.overrideWith(() => _Account(role)),
          ],
        );
        await settle(tester);
        final nav = NzAppNavScope.of(
          tester.element(find.byType(NzAdaptiveShell)),
        );
        nav.openProfile();
        await settle(tester);
        expect(locationOf(router), const ProfileRoute().location);
        expect(find.byType(ProfilePage), findsOneWidget);
        expect(find.byType(NzAdaptiveShell), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(ProfilePage),
            matching: find.byType(RootTopBar),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        // Profil yeniden açılınca ikinci bir profil ya da kabuk yığını oluşmaz.
        nav.openProfile();
        await settle(tester);
        expect(find.byType(ProfilePage), findsOneWidget);
        expect(router.canPop(), isTrue);
        router.pop();
        await settle(tester);
        expect(locationOf(router), const HomeRoute().location);

        nav.openProfile();
        await settle(tester);
        if (width == 360) {
          final floating = find.byType(NzFloatingNav);
          expect(floating, findsOneWidget);
          tester.widget<NzFloatingNav>(floating).onSelect(1);
          await settle(tester);
          expect(locationOf(router), const TasksRoute().location);
          tester.widget<NzFloatingNav>(floating).onSelect(0);
          await settle(tester);
          expect(locationOf(router), const HomeRoute().location);
          nav.openProfile();
          await settle(tester);
          tester.widget<NzFloatingNav>(floating).onSelect(0);
        } else {
          final rail = find.byType(NzTabletRail);
          expect(rail, findsOneWidget);
          tester.widget<NzTabletRail>(rail).onSelect(0);
        }
        await settle(tester);
        expect(locationOf(router), const HomeRoute().location);
        expect(find.byType(ProfilePage), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
