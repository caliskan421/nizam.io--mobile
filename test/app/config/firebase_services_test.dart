import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/firebase_services.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/notifications/push_notifications.dart';

void main() {
  const services = FirebaseServices(
    pushNotifications: DisabledPushNotifications(),
    releasePolicySource: DisabledReleasePolicySource(),
  );

  test('prod, web and desktop skip initialization entirely', () async {
    var calls = 0;
    Future<FirebaseServices> initialize() async {
      calls++;
      return services;
    }

    for (final platform in TargetPlatform.values) {
      expect(
        await initializeFirebaseServices(
          Flavor.prod,
          platform: platform,
          isWeb: false,
          initialize: initialize,
        ),
        isNull,
      );
      expect(
        await initializeFirebaseServices(
          Flavor.dev,
          platform: platform,
          isWeb: true,
          initialize: initialize,
        ),
        isNull,
      );
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        continue;
      }
      expect(
        await initializeFirebaseServices(
          Flavor.dev,
          platform: platform,
          isWeb: false,
          initialize: initialize,
        ),
        isNull,
      );
    }
    expect(calls, 0);
  });

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    test('$platform returns initialized ports unchanged', () async {
      expect(
        await initializeFirebaseServices(
          Flavor.dev,
          platform: platform,
          isWeb: false,
          initialize: () async => services,
        ),
        same(services),
      );
    });
  }

  test(
    'error reporter defaults to an unavailable no-op (never auto-enabled)',
    () {
      expect(services.errorReporter.isAvailable, isFalse);
    },
  );

  test('synchronous and asynchronous SDK failures stay optional', () async {
    for (final initialize in <Future<FirebaseServices> Function()>[
      () => throw StateError('unavailable'),
      () async => throw Exception('unavailable'),
    ]) {
      expect(
        await initializeFirebaseServices(
          Flavor.dev,
          platform: TargetPlatform.android,
          isWeb: false,
          initialize: initialize,
        ),
        isNull,
      );
    }
  });

  testWidgets('hung initialization times out; late result cannot bind ports', (
    tester,
  ) async {
    final pending = Completer<FirebaseServices>();
    FirebaseServices? result;
    var completed = false;
    unawaited(
      initializeFirebaseServices(
        Flavor.dev,
        platform: TargetPlatform.android,
        isWeb: false,
        timeout: const Duration(seconds: 2),
        initialize: () => pending.future,
      ).then((value) {
        result = value;
        completed = true;
      }),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(completed, isTrue);
    expect(result, isNull);
    pending.complete(services);
    await tester.pump();
    expect(result, isNull);
  });
}
