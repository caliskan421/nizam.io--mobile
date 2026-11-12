import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/flavor.dart';
import '../../core/config/mobile_release_policy.dart';
import '../../core/notifications/push_notifications.dart';
import '../../core/preferences/app_preferences.dart';
import '../notifications/firebase_push_notifications.dart';
import 'firebase_release_policy_source.dart';

/// Optional native adapters. Construction does not fetch policy, request push
/// permission, obtain a token, or enable collection.
final class FirebaseServices {
  const FirebaseServices({
    required this.pushNotifications,
    required this.releasePolicySource,
  });

  final PushNotifications pushNotifications;
  final ReleasePolicySource releasePolicySource;
}

/// Dev mobile only; unsupported targets return before any SDK access.
/// Native flavor configuration supplies the default Firebase app options.
/// A timed-out initialization cannot be cancelled, but its eventual result is
/// discarded: composition retains disabled ports for the entire launch.
Future<FirebaseServices?> initializeFirebaseServices(
  Flavor flavor, {
  AppPreferences? preferences,
  Duration timeout = const Duration(seconds: 2),
  @visibleForTesting Future<FirebaseServices> Function()? initialize,
  @visibleForTesting bool? isWeb,
  @visibleForTesting TargetPlatform? platform,
}) async {
  final target = platform ?? defaultTargetPlatform;
  if (flavor != Flavor.dev ||
      (isWeb ?? kIsWeb) ||
      (target != TargetPlatform.android && target != TargetPlatform.iOS)) {
    return null;
  }
  try {
    return await Future.sync(initialize ?? () => _initializeNative(preferences))
        .timeout(timeout);
  } catch (_) {
    // Optional Firebase failure must not block server binding/login. Never log
    // SDK exception bodies (which can contain configuration or identifiers).
    return null;
  }
}

Future<FirebaseServices> _initializeNative(AppPreferences? preferences) async {
  await Firebase.initializeApp();
  // Native defaults are also disabled, including before initialization finishes.
  // Remote policy flags never grant consent or activate telemetry.
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  return FirebaseServices(
    pushNotifications: FirebasePushNotifications(
      messaging: FirebaseMessaging.instance,
    ),
    releasePolicySource: FirebaseReleasePolicySource(
      FirebaseRemoteConfig.instance,
      preferences: preferences,
      minimumFetchInterval: kDebugMode
          ? const Duration(seconds: 30)
          : const Duration(hours: 12),
    ),
  );
}
