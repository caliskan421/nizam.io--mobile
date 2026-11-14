import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/administration/application/team_controller.dart';
import 'package:nizamio/features/administration/domain/team_view.dart';
import 'package:nizamio/features/administration/presentation/team_roster_view.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  final l = AppLocalizationsTr();
  for (final available in [false, true]) {
    testWidgets(
      'üye ekibi: grup mevcut=$available, yük sayılmaz ve kişi açılır',
      (t) async {
        final backend = PilotBackend()
          ..companyAdmin = false
          ..seats = [
            {
              'program_id': 'prog-1',
              'department_id': 'd1',
              'display_name': 'Altyapı',
              'role': 'uye',
            },
          ];
        final h = await real(t, () => pilotHarness(backend, signedIn: true));
        h.read(scopeControllerProvider).selectProgram('prog-1');
        final opened = <String>[];
        await pumpScreen(
          t,
          h,
          ProviderScope(
            overrides: [
              teamSourceProvider.overrideWithValue(TeamSource.departmentGroup),
              effectiveAccessProvider.overrideWith(
                (ref) => EffectiveAccess.of(
                  TaskAccess(
                    accountId: 'acc-1',
                    companyAdmin: false,
                    seats: const [
                      TeamSeat(
                        programId: 'prog-1',
                        departmentId: 'd1',
                        departmentName: 'Altyapı',
                        role: SeatRole.member,
                      ),
                    ],
                  ),
                  const ScopeSelection(programId: 'prog-1'),
                ),
              ),
              teamRosterProvider.overrideWith(
                (ref) async => TeamRoster(
                  source: TeamSource.departmentGroup,
                  departmentId: 'd1',
                  available: available,
                  people: available
                      ? const [
                          TeamPerson(
                            accountId: 'acc-1',
                            name: 'Deniz Yılmaz',
                            lead: false,
                          ),
                          TeamPerson(
                            accountId: 'lead',
                            name: 'Ece Kaya',
                            lead: true,
                          ),
                        ]
                      : const [],
                ),
              ),
            ],
            child: TeamRosterView(onOpen: opened.add),
          ),
        );
        await settle(t);
        expect(find.text('Altyapı · 2 kişi'), findsNothing);
        if (!available) {
          expect(find.text(l.uiUsersTeamUnavailable), findsOneWidget);
        } else {
          expect(find.text('Ece Kaya'), findsOneWidget);
          expect(find.textContaining(l.uiUsersTeamOpen), findsNothing);
          await t.tap(find.text('Ece Kaya'));
          await settle(t);
          expect(opened, ['lead']);
          expect(find.byTooltip(l.uiUsersTeamAdd), findsNothing);
        }
        expect(t.takeException(), isNull);
      },
    );
  }
}
