import 'package:url_launcher/url_launcher.dart';

import '../../core/config/mobile_release_policy.dart';
import '../../core/config/running_release.dart';
import '../../core/config/update_store.dart';
import '../../core/telemetry/report_source.dart';
import '../../core/telemetry/unexpected_error.dart';

/// Only a release build configuration can select a store, never remote payloads.
final class NativeUpdateStore implements UpdateStore {
  NativeUpdateStore(
    RunningRelease release, {
    String androidUrl = const String.fromEnvironment(
      'NIZAMIO_ANDROID_STORE_URL',
    ),
    String iosUrl = const String.fromEnvironment('NIZAMIO_IOS_STORE_URL'),
  }) : target = trustedStoreTarget(
         release,
         androidUrl: androidUrl,
         iosUrl: iosUrl,
       );

  final Uri? target;
  @override
  bool get available => target != null;

  @override
  Future<bool> open() async {
    final uri = target;
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (e, st) {
      // Platform hizmeti (mağaza açma) başarısız: kullanıcı "açılamadı" görür; sebep raporlanır.
      reportUnexpected(e, st, source: ReportSource.app);
      return false;
    }
  }
}

Uri? trustedStoreTarget(
  RunningRelease release, {
  required String androidUrl,
  required String iosUrl,
}) {
  // Development binaries must never point users at an unrelated prod binary.
  if (release.packageName != 'io.nizamio.mobile') return null;
  final raw = release.platform == MobileReleasePlatform.android
      ? androidUrl
      : iosUrl;
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.userInfo.isNotEmpty ||
      uri.hasPort ||
      uri.hasFragment) {
    return null;
  }
  return switch (release.platform) {
    MobileReleasePlatform.android
        when uri.host == 'play.google.com' &&
            uri.path == '/store/apps/details' &&
            uri.queryParametersAll.length == 1 &&
            uri.queryParametersAll['id']?.length == 1 &&
            uri.queryParameters['id'] == release.packageName =>
      uri,
    MobileReleasePlatform.ios
        when uri.host == 'apps.apple.com' &&
            RegExp(r'^/(?:[a-z]{2}/)?app/(?:[a-zA-Z0-9-]+/)?id[0-9]+$')
                .hasMatch(uri.path) &&
            !uri.hasQuery =>
      uri,
    _ => null,
  };
}
