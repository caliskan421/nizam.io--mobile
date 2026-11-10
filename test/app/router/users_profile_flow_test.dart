import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/app_nav.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/preferences/locale_controller.dart';
import 'package:nizamio/core/preferences/theme_mode_controller.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/application/admin_user_task_panel_controller.dart';
import 'package:nizamio/features/administration/domain/admin_user_tasks.dart';
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/administration/presentation/admin_user_profile_page.dart';
import 'package:nizamio/features/scope/scope.dart' show DepartmentRole;
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/connected_module_support.dart';
import '../../support/tablet_harness.dart' show hostPng;
import 'router_test_support.dart' show locationOf, settle;

class _Users implements OrganizationAdminRepository {
  @override
  Future<UserDirectoryPage> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    bool companyAdminOnly = false,
    String? programId,
    String? departmentId,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) async {
    final PageSlice<KnownUser> slice = search != null && search.isNotEmpty
        ? PageSlice(
            items: [
              KnownUser(
                accountId: 'person-1',
                fullName: 'Deniz Örnek',
                memberships: const ['program:department:koordinator'],
                teams: const [
                  UserMembership(
                    programId: 'program',
                    departmentId: 'department',
                    role: DepartmentRole.coordinator,
                  ),
                ],
              ),
            ],
          )
        : page.cursor == null
        ? PageSlice(
            items: [
              KnownUser(
                accountId: 'person-1',
                fullName: 'Deniz Örnek',
                memberships: const ['program:department:koordinator'],
                teams: const [
                  UserMembership(
                    programId: 'program',
                    departmentId: 'department',
                    role: DepartmentRole.coordinator,
                  ),
                ],
              ),
              KnownUser(
                accountId: 'person-2',
                fullName: 'Mina Güneş Uzunsoy Çınar Örnekçi',
                memberships: const [
                  'program:department:uye',
                  'program:design:koordinator',
                  'program:events:uye',
                ],
                teams: const [
                  UserMembership(
                    programId: 'program',
                    departmentId: 'department',
                    role: DepartmentRole.member,
                  ),
                  UserMembership(
                    programId: 'program',
                    departmentId: 'design',
                    role: DepartmentRole.coordinator,
                  ),
                  UserMembership(
                    programId: 'program',
                    departmentId: 'events',
                    role: DepartmentRole.member,
                  ),
                ],
              ),
              KnownUser(
                accountId: 'person-3',
                fullName: 'Arda Demir',
                memberships: const [],
              ),
            ],
            nextCursor: 'page-2',
          )
        : PageSlice(
            items: [
              KnownUser(
                accountId: 'person-4',
                fullName: 'Ekin Kaya',
                memberships: const ['program:department:uye'],
                teams: const [
                  UserMembership(
                    programId: 'program',
                    departmentId: 'department',
                    role: DepartmentRole.member,
                  ),
                ],
              ),
            ],
          );
    return UserDirectoryPage(
      items: slice.items,
      nextCursor: slice.nextCursor,
      total: search != null && search.isNotEmpty ? 1 : 4,
      roleCounts: const UserRoleCounts(
        all: 4,
        admins: 0,
        coordinators: 2,
        members: 2,
      ),
    );
  }

  @override
  Future<KnownUser> readUser(String accountId) async {
    final first = await listUsers();
    final second = await listUsers(page: const PageRequest(cursor: 'page-2'));
    final user = [
      ...first.items,
      ...second.items,
    ].firstWhere((u) => u.accountId == accountId);
    return KnownUser(
      accountId: user.accountId,
      fullName: user.fullName,
      memberships: user.memberships,
      teams: user.teams,
      email: 'deniz@example.test',
      accountStatus: AccountStatus.disabled,
      loginLocked: true,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TaskCatalog _profileCatalog() {
  final base = moduleCatalog();
  TaskItem task(
    String code,
    String title,
    String department,
    TaskStatus status,
    int day,
  ) => TaskItem(
    code: code,
    title: title,
    coordinatorship: department,
    departmentId: department,
    programId: 'program',
    status: status,
    priority: TaskPriority.medium,
    start: DateTime(2026, 11, 1),
    due: DateTime(2026, 11, day),
    assignees: const ['person-1'],
  );
  return TaskCatalog(
    today: base.today,
    me: base.me,
    access: base.access,
    people: base.people,
    coordinatorships: const [
      CoordinatorshipRef(
        code: 'department',
        name: 'İletişim',
        leads: [],
        members: [],
      ),
      CoordinatorshipRef(
        code: 'design',
        name: 'Tasarım',
        leads: [],
        members: [],
      ),
    ],
    tasks: [
      task('task-1', 'Etkinlik planı', 'department', TaskStatus.todo, 10),
      task('task-2', 'Duyuru metni', 'department', TaskStatus.inProgress, 22),
      task('task-3', 'Afiş tasarımı', 'design', TaskStatus.review, 12),
      task('task-4', 'Görsel arşivi', 'design', TaskStatus.done, 13),
      task('task-5', 'Program hazırlığı', 'department', TaskStatus.todo, 23),
      task('task-6', 'Salon planı', 'design', TaskStatus.inProgress, 24),
      task('task-7', 'İçerik kontrolü', 'department', TaskStatus.review, 25),
      task('task-8', 'Son düzenleme', 'design', TaskStatus.todo, 26),
    ],
  );
}

void main() {
  setUpFonts();
  for (final size in const [Size(390, 844), Size(1180, 820)]) {
    testWidgets('Kullanıcı listesi, profil ve hesap: $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      final prefs = AppPreferences(MemoryPreferenceStore());
      final locale = LocaleController(prefs);
      final themeMode = ThemeModeController(prefs);
      addTearDown(locale.dispose);
      addTearDown(themeMode.dispose);
      final container = moduleContainer(
        catalog: _profileCatalog(),
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(_Users()),
          connectivityStateProvider.overrideWithValue(ConnectivityState.online),
          flavorProvider.overrideWithValue(Flavor.dev),
          localeControllerProvider.overrideWithValue(locale),
          themeModeControllerProvider.overrideWithValue(themeMode),
        ],
      );
      addTearDown(container.dispose);
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = createRouter(phase);
      addTearDown(router.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) => MaterialApp.router(
              theme: theme(true),
              locale: const Locale('tr'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: testLocalizationDelegates,
              routerConfig: router,
              builder: (context, child) => NzAppNavScope(
                nav: GoRouterAppNav(router, ref),
                child: child!,
              ),
            ),
          ),
        ),
      );
      router.go('/users');
      await settle(tester);
      expect(find.text('Deniz Örnek'), findsOneWidget);
      expect(find.text('Mina Güneş Uzunsoy Çınar Örnekçi'), findsOneWidget);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-users-list-${size.width.toInt()}.png')
            .writeAsBytesSync(await hostPng(tester));
      }
      await tester.tap(find.bySemanticsLabel('Kullanıcı ara'));
      await settle(tester);
      await tester.enterText(find.byType(TextField).first, 'Deniz');
      await tester.pump(const Duration(seconds: 1));
      await settle(tester);
      expect(container.read(adminUserQueryProvider).search, 'Deniz');
      expect(find.text('Mina Güneş Uzunsoy Çınar Örnekçi'), findsNothing);
      expect(find.text('Deniz Örnek'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump(const Duration(seconds: 1));
      await settle(tester);
      final before = container
          .read(adminUsersProvider.notifier)
          .visible
          .requireValue;
      expect(find.text('4 kullanıcı (geçerli filtre)'), findsOneWidget);
      expect(find.text('4 kişi'), findsWidgets);
      expect(before.items.length, 3);
      expect(before.nextCursor, 'page-2');
      await tester.ensureVisible(find.text('Daha fazla göster'));
      await tester.tap(find.text('Daha fazla göster'));
      await settle(tester);
      final after = container
          .read(adminUsersProvider.notifier)
          .visible
          .requireValue;
      expect(find.text('4 kullanıcı (geçerli filtre)'), findsOneWidget);
      expect(find.text('4 kişi'), findsWidgets);
      expect(after.items.length, 4);
      expect(after.nextCursor, isNull);
      expect(find.text('Ekin Kaya'), findsOneWidget);
      await tester.ensureVisible(find.text('Deniz Örnek'));
      await tester.tap(find.text('Deniz Örnek'));
      await settle(tester);
      expect(locationOf(router), '/users/person-1');
      expect(find.byType(AdminUserProfilePage), findsOneWidget);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-user-profile-${size.width.toInt()}.png')
            .writeAsBytesSync(await hostPng(tester));
      }

      final collapsed = find.byKey(
        const ValueKey('user-profile-collapsed-title'),
      );
      expect(tester.widget<Opacity>(collapsed).opacity, 0);
      final scroll = tester.state<ScrollableState>(
        find
            .descendant(
              of: find.byType(AdminUserProfilePage),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(scroll.position.maxScrollExtent, greaterThan(200));
      scroll.position.jumpTo(scroll.position.maxScrollExtent);
      await tester.pump();
      await settle(tester);
      expect(tester.widget<Opacity>(collapsed).opacity, greaterThan(0));
      await Scrollable.ensureVisible(
        tester.element(find.text('Takvim').last),
        alignment: 0.5,
      );
      await tester.pump();
      await tester.tap(find.text('Takvim').last);
      await settle(tester);
      expect(
        container.read(adminUserTaskPanelProvider('person-1')).view,
        UserTaskView.calendar,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Liste').last),
        alignment: 0.5,
      );
      await tester.pump();
      await tester.tap(find.text('Liste').last);
      await settle(tester);
      expect(
        container.read(adminUserTaskPanelProvider('person-1')).view,
        UserTaskView.list,
      );
      await tester.tap(find.bySemanticsLabel('Görevleri süz').last);
      await settle(tester);
      await tester.tap(find.text('Tamamlananlar').last);
      await settle(tester);
      expect(
        container.read(adminUserTaskPanelProvider('person-1')).statuses,
        contains(UserTaskStatus.done),
      );
      Navigator.of(tester.element(find.text('Tamamlananlar').last)).pop();
      await settle(tester);
      scroll.position.jumpTo(0);
      await tester.pump();
      await settle(tester);
      expect(tester.widget<Opacity>(collapsed).opacity, 0);
      await tester.ensureVisible(find.text('Hesap').last);
      await tester.tap(find.text('Hesap').last, warnIfMissed: true);
      await settle(tester);
      expect(find.text('deniz@example.test'), findsWidgets);
      await tester.ensureVisible(find.text('Hesabı aç'));
      expect(find.text('Hesabı aç'), findsOneWidget);
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-users-${size.width.toInt()}.png')
            .writeAsBytesSync(await hostPng(tester));
      }
    });
  }
}
