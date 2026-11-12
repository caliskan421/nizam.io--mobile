import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/release_policy_host.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/config/release_policy_provider.dart';
import 'package:nizamio/core/config/running_release.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

const _running = RunningRelease(
  version: '0.2.0',
  build: 2,
  packageName: 'io.nizamio.mobile',
  platform: MobileReleasePlatform.android,
);
final _required = MobileReleasePolicy.fromRemoteConfig({
  'android_minimum_version': '0.3.0',
});
final _optional = MobileReleasePolicy.fromRemoteConfig({
  'android_recommended_version': '0.3.0',
});

void main() {
  Future<void> pump(
    WidgetTester tester,
    Stream<MobileReleasePolicy> events, {
    BindingState? binding,
    Widget child = const Scaffold(body: Text('protected content')),
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          runningReleaseProvider.overrideWithValue(_running),
          mobileReleasePolicyProvider.overrideWith((ref) => events),
          bindingStateProvider.overrideWith(
            (ref) =>
                binding ??
                BindingVerified(
                  ServerInfo(
                    address: ServerAddress.parse(
                      'https://example.test',
                      Flavor.prod,
                    ),
                    instanceId: 'test',
                    displayName: 'test',
                    brandColor: '',
                    apiVersion: 'v1',
                    minimumMobileVersion: '0.0.0',
                    serverVersion: 'test',
                  ),
                ),
          ),
          connectivityStateProvider.overrideWith(
            (ref) => ConnectivityState.unknown,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReleasePolicyHost(child: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'mandatory policy hides active content; no fabricated store action',
    (tester) async {
      await pump(tester, Stream.value(_required));
      expect(find.text('protected content'), findsNothing);
      expect(find.text('Devam etmek için güncelle'), findsOneWidget);
      expect(find.text('Şimdi güncelle'), findsOneWidget);
      expect(find.bySemanticsLabel('Kapat'), findsNothing);
      expect(find.text('Daha sonra'), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('protected content'), findsNothing);
      expect(
        find.textContaining('Güncelleme bağlantısı henüz hazır değil'),
        findsOneWidget,
      );
      expect(find.textContaining('0.2.0+2'), findsNothing);
    },
  );

  testWidgets('optional dismissal never dismisses a later mandatory policy', (
    tester,
  ) async {
    final events = StreamController<MobileReleasePolicy>();
    addTearDown(events.close);
    events.add(_optional);
    await pump(tester, events.stream);
    expect(find.text('Daha sonra'), findsOneWidget);
    expect(find.bySemanticsLabel('Kapat'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Kapat'));
    await tester.pumpAndSettle();
    expect(find.text('protected content'), findsOneWidget);
    events.add(_required);
    await tester.pumpAndSettle();
    expect(find.text('protected content'), findsNothing);
    expect(find.text('Daha sonra'), findsNothing);
    expect(find.text('Devam etmek için güncelle'), findsOneWidget);
  });

  testWidgets('optional page blocks hidden focus and preserves form on later', (
    tester,
  ) async {
    final events = StreamController<MobileReleasePolicy>();
    addTearDown(events.close);
    final focus = FocusNode();
    addTearDown(focus.dispose);
    events.add(const MobileReleasePolicy.disabled());
    await pump(
      tester,
      events.stream,
      child: Scaffold(body: TextField(focusNode: focus)),
    );
    await tester.enterText(find.byType(TextField), 'korunan taslak');
    expect(focus.hasFocus, isTrue);
    events.add(_optional);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(focus.canRequestFocus, isFalse);
    await tester.tap(find.text('Daha sonra'));
    await tester.pumpAndSettle();
    expect(find.text('korunan taslak'), findsOneWidget);
  });

  testWidgets('optional panel does not cover backend update gate', (
    tester,
  ) async {
    await pump(
      tester,
      Stream.value(_optional),
      binding: BindingUpdateRequired(
        address: ServerAddress.parse('https://example.test', Flavor.prod),
        minimumVersion: '9.0.0',
        appVersion: '0.2.0',
      ),
    );
    expect(find.text('Daha sonra'), findsNothing);
    expect(find.text('protected content'), findsOneWidget);
  });
}
