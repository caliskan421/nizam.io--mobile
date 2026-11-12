import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/native_update_store.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/config/running_release.dart';

void main() {
  const android = RunningRelease(
    version: '0.2.0',
    build: 2,
    packageName: 'io.nizamio.mobile',
    platform: MobileReleasePlatform.android,
  );
  const ios = RunningRelease(
    version: '0.2.0',
    build: 2,
    packageName: 'io.nizamio.mobile',
    platform: MobileReleasePlatform.ios,
  );
  test('absent targets never infer a published app', () {
    expect(trustedStoreTarget(android, androidUrl: '', iosUrl: ''), isNull);
    expect(trustedStoreTarget(ios, androidUrl: '', iosUrl: ''), isNull);
  });
  test('only explicit trusted app-specific HTTPS store targets accepted', () {
    const play =
        'https://play.google.com/store/apps/details?id=io.nizamio.mobile';
    expect(
      trustedStoreTarget(android, androidUrl: play, iosUrl: ''),
      Uri.parse(play),
    );
    for (final url in [
      play.replaceFirst('https:', 'http:'),
      '$play&redirect=https://evil.test',
      play.replaceFirst('io.nizamio.mobile', 'other.app'),
      'https://play.google.com.evil.test/store/apps/details?id=io.nizamio.mobile',
      'https://name@play.google.com/store/apps/details?id=io.nizamio.mobile',
    ]) {
      expect(trustedStoreTarget(android, androidUrl: url, iosUrl: ''), isNull);
    }
    expect(
      trustedStoreTarget(
        ios,
        androidUrl: '',
        iosUrl: 'https://apps.apple.com/app/id123456',
      ),
      isNotNull,
    );
    expect(
      trustedStoreTarget(
        ios,
        androidUrl: '',
        iosUrl: 'https://apps.apple.com/app/id123456?redirect=evil',
      ),
      isNull,
    );
    const dev = RunningRelease(
      version: '0.2.0',
      build: 2,
      packageName: 'io.nizamio.mobile.dev',
      platform: MobileReleasePlatform.android,
    );
    expect(trustedStoreTarget(dev, androidUrl: play, iosUrl: ''), isNull);
  });
}
