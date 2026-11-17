import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/administration/application/team_controller.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/team_view.dart';
import 'package:nizamio/features/administration/presentation/admin_user_profile_page.dart';
import 'package:nizamio/features/administration/presentation/administration_page.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';

class _TeamCatalog extends TaskCatalogController {
  _TeamCatalog(this.role);
  final SeatRole role;

  @override
  Future<TaskCatalog> build() async => TaskCatalog(
    today: DateTime(2026, 11, 18),
    me: 'acc-1',
    access: TaskAccess(
      accountId: 'acc-1',
      companyAdmin: false,
      seats: [
        TeamSeat(
          programId: 'prog-1',
          departmentId: 'd1',
          departmentName: 'Altyapı',
          role: role,
        ),
      ],
    ),
    people: const [],
    coordinatorships: const [
      CoordinatorshipRef(
        code: 'd1',
        name: 'Altyapı',
        leads: ['lead'],
        members: ['acc-1'],
      ),
    ],
    tasks: const [],
  );
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  final l = AppLocalizationsTr();
  for (final role in [SeatRole.member, SeatRole.coordinator]) {
    final source = role == SeatRole.member
        ? TeamSource.departmentGroup
        : TeamSource.departmentMembers;
    for (final available in role == SeatRole.member ? [false, true] : [true]) {
      testScreens(
        '${role.name} ekibi: kaynak mevcut=$available, kişi açılır ve sayfadan çıkılır',
        (t, screen) async {
          t.platformDispatcher.textScaleFactorTestValue = 2;
          addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
          final backend = PilotBackend()
            ..companyAdmin = false
            ..seats = [
              {
                'program_id': 'prog-1',
                'department_id': 'd1',
                'display_name': 'Altyapı',
                'role': role == SeatRole.member ? 'uye' : 'koordinator',
              },
            ];
          final h = await real(t, () => pilotHarness(backend, signedIn: true));
          h.read(scopeControllerProvider).selectProgram('prog-1');
          final opened = <String>[];
          final selected = ValueNotifier<String?>(null);
          addTearDown(selected.dispose);
          await pumpScreen(
            t,
            h,
            ProviderScope(
              overrides: [
                taskCatalogControllerProvider.overrideWith(
                  () => _TeamCatalog(role),
                ),
                teamUserProfileProvider('lead').overrideWith(
                  (ref) async => KnownUser(
                    accountId: 'lead',
                    fullName: 'Ece Kaya',
                    memberships: const [],
                  ),
                ),
                teamSourceProvider.overrideWithValue(source),
                effectiveAccessProvider.overrideWith(
                  (ref) => EffectiveAccess.of(
                    TaskAccess(
                      accountId: 'acc-1',
                      companyAdmin: false,
                      seats: [
                        TeamSeat(
                          programId: 'prog-1',
                          departmentId: 'd1',
                          departmentName: 'Altyapı',
                          role: role,
                        ),
                      ],
                    ),
                    const ScopeSelection(programId: 'prog-1'),
                  ),
                ),
                teamRosterProvider.overrideWith(
                  (ref) async => TeamRoster(
                    source: source,
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
              child: ValueListenableBuilder<String?>(
                valueListenable: selected,
                builder: (context, id, _) => id == null
                    ? AdministrationPage(
                        onUserSelected: (id) {
                          opened.add(id);
                          selected.value = id;
                        },
                      )
                    : AdminUserProfilePage(
                        accountId: id,
                        onBack: () => selected.value = null,
                      ),
              ),
            ),
          );
          await settle(t);
          expect(find.text('Altyapı · 2 kişi'), findsNothing);
          if (!available) {
            expect(find.text(l.uiUsersTeamUnavailable), findsOneWidget);
          } else {
            expect(find.text('Ece Kaya'), findsOneWidget);
            if (role == SeatRole.member) {
              expect(find.textContaining(l.uiUsersTeamOpen), findsNothing);
            }
            await t.tap(find.text('Ece Kaya'));
            await settle(t);
            expect(opened, ['lead']);
            expect(find.byType(AdminUserProfilePage), findsOneWidget);
            expect(find.text('Ece Kaya'), findsWidgets);
            expect(find.text(l.uiUsersNotFound), findsNothing);
            if (role == SeatRole.member) {
              expect(find.byTooltip(l.uiUsersTeamAdd), findsNothing);
            }
          }
          expect(t.takeException(), isNull);
          await pumpScreen(t, h, const SizedBox.shrink());
          await settle(t);
          expect(t.takeException(), isNull);
        },
      );
    }
  }
}
