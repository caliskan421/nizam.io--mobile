// Görüşme adresi doğrulaması: prod'da yalnız wss, dev'de özel ağ ws; diğer her biçim reddedilir.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/meetings/application/conference_url.dart';

void main() {
  final rejected = isA<ApiError>().having(
    (e) => e.code,
    'code',
    ClientErrorCode.conferenceInsecureUrl,
  );

  test('wss her çeşitte geçer', () {
    for (final f in Flavor.values) {
      expect(
        conferenceUrl(' wss://lk.example.com ', f),
        'wss://lk.example.com',
      );
    }
  });

  test('ws: yalnız dev ve yalnız yerel/özel ağ adresi', () {
    for (final host in [
      '192.168.2.7:7880',
      '10.0.0.5',
      '172.20.1.1',
      'localhost:7880',
      'mac.local',
    ]) {
      expect(conferenceUrl('ws://$host', Flavor.dev), 'ws://$host');
      expect(() => conferenceUrl('ws://$host', Flavor.prod), throwsA(rejected));
    }
    for (final host in ['lk.example.com', '8.8.8.8', '172.32.0.1']) {
      expect(() => conferenceUrl('ws://$host', Flavor.dev), throwsA(rejected));
    }
  });

  test('başka şema, boş host, kullanıcı bilgisi, parça reddedilir', () {
    for (final raw in [
      'https://lk.example.com',
      'http://192.168.2.7:7880',
      'wss://',
      'wss://u:p@lk.example.com',
      'wss://lk.example.com#x',
      'lk.example.com',
      '',
    ]) {
      expect(
        () => conferenceUrl(raw, Flavor.dev),
        throwsA(rejected),
        reason: raw,
      );
    }
  });
}
