import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/app_nav.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
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
  }) async => PageSlice(
    items: [
      KnownUser(
        accountId: 'person-1',
        fullName: 'Deniz Örnek',
        memberships: const [],
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
      final container = moduleContainer(
        overrides: [
          organizationAdminRepositoryProvider.overrideWithValue(_Users()),
          connectivityStateProvider.overrideWithValue(ConnectivityState.online),
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
              theme: theme(false),
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
