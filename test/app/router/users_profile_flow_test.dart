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
import 'package:nizamio/features/administration/domain/organization_admin.dart';
import 'package:nizamio/features/administration/domain/organization_admin_repository.dart';
import 'package:nizamio/features/administration/presentation/admin_user_profile_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/connected_module_support.dart';
import '../../support/tablet_harness.dart' show hostPng;
import 'router_test_support.dart' show locationOf, settle;

class _Users implements OrganizationAdminRepository {
  @override
  Future<PageSlice<KnownUser>> listUsers({
    PageRequest page = const PageRequest(),
    dynamic role,
    String? search,
    dynamic sortBy,
    dynamic sortOrder,
  }) async => search != null && search.isNotEmpty
      ? PageSlice(
          items: [
            KnownUser(
              accountId: 'person-1',
              fullName: 'Deniz Örnek',
              memberships: const ['program:department:koordinator'],
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
            ),
            KnownUser(
              accountId: 'person-2',
              fullName: 'Mina Güneş Uzunsoy Çınar Örnekçi',
              memberships: const [
                'program:department:uye',
                'program:design:koordinator',
                'program:events:uye',
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
            ),
          ],
        );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
      expect(find.text('3+ kullanıcı'), findsOneWidget);
      expect(find.text('3+ kişi'), findsWidgets);
      expect(before.items.length, 3);
      expect(before.nextCursor, 'page-2');
      await tester.ensureVisible(find.text('Daha fazla göster'));
      await tester.tap(find.text('Daha fazla göster'));
      await settle(tester);
      final after = container
          .read(adminUsersProvider.notifier)
          .visible
          .requireValue;
      expect(find.text('4 kullanıcı'), findsOneWidget);
      expect(find.text('4 kişi'), findsWidgets);
      expect(after.items.length, 4);
      expect(after.nextCursor, isNull);
      expect(find.text('Ekin Kaya'), findsOneWidget);
      await tester.ensureVisible(find.text('Deniz Örnek'));
      await tester.tap(find.text('Deniz Örnek'));
      await settle(tester);
      expect(locationOf(router), '/users/person-1');
      expect(find.byType(AdminUserProfilePage), findsOneWidget);
      await tester.ensureVisible(find.text('Hesap').last);
      await tester.tap(find.text('Hesap').last, warnIfMissed: true);
      await settle(tester);
      expect(
        find.textContaining('E-posta, giriş kilidi ve son giriş bilgisi'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-users-${size.width.toInt()}.png')
            .writeAsBytesSync(await hostPng(tester));
      }
    });
  }
}
